%-----------------------------------------------
%| Ricardo Caetano - 87699
%-----------------------------------------------
include(exemplos_puzzles).

propaga(Puz, Pos, Posicoes) :-
  



% propaga([[[H2|T2]|T1]|T], Pos, Posicoes) :-
%   member(H2, Pos),
%   propaga([T2|T1]|T], Pos, Posicoes),
%   last(Pos, H2),
%
%
%
%
%
%
%
%
%
%   sort(Posicoes, PosicoesOrd).




nao_altera_linhas_anteriores().
verifica_parcial().
possibilidades_linha().
resolve().
