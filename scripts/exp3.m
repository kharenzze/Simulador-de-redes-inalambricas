function salida = exp3(varargin)
%Ejemplo de lista de nodos
%   Detailed explanation goes here

% Parametros de simulación
t=10;      % Tiempo de simulacion
dt=0.1;     % Subdivisiones de tiempo
mapa=Mapa(100,100,1);% Mapa
n=50;       % Numero de nodos
enc='Barrido';% Nombre del encaminamiento
canal=Canal();% Modelo de Canal
canal=canal.setPathloss('simpl',{Canal.fspl(1,lambda(2.4e9)),1,2.4});
name='';
% en caso de llamar a la función, los parametros de entrada sobreescriben a los anteriores.
switch nargin
    case 1
        exponente=varargin{1};
        name=num2str(exponente);
        canal=canal.setPathloss('simpl',{Canal.fspl(1,lambda(2.4e9)),1,exponente});
end

modo_silencioso=false;
modo_rapido=true;
modo_paralelo=true;
calcular3D=false;

% Preallocate listaNodos
listaNodos=cell(1,n);

for i=1:n
    listaNodos{i}=Nodo(mapa);
    listaNodos{i}.P_idle=lin(-9);
    %listaNodos{i}.name=num2str(i);
end

%Personalización de nodos
listaNodos{1}.mov=listaNodos{1}.mov.setTipo('fixed');
listaNodos{1}.mov.pos=[0 0];
listaNodos{1}.estilo='b^';
listaNodos{1}.name='D';

listaNodos{2}.mov=listaNodos{2}.mov.setTipo('fixed');
listaNodos{2}.mov.pos=[mapa.maxX mapa.maxY];
listaNodos{2}.estilo='gx';
listaNodos{2}.name='S';

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
salida{11}=name;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%