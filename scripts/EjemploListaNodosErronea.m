function listaNodos = EjemploListaNodosErronea()
%Ejemplo de lista de nodos
%   Detailed explanation goes here
listaNodos{1}=Nodo(20,20);
listaNodos{1}.estilo='r*';

listaNodos{2}=Nodo(-20,-20);
listaNodos{2}.estilo='k^';

listaNodos{4}=Nodo(10,0);
listaNodos{4}.mov=Movimiento('circ',10,1/4,1);
listaNodos{4}.estilo='b^';

for i=1:length(listaNodos)
    listaNodos{i}.name=strcat(['Nodo ' num2str(i)]);
end