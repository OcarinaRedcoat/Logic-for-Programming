/*-----------------------------------------------*\
| Ricardo Caetano - 87699                         |
\*-----------------------------------------------*/
:- include('exemplos_puzzles.pl').

%TODO: nos comentarios fiquei no nao_altera_linhas_anteriores

/*-----------------------------------------------*\
| Predicados Auxiliares                           |
\*-----------------------------------------------*/

/*----------------------------------------------------------------------------*\
| propaga:
| Recebe: - Lista em que a Head representa os termometros
|         - Posicao que queromos final, que quermos propagar ate esta
| Devolve: Uma lista de posicoes ate a pos que temos de preencher ordenadamente
|
\*----------------------------------------------------------------------------*/
propaga([H|_], Pos, Posicoes) :-
  member(Term, H),
  append(Pref, [Pos|_], Term),
  sort([Pos|Pref], Posicoes).

/*----------------------------------------------------------------------------*\
| nao_altera_linhas_anteriores:
| Recebe: - Lista em que a Head representa os termometros
|         - Posicao que queromos final, que quermos propagar ate esta
| Devolve: Uma lista de posicoes ate a pos que temos de preencher ordenadamente
|
\*----------------------------------------------------------------------------*/
nao_altera_linhas_anteriores([], _, _).
nao_altera_linhas_anteriores([(X,Y)|T], L, Ja_Preenchidas) :-
  X < L,
  member((X,Y), Ja_Preenchidas),
  nao_altera_linhas_anteriores(T, L, Ja_Preenchidas). 

nao_altera_linhas_anteriores([(X,_)|T], L, Ja_Preenchidas) :-
  X >= L,
  nao_altera_linhas_anteriores(T, L, Ja_Preenchidas). 

/*----------------------------------------------------------------------------*\
| how_many_in_collums:
| Recebe: - Lista em que a Head representa os termometros
|         - Posicao que queromos final, que quermos propagar ate esta
| Devolve: Uma lista de posicoes ate a pos que temos de preencher ordenadamente
|
\*----------------------------------------------------------------------------*/
how_many_in_collums([], _, 0).
how_many_in_collums([(_,Y)|T], Collum, Result) :-
  how_many_in_collums(T, Collum, Aux),
  (Y == Collum, Accomulator = 1; Accomulator = 0),
  Result is Aux + Accomulator, !.


/*----------------------------------------------------------------------------*\
| verifica_parcial_auxiliar:
| Recebe: - Lista em que a Head representa os termometros
|         - Posicao que queromos final, que quermos propagar ate esta
| Devolve: Uma lista de posicoes ate a pos que temos de preencher ordenadamente
|
\*----------------------------------------------------------------------------*/
verifica_parcial_auxiliar(_,_,Count, Dim) :- Count > Dim, !.
verifica_parcial_auxiliar([H|T], Lst, Count, Dim) :-
  how_many_in_collums(Lst, Count, Total),
  H >= Total,
  Count_Aux is Count + 1,
  verifica_parcial_auxiliar(T, Lst, Count_Aux, Dim).

/*----------------------------------------------------------------------------*\
| verifica_parcial:
| Recebe: - Lista em que a Head representa os termometros
|         - Posicao que queromos final, que quermos propagar ate esta
| Devolve: Uma lista de posicoes ate a pos que temos de preencher ordenadamente
|
\*----------------------------------------------------------------------------*/
verifica_parcial(Puz, Ja_Preenchidas, Dim, Poss) :-
  union(Ja_Preenchidas, Poss, LstVerifica),
  Puz = [_, _,Collums],
  verifica_parcial_auxiliar(Collums, LstVerifica, 1, Dim).

/*----------------------------------------------------------------------------*\
| combine_positions_list:
| Recebe: - Lista em que a Head representa os termometros
|         - Posicao que queromos final, que quermos propagar ate esta
| Devolve: Uma lista de posicoes ate a pos que temos de preencher ordenadamente
|alterar para copias
\*----------------------------------------------------------------------------*/
combine_positions_list([], 0, []).
combine_positions_list([H|_], 1, [H]).

combine_positions_list([H|T], HowManyCombine, [H|Result]) :-
  HowManyCombineAUX is HowManyCombine - 1,
  HowManyCombineAUX > 0,
  combine_positions_list(T, HowManyCombineAUX, Result).

combine_positions_list([_|T], HowManyCombine,  Result) :- 
  combine_positions_list(T, HowManyCombine, Result).

/*----------------------------------------------------------------------------*\
| propaga_possibilidades_aux:
| Recebe: - Lista em que a Head representa os termometros
|         - Posicao que queromos final, que quermos propagar ate esta
| Devolve: Uma lista de posicoes ate a pos que temos de preencher ordenadamente
|alterar para copias
\*----------------------------------------------------------------------------*/
propaga_possibilidades_aux(_, [], []).
propaga_possibilidades_aux(Puz, [H|T], Res1) :-
  propaga(Puz, H, Res),
  propaga_possibilidades_aux(Puz, T, R),
  union(R, Res, Res1).

/*-----------------------------------------------*\
| Predicados do Projeto                           |
\*-----------------------------------------------*/

/*----------------------------------------------------------------------------*\
| how_many_in_lines:
| Recebe: - Lista em que a Head representa os termometros
|         - Posicao que queromos final, que quermos propagar ate esta
| Devolve: Uma lista de posicoes ate a pos que temos de preencher ordenadamente
|alterar para copias
\*----------------------------------------------------------------------------*/
how_many_in_lines([], _, 0).
how_many_in_lines([(X,_)|T], Line, Result) :-
  how_many_in_lines(T, Line, Aux),
  (X == Line, Accumulator = 1; Accumulator = 0),
  Result is Aux + Accumulator, !.

/*----------------------------------------------------------------------------*\
| possibilidades_linha:
| Recebe: - Lista em que a Head representa os termometros
|         - Posicao que queromos final, que quermos propagar ate esta
| Devolve: Uma lista de posicoes ate a pos que temos de preencher ordenadamente
|alterar para copias
\*----------------------------------------------------------------------------*/
possibilidades_linha(Puz, Posicoes_linha, Total, Ja_Preenchidas, Possibilidades_L) :-
  findall(P, possibilidade_uma(Puz, Posicoes_linha, Total, Ja_Preenchidas, P), Todas_Possibilidades),
  sort(Todas_Possibilidades, Possibilidades_L).

/*----------------------------------------------------------------------------*\
| possibilidade_uma:
| Recebe: - Lista em que a Head representa os termometros
|         - Posicao que queromos final, que quermos propagar ate esta
| Devolve: Uma lista de posicoes ate a pos que temos de preencher ordenadamente
|alterar para copias
\*----------------------------------------------------------------------------*/
possibilidade_uma(Puz, Posicoes_linha, Total, Ja_Preenchidas, Possibilidade) :-
  Posicoes_linha = [(L, _)|_],
  length(Posicoes_linha, Dim),
  combine_positions_list(Posicoes_linha, Total, Combinacao),
  propaga_possibilidades_aux(Puz, Combinacao, Propagacoes),
  
  union(Propagacoes, Ja_Preenchidas, Todas_Posicoes),
  how_many_in_lines(Todas_Posicoes, L, Todas_da_linha),
  Todas_da_linha =:= Total,

  nao_altera_linhas_anteriores(Propagacoes, L, Ja_Preenchidas),
  verifica_parcial(Puz, Ja_Preenchidas, Dim, Propagacoes),
  sort(Propagacoes, Possibilidade).

/*----------------------------------------------------------------------------*\
| resolve:
| Recebe: - Lista em que a Head representa os termometros
|         - Posicao que queromos final, que quermos propagar ate esta
| Devolve: Uma lista de posicoes ate a pos que temos de preencher ordenadamente
|alterar para copias
\*----------------------------------------------------------------------------*/
resolve(Puz, Solucao) :-
  