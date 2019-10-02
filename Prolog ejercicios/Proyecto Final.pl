%--------------------------------------------------------------------------------------------
%PREDICADOS GENERICOS.
%recibe (ITEM (elemento a agregar) LISTAACTUAL(lista)), devuelve [ITEM|LISTAACTUAL](nuevaLista).
agregar(ITEM,LISTAACTUAL,[ITEM|LISTAACTUAL]).

%predicado generico para eliminar un item de una lista
eliminarItem(X, [X|Xs], Xs).%si la cabeza  de la lista es igual al item. Devuelve la cola de la lista
eliminarItem(X, [Y|Ys], [Y|Zs]):- eliminarItem(X, Ys, Zs).

%predicado generico muestra los elementos actuales de una lista
mostrarElementos([]).
mostrarElementos([X|L]):- mostrarElementos(L),write(X),write(',').
%-------------------------------------------------------------------------------------------------------
%PREDICADOS OPCION 1
%cuando se leyeron todos los numero se ejecuta la eliminacion
ingresarValoresListaEliminar(0,LISTALLENA):- mostrarElementos(LISTALLENA),
                                             write('Escriba elemento a eliminar'),nl,
                                             read(ITEM),
                                             eliminarItem(ITEM,LISTALLENA,R),
                                             write('La lista luego de la eliminacion es:'),nl,
                                             mostrarElementos(R),nl.

%recibe un NUMITEMS que indica cuantos elementos se van a leer.
ingresarValoresListaEliminar(NUMITEMS,LISTAACTUAL) :- write('ingrese Elemento'), 
                                              read(ITEM),
                                              agregar(ITEM,LISTAACTUAL,LISTANUEVA),
                                              C is NUMITEMS-1,
                                              ingresarValoresListaEliminar(C,LISTANUEVA).

%-------------------------------------------------------------------------------------------
validar(L):-forall(member(X,L),atom(X)).

contar(_,[],0):- !.
contar(X,[X|C],S):-contar(X,C,S1),!,S is S1+1.
contar(X,[_|C],S):-contar(X,C,S).

eliminar(_,[],[]):-!.
eliminar(X,[],C1):- eliminar(X,C,C1),!.
eliminar(X,[M|Y],[M|C1]):- eliminar(X,C,C1).

armar([],[]):-!.
armar([X|C],[[X,Y]|C1]):-contar(X,C,S), Y is S+1, eliminar(X,C,L1),armar(L1,C1),!.

maximo([[W,Z]],[W,Z]):-!.

maximo([[_,y]|L],[W,Z]):- maximo(L,[W,Z]), Y<Z , !.
maximo([[X,Y]|_],[X,Y]).

encontrar_max([],[]):-!. %llega lista vacia no hace nada
encontrar_max(C,_):- not(validar(C)),!,write('Lista Invalida').

%devuelve el elemento y el numero de veces repetido.
encontrar_max(C,L):- armar(C,L1),maximo(L1,L).


%PREDICADOS OPCION 3
%cuando se leyeron todos los numero se ejecuta la eliminacion
ingresarValoresListaMasRepetido(0,LISTALLENA):- mostrarElementos(LISTALLENA),
                                                encontrar_max(LISTALLENA,R),
                                                write('El elemento mas repetido es'),nl,
                                                write(R),nl.

%recibe un NUMITEMS que indica cuantos elementos se van a leer.
ingresarValoresListaMasRepetido(NUMITEMS,LISTAACTUAL) :- write('ingrese Elemento'), 
                                              read(ITEM),
                                              agregar(ITEM,LISTAACTUAL,LISTANUEVA),
                                              C is NUMITEMS-1,
                                              ingresarValoresListaMasRepetido(C,LISTANUEVA).

%-----------------------------------------------------------------------------------------------
%PREDICADOS OPCION 4
%
%base del conocimiento que me dice los vecinos de un pais.
vecino(ecuador,peru).
vecino(ecuador,colombia).
vecino(peru,colombia).
vecino(peru,brasil).
vecino(peru,bolivia).
vecino(peru,chile).
vecino(colombia,venezuela).
vecino(colombia,brasil).
vecino(venezuela,guyana).
vecino(venezuela,brasil).
vecino(guyana,surinam).
vecino(guyana,brasil).
vecino(surinam,brasil).
vecino(brasil,bolivia).
vecino(brasil,paraguay).
vecino(brasil,argentina).
vecino(brasil,uruguay).
vecino(bolivia,chile).
vecino(bolivia,paraguay).
vecino(bolivia,argentina).
vecino(chile,argentina).
vecino(paraguay,argentina).
vecino(argentina,uruguay).
limitacon(A,B) :- vecino(A,B).
limitacon(A,B) :- vecino(B,A).

solucionMapa([]).
solucionMapa([X/Y|Tail]) :- 

            			solucionMapa(Tail),
    					color(Y, [1,2,3,4]),
    				    %cada numero representaría un color diferente
    				    diferentecolor(X/Y, Tail).

diferentecolor(_,[]).
diferentecolor(X/Y, [X1/Y1|Tail]) :-
            limitacon(X,X1),
            Y =\= Y1,
            diferentecolor(X/Y,Tail).

diferentecolor(X/Y, [X1/_|Tail]) :-

            not(limitacon(X,X1)),

            diferentecolor(X/Y,Tail).

color(Elemento,[Elemento|_]).

color(Elemento,[_|Restante]):-  color(Elemento,Restante).

%------------------------------------------------------------------------------------------------
%OPCION DE PROBLEMA N REINAS. 

%LAS POSICIONES FINALES SE REPRESENTARAN DE LA FORMA CLASICA A1, A2..H7,H8

%el conocimiento inicial esque sabemos que ninguna reina puede estar en la misma columna.
%y se le asigna a cada reina diferente letra. o columna representada por la lista inicial que va desde la A hasta H


%se define la base del conocimiento de posiciones numericas disponibles que representan las filas.
posicion(1).
posicion(2).
posicion(3).
posicion(4).
posicion(5).
posicion(6).
posicion(7).
posicion(8).

% llamada recursiva principal.

reinas([]).
reinas([X|L]):-%recibe las 8 reinas cada una con letra diferente(representan las columnas)
reinas(L),%todas las reinas pueden tomaran cualquier fila de 1 a 8
posicion(X),%retorna cualquier posicion. de fila.
comprueba(X,L,0).


% Comprobación de que las reinas no se amenacen entre sí
comprueba(_,[],_).
comprueba(X,[X1|L],N):-%compara la reina X con todas las reinas restantes. 
N1 is N+1,
X =\= X1, % Distinta fila
X =\= X1+N1, % Distinta diagonal superior
X =\= X1-N1, % Distinta diagonal hacia abajo
comprueba(X,L,N1).



%_______________________________________________________________________________________________







llenarListaEliminar :- write('ingrese numero de elementos a agregar en lista\n'),
                       read(NUMITEMS),
                       ingresarValoresListaEliminar(NUMITEMS,L).

llenarListaMasRepetido :- write('ingrese numero de elementos a agregar en lista\n'),
                          read(NUMITEMS),
                          ingresarValoresListaMasRepetido(NUMITEMS,L1).


%%Predicado menu:caputa por teclado la opcion
menu  :- write('***Bienvenido al menu*** \n'),
	 write('1.Eliminar elemento de una lista'),nl,
	 %write('2.Busqueda binaria de una lista '),nl,
	 write('3.Numero que mas se repite en una lista'),nl,
	 %write('4.Coloreado de un mapa'),nl,
	 write('5.8 reinas'),nl,
	 %write('6.Ejecucion de tareas en segundos'),nl,
	 %write('7.Canibales y misioneros'),nl,
	 write('Oprima una opcion (para salir 0): '), read(Opcion),ejecutarOpcion(Opcion).

% Predicado ejecutarOpcionejecuta una opcion seleccionada y vuelve a
% llamar el menu.

ejecutarOpcion(Opcion) :- Opcion == 1,llenarListaEliminar, menu;
			  Opcion == 2, menu;
			  Opcion == 3,llenarListaMasRepetido, menu;
			  Opcion == 4,solucionMapa(['colombia'/C]), menu;
			  Opcion == 5,reinas([A,B,C,D,E,F,G,H]),write('Reina1 pos: A'),write(A),nl, 
    											    write('Reina2 pos: B'),write(B),nl, 
    												write('Reina3 pos: C'),write(C),nl, 
    												write('Reina4 pos: D'),write(D),nl, 
    												write('Reina5 pos: E'),write(E),nl, 
    											    write('Reina6 pos: F'),write(F),nl, 
    												write('Reina7 pos: G'),write(G),nl,
    												write('Reina8 pos: H'),write(H),nl,
    				    menu;
			  Opcion == 6, menu;
			  Opcion == 7, menu;
			  Opcion == 0, true.