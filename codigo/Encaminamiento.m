classdef Encaminamiento
    % Clase en la que se definen los distintos algoritmos de encaminamiento
    % que se utilizan
    %   Concretamente, cada uno esta diseñado para encontrar el camino
    %   optimo suponiendo como origen el nodo 2, y destino el nodo 1
    
    properties
        tipo;% Tipo de encaminamiento utilizado 
        Calcular; % Puntero a funcion correspondiente.
        s;% Nodo de origen
        d;% Nodo de destino
        Dopt;% Distancia optima de transmisión. Depende del canal y los nodos implicados
    end
    
    methods
        function this = Encaminamiento(varargin)
            switch nargin
                case 0
                    this=this.setTipo('greedy');
                    this=this.setSD(2,1);
                case 4
                    this=this.setDopt(varargin{4});
                    this=this.setTipo(varargin{1});
                    this=this.setSD(varargin{2},varargin{3});
                otherwise
                    error('Los parametros introducidos son erroneos');
            end
        end
        
        function this = setTipo(this,nombre)
            % Establece el tipo de encaminamiento a utilizar
            if isnan(this.Dopt) || isempty(this.Dopt)
                warning('El parámetro Dopt no está inicializado. Si el tipo de encaminamiento a utilizar es distinto a "greedy", debe inicializarlo para no producir errores');
            end
            t=this.cellTipos();
            for i=1:length(t)
                if isequal(t{i},nombre)
                    eval(strcat(['this.Calcular=@this.' nombre ';']));
                    this.tipo=nombre;
                    return
                end
            end
            error('El nombre indicado no es correcto');
        end
        
        function this = setSD(this,s,d)
            % Establece el origen y el destino
            if s==d
                error('Los nodos origen y destino deben ser distintos')
            else
                this.s=s;
                this.d=d;
            end
        end
        
        function this=setDopt(this,Dopt)
            % Establece la distancia optima entre origen y destino
            this.Dopt=Dopt;
        end
    end
    
    methods(Static)
        function c= cellTipos()
            % Devuelve un cell con los nombres de los tipos de encaminamiento posibles.
            c={ 'directo',...
                'greedy',...
                'B_Above',...
                'B_Below',...
                'GeRaF',...
                'EEGR',...
                'dijkstra'};
        end
        
        function c= cellColor()
            % Devuelve un cell con el color para pintar cada tipo de encaminamiento
            %   Util para pintar lineas temporales de distinto color
            c={ 'k',...
                'r',...
                'm',...
                'c',...
                'g',...
                'b',...
                'y'};
        end
        
        function c= cellEstilo()
            % Devuelve un cell con el estilo para pintar cada tipo de encaminamiento
            %   Similar a CELLCOLOR. Util para pintar resultados de varias simulaciones
            c={ ':ok',...
                ':+r',...
                ':*m',...
                ':.c',...
                ':xg',...
                ':sb',...
                ':dy'};
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Metodos de encaminamiento
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function [cost,path]=directo(this,~,~,consumo,cobertura)
            % Encaminamiento clásico. Desde el emisor, al receptor.
            if cobertura(this.d,this.s)
                path=[this.s this.d];
                cost=consumo(this.d,this.s)+consumo(this.d,this.d);
            else 
                error('No se puede establecer ninguna ruta');
            end
        end
        
        function [cost,path]=greedy(this,dist,~,consumo,cobertura)
            % Implementación del algoritmo de encaminamiento 'Greedy
            % Minimum Energy'
            %   cost:       Coste del camino completo
            %   path:       Vector con el camino
            %   d:          Matriz de distancias entre nodos
            %   consumo:    Matriz con el consumo de un nodo al transmitir
            %               a otro nodo
            %   Cobertura:  Matriz que indica si un nodo recibe la señal de
            %               otro
            % 
            %   Si no se puede alcanzar el objetivo, (cost=inf), se produce
            %   un error
            n=size(dist,1);
            path=ones(1,n)*this.s;
            cost=consumo(this.d,this.d);
            i=1;
            while path(i)~=this.d
                FTS=dist(:,this.d)<dist(this.d,path(i));%vector bool que indica que nodos estan en FTS
                posible=1./(FTS&cobertura(:,path(i)));%los ceros pasan a infinitos, para luego buscar el mínimo 
                [next,nextIndex]=min(posible.*dist(:,path(i)));
                if isinf(next)
                    error('No se puede establecer ninguna ruta');
                else
                    cost=cost+consumo(nextIndex,path(i));
                    i=i+1;
                    path(i)=nextIndex;
                end
            end
            path=path(1:i);
        end
        
        function [cost,path]=B_Above(this,dist,~,consumo,cobertura)
            % Implementación del algoritmo de encaminamiento 'Greedy
            % Minimum Energy'
            %   cost:       Coste del camino completo
            %   path:       Vector con el camino
            %   d:          Matriz de distancias entre nodos
            %   consumo:    Matriz con el consumo de un nodo al transmitir
            %               a otro nodo
            %   Cobertura:  Matriz que indica si un nodo recibe la señal de
            %               otro
            % 
            %   Si no se puede alcanzar el objetivo, (cost=inf), se produce
            %   un error
            n=size(dist,1);
            path=ones(1,n)*this.s;
            cost=consumo(this.d,this.d);
            i=1;
            while path(i)~=this.d
                if dist(this.d,path(i))<this.Dopt && cobertura(this.d,path(i))
                    cost=cost+consumo(this.d,path(i));
                    i=i+1;
                    path(i)=this.d;
                else
                    FTS=dist(:,this.d)<dist(this.d,path(i));%vector bool que indica que nodos estan en FTS
                    Aout=dist(:,path(i))>this.Dopt;
                    posible=1./(Aout&FTS&cobertura(:,path(i)));%los ceros pasan a infinitos, para luego buscar el mínimo 
                    [next,nextIndex]=min(posible.*dist(:,path(i)));
                    if isinf(next)
                        error('No se puede establecer ninguna ruta');
                    else
                        cost=cost+consumo(nextIndex,path(i));
                        i=i+1;
                        path(i)=nextIndex;
                    end
                end
            end
            path=path(1:i);
        end
        
        function [cost,path]=B_Below(this,dist,~,consumo,cobertura)
            % Implementación del algoritmo de encaminamiento 'Greedy
            % Minimum Energy'
            %   cost:       Coste del camino completo
            %   path:       Vector con el camino
            %   d:          Matriz de distancias entre nodos
            %   consumo:    Matriz con el consumo de un nodo al transmitir
            %               a otro nodo
            %   Cobertura:  Matriz que indica si un nodo recibe la señal de
            %               otro
            % 
            %   Si no se puede alcanzar el objetivo, (cost=inf), se produce
            %   un error
            n=size(dist,1);
            path=ones(1,n)*this.s;
            cost=consumo(this.d,this.d);
            i=1;
            while path(i)~=this.d
                if dist(this.d,path(i))<this.Dopt && cobertura(this.d,path(i))
                    cost=cost+consumo(this.d,path(i));
                    i=i+1;
                    path(i)=this.d;
                else
                    FTS=dist(:,this.d)<dist(this.d,path(i));%vector bool que indica que nodos estan en FTS
                    Aout=dist(:,path(i))>this.Dopt;
                    Ain=~Aout;
                    posible=Ain&FTS&cobertura(:,path(i));
                    if any(posible)
                        [next,nextIndex]=max(posible.*dist(:,path(i)));
                    else
                        posible=1./(Aout&FTS&cobertura(:,path(i)));
                        [next,nextIndex]=min(posible.*dist(:,path(i)));
                    end
                    if isinf(next)
                        error('No se puede establecer ninguna ruta');
                    else
                        cost=cost+consumo(nextIndex,path(i));
                        i=i+1;
                        path(i)=nextIndex;
                    end
                end
            end
            path=path(1:i);
        end
        
        function [cost,path]=GeRaF(this,dist,~,consumo,cobertura)
            % Implementación del algoritmo de encaminamiento 'Greedy
            % Minimum Energy'
            %   cost:       Coste del camino completo
            %   path:       Vector con el camino
            %   d:          Matriz de distancias entre nodos
            %   consumo:    Matriz con el consumo de un nodo al transmitir
            %               a otro nodo
            %   Cobertura:  Matriz que indica si un nodo recibe la señal de
            %               otro
            % 
            %   Si no se puede alcanzar el objetivo, (cost=inf), se produce
            %   un error
            margen=this.Dopt*.5;
            n=size(dist,1);
            path=ones(1,n)*this.s;
            cost=consumo(this.d,this.d);
            i=1;
            while path(i)~=this.d
                posible=dist(:,path(i))>(this.Dopt-margen) & dist(:,path(i))<(this.Dopt+margen);
                FTS=dist(:,this.d)<dist(this.d,path(i));
                posible=1./(posible&FTS&cobertura(:,path(i)));
                [next,nextIndex]=min(posible.*dist(:,this.d));
                if isinf(next)
                    if dist(this.d,path(i))<this.Dopt && cobertura(this.d,path(i))
                        cost=cost+consumo(this.d,path(i));
                        i=i+1;
                        path(i)=this.d;
                    else
                        Aout=dist(:,path(i))>this.Dopt;
                        posible=1./(Aout&FTS&cobertura(:,path(i)));%los ceros pasan a infinitos, para luego buscar el mínimo
                        [next,nextIndex]=min(posible.*dist(:,path(i)));
                        if isinf(next)
                            error('No se puede establecer ninguna ruta');
                        else
                            cost=cost+consumo(nextIndex,path(i));
                            i=i+1;
                            path(i)=nextIndex;
                        end
                    end
                else
                    cost=cost+consumo(nextIndex,path(i));
                    i=i+1;
                    path(i)=nextIndex;
                end
            end
            path=path(1:i);
        end
        
        function [cost,path]=EEGR(this,dist,pos,consumo,cobertura)
            % Implementación del algoritmo de encaminamiento 'Greedy
            % Minimum Energy'
            %   cost:       Coste del camino completo
            %   path:       Vector con el camino
            %   d:          Matriz de distancias entre nodos
            %   consumo:    Matriz con el consumo de un nodo al transmitir
            %               a otro nodo
            %   Cobertura:  Matriz que indica si un nodo recibe la señal de
            %               otro
            % 
            %   Si no se puede alcanzar el objetivo, (cost=inf), se produce
            %   un error
            n=length(pos);
            path=ones(1,n)*this.s;
            cost=consumo(this.d,this.d);
            i=1;
            d=zeros(1,n);
            visited=zeros(1,n);
            visited(this.s)=true;
            while path(i)~=this.d
                centro = pos(path(i),:)+Movimiento.vUnitario(pos(path(i),:),pos(this.d,:))*this.Dopt;
                for j=1:n
                    d(j)=Movimiento.distancia(centro,pos(j,:));
                end
                posible=cobertura(:,path(i))&(d<this.Dopt)';
                if posible(this.d)
                    cost=cost+consumo(this.d,path(i));
                    i=i+1;
                    path(i)=this.d;
                else
                    [next,nextIndex]=min((1./posible).*dist(:,this.d));
                    if isinf(next) || visited(nextIndex)
                        FTS=dist(:,this.d)<dist(this.d,path(i));
                        Aout=dist(:,path(i))>this.Dopt;
                        posible=1./(Aout&FTS&cobertura(:,path(i)));%los ceros pasan a infinitos, para luego buscar el mínimo
                        [next,nextIndex]=min(posible.*dist(:,path(i)));
                        if isinf(next)
                            error('No se puede establecer ninguna ruta');
                        else
                            cost=cost+consumo(nextIndex,path(i));
                            i=i+1;
                            path(i)=nextIndex;
                            visited(nextIndex)=true;
                        end
                    else
                        cost=cost+consumo(nextIndex,path(i));
                        i=i+1;
                        path(i)=nextIndex;
                        visited(nextIndex)=true;
                    end
                end
            end
            path=path(1:i);
        end
        
        function [cost,path]=dijkstra(this,~,~,consumo,cobertura)
            % Implementación del algoritmo de encaminamiento 'Greedy
            % Minimum Energy'
            %   cost:       Coste del camino completo
            %   path:       Vector con el camino
            %   d:          Matriz de distancias entre nodos
            %   consumo:    Matriz con el consumo de un nodo al transmitir
            %               a otro nodo
            %   Cobertura:  Matriz que indica si un nodo recibe la señal de
            %               otro
            % 
            %   Si no se puede alcanzar el objetivo, (cost=inf), se produce
            %   un error
            mapa=((1./cobertura).*consumo)';
            
            n=size(mapa,1);
            % S(1:n) = 0;     %s, vector, set of visited vectors
            dist(1:n) = inf;   % it stores the shortest distance between the source node and any other node;
            prev(1:n) = n+1;    % Previous node, informs about the best previous node known to reach each  network node 

            dist(this.s) = consumo(this.d,this.d); % se añade como basse el consumo del nodo receptor, ya que este no entra en ningun calculo

            % eliminacion de nodos inaccesibles 
            S=~any(isfinite(mapa),2)' & ~any(isfinite(mapa),1);% se marcan como visitados los no validos
            if sum(S)==n || S(this.s) || S(this.d)
                error('No se puede establecer ninguna ruta');
            end

            while sum(S)~=n
                [~,u] = min(1 ./ (S==0) .* dist);
                if S(u)
                    error('No se puede establecer ninguna ruta')
                end
                S(u)=1;
                for i=1:n
                    if(dist(u)+mapa(u,i))<dist(i)
                        dist(i)=dist(u)+mapa(u,i);
                        prev(i)=u;
                    end
                end
            end
            
            path = [this.d];

            while path(1) ~= this.s
                if prev(path(1))<=n
                    path=[prev(path(1)) path];
                else
                    error('No se puede establecer ninguna ruta');
                end
                if length(path)>n
                    error('No se puede establecer ninguna ruta');
                end
            end;
            cost = dist(this.d);
        end
    end
end

