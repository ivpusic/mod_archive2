%%%----------------------------------------------------------------------
%%% File    : general.erl
%%% Author  : Alexander Tsvyashchenko <ejabberd@ndl.kiev.ua>
%%% Purpose : mod_archive2 general regression testing
%%% Created : 30 Sep 2009 by Alexander Tsvyashchenko <ejabberd@ndl.kiev.ua>
%%%
%%% mod_archive2, Copyright (C) 2009 Alexander Tsvyashchenko
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

-module(general).
-author('ejabberd@ndl.kiev.ua').

-include_lib("eunit/include/eunit.hrl").

-include("testing.hrl").
-include("general.hrl").

general_test_() ->
    ?test_foreach(
        client:session_setup,
        client:session_teardown,
        [
            ?test_gen1(test_disco),
            ?test_gen1(test_remove_user),
            ?test_gen1(test_remove_user2)
        ]).

test_disco(F) ->
    ?GENERAL_TC1_QUERY_RESULT =
    client:response(F, exmpp_xml:element(undefined, "iq",
    [
        exmpp_xml:attribute("from", ?CLIENTJID),
	exmpp_xml:attribute("to", ?SERVERHOST),
	exmpp_xml:attribute("type", "get")
    ],
    [
        exmpp_xml:element("http://jabber.org/protocol/disco#info", "query", [], [])
    ])),
    DiscoSorted = lists:sort(lists:filter(
        fun({xmlel, _, _, _, [{xmlattr,_,_,NS}], []}) -> string:str(binary_to_list(NS), "xep-0136") /= 0;
	(_) -> false end, DiscoElements)),
    ?GENERAL_TC1_DISCO_ELEMENTS = DiscoSorted.

test_remove_user(F) ->
    ?GENERAL_TC2_QUERY_RESULT =
    client:response(F, exmpp_client_register:remove_account()).

test_remove_user2(F) ->
    ?GENERAL_TC3_RETRIEVE_RESULT =
    client:response(F, exmpp_iq:get(undefined, exmpp_xml:element(?NS, "modified",
    [
	exmpp_xml:attribute("start", "1469-07-21T01:14:47Z")
    ],
    [
        exmpp_xml:element("http://jabber.org/protocol/rsm", "set",
	[
	    exmpp_xml:attribute("max", "30")
	], [])
    ]))).
