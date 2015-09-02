classdef Nodo
    %Nodo Representa a un nodo de comunicación
    %   Detailed explanation goes here
    
    properties
        rx; %Parámetros de recepción. Clase 'Receptor'
        tx; %Parámetros de transmisión. Clase 'Transmisor'
        mov; %Indica cmoo se mueve el nodo. Clase 'Movimiento'
        name;%Nombre del nodo
        estilo;%Forma con la que se pinta en el mapa. Ej: 'r*'
        P_idle;% mW. Potencia que consume el dispositivo por el hecho de estar encendido
    end
    
    methods
        %Constructor
        function this = Nodo(varargin)
            % Constructor de la clase Nodo
            % 
            %   Nodo(mapa)  Crea un nodo cuya posicion es aleatoria dentro
            %   del mapa
            % 
            %   Nodo(x,y) Crea un nodo predeterminado con posicion [x y]
            % 
            %   Nodo(x,y,name) Name es el nombre del nodo. Debe ser de tipo
            %       String
            
            % Se crean los parametros basicos
            this.mov=Movimiento();
            this.rx=Receptor();
            this.tx=Transmisor();
            this.estilo='k*';
            this.P_idle=1e-3;
            this.name='';
            % Se crean los parametros que dependen del numero de argumentos de entrada
            switch nargin
                case 0
                    return
                case 1
                    this.mov.pos=varargin{1}.randPos();
                case 2
                    this.mov.pos=[varargin{1} varargin{2}];
                case 3
                    this.mov.pos=[varargin{1} varargin{2}];
                    if ischar(varargin{3})
                        this.name=varargin{3};
                    else
                        error('La entrada numero 3 debe ser de tipo String')
                    end
                otherwise
                    error('Error al crear objeto. Numero de argumentos de entrada no valido')
            end
        end
    end
    
    methods(Static)
        function checkListaNodos(listaNodos)
            % Indica si una lista de nodos está definida de forma correcta, siendo
            % todos los elementos de esta de la clase 'Nodo'
            l=length(listaNodos);
            if l<1
                error('La lista no tiene ningun elemento');
            else
                for i=1:l
                    if ~isequal(class(listaNodos{i}),'Nodo')
                        error('Hay un hueco en la lista');
                    end
                end
            end
        end
        
        function n=MICAz()
            %Devuelve un nodo basado en el sensor MICAz
            n=Nodo();
            n.P_idle=lin(15);
            n.rx.sensibilidad=-94;
        end
    end
end
