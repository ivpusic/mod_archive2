-define(MANUAL_TC1_SAVE_RESULT,
    {atomic,{iq,response,result,<<"stanza-",_/binary>>,?NS_ARCHIVING,
        {xmlel,?NS_ARCHIVING,[],save,[],
               [{xmlel,undefined,[],chat,
                       [{xmlattr,undefined,<<"with">>,
                                 <<"juliet@capulet.com/chamber">>},
                        {xmlattr,undefined,<<"start">>,
                                 <<"1469-07-21T02:56:15.000000Z">>},
                        {xmlattr,undefined,<<"subject">>,<<"Subject">>},
                        {xmlattr,undefined,<<"thread">>,<<"12345">>},
                        {xmlattr,undefined,<<"crypt">>,<<"true">>},
                        {xmlattr,undefined,<<"version">>,<<"0">>}],
                       [{xmlel,undefined,[],x,[],
                               [{xmlel,undefined,[],test,[],[]}]}]}]},
        undefined,undefined,'jabber:client'}}).

-define(MANUAL_TC2_RETRIEVE_RESULT,
    {atomic,
        {iq,response,result,<<"stanza-",_/binary>>,?NS_ARCHIVING,
         {xmlel,?NS_ARCHIVING,[],chat,
            [{xmlattr,undefined,<<"with">>,<<"juliet@capulet.com/chamber">>},
             {xmlattr,undefined,<<"start">>,<<"1469-07-21T02:56:15.000000Z">>},
             {xmlattr,undefined,<<"subject">>,<<"Subject">>},
             {xmlattr,undefined,<<"thread">>,<<"12345">>},
             {xmlattr,undefined,<<"crypt">>,<<"true">>},
             {xmlattr,undefined,<<"version">>,<<"0">>}],
            [{xmlel,undefined,[],x,[],[{xmlel,undefined,[],test,[],[]}]},
             {xmlel,undefined,[],from,
              [{xmlattr,undefined,<<"secs">>,<<"0">>}],
              [{xmlel,undefined,[],body,[],
                [{xmlcdata,<<"Art thou not Romeo, and a Montague?">>}]}]},
             {xmlel,undefined,[],to,
              [{xmlattr,undefined,<<"secs">>,<<"11">>}],
              [{xmlel,undefined,[],body,[],
                [{xmlcdata,
                  <<"Neither, fair saint, if either thee dislike.">>}]}]},
             {xmlel,undefined,[],to,
              [{xmlattr,undefined,<<"secs">>,<<"12">>},
               {xmlattr,undefined,<<"name">>,<<"romeo">>},
               {xmlattr,undefined,<<"jid">>,<<"romeo@montague.net">>}],
              [{xmlel,undefined,[],body,[],
                   [{xmlcdata,<<"Neither, fair saint, if either thee dislike.">>}]},
               {xmlel,'http://jabber.org/protocol/xhtml-im',_,html,[],
                   [{xmlel,'http://www.w3.org/1999/xhtml',_,body,[],
                        [{xmlel,undefined,[],p,[],
                             [{xmlcdata,
                                  <<"Neither, fair saint, if either thee dislike.">>}]}]}]}]},
             {xmlel,undefined,[],note,
              [{xmlattr,undefined,<<"utc">>,<<"1469-07-21T03:04:35.000000Z">>}],
              [{xmlcdata,<<"I think she might fancy me.">>}]},
             {xmlel,'http://jabber.org/protocol/rsm',[],set,[],
              [{xmlel,'http://jabber.org/protocol/rsm',[],first,
                [{xmlattr,undefined,<<"index">>,<<"0">>}],
                [{xmlcdata,_}]},
               {xmlel,'http://jabber.org/protocol/rsm',[],last,[],
                [{xmlcdata,_}]},
               {xmlel,'http://jabber.org/protocol/rsm',[],count,[],
                [{xmlcdata,<<"4">>}]}]}]},
         undefined,undefined,'jabber:client'}}).

-define(MANUAL_TC3_UPDATE_RESULT,
    {atomic,{iq,response,result,<<"stanza-",_/binary>>,?NS_ARCHIVING,
        {xmlel,?NS_ARCHIVING,[],save,[],
               [{xmlel,undefined,[],chat,
                       [{xmlattr,undefined,<<"with">>,
                                 <<"juliet@capulet.com/chamber">>},
                        {xmlattr,undefined,<<"start">>,
                                 <<"1469-07-21T02:56:15.000000Z">>},
                        {xmlattr,undefined,<<"subject">>,<<"Subject2">>},
                        {xmlattr,undefined,<<"thread">>,<<"12345">>},
                        {xmlattr,undefined,<<"crypt">>,<<"false">>},
                        {xmlattr,undefined,<<"version">>,<<"1">>}],
                       []}]},
        undefined,undefined,'jabber:client'}}).

-define(MANUAL_TC4_RETRIEVE_RESULT,
    {atomic,
        {iq,response,result,<<"stanza-",_/binary>>,?NS_ARCHIVING,
         {xmlel,?NS_ARCHIVING,[],chat,
            [{xmlattr,undefined,<<"with">>,<<"juliet@capulet.com/chamber">>},
             {xmlattr,undefined,<<"start">>,<<"1469-07-21T02:56:15.000000Z">>},
             {xmlattr,undefined,<<"subject">>,<<"Subject2">>},
             {xmlattr,undefined,<<"thread">>,<<"12345">>},
             {xmlattr,undefined,<<"crypt">>,<<"false">>},
             {xmlattr,undefined,<<"version">>,<<"1">>}],
            [{xmlel,undefined,[],to,
              [{xmlattr,undefined,<<"secs">>,<<"11">>}],
              [{xmlel,undefined,[],body,[],
                [{xmlcdata,
                  <<"Neither, fair saint, if either thee dislike.">>}]}]},
             {xmlel,undefined,[],to,
              [{xmlattr,undefined,<<"secs">>,<<"12">>},
               {xmlattr,undefined,<<"name">>,<<"romeo">>},
               {xmlattr,undefined,<<"jid">>,<<"romeo@montague.net">>}],
              [{xmlel,undefined,[],body,[],
                   [{xmlcdata,<<"Neither, fair saint, if either thee dislike.">>}]},
               {xmlel,'http://jabber.org/protocol/xhtml-im',_,html,[],
                   [{xmlel,'http://www.w3.org/1999/xhtml',_,body,[],
                        [{xmlel,undefined,[],p,[],
                             [{xmlcdata,
                                  <<"Neither, fair saint, if either thee dislike.">>}]}]}]}]},
             {xmlel,'http://jabber.org/protocol/rsm',[],set,[],
              [{xmlel,'http://jabber.org/protocol/rsm',[],first,
                [{xmlattr,undefined,<<"index">>,<<"1">>}],
                [{xmlcdata,_}]},
               {xmlel,'http://jabber.org/protocol/rsm',[],last,[],
                [{xmlcdata,_}]},
               {xmlel,'http://jabber.org/protocol/rsm',[],count,[],
                [{xmlcdata,<<"4">>}]}]}]},
         undefined,undefined,'jabber:client'}}).

-define(MANUAL_TC5_RETRIEVE_RESULT,
    {atomic,
        {iq,response,result,<<"stanza-",_/binary>>,?NS_ARCHIVING,
         {xmlel,?NS_ARCHIVING,[],chat,
            [{xmlattr,undefined,<<"with">>,<<"juliet@capulet.com/chamber">>},
             {xmlattr,undefined,<<"start">>,<<"1469-07-21T02:56:15.000000Z">>},
             {xmlattr,undefined,<<"subject">>,<<"Subject">>},
             {xmlattr,undefined,<<"thread">>,<<"12345">>},
             {xmlattr,undefined,<<"crypt">>,<<"true">>},
             {xmlattr,undefined,<<"version">>,<<"0">>}],
            [{xmlel,undefined,[],x,[],[{xmlel,undefined,[],test,[],[]}]},
             {xmlel,undefined,[],from,
              [{xmlattr,undefined,<<"utc">>,<<"1469-07-21T02:56:15.000000Z">>}],
              [{xmlel,undefined,[],body,[],
                [{xmlcdata,<<"Art thou not Romeo, and a Montague?">>}]}]},
             {xmlel,undefined,[],to,
              [{xmlattr,undefined,<<"utc">>,<<"1469-07-21T02:56:26.000000Z">>}],
              [{xmlel,undefined,[],body,[],
                [{xmlcdata,
                  <<"Neither, fair saint, if either thee dislike.">>}]}]},
             {xmlel,undefined,[],to,
              [{xmlattr,undefined,<<"utc">>,<<"1469-07-21T02:56:27.000000Z">>},
               {xmlattr,undefined,<<"name">>,<<"romeo">>},
               {xmlattr,undefined,<<"jid">>,<<"romeo@montague.net">>}],
              [{xmlel,undefined,[],body,[],
                   [{xmlcdata,<<"Neither, fair saint, if either thee dislike.">>}]},
               {xmlel,'http://jabber.org/protocol/xhtml-im',_,html,[],
                   [{xmlel,'http://www.w3.org/1999/xhtml',_,body,[],
                        [{xmlel,undefined,[],p,[],
                             [{xmlcdata,
                                  <<"Neither, fair saint, if either thee dislike.">>}]}]}]}]},
             {xmlel,undefined,[],note,
              [{xmlattr,undefined,<<"utc">>,<<"1469-07-21T03:04:35.000000Z">>}],
              [{xmlcdata,<<"I think she might fancy me.">>}]},
             {xmlel,'http://jabber.org/protocol/rsm',[],set,[],
              [{xmlel,'http://jabber.org/protocol/rsm',[],first,
                [{xmlattr,undefined,<<"index">>,<<"0">>}],
                [{xmlcdata,_}]},
               {xmlel,'http://jabber.org/protocol/rsm',[],last,[],
                [{xmlcdata,_}]},
               {xmlel,'http://jabber.org/protocol/rsm',[],count,[],
                [{xmlcdata,<<"4">>}]}]}]},
         undefined,undefined,'jabber:client'}}).
