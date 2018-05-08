/*-----------------------------------------------*\
| Ricardo Caetano - 87699                         |
\*-----------------------------------------------*/
:- include('exemplos_puzzles.pl').



propaga([H|_], Pos, Posicoes) :-
  member(Term, H),
  append(Pref, [Pos|_], Term),
  sort([Pos|Pref], Posicoes).

nao_altera_linhas_anteriores([], _, _).
nao_altera_linhas_anteriores([(X,Y)|T], L, Ja_Preenchidas) :-
  X < L,
  member((X,Y), Ja_Preenchidas),
  nao_altera_linhas_anteriores(T, L, Ja_Preenchidas). 

nao_altera_linhas_anteriores([(X,_)|T], L, Ja_Preenchidas) :-
  X >= L,
  nao_altera_linhas_anteriores(T, L, Ja_Preenchidas). 

verifica_parcial(Puz, Ja_Preenchidas, Dim, Poss) :-
  



% possibilidades_linha()
% resolve().