-module(server_app).
-behavior(application).
 
-export([start/2]).
-export([stop/1]).
 
start(_Type, _Args) ->
    { ok, SocketMessageBus} = messagebus:start_link(socketmessagebus),
    Dispatch = cowboy_router:compile([
        {'_', [
               {"/comms", comms_handler, SocketMessageBus},
               {"/[...]", cowboy_static, {dir, "../www"}},
               {'_', hello_handler, []}
              ]}
    ]),
    %% Name, NbAcceptors, TransOpts, ProtoOpts
    cowboy:start_http(my_http_listener, 100,
        [{port, 8080}],
        [{env, [{dispatch, Dispatch}]}]
    ),
    server_sup:start_link().
 
stop(_State) ->
    ok.
