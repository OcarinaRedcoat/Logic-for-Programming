/*-----------------------------------------------*\
| Ricardo Caetano - 87699                         |
\*-----------------------------------------------*/
:- include('exemplos_puzzles.pl').



propaga([H|_], Pos, Posicoes) :-
  member(Term, H),
  append(Pref, [Pos|_], Term),
  sort([Pos|Pref], Posicoes).


nao_altera_linhas_anteriores(Posicoes, L, Ja_Preenchidas) :-
  

% verifica_parcial().
% possibilidades_linha().
% resolve().