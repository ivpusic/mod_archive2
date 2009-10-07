%%%----------------------------------------------------------------------
%%% File    : general.hrl
%%% Author  : Alexander Tsvyashchenko <ejabberd@ndl.kiev.ua>
%%% Purpose : mod_archive2 general regression testing expected replies
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

-define(GENERAL_TC1_QUERY_RESULT,
    {received_packet,iq,"result",
     {undefined,<<?SERVERHOST>>,undefined},
     _,undefined,
     {xmlel,'jabber:client',[],iq,
      [{xmlattr,undefined,from,<<?SERVERHOST>>},
       {xmlattr,undefined,to,
        _},
       {xmlattr,undefined,id,_},
       {xmlattr,undefined,type,<<"result">>}],
      [{xmlel,'http://jabber.org/protocol/disco#info',
        [{'http://jabber.org/protocol/disco#info',none}],
        'query',[],
	DiscoElements}]}}).

-define(GENERAL_TC1_DISCO_ELEMENTS,
        [
         {xmlel,'http://jabber.org/protocol/disco#info',[],
          feature,
          [{xmlattr,undefined,var,
            <<?NS>>}],
          []},
         {xmlel,'http://jabber.org/protocol/disco#info',[],
          feature,
          [{xmlattr,undefined,var,
            <<"http://www.xmpp.org/extensions/xep-0136.html#ns-auto">>}],
          []},
         {xmlel,'http://jabber.org/protocol/disco#info',[],
          feature,
          [{xmlattr,undefined,var,
            <<"http://www.xmpp.org/extensions/xep-0136.html#ns-manage">>}],
          []},
         {xmlel,'http://jabber.org/protocol/disco#info',[],
          feature,
          [{xmlattr,undefined,var,
            <<"http://www.xmpp.org/extensions/xep-0136.html#ns-manual">>}],
          []},
         {xmlel,'http://jabber.org/protocol/disco#info',[],
          feature,
          [{xmlattr,undefined,var,
            <<"http://www.xmpp.org/extensions/xep-0136.html#ns-pref">>}],
          []}
	]).

-define(GENERAL_TC2_QUERY_RESULT,
    {received_packet,iq,"result",
        {<<?CLIENTNAME>>,<<?SERVERHOST>>,
         _},
        _,undefined,
        {xmlel,'jabber:client',[],iq,
            [{xmlattr,undefined,from,
                 _},
             {xmlattr,undefined,to,
                 _},
             {xmlattr,undefined,id,_},
             {xmlattr,undefined,type,<<"result">>}],
            [{xmlel,'jabber:iq:register',
                 [{'jabber:iq:register',none}],
                 'query',[],
                 [{xmlel,'jabber:iq:register',[],remove,[],
                      []}]}]}}).

-define(GENERAL_TC3_RETRIEVE_RESULT,
    {received_packet,iq,"result",
        {<<?CLIENTNAME>>,<<?SERVERHOST>>,undefined},
        _,undefined,
        {xmlel,'jabber:client',[],iq,
            [{xmlattr,undefined,from,<<?CLIENTJID>>},
             {xmlattr,undefined,to,
                 _},
             {xmlattr,undefined,id,_},
             {xmlattr,undefined,type,<<"result">>}],
            [{xmlel,
                 ?NS,
                 [{?NS,
                   none}],
                 modified,[],[]}]}}).
