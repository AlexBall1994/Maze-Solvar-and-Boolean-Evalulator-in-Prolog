
test_prod(L) :- findall(R, prod(L,R), Out), write(Out), nl.

public_prod :-
	write('% public_prod'),nl,
	test_prod([1,2,3]),
	test_prod([]),
	test_prod([2,2,2]).

test_fill1(N,X) :- findall(R, fill(N,X,R), Out), write(Out), nl.
test_fill2(N,R) :- findall(X, fill(N,X,R), Out), write(Out), nl.

public_fill :-
	write('% public_fill'),nl,
	test_fill1(4,2),
	test_fill1(2,3),
	test_fill2(4,[2,2,2,2]),
	test_fill2(2,[3,3]).
