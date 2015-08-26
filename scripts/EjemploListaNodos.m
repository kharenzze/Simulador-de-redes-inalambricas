function salida = EjemploListaNodos(varargin)
%Ejemplo de lista de nodos
%   Detailed explanation goes here

% Parametros de simulación
t=10;      % Tiempo de simulacion
dt=0.1;     % Subdivisiones de tiempo
mapa=Mapa(100,100,1);% Mapa
n=10;       % Numero de nodos
enc='dijkstra';% Nombre del encaminamiento
canal=Canal();% Modelo de Canal

% en caso de llamar a la función, los parametros de entrada sobreescriben a los anteriores.
switch nargin
    case 1
        n=varargin{1};
end

modo_silencioso=false;
modo_rapido=true;
modo_paralelo=true;
calcular3D=false;

% Preallocate listaNodos
listaNodos=cell(1,n);

%Personalización de nodos
listaNodos{1}=Nodo(10,0);
listaNodos{1}.mov=listaNodos{1}.mov.setTipo('circ',10,1/4,-1);
listaNodos{1}.estilo='b^';
listaNodos{1}.name='D';

listaNodos{2}=Nodo(0,0);
listaNodos{2}.mov=listaNodos{2}.mov.setTipo('rect',10,30,1);
listaNodos{2}.estilo='gx';
listaNodos{2}.name='S';
%listaNodos{2}.tx=listaNodos{2}.tx.setAntenas(Antena.arrayN(1,lin(30)));

for i=3:n
    listaNodos{i}=Nodo(mapa);
    listaNodos{i}.name=num2str(i);
%     listaNodos{i}.mov=listaNodos{i}.mov.setTipo('random',10);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Asignación de variables a cell de salida
% NO EDITAR
salida{1}=listaNodos;
salida{2}=t;
salida{3}=dt;
salida{4}=mapa;
salida{5}=enc;
salida{6}=canal;
salida{7}=modo_silencioso;
salida{8}=modo_rapido;
salida{9}=modo_paralelo;
salida{10}=calcular3D;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
