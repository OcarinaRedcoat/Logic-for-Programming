/*-----------------------------------------------*\
| Ricardo Caetano - 87699                         |
\*-----------------------------------------------*/
:- include('exemplos_puzzles.pl').

%TODO: nos comentarios fiquei no nao_altera_linhas_anteriores

/*-----------------------------------------------*\
| Predicados Auxiliares                       |
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
verifica_parcial_auxiliar(Collum, [(_|Y)|T], Count, Dim) :-
  how_many_in_collums([(_,Y)|T], Count, Total),
  Y >= Total,
  Count_Aux is Count +1,
  verifica_parcial_auxiliar(Collum, T, Count_Aux, Dim).

/*----------------------------------------------------------------------------*\
| verifica_parcial:
| Recebe: - Lista em que a Head representa os termometros
|         - Posicao que queromos final, que quermos propagar ate esta
| Devolve: Uma lista de posicoes ate a pos que temos de preencher ordenadamente
|
\*----------------------------------------------------------------------------*/
verifica_parcial(Puz, Ja_Preenchidas, Dim, Poss) :-
  union(Ja_Preenchidas, Poss, LstVerifica),
  Puz = [_, _, Collums],
  verifica_parcial_auxiliar(Collums, LstVerifica, 1, Dim).