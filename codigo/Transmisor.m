classdef Transmisor
    %Objeto que define los distintos parámetros de transmisión de un nodo
    
    properties
        pmax; %dB Potencia de transmisión máxima
        pmin;%dB Potencia de transmisión mínima
        f; %Hz. Frecuencia de trabajo
        lambda; %m. Longitud de onda
        gain; %Ganancia máxima de una antena
        antenas; % Cell de antenas
        nAntenas;% Número de antenas
    end
    
    methods
        
        function this = Transmisor(varargin)
            % Constructor de la clase
            %       this = Transmisor() Crea un transmisor con parametros
            %       predeterminados
            %       
            %       this = Transmisor(pmin,pmax,f,gain) Crea un transmisor con parametros
            %       predeterminados
            %
            %       Si se introduce otro numero de argumentos, se genera un
            %       error
            if nargin == 4
                this.pmin=varargin{1};
                this.pmax=varargin{2};
                this.f=varargin{3};
                this.lambda=lambda(this.f);
                this=this.setAntenas({Antena()});
            elseif nargin==0
                this.pmin=-200;
                this.pmax=0;
                this.f=2.4e9;
                this.lambda=lambda(this.f);
                this=this.setAntenas({Antena()});
            else
                error('Error al crear objeto. Numero de argumentos de entrada no valido')
            end
        end
        
        function this=setF(this,f)
            % Establece la frecuencia y la longitud de onda
            this.f=f;
            this.lambda=lambda(f);
        end
        
        function p = ajustarPotencia(this,pl,sensibilidad,G,umbral)
            % Esta función devuelve la potencia de transmisión para emitir
            % a un nodo dado un pathloss.
            % G= producto de ganancias
            p=sensibilidad+umbral-dB(pl)-dB(G);
            if p>this.pmax
                p=this.pmax;
            elseif p<this.pmin
                p=this.pmin;
            end
            p=lin(p);
        end
        
        function this= setAntenas(this,c)
            % Establece el cell de antenas
            this.antenas=c;
            this.gain=0;
            this.nAntenas=length(c);
            for i=1:this.nAntenas
                v=c{i}.maxGain();
                if v>this.gain
                    this.gain=v;
                end
            end
        end
        
        function g= ganancia(this,a)
            % Función que selecciona antenas para transmitir, y devuelve la ganancia total
            % a = angulo (complejo), complejo v/complej odestino
            gs=zeros(1,this.nAntenas);
            for i=1:this.nAntenas
                gs(i)=this.antenas{i}.getGain(angle(a*Movimiento.angle2complex(this.antenas{i}.dir)));
            end
            g=max(gs);
            if this.nAntenas>1
                for i=2:this.nAntenas
                    mejor=max(sum(nchoosek(gs,i),2));
                    if mejor>g
                        g=mejor;
                    end
                end
            end
            g=g/this.nAntenas;
        end
    end 
end
