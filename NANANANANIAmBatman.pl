/*----------------------------------------------------------------------------*\
|                                                                              |
|                                                                              |
|                         Ricardo Caetano - 87699                              |
|                                                                              |
|                                                                              |
\*----------------------------------------------------------------------------*/
:- include('exemplos_puzzles.pl').

/*----------------------------------------------------------------------------*\
|                                                                              |
|                                                                              |
|                         Predicados Auxiliares                                |
|                                                                              |
|                                                                              |
\*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*\
| propaga:
| Recebe: - Lista em que a Head representa os termometros
|         - Posicao que queremos final, que quermos propagar ate esta
| Devolve: Uma lista de posicoes ate a pos que temos de preencher ordenadamente
| Descricao: propaga(Puz, Pos, Posicoes) significa que, dado o puzzle Puz,
| o preenchimentoda posicao Pos implica o preenchimento de todas as posicoes da
| lista de posicoes Posicoes.
\*----------------------------------------------------------------------------*/
propaga([H|_], Pos, Posicoes) :-
  member(Term, H),
  append(Pref, [Pos|_], Term),
  sort([Pos|Pref], Posicoes).

/*----------------------------------------------------------------------------*\
| nao_altera_linhas_anteriores:
| Recebe: - Lista de posicoes
|         - Uma Linha e uma lista
|         - Uma lista de ja preenchidas
| Descricao: nao_altera_linhas_anteriores(Posicoes, L, Ja_Preenchidas) significa
| que, dada a lista de posicoes Posicoes, representando uma possibilidade de
| preenchimento para a linha L, todas as posicoes desta lista pertencendo
| a linhas anteriores a L, pertencem a lista de posicoes Ja_Preenchidas.
| Como o nome indica, esta lista contem todas as posicoes ja preenchidas
| nas linhas anteriores a L.
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
| Recebe: - Lista
|         - Uma Coluna
| Devolve: O numero de elementos dessa dada coluna que existem na Lista
\*----------------------------------------------------------------------------*/
how_many_in_collums([], _, 0).
how_many_in_collums([(_,Y)|T], Collum, Result) :-
  how_many_in_collums(T, Collum, Aux),
  (Y == Collum, Accomulator = 1; Accomulator = 0),
  Result is Aux + Accomulator, !.


/*----------------------------------------------------------------------------*\
| verifica_parcial_auxiliar:
| Recebe: - Puz e um puzzle,
|         - Ja_Preenchidas e a lista das posicoes
|         ja preenchidas por escolhas anteriores,
|         - Dim e a dimensao de Puz,
|         - Poss e lista de posicoes representando
|         uma potencial possibilidade para preencher uma linha
\*----------------------------------------------------------------------------*/
verifica_parcial_auxiliar(_,_,Count, Dim) :- Count > Dim, !.
verifica_parcial_auxiliar([H|T], Lst, Count, Dim) :-
  how_many_in_collums(Lst, Count, Total),
  H >= Total,
  Count_Aux is Count + 1,
  verifica_parcial_auxiliar(T, Lst, Count_Aux, Dim).

/*----------------------------------------------------------------------------*\
| verifica_parcial:
| Recebe: - Puz e um puzzle,
|         - Ja_Preenchidas e a lista das posicoes
|         ja preenchidas por escolhas anteriores,
|         - Dim e a dimensao de Puz,
|         - Poss e lista de posicoes representando
|         uma potencial possibilidade para preencher uma linha
| Descricao: permite verificar se uma possibilidade para preencher
| uma linha nao viola os totais das colunas, tendo em atencao
| as escolhas feitas anteriormente.
\*----------------------------------------------------------------------------*/
verifica_parcial(Puz, Ja_Preenchidas, Dim, Poss) :-
  union(Ja_Preenchidas, Poss, LstVerifica),
  Puz = [_, _, Collums],
  verifica_parcial_auxiliar(Collums, LstVerifica, 1, Dim).

/*----------------------------------------------------------------------------*\
| combine_positions_list:
| Recebe: - Lista
|         - HowManyCombine que diz o numero das combinaces, e.g combinacoes
|         2 a 2 , 3 a 3 etc
| Devolve: Uma possivel combinacao
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
|         - Uma lista de Posicoes que queremos final, que quermos propagar ate
| Devolve: Uma lista de posicoes ate a pos que temos de preencher ordenadamente
| alterar para copias
\*----------------------------------------------------------------------------*/
propaga_possibilidades_aux(_, [], []).
propaga_possibilidades_aux(Puz, [H|T], Res1) :-
  propaga(Puz, H, Res),
  propaga_possibilidades_aux(Puz, T, R),
  union(R, Res, Res1).

/*----------------------------------------------------------------------------*\
|                                                                              |
|                                                                              |
|                         Predicados do Projeto                                |
|                                                                              |
|                                                                              |
\*----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------*\
| how_many_in_lines:
| Recebe: - Lista
|         - Uma linha
| Devolve: O numero de elementos dessa dada linha que existem na Lista
\*----------------------------------------------------------------------------*/
how_many_in_lines([], _, 0).
how_many_in_lines([(X,_)|T], Line, Result) :-
  how_many_in_lines(T, Line, Aux),
  (X == Line, Accumulator = 1; Accumulator = 0),
  Result is Aux + Accumulator, !.

/*----------------------------------------------------------------------------*\
| possibilidades_linha:
| Recebe: - Puz e um puzzle,
|         - Posicoes_linha e uma lista com as posicoes da linha em questao.
|         - Total e o numero total de posicoes a preencher na linha em questao,
|         - Ja_Preenchidas e a lista das posicoes ja preenchidas por escolhas
|         anteriores,
|         - Possibilidades_L e uma lista de listas de posicoes,
| Descricao: Este predicado permite determinar as possibilidades existentes para
| preencher uma determinada linha, tendo em atencao as escolhas ja feitas
| para preencher as linhas anteriores, e os totais das colunas.
\*----------------------------------------------------------------------------*/
possibilidades_linha(Puz, Posicoes_linha, Total, Ja_Preenchidas, Possibilidades_L) :-
  findall(P, possibilidade_uma(Puz, Posicoes_linha, Total, Ja_Preenchidas, P), Todas_Possibilidades),
  sort(Todas_Possibilidades, Possibilidades_L).

/*----------------------------------------------------------------------------*\
| possibilidade_uma:
| Recebe: - Puz e um puzzle,
|         - Posicoes_linha e uma lista com as posicoes da linha em questao.
|         - Total e o numero total de posicoes a preencher na linha em questao,
|         - Ja_Preenchidas e a lista das posicoes ja preenchidas por escolhas
|         anteriores,
|         - Possibilidades_L e uma lista de listas de posicoes,
| Devolve: A possibilidade apenas para uma combinacao.
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
| resolve_auxiliar:
| Recebe: - puzzle
|         - Lista dos pesos das linhas
|         - Contador da Linha
|         - Lista das ja preenchidas
|         - Dimensao do puzzle
| Devolve: Solucao
\*----------------------------------------------------------------------------*/
resolve_auxiliar(_, [], _, [], _).
resolve_auxiliar(_,_, Count, _, Dim,_) :- Dim < Count, !.
resolve_auxiliar(Puz, [H|T], Count, Ja_Preenchidas, Dim,Solucao) :-
  Puz = [_,Linhas,_],
  length(Linhas, Dim),
  findall(P, (P = (Count, C), between(1, Dim, C)), Linha),
  
  possibilidades_linha(Puz, Linha, H, Ja_Preenchidas, Possibilidades),
  
  %member(X, Possibilidades),
  union(Possibilidades, Ja_Preenchidas, Novas_Preenchidas),
  CountNext is Count + 1,
  
  resolve_auxiliar(Puz, T, CountNext, Novas_Preenchidas, Dim, Solucao),
  sort(Novas_Preenchidas, Solucao).





/*----------------------------------------------------------------------------*\
| resolve:
| Recebe: - puzzle,
| Devolve: Solucao e uma lista de posicoes,
\*----------------------------------------------------------------------------*/
resolve(Puz, Solucao) :-
  Puz = [_, Linhas, _],
  length(Linhas, Dim),
  resolve_auxiliar(Puz, Linhas, 1, [], Dim, SolucaoAux),
  sort(SolucaoAux, Solucao).
