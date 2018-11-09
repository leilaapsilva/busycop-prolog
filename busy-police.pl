%Juliana Karoline 594997
%Leila Aparecida 628166
%Nicolas Prates 628212

% ambiente:
% 1 2 3 4 5 6 7 8 9 10
%5
%4
%3
%2
%1

% Ambiente 3
%escada representada pela parte de baixo
escada(9,1).
escada(1,2).
escada(10,3).
escada(5,4).
carrinho(3,2).
carrinho(5,2).
carrinho(7,2).
carrinho(7,3).
carrinho(7,5).
carrinho(8,4).
vortex(3,3).
ladrao(1,5).


%a meta é a posiçao do ladrao
meta([X,Y]) :- ladrao(X,Y).

%uma posiçao esta ocupada se tiver algum objeto
ocupado(X,Y) :- carrinho(X,Y).
ocupado(X,Y) :- escada(X,Y).
ocupado(X,Y) :- escada(X,Y2), Y2 is (Y+1).
ocupado(X,Y) :- ladrao(X,Y).
ocupado(X,Y) :- vortex(X,Y).

%sempre verifica se nao esta no caminho que ja foi visitado

%move para um lugar aleatório caso encontre um vortex
move([X,Y],[X3,Y3],Caminho) :- vortex(X,Y), random_between(1,10,X3), random_between(1,5,Y3), not(ocupado(X3,Y3)), not(pertence([X,Y],[X3,Y3]|Caminho)).%tentativa 1
move([X,Y],[X4,Y4],Caminho) :- vortex(X,Y), random_between(1,10,X4), random_between(1,5,Y4), not(ocupado(X4,Y4)), not(pertence([X,Y],[X4,Y4]|Caminho)).%tentativa 2
move([X,Y],[X5,Y5],Caminho) :- vortex(X,Y), random_between(1,10,X5), random_between(1,5,Y5), not(ocupado(X5,Y5)), not(pertence([X,Y],[X5,Y5]|Caminho)).%tentativa 3

%se as três tentativas gerarem uma posição já ocupada, joga para os cantos da tela
move([X,Y],[1,1],Caminho) :- vortex(X,Y),  not(ocupado(1,1)), not(pertence([X,Y],[1,1]|Caminho)). %canto inferior esquerdo
move([X,Y],[1,5],Caminho) :- vortex(X,Y),  not(ocupado(1,5)), not(pertence([X,Y],[1,5]|Caminho)). %canto superior esquerdo
move([X,Y],[10,1],Caminho) :- vortex(X,Y),  not(ocupado(10,1)), not(pertence([X,Y],[10,1]|Caminho)). %canto inferior direito
move([X,Y],[10,5],Caminho) :- vortex(X,Y),  not(ocupado(10,5)), not(pertence([X,Y],[10,5]|Caminho)). %canto superior direito

%move para cima se tiver escada 
move([X,Y1],[X,Y2], Caminho) :-  escada(X,Y1), Y2 is (Y1+1), Y2<6, not(pertence([X,Y2],[X,Y1]|Caminho)). 

%move para direita se nao for a ultima posiçao
move([X1,Y],[X2,Y], Caminho) :- X2 is (X1+1), X2 < 11, not(carrinho(X2,Y)), not(pertence([X2,Y],[X1,Y]|Caminho)).

%move para esquerda se nao for a primeira posiçao
move([X1,Y],[X2,Y], Caminho) :- X2 is (X1-1), X2 > 0, not(carrinho(X2,Y)), not(pertence([X2,Y],[X1,Y]|Caminho)).

%move dois para a direita se tiver um carrinho e nao tiver um objeto depois
move([X1,Y],[X3,Y], Caminho) :-  X2 is (X1+1), X3 is (X1+2), X3<11, carrinho(X2,Y),  not(ocupado(X3,Y)), not(pertence([X2,Y],[X1,Y]|Caminho)), not(ocupado(X1,Y)).

%move dois para a esquerda se tiver um carrinho e nao tiver um objeto depois
move([X1,Y],[X3,Y],Caminho) :- X2 is (X1-1), X3 is (X1-2), X3>0, carrinho(X2,Y), not(ocupado(X3,Y)), not(pertence([X2,Y],[X1,Y]|Caminho)), not(ocupado(X1,Y)).

%move para baixo se tiver escada 
move([X,Y1],[X,Y2],Caminho) :- escada(X,Y2), Y2 is (Y1-1), Y2>0, not(pertence([X,Y2],[X,Y1]|Caminho)).

%função auxiliar
pertence(X,[X|_]).
pertence(X,[_|L]) :- pertence(X,L).

%chamada inicial - passa para a dfs 
pega_ladrao(Inicio,Solucao) :- dfs([],Inicio,Solucao).

dfs(Caminho,Estado,[Estado|Caminho]) :- nl, meta(Estado).
dfs(Caminho,Estado,Solucao) :- write(Estado), move(Estado,Sucessor, Caminho), not(pertence(Sucessor,[Estado|Caminho])), dfs([Estado|Caminho],Sucessor,Solucao).

%para rodar:
%  ?-pega_ladrao([x_inicial,y_inicial],X)

%exemplo: (sendo x_inicial,y_inicial a posiçao do policial)
%  ?-pega_ladrao([1,1],X)