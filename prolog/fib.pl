fib(0,0). 
fib(1,1).
fib(X,F) :- X > 1,
    X, is X-1,
    fib(X1,F1),
    X2, is X-2,
    fib(X2, F2),
    F is F1+F2,
    memoriza(fib(X, F)).

memoriza(L) :- asserta(L :- !).
