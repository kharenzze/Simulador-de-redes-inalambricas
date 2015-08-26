function salida = EjemploListaNodos2()
%Ejemplo de lista de nodos
%   Detailed explanation goes here

%parametros de simulación
t=100;
dt=0.1;

%Personalización de nodos
listaNodos{1}=Nodo(10,0);
listaNodos{1}.mov=Movimiento('circ',10,1/4,-1);
listaNodos{1}.estilo='b^';

listaNodos{2}=Nodo(0,0);
listaNodos{2}.mov=Movimiento('rect',10,30,1);
listaNodos{2}.estilo='gx';

listaNodos{3}=Nodo(20,20);
listaNodos{3}.estilo='r*';

listaNodos{4}=Nodo(-20,-20);
listaNodos{4}.estilo='k^';

%asignación de nombre de nodos
for i=1:length(listaNodos)
    listaNodos{i}.name=strcat(['Nodo ' num2str(i)]);
end


% asignacion de variables a cell de salida
salida{1}=listaNodos;
salida{2}=t;
salida{3}=dt;


