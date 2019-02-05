%BASE DEL CONOCIMiENTo de lo que son enfermedades+
enfermedad(neumonia).
enfermedad(tuberculosis).
enfermedad(hepatitisB).
enfermedad(gastritis).
enfermedad(sinusitis).
enfermedad(gripa).
%
% sintoma(X,Y) = X es sintoma de Y, donde Y es enfermedad
%
% enfermedad: Neumonia
sintoma(fiebre,neumonia).
sintoma(dolorToraxico, neumonia).
sintoma(dolorCabeza, neumonia).
sintoma(escalofrios, neumonia).
sintoma(tos,neumonia).
sintoma(nauseas,neumonia).
%enfermedad:gripa
sintoma(fiebre,gripa).
sintoma(malestar,gripa).
sintoma(dolorCabeza,gripa).
sintoma(escalofrios,gripa).
sintoma(somnolencia,gripa).
% enfermedad: Tuberculosis
sintoma(fiebre,tuberculosis).
sintoma(cansancio,tuberculosis).
sintoma(perdidaPeso,tuberculosis).
sintoma(faltaApetito,tuberculosis).
sintoma(tos ,tuberculosis).
sintoma(sudoracion ,tuberculosis).
% enfermedad: Hepatitis B
sintoma(fiebre,hepatitisB).
sintoma(cansancio,hepatitisB).
sintoma(dolorParteAltaAbdomen,hepatitisB).
sintoma(ictericia,hepatitisB).
sintoma(orinaColorOscuro,hepatitisB)
% enfermedad: Gastritis
sintoma(distencionAbdominal,gastritis).
sintoma(nauseas,gastritis).
sintoma(dolorParteAltaAbdomen,gastritis).
sintoma(faltaApetito,gastritis).
sintoma(acidezEstomacal,gastritis).
% enfermedad: Sinusitis
sintoma(fiebre,sinusitis).
sintoma(congestionSecrecionNasal,sinusitis).
sintoma(dolorCabeza,sinusitis).
sintoma(tos,sinusitis).
%medicamento_atomo(ibuprofeno).
%--------------------------------------------------------------------
% medicamento(X,Y) = X es medicamento de Y
%--------------------------------------------------------------------
% enfermedad: Neumonia
medicamento(ibuprofeno ,neumonia).
medicamento(azitromicina,neumonia).
medicamento(claritromicina,neumonia).
medicamento(amoxicilina,neumonia).
medicamento(dextrometorfano,neumonia).
% enfermedad: Tuberculosis
medicamento(ibuprofeno ,tuberculosis).
medicamento(complejoB,tuberculosis).
medicamento(pirazinamida,tuberculosis).
medicamento(ribavirina,tuberculosis).
medicamento(dextrometorfano,tuberculosis).
% enfermedad: Hepatitis B
medicamento(ibuprofeno,hepatitisB).
medicamento(ondansetron,hepatitisB).
medicamento(omeprazol ,hepatitisB).
medicamento(timosina ,hepatitisB).
medicamento(entecavir,hepatitisB).
% enfermedad: Gastritis
medicamento(almax ,gastritis).
medicamento(ondansetron,gastritis).
medicamento(omeprazol ,gastritis).
medicamento(ribavirina_l,gastritis).
medicamento(ridocaina ,gastritis).
% enfermedad: Sinusitis
medicamento(ibuprofeno,sinusitis).
medicamento(ampicilina,sinusitis).
medicamento(clindamicina ,sinusitis).
medicamento(amoxicilina,sinusitis).
medicamento(dextrometorfano,sinusitis).
medicamento(noraver,gripa).
medicamento(noxpirin,gripa).
%reglas para gestionar la base del conocimiento

% elemento X no pertenece a la lista [Y|Ys]
% donde Y es la cabeza y Ys es la cola.
noPertenece(X,[]).
noPertenece(X,[Y|Ys]):-X\=Y,noPertenece(X,Ys).

% elemento X pertenece a la lista
pertenece(X,[X|_]).
pertenece(X,[_|T]):- pertenece(X,T).

% verifica si la lista [X] con duplicados, contiene
% los mismos elementos de la lista [Y] sin duplicados
% ejemplos:
% sinDuplicados([1,1,1,2,2,2,2,2,4,3,3,3,3,3,4],[1,2,3,4]).   => true
% sinDuplicados([1,2,3],[1,2,3]).   => true
% sinDuplicados([1,1,2,3],[1,1,2,3]).  => false
% sinDuplicados([1,2,3],[1,2,4]).   => false
sinDuplicados([],[]).
sinDuplicados([X|Xs],[X|Ys]):-noPertenece(X,Xs),sinDuplicados(Xs,Ys).
sinDuplicados([X|Xs],Ys):- pertenece(X,Xs),sinDuplicados(Xs,Ys).

% el metodo consultar nos permite encontrar la enfermedad E que tenga
% todos los sintomas de la lista [X,Xs]
% ejemplo:
% consultar([fiebre,dolorToraxico,dolorCabeza,escalofrios,tos],E,P).  =>  E=neumonia   P=5
consultar([],E,0).
consultar(X , E , 1) :- sintoma(X, E).
consultar([X|Xs], E, P) :- enfermedad(E), consultar(X, E, S1), consultar(Xs, E, S2), P is S1 + S2.
%esta funcion se llama en diagnostico lo que hace es calcular la cantidad
%completa  de sintomas para
%una enfermedad
totalSintoma(E , K) :- findall(X , sintoma(X, E) , L) , length(L , K) .

% funcion que recibe una lista de sintomas y devuelve las enfermedades
% con su probabilidad esto lo hace llamando a la funcion consultar que le da cuantos
% sintomas tiene una enfermedad y lo compara con todos los posibles sintomas de la enfermedad y con esto se sabe la probabilidad
% entre mas completo sea nuestra base de conocimiento la probabilidad sera mas exacta
%diagnostico([fiebre,tos],E,T). caso de pruebas
diagnostico([X|Xs], E, K) :- consultar([X|Xs], E, P), totalSintoma(E, T), K is P * 100 / T.
% para ejecutar un ejemplo :
% diagnostico_completo([fiebre,dolorCabeza,tos],E,K,TRATAMIENTO).
diagnostico_completo([X|Xs], E, K, TRATAMIENTO):- diagnostico([X|Xs],E,K), cant_medicamentos(E,T), TRATAMIENTO = T.
% medicamento M alivia los sintomas S
alivia_sintoma(M,S):-medicamento(M,E),sintoma(S,E).

% Cantidad T de medicamentos que pueden aliviar la enfermedad E
cant_medicamentos(E,T):- findall(M,medicamento(M,E),T), length(T,C).