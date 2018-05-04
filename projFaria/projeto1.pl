%---------------------------------------------------------------------
% Bernardo Goncalves de Faria   Nr87636
% --------------------------------------------------------------------

:- include('SUDOKU').

%---------------------------------------------------------------------
%
%            3.1 - Predicados para a propagacao de mudancas
%               3.1.1 - Predicado tira_num/4
%
% --------------------------------------------------------------------


%---------------------------------------------------------------------
% tira_num_aux(Num,Puz,Pos,N_Puz): Retorna o puzzle N_Puz resultante de
% tirar o numero Num da posicao Pos do puzzle Puz, usando os predicados
% puzzle_ref(Puz,Pos,Cont), subtract(Cont,[Num],Cont_aux) que tira o
% numero Num do Cont e devolte o Cont_aux, e
% puzzle_muda_propaga(Puz,Pos,Cont_aux,N_puz).
% --------------------------------------------------------------------

tira_num_aux(Num,Puz,Pos,N_Puz) :-
    puzzle_ref(Puz,Pos,Cont),
    subtract(Cont,[Num],Cont_aux),
    puzzle_muda_propaga(Puz,Pos,Cont_aux,N_Puz).



%---------------------------------------------------------------------
% tira_num(Num,Puz,Posicoes,N_Puz): Retorna o puzzle N_Puz resultante
% de tirar o numero Num de todas as posicoes em Posicoes do puzzle Puz.
% Fa-lo atraves do predicado percorre_muda_Puz(Puz,Accao,Lst,N_Puz) que
% retorna o N_Puz resultante de aplicar a Accao(que neste caso e' o
% predicado tira_num_aux(Num) a cada elemento de Lst, que neste caso
% sao as posicoes em Posicoes, de Puz.
% ---------------------------------------------------------------------

tira_num(Num,Puz,Posicoes,N_Puz) :-
    percorre_muda_Puz(Puz,tira_num_aux(Num),Posicoes,N_Puz).



%---------------------------------------------------------------------
%
%            3.1 - Predicados para a propagacao de mudancas
%               3.1.2 - Predicado puzzle_muda_propaga/4
%
%---------------------------------------------------------------------


%---------------------------------------------------------------------
% puzzle_muda_propaga(Puz,Pos,Cont,N_Puz):
%
%   1 - quando o conteudo da posicao Pos e' igual ao Cont: neste caso,
% implementamos o predicado puzzle_ref(Puz,Pos,Cont) que mantem o
% conteudo na posicao escolhida.
%
%   2 - quando o Cont e' uma lista unitaria: aqui, mantemos o Cont
% atraves do predicado puzzle_muda(Puz,Pos,[Cont],N_Puz_aux),
% percorremos todas as posicoes em Posicoes atraves do predicado
% posicoes_relacionadas(Pos,Posicoes), e retiramos o Cont dessas
% Posicoes atraves do predicado tira_num(Cont,N_Puz_aux,Posicoes,N_Puz).
%
%   3 - quando o Cont nao e' uma lista unitaria: nesta situacao,
% aplicamos diretamente o predicado puzzle_muda(Puz,Pos,Cont,N_Puz) para
% mudar o conteudo da posicao Pos para Cont.
% ---------------------------------------------------------------------

puzzle_muda_propaga(Puz,Pos,Cont,Puz) :-
    puzzle_ref(Puz,Pos,Cont),!.


puzzle_muda_propaga(Puz,Pos,[Cont],N_Puz) :-
    !,
    puzzle_muda(Puz,Pos,[Cont],N_Puz_aux),
    posicoes_relacionadas(Pos,Posicoes),
    tira_num(Cont,N_Puz_aux,Posicoes,N_Puz).


puzzle_muda_propaga(Puz,Pos,Cont,N_Puz):-
    puzzle_muda(Puz,Pos,Cont,N_Puz).





%---------------------------------------------------------------------
%
%            3.2 - Predicados para a inicializacao de puzzles
%               3.2.1 - Predicado possibilidades/3
%
%---------------------------------------------------------------------


%---------------------------------------------------------------------
% possibilidades(Pos,Puz,Poss):
%
%    1 - quando a posicao Pos ja contem uma sequencia unitaria: aqui,
% utilizamos o predicado puzzle_ref(Puz,Pos,[U]), que verifica
% se o conteudo da posicao Pos e uma sequencia unitaria, e se for,
% inclui-a na lista Poss.
%
%    2 - quando a posicao Pos nao contem uma sequencia unitaria: neste
% caso, utilizamos o predicado posicoes_relacionadas(Pos,Posicoes) para
% obter as Posicoes, utilizamos o predicado
% conteudos_posicoes(Puz,Posicos,Cont)para verificarmos os conteudos
% das Posicoes e introduzirmo-los no Cont. Depois, implementamos o
% predicado possibilidades_aux(Cont,Cont_aux) que vai introduzir no
% Cont_aux apenas as sequencias unitarias existentes em Cont; o
% predicado flatten(Cont_aux,Res) transforma a lista de listas Cont_aux
% numa lista de numeros Res. O predicado numeros(N) e' utilizado para
% obter os numeros possiveis, relacionando-se com o predicado
% subtract(N,Res,Poss), que subtrai 'a lista N os numeros de Res,
% obtendo os numeros possiveis.
%
%
% possibilidades_aux:
%
%    1 - quando a posicao e' uma lista vazia: retorna essa lista
% vazia.
%
%    2 - quando a head da lista ja e' uma sequencia unitaria: aqui,
% chamamos de novo o predicado para a Tail, e introduzimos a head na
% lista Cont_aux.
%
%    3 - quando a head da lista nao e' uma sequencia unitaria: neste
% caso, a head nao e' relevante, e chamamos de novo o predicado para a
% Tail.
% ---------------------------------------------------------------------

possibilidades(Pos,Puz,Poss):-
    puzzle_ref(Puz,Pos,[U]),!,
    Poss = [U].

possibilidades(Pos,Puz,Poss) :-
    posicoes_relacionadas(Pos,Posicoes),
    conteudos_posicoes(Puz,Posicoes,Cont),
    possibilidades_aux(Cont,Cont_aux),
    numeros(N),
    flatten(Cont_aux,Res),
    subtract(N,Res,Poss).


possibilidades_aux([],[]).

possibilidades_aux([[H]|T],[H|Cont_aux]) :-
    possibilidades_aux(T,Cont_aux).

possibilidades_aux([_|T],Cont_aux) :-
    possibilidades_aux(T,Cont_aux).



%---------------------------------------------------------------------
%
%            3.2 - Predicados para a inicializacao de puzzles
%               3.2.2 - Predicado inicializa/2
%
%---------------------------------------------------------------------


%---------------------------------------------------------------------
% inicializa_aux(Puz,Pos,N_Puz:
%
%    1 - quando o conteudo da posicao Pos e' uma lista unitaria: usa o
% predicado puzzle_ref(Puz,Pos,[Cont] para ver se o conteudo da posicao
% Pos e' uma lista unitaria, e se for, nada e' alterado.
%
%    2 - quando o conteudo da posicao Pos nao e' uma lista unitaria: vai
% vai ver quais as possibilidades para essa posicao atraves do
% predicado possibilidades(Pos,Puz,Poss), e utiliza o
% puzzle_muda_propaga(Puz,Pos,Poss,N_Puz) para adicionar essas
% possibilidades ao conteudo da posicao.
% --------------------------------------------------------------------

inicializa_aux(Puz,Pos,N_Puz) :-
    puzzle_ref(Puz,Pos,[Cont]),!,
    puzzle_muda_propaga(Puz,Pos,[Cont],N_Puz).

inicializa_aux(Puz,Pos,N_Puz) :-
    possibilidades(Pos,Puz,Poss),
    puzzle_muda_propaga(Puz,Pos,Poss,N_Puz).



%----------------------------------------------------------------------
% inicializa(Puz,N_Puz): o predicado vai buscar todas as posicoes com o
% predicado todas_posicoes(Todas_Posicoes) e utiliza o
% percorre_muda_Puz(Puz,Accao,Todas_Posicoes,N_Puz) para adicionar as
% possibilidades de cada posicao ao seu conteudo (a Accao e' o predicado
% inicializa_aux).
% ---------------------------------------------------------------------

inicializa(Puz,N_Puz) :-
    todas_posicoes(Todas_Posicoes),
    percorre_muda_Puz(Puz,inicializa_aux,Todas_Posicoes,N_Puz).





%---------------------------------------------------------------------
%
%            3.3 - Predicados para a inspecao de puzzles
%               3.3.1 - Predicado so_aparece_uma_vez/4
%
% ----------------------------------------------------------------------

% ----------------------------------------------------------------------
% so_aparece_uma_vez(Puz,Num,Posicoes,Pos_Num): vai utilizar o predicado
% so_aparece_uma_vez_aux(Puz,Num,Posicoes,Pos_Num,[Lst_Pos]), retornando
% a posicao Pos_Num.
%
% so_aparece_uma_vez_aux:
%
%    1 - quando Posicoes e' uma lista vazia: retorna uma lista vazia.
%
%    2 - quando o numero Num aparece numa posicao de Posicoes: vai
% utilizar o predicado puzzle_ref(Puz,H,Cont) para ver o conteudo da
% primeira posicao de Posicoes, e se esse o numero Num estiver nesse
% conteudo (predicado member), adiciona a posicao 'a lista Lst_Pos,
% prosseguindo pelo resto das Posicoes.
%
%    3 - quando o numero Num nao aparece nas Posicoes: vai ver o
% conteudo de cada posicao atraves do predicado puzzle_ref(Puz,H,Cont),
% e caso nao esteja (predicado member), prossegue para o resto das
% Posicoes.
% -----------------------------------------------------------------------

so_aparece_uma_vez(Puz,Num,Posicoes,Pos_Num) :-
    so_aparece_uma_vez_aux(Puz,Num,Posicoes,Pos_Num,[Lst_Pos]),
    Pos_Num = Lst_Pos.

so_aparece_uma_vez_aux(_,_,[],_,[]).

so_aparece_uma_vez_aux(Puz,Num,[H|T],_,[H|Lst_Pos]) :-
    puzzle_ref(Puz,H,Cont),
    member(Num,Cont),!,
    so_aparece_uma_vez_aux(Puz,Num,T,_,Lst_Pos).

so_aparece_uma_vez_aux(Puz,Num,[H|T],_,Lst_Pos) :-
    puzzle_ref(Puz,H,Cont),
    \+ member(Num,Cont),!,
    so_aparece_uma_vez_aux(Puz,Num,T,_,Lst_Pos).



%---------------------------------------------------------------------
%
%            3.3 - Predicados para a inspecao de puzzles
%               3.3.2 - Predicado inspecciona/2
%
%---------------------------------------------------------------------

%---------------------------------------------------------------------
% inspecciona_num: a primeira variante verifica se o Num so ocorre numa
% posicao de Posicoes e se esse conteudo nao e' uma lista unitaria
% atraves do predicado so_aparece_uma_vez(Puz,Num,Posicoes,Pos_Num); a
% segunda variante certifica que o Puz esta correto e iguala-o ao novo
% puzzle.
% ---------------------------------------------------------------------

inspecciona_num(Posicoes,Puz,Num,N_Puz) :-
    so_aparece_uma_vez(Puz,Num,Posicoes,Pos_Num),
    puzzle_muda_propaga(Puz,Pos_Num,[Num],N_Puz).

inspecciona_num(_,Puz,_,Puz).



% -----------------------------------------------------------------------
% inspecciona_grupo(Puz,Gr,N_Puz): o predicado vai buscar a lista de
% numeros L atraves do predicado numeros(L), vai utilizar o predicado
% percorre_muda_Puz(Puz,Accao,Lst,N_Puz), onde a Accao e' o predicado
% inspecciona_num(Gr) (utilizado sobre a lista de posicoes Gr) que e'
% aplicado 'a lista L de numeros.
% -----------------------------------------------------------------------
%

inspecciona_grupo(Puz,Gr,N_Puz) :-
    numeros(L),
    percorre_muda_Puz(Puz,inspecciona_num(Gr),L,N_Puz).



% -----------------------------------------------------------------------
% inspecciona(Puz,N_Puz): vai utilizar o predicado grupos(Gr) que contem
% uma lista com todas as posicoes de um grupo, e vai utilizar o
% predicado percorre_muda_Puz(Puz,Accao,Lst,N_Puz), em que a Accao e' o
% predicado inspecciona_grupo, que vai ser aplicado na lista Gr.
% -----------------------------------------------------------------------

inspecciona(Puz,N_Puz) :-
    grupos(Gr),
    percorre_muda_Puz(Puz,inspecciona_grupo,Gr,N_Puz).





% -----------------------------------------------------------------------
%
%            3.4 - Predicados para a verificacao de solucoes
%
% -----------------------------------------------------------------------

% -----------------------------------------------------------------------
% grupo_correcto(Puz,Nums,Gr): verifica se um grupo de Puz e' correto.
% Para isso, utiliza o predicado conteudos_posicoes(Puz,Gr,Conteudos)
% para ir buscar o conteudo de Gr (lista de listas, em que cada lista e'
% uma lista com todas as posicoes de uma linha do puzzle), usa o
% predicado flatten(Conteudos,Conteudos_aux) para mudar a lista Gr para
% uma lista de listas, em que cada lista tem as posicoes, ordena os
% Conteudos_aux e os Nums atraves do predicado msort, e verifica se esses
% conteudos sao iguais aos numeros dados.
% -----------------------------------------------------------------------

grupo_correcto(Puz,Nums,Gr) :-
    conteudos_posicoes(Puz,Gr,Conteudos),
    flatten(Conteudos,Conteudos_aux),
    msort(Conteudos_aux,Conteudos_sort),
    msort(Nums,Nums_sort),
    Conteudos_sort = Nums_sort.


% -----------------------------------------------------------------------
% solucao(Puz): verifica se Puz e' uma solucao, atraves dos predicados
% grupos(Gr) e solucao_aux(Puz,Gr).
%
% solucao_aux:
%
%    1 - caso Gr seja uma lista vazia, o predicado nao faz nada.
%
%    2 - caso Gr nao seja uma lista vazia, o predicado numeros(L) e'
% chamado, o predicado grupo_correcto(Puz,L,H) e' utilizado para
% verificar se H e' um grupo correto, e se for, chama de novo a funcao
% para a Tail da lista.
% -----------------------------------------------------------------------

solucao(Puz) :-
    grupos(Gr),
    solucao_aux(Puz,Gr).

solucao_aux(_,[]).

solucao_aux(Puz,[H|T]) :-
    numeros(L),
    grupo_correcto(Puz,L,H),!,
    solucao_aux(Puz,T).















































































