/*---------------------------------------------------------------

   CMSC 330 Project 6 - Maze Solver and SAT in Prolog

   NAME:

*/


%%%%%%%%%%%%%%%%%%%%%%
% Part 1 - Recursion %
%%%%%%%%%%%%%%%%%%%%%%

% prod - R is product of entries in list L

prod([], 1).
prod([Hd|Tl],R) :-
	prod(Tl,R1),
	R is R1 * Hd.

% fill - R is list of N copies of X

fill(0, X, []).
fill(N,X,[Hd|Tl]) :-
	N > 0,
	X = Hd,
	N1 is N-1,
	fill(N1, X, Tl).

% genN - R is value between 0 and N-1, in order

  genN(X,F) :- countHelp(X,F,0).

	countHelp(X,F,Z) :-
	Z < X,
	(F = Z ;
	Z1 is Z + 1,
	countHelp(X,F,Z1)).

% genXY - R is pair of values [X,Y] between 0 and N-1, in lexicographic order

genXY(X,F) :- countHelp(X,F,0,0).

	countHelp(X,F,Z,G) :-
	(Z < X ->
	(F = [G,Z] ;
	Z1 is Z + 1,
	countHelp(X,F,Z1,G));
	G+1 < X,
	G1 is G+1,
	countHelp(X,F,0,G1)).

% flat(L,R) - R is elements of L concatentated together, in order

flat(L,R) :- flatHelp(L,[],R).

flatHelp([],R,R).
flatHelp([H|T],N, F) :-
	 (integer(H) ->
	append(N,[H],J),
	flatHelp(T,J,F);
	append(N,H,J),
	 flatHelp(T,J,F)).


	




%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2 - Maze Solver %
%%%%%%%%%%%%%%%%%%%%%%%%

% stats(U,D,L,R) - number of cells w/ openings up, down, left, right


stats(U,D,L,R) :- maze(Size,_,_,_,_),
	 			 findall(R, genXY(Size,R), Out),
	 			
	 			 statsHelp(Out,U, L, R, D).

statsHelp([],0,0,0,0).
statsHelp([[X|[Y]]|Tl],U, L, R, D) :- cell(X,Y,Dirs,Wt),
								(contains1(u,Dirs) -> U1 is 1; U1 is 0),
								(contains1(d,Dirs) -> D1 is 1; D1 is 0),
								(contains1(l,Dirs) -> L1 is 1; L1 is 0),
								(contains1(r,Dirs) -> R1 is 1; R1 is 0),
								statsHelp(Tl,U2, L2, R2, D2),
								
								U is U1 + U2,
								D is D1 + D2,
								R is R1 + R2,
								L is L1 + L2.


			

contains1(V,[V|Tl]).
contains1(V,[Hd|Tl]):-
contains1(V,Tl).


					

% validPath(N,W) - W is weight of valid path N rounded to 4 decimal places

validPath(N,W) :- maze(Size,_,_,_,_),
	 			 path(Name,Sx,Sy,Dir),
	 			 validPathHelp(N,W3,Sx, Sy, Dir, Name),
	 			 round4(W3,W).


validPathHelp(N,0,Sx,Sy,[],Name) :- N = Name.
validPathHelp(N,W,X, Y, [F|Tl], Name) :- cell(X,Y,Dcell,Whd),
										contains1(F,Dcell,Whd,Bam),
										changeDir(X,Y,F,Cx, Cy),
										validPathHelp(N,W123, Cx, Cy, Tl, Name),
										W is Bam + W123.
										

							

contains1(V,[V|Tl],[F1|Fr], Pos2) :- Pos2 is F1.
contains1(V,[Hd|Tl],[S1|S2], Pos2):-
contains1(V,Tl,S2, Pos2).

getWeight([], 0, N).
getWeight([Hd|Tl], Bam, 0) :- Bam is Hd.
getWeight([Hd|Tl], Bam, N) :- N1 is N - 1,
							getWeight(Tl, Bam, N1).


changeDir(X,Y, F, Cx, Cy) :- (F = u -> Cy is Y - 1, Cx is X);
							 (F = d -> Cy is Y + 1, Cx is X);
							 (F = l -> Cx is X - 1, Cy is Y);
							 (F = r -> Cx is X + 1, Cy is Y).



round4(X,Y) :- T1 is X*10000, T2 is round(T1), Y is T2/10000.

% findDistance(L) - L is list of coordinates of cells at distance D from start

findDistance(L) :- maze(_,X,Y,_,_),
                   Q = [[0,[X,Y]]],
                   buildLst(Q,[],[],L1),
                   sort(L1,L2),
                   start(L2,[],R,Z),

                   finish(R,Z,L9),
                   	sort(L9,L).

start([[D,[[X,Y]]] | Tl],[], R, L) :- append([[D,[[X,Y]]]],[],L), R = Tl.

finish([],L,L).
finish([[D,[[X,Y]]] | Tl], [[D,[[Cx,Cy]|Rs]] | Tl2], L) :- !,append([[X,Y]],[[Cx,Cy]],Cell),
																append(Cell,Rs,Cell1),
																sort(Cell1,Cellf),
														append([[D,Cellf]], Tl2, Nk),
														finish(Tl,Nk,L). 
finish([[D,[[X,Y]]] | Tl],Z, L) :- append([[D,[[X,Y]]]],Z,R), finish(Tl,R,L).




                   
                   



buildLst([],P,L,L).
buildLst([[D,[X,Y]] | Tl],P,L1, L) :- cell(X,Y,Dirs,_),
								D1 is D + 1,
								append([[X,Y]],P, P1),
								!,process(D1,X,Y,Dirs,P1,Tl,Lst),
								append([[D,[[X,Y]]]],L1,L2),
								buildLst(Lst,P1,L2,L).


process(D,X,Y,[],P,Q,Q).
process(D,X,Y,[Hd|Tl],P,Q,Qf) :- getCord1(X,Y, Hd, Cx, Cy),
								!,(\+containz([Cx,Cy],P) -> append(Q,[[D,[Cx,Cy]]],Q1), process(D,X,Y, Tl, P, Q1, Qf);
									process(D,X,Y,Tl,P,Q, Qf)).
								




containz(Cell,[Cell|Tl]).
containz(Cell, [Hd|Tl]) :- containz(Cell, Tl).






% solve - True if maze is solvable, fails otherwise.

solve :- 
	maze(Size,Sx,Sy,Ex,Ey),
	Q = [[Sx,Sy]],
	F = [Ex,Ey],
	solveHelp(Q,[],F).

solveHelp([Hd|Tl],P, Hd).
solveHelp([[X|[Y]]|Tl], P, F) :-
			append([[X,Y]], P, P1),
			cell(X,Y,Dirs,_),
			buildQ(X,Y,Dirs,Tl,P1, R),
			solveHelp(R,P1,F).

				
buildQ(X,Y,[],Q,P, Q).
buildQ(X,Y,[Dirs|Dend],Q,P,R) :- getCord1(X,Y,Dirs, Cx, Cy),
							  (\+member([Cx,Cy],P) -> append([[Cx,Cy]], Q, Q1); Q1 = Q),
							  buildQ(X,Y,Dend, Q1, P, R).


							
getCord1(X,Y,F,Cx,Cy) :- (F = u -> Cy is Y - 1, Cx is X);
							 (F = d -> Cy is Y + 1, Cx is X);
							 (F = l -> Cx is X - 1, Cy is Y);
							 (F = r -> Cx is X + 1, Cy is Y).

%%%%%%%%%%%%%%%%
% Part 3 - SAT %
%%%%%%%%%%%%%%%%



% eval(F,A,R) - R is t if formula F evaluated with list of 
%                 true variables A is true, false otherwise

eval(F,A,R) :- (evalVal(F,A) -> R = t; R = f).



evalT([X,B|C],[B]).

evalVal(t,Lst).
evalVal(Var, Lst) :- member(Var,Lst).
evalVal([Var], Lst) :- member(Var, Lst).
evalVal([and,X,Y|Tl], Lst):- evalVal(X,Lst),
							evalVal(Y,Lst).
evalVal([no,X|Tl], Lst) :- !,\+(evalVal(X,Lst)).
evalVal([or,X,Y|Tl], Lst) :- (evalVal(X,Lst); evalVal(Y,Lst)).
evalVal([every,V,F],Lst) :- (!,\+member(V,Lst) -> evalVal(F,Lst),
	                                              append([V],Lst,Lst1),
	                                               evalVal(F,Lst1); evalVal(F,Lst),
	                                               remover(Lst,V,Nlst),
	                                               evalVal(F,Nlst)).	 
evalVal([exists,V,F],Lst) :- (!,\+member(V,Lst) -> (evalVal(F,Lst);
	                                              append([V],Lst,Lst1),
	                                               evalVal(F,Lst1)); 

	                                               (evalVal(F,Lst);
	                                               remover(Lst,V,Nlst),
	                                               evalVal(F,Nlst))).


remover([],Z,[]) :- !. 
remover([X|T],X,L1) :- !, remover(T,X,L1).         
remover([H|T],X,[H|L1]) :- remover(T,X,L1).


% varsOf(F,R) - R is list of free variables in formula F


varsOf(F,R) :- varsOfHelper([], F, R1),
				R2 = [],
				!,find(R1,[],R2, R3),
				sort(R3,R).
			

find([], C, R, R).
find(R,C,R,R) :- 3=5.
find([Hd|Tl], C, R, R2) :- (\+member(Hd,C) -> append([Hd], C, C1), append([Hd],R, R1), find(Tl, C1, R1, R2);
	find(Tl, C, R, R2)).


varsOfHelper(F,[],R).
varsOfHelper(F, [t|Tl], R) :- R = [].
varsOfHelper(F, [f|Tl] ,R) :- R = [].
varsOfHelper(F, f ,R) :- R = [].
varsOfHelper(F, t ,R) :- R = [].
varsOfHelper(F, [and,X,Y|Tl], R) :- 
									 varsOfHelper(F,X, R1),
									 varsOfHelper(F,Y,R2),
									 append(R2,R1,R).

varsOfHelper(F, [or,X,Y|Tl], R) :- 
									 varsOfHelper(F,X, R1),
									 varsOfHelper(F,Y,R2),
									 append(R2,R1,R).


varsOfHelper(F, [no,X|Tl],R) :- varsOfHelper(F,X, R).
varsOfHelper(F,[every,X|Tl], R) :- append([X],F, F1),
								flat(Tl,J),
								varsOfHelper(F1,J, R).
varsOfHelper(F,[exists,X|Tl], R) :- append([X],F, F1),
								flat(Tl,J),
								varsOfHelper(F1,J, R).

varsOfHelper(F,[V], R) :-  (member(V,F) -> R = []; R = [V]).

varsOfHelper(F,V, R) :-    (member(V,F) -> R = []; R = [V]).






my_rev(X,F) :- rev_helper(X,[],F).

rev_helper([],A,A).
rev_helper([H|T],A,F) :- 
	rev_helper(T,[H|A],F).

ehelp(F, R) :- evalVal(F,[]), R = [].


% sat(F,R) - R is a list of true variables that satisfies F

sat(F,R) :- varsOf(F, V),
			subset(V, R),
			eval(F,R,t).
			  
			


% Helper Function
% subset(L, R) - R is a subset of list L, with relative order preserved

subset([], []).
subset([H|T], [H|NewT]) :- subset(T, NewT).
subset([_|T], NewT) :- subset(T, NewT).
