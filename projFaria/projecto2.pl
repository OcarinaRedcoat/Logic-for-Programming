:- include('SUDOKU').
:- include('exemplos').


exemplo([[[ ],[3],[ ],[ ],[ ],[1],[ ],[ ],[ ]],
[[ ],[ ],[6],[ ],[ ],[ ],[ ],[5],[ ]],
[[5],[ ],[ ],[ ],[ ],[ ],[9],[8],[3]],
[[ ],[8],[ ],[ ],[ ],[6],[3],[ ],[2]],
[[ ],[ ],[ ],[ ],[5],[ ],[ ],[ ],[ ]],
[[9],[ ],[3],[8],[ ],[ ],[ ],[6],[ ]],
[[7],[1],[4],[ ],[ ],[ ],[ ],[ ],[9]],
[[ ],[2],[ ],[ ],[ ],[ ],[8],[ ],[ ]],
[[ ],[ ],[ ],[4],[ ],[ ],[ ],[3],[ ]]],1).

%---------------------------------------------------------------------
% Bernardo Goncalves de Faria   Nr87636
% --------------------------------------------------------------------


%---------------------------------------------------------------------
%
%            3.1 - Predicados para a propagacao de mudancas
%               3.1.1 - Predicado tira_num/4
%
% --------------------------------------------------------------------


%---------------------------------------------------------------------
% tira_num_aux(Num,Puz,Pos,N_Puz):Retorna o puzzle N_Puz
% resultante de tirar o numero Num da posicao Pos do puzzle Puz. Para
% isso, usa os predicados puzzle_ref(Puz,Pos,Cont),
% puzzle_muda(Puz,Pos,Cont_aux,N_puz) e subtract(Cont,[Num],Cont_aux)
% que tira o numero Num do Cont e devolte o Cont_aux.
% --------------------------------------------------------------------

tira_num_aux(Num,Puz,Pos,N_Puz) :-
    puzzle_ref(Puz,Pos,Cont),
    subtract(Cont,[Num],Cont_aux),
    puzzle_muda_propaga(Puz,Pos,Cont_aux,N_Puz).



%---------------------------------------------------------------------
% tira_num(Num,Puz,Posicoes,N_Puz): retorna o puzzle N_Puz resultante
% de tirar o numero Num de todas as posicoes em Posicoes do puzzle Puz.
% Fa-lo atraves do predicado percorre_muda_Puz(Puz,Accao,Lst,N_Puz) que
% retorna o N_Puz resultante de aplicar a Accao(que neste caso e o
% predicado tira_num_aux(Num,Puz,Pos,N_Puz) a cada elemento de Lst, que
% neste caso sao as posicoes em Posicoes, de Puz.
%---------------------------------------------------------------------

tira_num(Num,Puz,Posicoes,N_Puz) :-
    percorre_muda_Puz(Puz,tira_num_aux(Num),Posicoes,N_Puz).





%---------------------------------------------------------------------
%
%            3.1 - Predicados para a propagacao de mudancas
%               3.1.2 - Predicado puzzle_muda_propaga/4
%
%---------------------------------------------------------------------


%---------------------------------------------------------------------
% puzzle_muda_propaga(Puz,Pos,Cont,N_Puz): existem tres variantes na
% implementacao deste predicado:
%
%   1 - quando o conteudo da posicao Pos e' igual ao Cont: neste caso,
% implementamos o predicado puzzle_ref(Puz,Pos,Cont) que mantem o
% conteudo na posicao escolhida.
%
%   2 - quando o Cont e' uma lista unitaria: aqui, mantemos o Cont
% atraves do predicado puzzle_muda(Puz,Pos,[Cont],N_Puz1), percorremos
% todas as posicoes em Posicoes atraves do predicado
% posicoes_relacionadas(Pos,Posicoes), e retiramos o Cont dessas
% Posicoes atraves do predicado tira_num(Cont,N_Puz1,Posicoes,N_Puz).
%
%   3 - quando o Cont nao e' uma lista unitaria: nesta situacao,
% aplicamos diretamente o predicado puzzle_muda(Puz,Pos,Cont,N_Puz) para
% mudar o conteudo da posicao Pos para Cont.
% ---------------------------------------------------------------------

puzzle_muda_propaga(Puz,Pos,Cont,Puz) :-
    puzzle_ref(Puz,Pos,Cont),!.


puzzle_muda_propaga(Puz,Pos,[Cont],N_Puz) :-
    !,
    puzzle_muda(Puz,Pos,[Cont],N_Puz1),
    posicoes_relacionadas(Pos,Posicoes),
    tira_num(Cont,N_Puz1,Posicoes,N_Puz).


puzzle_muda_propaga(Puz,Pos,Cont,N_Puz):-
    puzzle_muda(Puz,Pos,Cont,N_Puz).



%---------------------------------------------------------------------
%
%            3.2 - Predicados para a inicializacao de puzzles
%               3.2.1 - Predicado possibilidades/3
%
%---------------------------------------------------------------------


%---------------------------------------------------------------------
% possibilidades(Pos,Puz,Poss): existem duas variantes para este
% predicado:
%
%    1 - quando a posicao Pos ja contem uma sequencia unitaria: aqui,
% utilizamos o predicado puzzle_ref(Puz,Pos,[N]), que verifica
% se o conteudo da posicao Pos e uma sequencia unitaria, e se for,
% inclui-a na lista Poss.
%
%    2 - quando a posicao Pos nao contem uma sequencia unitaria: neste
% caso, utilizamos o predicado posicoes_relacionadas(Pos,Posicoes) para
% obter as Posicoes relacionadas com a posicao Pos, utilizamos o
% predicado conteudos_posicoes(Puz,Posicos,Cont) para verificarmos os
% conteudos das Posicoes e introduzirmo-los no Cont. Depois,
% implementamos o predicado possibilidades_aux(Cont,Cont_aux) que vai
% introduzir no Cont_aux apenas as sequencias unitarias existentes em
% Cont; o predicado flatten(Cont_aux,Res) transforma a lista de listas
% Cont_aux numa lista de numeros Res. O predicado numeros(N) lista os
% numeros do 1 'a dimensao do puzzle, e e' utilizado para obter os
% numeros possiveis, relacionando-se com o predicado
% subtract(N,Res,Poss), que subtrai 'a lista N os numeros de Res,
% obtendo os numeros possiveis.
%
% O predicado possibilidades_aux tem tres variantes:
%
%    1 - quando a posicao e' uma lista vazia, que retorna essa lista
%    vazia.
%
%    2 - quando a head da lista ja e' uma sequencia unitaria: aqui,
% chamamos de novo o predicado para a Tail, e introduzimos a head na
% lista Cont_aux.
%
%    3 - quando a head da lista nao e' uma sequencia unitaria: neste
% caso, a head nao e' relevante, e chamamos de novo o predicado para a
% tail.
%
% ---------------------------------------------------------------------

possibilidades(Pos,Puz,Poss):-
    puzzle_ref(Puz,Pos,[N]),!,
    Poss = [N].

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
% inicializa_aux: ha duas variantes:
%    1 - quando o conteudo da posicao Pos e' uma lista unitaria: usa o
% predicado puzzle_ref para ver se o conteudo da posicao Pos e uma lista
% unitaria, e se for, nada e alterado.
%    2 - quando o conteudo da posicao Pos nao e' uma lista unitaria: vai
% vai ver quais as possibilidades para essa posicao, e utiliza o
% puzzle_muda_propaga para adicionar essas possibilidades ao conteudo da
% posicao.
% --------------------------------------------------------------------

inicializa_aux(Puz,Pos,N_Puz) :-
    puzzle_ref(Puz,Pos,[Cont]),!,
    puzzle_muda_propaga(Puz,Pos,[Cont],N_Puz).

inicializa_aux(Puz,Pos,N_Puz) :-
    possibilidades(Pos,Puz,Poss),
    puzzle_muda_propaga(Puz,Pos,Poss,N_Puz).


%----------------------------------------------------------------------
% inicializa: o predicado vai buscar todas as posicoes com o predicado
% todas_posicoes e utiliza o percorre_muda_Puz para adicionar as
% possibilidades de cada posicao ao seu conteudo (a Accao e o predicado
% inicializa_aux).

inicializa(Puz,N_Puz) :-
    todas_posicoes(Todas_Posicoes),
    percorre_muda_Puz(Puz,inicializa_aux,Todas_Posicoes,N_Puz).




%---------------------------------------------------------------------
%
%            3.3 - Predicados para a inspecao de puzzles
%               3.3.1 - Predicado so_aparece_uma_vez/4
%
%---------------------------------------------------------------------

%---------------------------------------------------------------------
%
%---------------------------------------------------------------------

so_aparece_uma_vez(Puz,Num,Posicoes,Pos_Num) :-!,
    so_aparece_uma_vez_aux(Puz,Num,Posicoes,Vazia),
    length(Vazia,1),
    Pos_Num = Vazia.

so_aparece_uma_vez_aux(_,_,[],[]) :-!.

so_aparece_uma_vez_aux(Puz,Num,[H|T],[H|L]) :-!,
    puzzle_ref(Puz,H,Cont),
    member(Num,Cont),
    so_aparece_uma_vez_aux(Puz,Num,T,L).

so_aparece_uma_vez_aux(Puz,Num,[H|T],L) :-
    puzzle_ref(Puz,H,Cont),
    \+ member(Num,Cont),
    so_aparece_uma_vez_aux(Puz,Num,T,L).