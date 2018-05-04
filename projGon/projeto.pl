%Goncalo Moita	87661
:-include('SUDOKU').

tira_num(Num,Puz,Posicoes,N_Puz):-
	percorre_muda_Puz(Puz,tira_num_aux(Num),Posicoes,N_Puz).

tira_num_aux(Num,Puz,Pos,N_Puz):-
	puzzle_ref(Puz,Pos,Cont),H=[Num],
	subtract(Cont,H,Res),
	puzzle_muda_propaga(Puz,Pos,Res,N_Puz).

puzzle_muda_propaga(Puz,Pos,Cont,Puz):-
	puzzle_ref(Puz,Pos,Cont),!.

puzzle_muda_propaga(Puz,Pos,[Num],N_Puz):-!,
	puzzle_muda(Puz,Pos,[Num],N_Puz1),
	posicoes_relacionadas(Pos,Posicoes),
	tira_num(Num,N_Puz1,Posicoes,N_Puz).

puzzle_muda_propaga(Puz,Pos,Cont,N_Puz):-
	puzzle_muda(Puz,Pos,Cont,N_Puz).

inicializa(Puz,N_Puz):- 
	todas_posicoes(Todas_Posicoes),
	percorre_muda_Puz(Puz,inicializa_aux,Todas_Posicoes,N_Puz),!.

inicializa_aux(Puz,Pos,N_Puz):- 		
	puzzle_ref(Puz,Pos,Cont),length(Cont,0),
	possibilidades(Pos,Puz,Poss),
	puzzle_muda_propaga(Puz,Pos,Poss,N_Puz),!.

inicializa_aux(Puz,_,Puz).	

possibilidades(Pos,Puz,Poss):- 		
	posicoes_relacionadas(Pos,Posicoes),
	conteudos_posicoes(Puz,Posicoes,Conteudos),
	numeros(Todos),obter_Poss(Conteudos,Todos,Poss).

obter_Poss([],Conteudo_Unitario,Conteudo_Unitario).

obter_Poss([H|T],Acomp,Conteudo_Unitario):-
	length(H,1),subtract(Acomp,H,Novo_Acomp),
	obter_Poss(T,Novo_Acomp,Conteudo_Unitario),!.
										
obter_Poss([_|T],Acomp,Conteudo_Unitario):-
	obter_Poss(T,Acomp,Conteudo_Unitario).
	
so_aparece_uma_vez(Puz,Num,Posicoes,Pos_Num):- 
	getPosOcorre(Puz,Posicoes,Num,Posicoes,Pos_Num_Aux),
	length(Pos_Num_Aux,1),[Pos]=Pos_Num_Aux,Pos_Num =(Pos).

getPosOcorre(_,[],_,Pos_Num,Pos_Num).

getPosOcorre(Puz,[H|T],Num,Pos_Acomp,Pos_Num):-
	puzzle_ref(Puz,H,Conteudo),
	member(Num,Conteudo),getPosOcorre(Puz,T,Num,Pos_Acomp,Pos_Num),!.

getPosOcorre(Puz,[H|T],Num,Pos_Acomp,Pos_Num):-
	subtract(Pos_Acomp,[H],Nova_Pos_Acomp),
	getPosOcorre(Puz,T,Num,Nova_Pos_Acomp,Pos_Num).
										
inspecciona_num(Posicoes,Puz,Num,N_Puz):- 	
	so_aparece_uma_vez(Puz,Num,Posicoes,Pos_Num),
	puzzle_muda_propaga(Puz,Pos_Num,[Num],N_Puz),!.

inspecciona_num(_,Puz,_,Puz).

inspecciona_grupo(Puz,Gr,N_Puz):-		
	numeros(Todos),
	inspeciona_varios_nums(Gr,Todos,Puz,N_Puz).

inspeciona_varios_nums(_,[],Puz,Puz).

inspeciona_varios_nums(Posicoes,[H|T],Puz,N_Puz):-
	inspecciona_num(Posicoes,Puz,H,Puz_Aux),
	inspeciona_varios_nums(Posicoes,T,Puz_Aux,N_Puz).

inspeciona_varios_grupos([],Puz,Puz).

inspeciona_varios_grupos([H|T],Puz,N_Puz):-	
	inspecciona_grupo(Puz,H,Puz_Aux),
	inspeciona_varios_grupos(T,Puz_Aux,N_Puz).

inspecciona(Puz,N_Puz):-
	grupos(Gr),
	inspeciona_varios_grupos(Gr,Puz,N_Puz),!.
	
solucao(Puz):-							
	grupos(Gr),
	verifica_varios_grupos(Gr,Puz).

verifica_varios_grupos([],_).
										
verifica_varios_grupos([H|T],Puz):-
	numeros(Nums),
	grupo_correcto(Puz,Nums,H),
	verifica_varios_grupos(T,Puz),!.

grupo_correcto(_,[],_).

grupo_correcto(Puz,[H|T],Posicoes):-	
	so_aparece_uma_vez(Puz,H,Posicoes,_),
	grupo_correcto(Puz,T,Posicoes).
	
resolve(Puz,Sol):-	
	inicializa(Puz,Sol_Aux),inspeciona(Sol_Aux,Sol),
	solucao(Sol).