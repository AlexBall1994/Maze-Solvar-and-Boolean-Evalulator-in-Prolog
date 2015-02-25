:- initialization(
    [ 'logic.pl'
    , 'publicRecursion1.pl'
    , 'publicRecursion2.pl'
    , 'publicMaze1.pl'
    , 'publicMaze2.pl'
    ]).
run_f(Func) :-
    % name(Func,FunName),
    % writef("Testcase: %s\n",[FunName]),
    Func.
testcases(
    [ public_prod
    , public_fill
    , public_genN
    , public_genXY
    , public_flat
    , public_stats
    , public_validPath
    , public_findDistance
    , public_solve
    ]).
run :-
    testcases(TC),
    maplist(run_f,TC).
