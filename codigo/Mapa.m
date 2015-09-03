classdef Mapa
    % En esta clase se definen los parámetros del mapa
    
    properties
        x;% Vector de puntos del eje x
        y;% Vector de puntos del eje y
        minX;
        minY;
        maxX;
        maxY;
        ancho;
        alto;
    end
    
    methods
        function this = Mapa(alto,ancho,densidadPuntos)
            this.x=linspace(-ancho/2,ancho/2,densidadPuntos*ancho+1);
            this.y=linspace(-alto/2,alto/2,densidadPuntos*alto+1);
            this.minX=this.x(1);
            this.minY=this.y(1);
            this.maxX=this.x(end);
            this.maxY=this.y(end);
            this.alto=alto;
            this.ancho=ancho;
        end
        
        function l = limites(this)
            % Esta función devuelve un vector con los limites.
            % Este vector es el tipico que se pasa a la función AXIS
            l=[this.minX this.maxX this.minY this.maxY];
        end
        
        function d=distanciaMaxima(this)
            % Devuelve la distancia maxima que puede haber entre 2 puntos del mapa, osea, la distancia de la diagonal
            d=norm([this.ancho this.alto]);
        end
        
        function p=randPos(this)
            % Devuelve una posicion aleatoria dentro del mapa
            p=[rand*this.ancho+this.minX rand*this.ancho+this.minY];
        end
    end
end

