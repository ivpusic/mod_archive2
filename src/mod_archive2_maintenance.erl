%%%----------------------------------------------------------------------
%%% File    : mod_archive2_maintenance.erl
%%% Author  : Alexander Tsvyashchenko <ejabberd@ndl.kiev.ua>
%%% Purpose : mod_archive2 maintenance operations
%%% Created : 20 Nov 2009 by Alexander Tsvyashchenko <ejabberd@ndl.kiev.ua>
%%%
%%% mod_archive2, Copyright (C) 2009 Alexander Tsvyashchenko
%%%
%%% Based on earlier works by:
%%%  - Olivier Goffart <ogoffar@kde.org> (mnesia version)
%%%  - Alexey Shchepin <alexey@process-one.net> (PostgreSQL version)
%%%  - Alexander Tsvyashchenko <ejabberd@ndl.kiev.ua> (ODBC version)
%%%
%%% This program is free software; you can redistribute it and/or
%%% modify it under the terms of the GNU General Public License as
%%% published by the Free Software Foundation; either version 2 of the
%%% License, or (at your option) any later version.
%%%
%%% This program is distributed in the hope that it will be useful,
%%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%%% General Public License for more details.
%%%
%%% You should have received a copy of the GNU General Public License
%%% along with this program; if not, write to the Free Software
%%% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
%%% 02111-1307 USA
%%%
%%%----------------------------------------------------------------------

-module(mod_archive2_maintenance).
-author('ejabberd@ndl.kiev.ua').

%% gen_mod callbacks
-export([remove_user/2, expire_collections/4]).

-include("mod_archive2.hrl").
-include("mod_archive2_storage.hrl").

remove_user(From, RDBMS) ->
    Host = exmpp_jid:prep_domain_as_list(From),
    US = exmpp_jid:prep_bare_to_list(From),
    ejabberd_storage:transaction(
        Host,
        fun() ->
            MS =
                ets:fun2ms(
                    fun(#archive_collection{us = US1}) when US1 =:= US ->
                        ok
                    end),
            case RDBMS of
                mnesia ->
                    mod_archive2_management:delete_messages(MS);
                _ ->
                    % All other RDBMSes should handle that via triggers.
                    ok
            end,
            ejabberd_storage:delete(
                ets:fun2ms(
                    fun(#archive_jid_prefs{us = US1}) when US1 =:= US ->
                        ok
                    end)),
            ejabberd_storage:delete(
                ets:fun2ms(
                    fun(#archive_global_prefs{us = US1}) when US1 =:= US ->
                        ok
                    end)),
            ejabberd_storage:delete(MS)
        end).

expire_collections(Host, DefaultExpire, ReplicationExpire, mnesia) ->
    ejabberd_storage:transaction(Host,
        fun() ->
            MS =
                ets:fun2ms(fun(#archive_collection{} = C) -> C end),
            expire_collections_mnesia(
                DefaultExpire,
                ReplicationExpire,
                calendar:now_to_datetime(mod_archive2_time:now()),
                mnesia:select(archive_collection, MS, ?SELECT_NOBJECTS, write))
        end);

expire_collections(Host, DefaultExpire, ReplicationExpire, RDBMS) ->
    ejabberd_storage:transaction(Host,
        fun() ->
            Now = ejabberd_storage_odbc:encode(
                calendar:now_to_datetime(mod_archive2_time:now()),
                ejabberd_storage_utils:get_table_info(archive_collection,
                    ?MOD_ARCHIVE2_SCHEMA)),
            expire_collections_odbc(
                DefaultExpire,
                ReplicationExpire,
                Now,
                RDBMS)
        end).

expire_collections_odbc(DefaultExpire, ReplicationExpire, Now, RDBMS) ->
    UTCField = "archive_collection.utc",
    ExpireByDefault =
    	case DefaultExpire of
            infinity ->
	            "";
            N when is_integer(N) ->
         	    [" or "
		         "archive_global_prefs.expire is null and "
                 "domain_jid_prefs.expire is null and "
                 "full_jid_prefs.expire is null and "
                 "bare_jid_prefs.expire is null and ",
	             get_expired_condition(RDBMS, integer_to_list(N), UTCField), " < ", Now]
        end,
    Query =
        ["update archive_collection "
            "left join archive_jid_prefs as full_jid_prefs "
                "on archive_collection.with_user = full_jid_prefs.with_user and "
                   "archive_collection.with_server = full_jid_prefs.with_server and "
                   "archive_collection.with_resource = full_jid_prefs.with_resource "
            "left join archive_jid_prefs as bare_jid_prefs "
                "on archive_collection.with_user = bare_jid_prefs.with_user and "
                   "archive_collection.with_server = bare_jid_prefs.with_server and "
                   "bare_jid_prefs.with_resource = '' and "
                   "bare_jid_prefs.exactmatch = 0 "
            "left join archive_jid_prefs as domain_jid_prefs "
                "on archive_collection.with_server = domain_jid_prefs.with_server and "
                   "domain_jid_prefs.with_user = '' and "
                   "domain_jid_prefs.with_resource = '' and "
                   "domain_jid_prefs.exactmatch = 0 "
            "left join archive_global_prefs "
                "on archive_collection.us = archive_global_prefs.us "
         "set deleted = 1, change_utc = ", Now, ", version = version + 1 "
         "where "
         "deleted = 0 and "
         "not full_jid_prefs.expire is null and ",
         get_expired_condition(RDBMS, "full_jid_prefs.expire", UTCField), " < ", Now, " or "
             "not bare_jid_prefs.expire is null and "
                 "full_jid_prefs.expire is null and ",
         get_expired_condition(RDBMS, "bare_jid_prefs.expire", UTCField), " < ", Now, " or "
             "not domain_jid_prefs.expire is null and "
                 "full_jid_prefs.expire is null and "
                 "bare_jid_prefs.expire is null and ",
         get_expired_condition(RDBMS, "domain_jid_prefs.expire", UTCField), " < ", Now, " or "
             "not archive_global_prefs.expire is null and "
                 "domain_jid_prefs.expire is null and "
                 "full_jid_prefs.expire is null and "
                 "bare_jid_prefs.expire is null and ",
         get_expired_condition(RDBMS, "archive_global_prefs.expire", UTCField), " < ", Now,
         ExpireByDefault],
	ejabberd_storage:sql_query(Query),
    case ReplicationExpire of
		infinity ->
            ok;
		N1 when is_integer(N1) ->
	        ejabberd_storage:sql_query(
                ["delete from archive_collection "
				 "where deleted = 1 "
				 "and ",
                 get_expired_condition(RDBMS, integer_to_list(N1),
                     "archive_collection.change_utc"), " < ", Now]),
            ok
    end.

get_expired_condition(RDBMS, ExpireField, UTCField) ->
    case RDBMS of
        mysql ->
            ["timestampadd(second, ", ExpireField, ", ", UTCField, ")"];
        sqlite ->
            ["datetime(", UTCField, ", '+' || ", ExpireField,
             " || ' seconds')"];
        pgsql ->
            ["timestamp ", UTCField, " + interval ", ExpireField,
             " || ' seconds'"];
        _ ->
            throw({error, 'internal-server-error'})
    end.

expire_collections_mnesia(DefaultExpire, ReplicationExpire, Now, {Records, Cont}) ->
    lists:foreach(
        fun(C) ->
            case C#archive_collection.deleted of
                false ->
                    From = exmpp_jid:parse(C#archive_collection.us),
                    With = exmpp_jid:make(
                        C#archive_collection.with_user,
                        C#archive_collection.with_server,
                        C#archive_collection.with_resource),
                    Expire =
                        case mod_archive2_prefs:get_effective_jid_prefs(
                            From, With) of
                            undefined ->
                                Prefs =
                                    mod_archive2_prefs:get_global_prefs(
                                        From,
                                        #archive_global_prefs{
                                            expire = DefaultExpire}),
                                Prefs#archive_global_prefs.expire;
                            JidPrefs ->
                                JidPrefs#archive_jid_prefs.expire
                        end,
                    case Expire of
                        infinity ->
                            ok;
                        undefined ->
                            ok;
                        _ ->
                            Diff =
                                datetime_to_now(C#archive_collection.utc, Now),
                            if Diff > Expire ->
                                mnesia:write(
                                    C#archive_collection{
                                        deleted = true,
                                        change_utc = Now,
                                        version = C#archive_collection.version + 1}),
                                MS =
                                    ets:fun2ms(
                                        fun(#archive_collection{id = ID1})
                                            when ID1 =:= C#archive_collection.id ->
                                            ok
                                        end),
                                mod_archive2_management:delete_messages(MS);
                               true ->
                                ok
                            end
                    end;
                true ->
                    Diff =
                        datetime_to_now(C#archive_collection.change_utc, Now),
                    if is_integer(ReplicationExpire) andalso
                        Diff > ReplicationExpire ->
                         mnesia:delete({archive_collection, C#archive_collection.id});
                       true ->
                        ok
                    end
            end
        end,
        Records),
    expire_collections_mnesia(
        DefaultExpire, ReplicationExpire, Now, mnesia:select(Cont));

expire_collections_mnesia(_, _, _, '$end_of_table') -> ok.

datetime_to_now(DateTime, Now) ->
    calendar:datetime_to_gregorian_seconds(Now) -
    calendar:datetime_to_gregorian_seconds(DateTime).