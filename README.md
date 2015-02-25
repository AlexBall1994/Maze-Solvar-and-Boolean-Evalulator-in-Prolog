# Maze Solver and Boolean Evaluator Prolog


Description:  For this project my code takes in an input maze file and returns values depending on the given command.  

My Code:  logic.pl

To Execute:  Compile logic.pl and then compile one of the test files.


Part 1: Recursion
Write the following recursive functions:

Name 	Parameters 	Example
prod(L,R) 	L=list of ints
R=product of elements of L
• R=1 if L=[]
• L will always be given 	?- prod([1,2,3],R).
R=6.
?- prod([],R).
R=1.
fill(N,X,R) 	N=int
X=int
R=list containing N copies of X
• R=[] if N=0
• N will always be given
• Either X or R will be given 	?- fill(4,2,R).
R=[2,2,2,2].
?- fill(4,X,[2,2,2,2]).
X=2.
genN(N,R) 	N=non-zero positive int
R=int values between 0 and N-1, inclusive, in ascending order
• N will always be given 	?- genN(2,R).
R=0;
R=1.
genXY(N,R) 	N=non-zero positive int
R=pairs [X,Y], where X & Y are values between 0 and N-1, inclusive,
generated in ascending lexicographic order.
• N will always be given 	?- genXY(2,R).
R=[0,0];
R=[0,1];
R=[1,0];
R=[1,1].
flat(L,R) 	L=list
R=elements of L concatenated together, preserving relative order,
first placing non-list elements in a list if necessary
• R=[] if L=[]
• L will always be given
• Only removes one level of list, unlike flatten/2 	?- flat([[1],[2,3]],R).
R=[1,2,3].
?- flat([1,[2,3]],R).
R=[1,2,3].
?- flat([[1,[2]],3],R).
R=[1,[2],3].
Part 2: Maze solver
Maze descriptions
For this project, the mazes you will compute with will be given as Prolog databases. In particular, you will be given three kinds of facts

    maze(N,SX,SY,EX,EY). This fact indicates that:
        The height and width of the maze is N cells,
        The default starting position is SX,SY, and
        The ending position is EX,EY. 

    cell(X,Y,Dirs,Wts). A fact of this form describes a cell in the maze. In particular, it says that the cell at position X,Y, has open walls as described by Dirs, the list of directions. More precisely:
        The list Dirs will contain at most one of each of the atoms u, d, l, and r, which designate openings going up, down, left, or right, respectively.
        Recall from project one that the coordinate system places 0,0 in the upper left corner of the maze.
        The Wts component of the fact indicates the weights granted to paths following the respective direction. That is, each element in Dirs has a corresponding weight in Wts. 
    As an example, the fact cell(1,0,[r,d],[16.6, 0.89]) indicates that the cell at 1,0 has two open walls: one leading to the right (to cell 2,0) with weight 16.6, and one leading down (to cell 1,1) with weight 0.89.

    path(N,SX,SY,Dirs). This fact describes a path named N (a string) through the maze starting at position SX,SY and following the directions given by Dirs. For example, the fact path('path1',0,3,[u,r,u,l,u]) indicates that there is a path 'path1' that starts at 0,3 and follows the given directions to end up at position 0,0.

Based on these maze facts, you need to implement the following functions for solving a maze.

Name 	Parameters 	Example
stats(U,D,L,R) 	U,D,L,R=number of cells with openings up, down, left, and right. 	?- stats(U,D,L,R).
U = D, D = 8,
L = R, R = 7.
validPath(N,W) 	N=name of valid path (only goes through openings)
W=float value for weight of path (rounded to 4 decimal places)
• Return valid paths in same order as in database
• Use round4(X,Y) :- T1 is X*10000, T2 is round(T1), Y is T2/10000.
• Apply round4() to final float weight, not intermediate sums. 	?- validPath(N,W).
N = path1,
W = 99.9958;
N = path2,
W = 103.779.
findDistance(L) 	L=list of coordinates of cells at distance D from maze start
• Elements of L are in form [D, [[X1,Y2],[X2,Y2],...]]
• Values of D range from 0 to D, in ascending order
• D=distance of cell furthest from start
• Cell coordinates [X,Y] are in lexicographic order 	?- findDistance(L).
L = [[0, [[0, 3]]],
       [1, [[0, 2]]],
       [2, [[1, 2]]],
       [3, [[1, 1],[2,2]],
  ..., [6, [[3, 2]]].
solve 	• True if maze is solvable, fails otherwise. 	?- solve.
true.

The maze converter program convertMaze.rb may be used to convert simple maze files from Project 1 into Prolog for use as test cases. Run it as "ruby convertMaze.rb simpleMazeN.in > prologMazeN.pl".

Part 3: Boolean Formulae & SAT
As in Project 3, you will be constructing collections of boolean formulae and determine whether they can be solved (satisfied). For this project boolean formula will be represented using lists of Prolog terms as follows:

    t and f represent true & false, respectively.
    [and, X, Y], [or, X, Y], [no, X] represent the and, or, not operations applied to formulas X, Y.
    [every, V, F], [exists, V, F] represent the forall & exists quantifiers applied to variable V in formula F.
    Any other term x (identifier beginning with lower case letter) represents a variable x.
    Instead of associative lists, we will use a list of true variables. Any variables not in the list are considered false. 

Note that we use no and every in place of not and forall, since those names are already taken in Prolog.

Based on these definitions for boolean formulae, you need to implement the following functions for determining whether a formula is satisfiable.

Name 	Parameters 	Example
eval(F,A,R) 	F=formula to be evaluated
A=list of true variables (may be empty)
R=result (either t or f)
• F and A will always be given
• Not all variables in A must be free variables in F 	?- eval(x,[x],R).
R = t.
?- eval([and,t,x],[x],R).
R = t.
varsOf(F,R) 	F=formula to be examined
R=list of free variables in F (sorted, no duplicates, may be empty)
• F will always be given 

 sat(F,R) 	F=formula to be examined
R=list of true variables that satisfies (solves) F
• R must be sorted, no duplicates, and contain only free variables of F
• If multiple values are possible for R, may return them in any order
• May not return the same value for R multiple times
• Return R=[] if F is true with no true free variables
• Fail if F is not satisfiable
• F will always be given	?- sat(t,R).
R = [].
?- sat([or,x,y],R).
R = [x];
R = [x,y];
R = [y].
?- sat(f,R).
false.
