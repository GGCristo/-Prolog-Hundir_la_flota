:- dynamic(vivo/3).

comprobar_final :-
  \+ vivo(_,_,_) ->
  write('Ya has terminado\n'),
  nb_getval(fuego,F), format('Has disparado un total de: ~d veces~n', [F]),
  nb_getval(contador_vivos,C), format('Coordenadas iniciales con enemigos: ~d~n', [C]),
  I is 10 * F,
  nb_getval(dimension,D0), D is D0 * D0,
  DIM is 10 * D,
  NUM is I - DIM,
  DEN is C - D,
  Puntuacion is NUM / DEN,
  format('Has conseguido una puntuacion de: ~2f~n', [Puntuacion]).

comprobar_disparo(X,Y,_) :-
  vivo(X,Y,_) ->
  retract(vivo(X,Y,_)),
  write('Tocado\n');
  % estahundido(X,Y,_);
  write('Fallaste\n').

estahundido(X, Y, _) :-
  format('El barco es : ~d ~d ~d~n', [X,Y,_]).

fuego :-
  write('Coordenada \'X\' del disparo: '),
  read(X),
  write('Coordenada \'Y\' del disparo: '),
  read(Y),
  nb_getval(fuego,F), Fnew is F + 1, nb_setval(fuego,Fnew),
  comprobar_disparo(X, Y, _),
  comprobar_final.

me_rindo :-
  forall(vivo(X,Y,Z), (format('X: ~d Y: ~d Barco: ~d~n', [X,Y,Z]))).

crear_campo(X) :-
  X =:= 1 ->
  write('El mar es de 3x3\n'),
  nb_setval(dimension, 3);
  X =:= 2 ->
  write('El mar es de 4x4\n'),
  nb_setval(dimension, 4);
  X =:= 3 ->
  write('El mar es de 4x4\n'),
  nb_setval(dimension, 4);
  write('El mar es de 5x5\n'),
  nb_setval(dimension, 5).

generar_puntos(X) :-
  X > 0 ->
  nb_getval(dimension,D),
  A is random(D) + 1,
  B is random(D) + 1,
  Barco is X,
  asserta(vivo(A, B, Barco)),
  generar_puntos(X-1);
  crecer_barco.

crecer_barco :-
  findall((X,Y,Z), vivo(X,Y,Z), List1),
  iterar(List1).

iterar([]).
iterar([(Headx, Heady, HeadBarco)|Tail]) :-
  Direccion is random(2),
  Agrandamiento is random(4),
  acoplar(Headx, Heady, HeadBarco, Direccion, Agrandamiento),
  iterar(Tail).

acoplar(X, Y, Barco, Direccion, Agrandamiento) :-

  % Vertical
  Y1 is Y + 1,
  nb_getval(dimension, D),
  Direccion =:= 0, Agrandamiento > 0, Y < D, \+ vivo(X, Y1, _) ->
  asserta(vivo(X, Y1, Barco)),
  nb_getval(contador_vivos,C), Cnew is C + 1, nb_setval(contador_vivos, Cnew),
  acoplar(X, Y1, Barco, Direccion, Agrandamiento-1);

  % Horizontal
  X1 is X + 1,
  nb_getval(dimension, D),
  Direccion =:= 1, Agrandamiento > 0, X < D, \+ vivo(X1, Y, _) ->
  asserta(vivo(X1, Y, Barco)),
  nb_getval(contador_vivos, C), Cnew is C + 1, nb_setval(contador_vivos, Cnew),
  acoplar(X1, Y, Barco, Direccion, Agrandamiento-1);
  true.

empezar :-
  X is random(4) + 1,
  nb_setval(contador_vivos, X),
  nb_setval(fuego, 0),
  retractall(vivo(_,_,_)),
  crear_campo(X),
  generar_puntos(X).
