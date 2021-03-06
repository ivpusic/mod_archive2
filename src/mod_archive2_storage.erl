%%%----------------------------------------------------------------------
%%% File    : mod_archive2_storage.erl
%%% Author  : Alexander Tsvyashchenko <xmpp@endl.ch>
%%% Purpose : mod_archive2-specific storage functionality
%%% Created : 07 Oct 2009 by Alexander Tsvyashchenko <xmpp@endl.ch>
%%%
%%% mod_archive2, Copyright (C) 2009 Alexander Tsvyashchenko
%%%
%%% Based on earlier works by:
%%%  - Olivier Goffart <ogoffar@kde.org> (mnesia version)
%%%  - Alexey Shchepin <alexey@process-one.net> (PostgreSQL version)
%%%  - Alexander Tsvyashchenko <xmpp@endl.ch> (ODBC version)
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

-module(mod_archive2_storage).
-author('xmpp@endl.ch').

%% Our hooks
-export([get_collection/2, get_collection/4]).

-include("mod_archive2.hrl").
-include("mod_archive2_storage.hrl").

%%--------------------------------------------------------------------
%% Retrieve collection links from minimally filled list of archive_collection
%% records. Required fields are 'with_*' and 'utc'.
%%--------------------------------------------------------------------

get_collection(undefined, _) ->
    undefined;

get_collection(#archive_collection{} = C, Type) ->
    TableInfo = dbms_storage_utils:get_table_info(
        archive_collection, ?MOD_ARCHIVE2_SCHEMA),
    get_collection(C, Type, existing, TableInfo#table.fields).

get_collection(undefined, _, _, _) ->
    undefined;

get_collection(#archive_collection{} = C, Type, Filter, Fields) ->
    TableInfo = dbms_storage_utils:get_table_info(
        archive_collection, ?MOD_ARCHIVE2_SCHEMA),
    MSHead = dbms_storage_utils:get_full_ms_head(TableInfo),
    case dbms_storage:select([{MSHead,
        get_collection_conditions(C, Type, Filter, TableInfo),
        dbms_storage_utils:get_ms_body(Fields, TableInfo)}]) of
        {selected, [#archive_collection{} = OutC]} ->
            OutC;
        _ ->
            undefined
    end.

%% Retrieve collection from minimally filled archive_collection
%% record: the only required field is 'id'.
get_collection_conditions(C, by_id, Filter, TableInfo) ->
    Conditions =
        filter_undef(
            [{'=:=', id,
                dbms_storage_utils:encode_brackets(C#archive_collection.id)},
             case Filter of
                 existing ->
                     {'=/=', deleted, true};
                 all ->
                     undefined
             end]),
    dbms_storage_utils:resolve_fields_names(Conditions, TableInfo);

%% Retrieve collection from minimally filled archive_collection
%% record: required fields are 'us', 'with_*' and 'utc'.
get_collection_conditions(C, by_link, Filter, TableInfo) ->
    Conditions =
        filter_undef(
            [{'=:=', us, C#archive_collection.us},
             {'=:=', with_user, C#archive_collection.with_user},
             {'=:=', with_server, C#archive_collection.with_server},
             {'=:=', with_resource, C#archive_collection.with_resource},
             {'=:=', utc,
                dbms_storage_utils:encode_brackets(C#archive_collection.utc)},
             case Filter of
                 existing ->
                     {'=/=', deleted, true};
                 all ->
                     undefined
             end]),
    dbms_storage_utils:resolve_fields_names(Conditions, TableInfo).
