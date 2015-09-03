classdef Movimiento
    %Define el tipo de movimiento de un nodo
    
    properties
        tipo; %String que indica como se mueve 
        v; %m/s.Vector de velocidad
        pos; %m. Vector de posicion
        params;%Parametros varios, dependientes del tipo de velocidad
    end
    
    methods
        function this=Movimiento(varargin)
            % Constructor
            % Se puede llamar de la siguiente forma:
            % 
            % Movimiento()  crea un nodo por defecto
            % 
            % Movimiento([x y]) Crea un nodo de movimiento aleatorio, que empieza a moverse en la posición
            if 1
            end
            switch nargin
                case 0
                    this.pos=[0 0];
                    this=this.setTipo('random',2);
                case 1
                    this=this.setTipo('random',2);
                    this.pos=varargin{1};
                otherwise
                    error('No se ha introducido un tipo correcto')
            end
        end
        
        function this=setTipo(varargin)
            %Cambia el tipo de movimiento
            % Se puede llamar de la siguiente forma:
            % 
            %('const',vx,vy,Modo_rebote)
            %('rect',modulo_velocidad,angulo_deg,Modo_rebote)
            %('random',amplitud)
            %('circ',radio,frecGiro)
            %('fixed')
            this=varargin{1};
            this.tipo=varargin{2};
            switch this.tipo
                case 'const'
                    if nargin~=5
                        error('Numero de argumentos incorrecto para este tipo de movimiento','Error');
                    end
                    this.v=[varargin{3} varargin{4}];
                    this.params.modoRebote=varargin{5};
                case 'rect'
                    if nargin~=5
                        error('Numero de argumentos incorrecto para este tipo de movimiento','Error');
                    end
                    vx=varargin{3}*cos(degtorad(varargin{4}));
                    vy=varargin{3}*sin(degtorad(varargin{4}));
                    this.v=[vx vy];
                    this.params.modoRebote=varargin{5};
                    this.tipo='const';
                case 'random'
                    if nargin>3
                        error('Numero de argumentos incorrecto para este tipo de movimiento','Error');
                    end
                    this.params.n=varargin{3};
                    this.v=[this.params.n*cos(rand*2*pi) this.params.n*sin(rand*2*pi)];
                case 'circ'
                    %añadir centro
                    if nargin~=5
                        error('Numero de argumentos incorrecto para este tipo de movimiento','Error');
                    end
                    this.params.radio=varargin{3};
                    this.params.w=varargin{4}*2*pi;
                    this.params.sentido=varargin{5};
                    this.pos=[this.params.radio 0];
                case 'fixed'
                    this.v=[0 0];
                otherwise
                    error('No se ha introducido un tipo correcto')
            end
        end
        
        function this = calcularVelocidad(this,t,mapa)
            % Calcula la velocidad para un instante de tiempo determinado
            switch this.tipo
                case 'random'
                    this.v=[this.params.n*cos(rand*2*pi) this.params.n*sin(rand*2*pi)];
                case 'circ'
                    vx=-this.params.radio*this.params.w*sin(this.params.w*t);
                    vy=this.params.sentido*this.params.radio*this.params.w*cos(this.params.w*t);
                    this.v=[vx vy];
                case 'const'
                    if this.params.modoRebote
                        this=this.devolver(mapa);
                    end
                case 'fixed'
                otherwise
                    error('No se ha introducido un tipo correcto')
            end
        end
        
        function this= devolver(this,mapa)
            % Si el nodo se sale del mapa, cambia su velocidad para que vuelva a entrar
            if this.pos(1) > mapa.maxX
                this.v(1)=-abs(this.v(1));
            elseif  this.pos(1) < mapa.minX
                this.v(1)=abs(this.v(1));
            end
            if this.pos(2) > mapa.maxY
                this.v(2)=-abs(this.v(2));
            elseif  this.pos(2) < mapa.minY
                this.v(2)=abs(this.v(2));
            end
        end
        function this = mover(this,dt,t,mapa,cambio_dir)
            % Actualiza la posicion y la velocidad.
            if isequal(this.tipo,'random')
                if cambio_dir
                    this=this.calcularVelocidad(t,mapa);
                end
                this=this.devolver(mapa);
            else
                this=this.calcularVelocidad(t,mapa);
            end
            % Actualizar posicion
            this.pos=this.pos+this.v*dt;
        end
    end
    
    methods(Static)
        function d = distancia(a,b)
            % Calcula la distancia entre 2 puntos
            d=norm(a-b);
        end
        
        function v = vUnitario(a,b)
            % Calcula la distancia entre 2 puntos
            v=b-a;
            v=v/norm(v);
        end
        
        function c= v2complex(v)
            % Convierte un vector 2d en un nº complejo
            % Útil para trabajar con ángulos
            c=v(1)+1j*v(2);
        end
        
        function c=angle2complex(a)
            % Convierte un angulo en rad  en un nº complejo
            % Útil para trabajar con ángulos
            c=exp(1j*a);
        end
    end
end

