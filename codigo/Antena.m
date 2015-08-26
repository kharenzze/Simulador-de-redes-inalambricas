classdef Antena
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pattern;% Diagrama de radiación en unidades lineales (no normalizado)
        angle;% (Rad) Vector de angulos del patrón de radiación.
        dir;% (Rad) Angulo de orientación de la antena, con respecto a la dirección de movimiento del Nodo. Sentido anticc-horario
    end
    
    methods
        function this=Antena(varargin)
            %Constructor 
            %   Antena(g_max) crea una antena omnidireccional de ganancia g_max (lineal)
            switch nargin
                case 0
                    [p,a]=this.omnidireccional(lin(2));
                    this=this.setPattern(p,a);
                    this.dir=0;
                case 1
                    [p,a]=this.omnidireccional(lin(varargin{1}));
                    this=this.setPattern(p,a);
                    this.dir=0;
                otherwise
                    error('número de argumentos inválido')
            end
        end
        
        function this=setPattern(this,p,angle)
            % Establece el patrón de radiación
            % Se puede utilizar para establecer un patrón de radiación personalizado
            if length(p)==length(angle)
                this.pattern=p;
                this.angle=angle;
            else
                error('La longitud de los vectores no coincide');
            end
        end
        
        function this=setDir(this,a)
            % Establece el ángulo de orientación de la antena
            this.angle=a;
        end
        
        function m= maxGain(this)
            % Devuelve la ganancia maxima que se puede alcanzar
            m=max(this.pattern);
        end
        
        function g= getGain(this,a)
            % Devuelve la ganancia, dado un ángulo
            % a = ángulo (rad)
            [~,i]=min(abs(this.angle-a));
            g=this.pattern(i);
        end
    end
    
    methods(Static)
        function [p,a] = omnidireccional(max)
            % Genera un diagrama de radiación omnidireccional
            %   Solo se genera un punto, ya que así se minimiza 
            %   el número de cálculos, siendo el resutlado el mismo
            p=max;
            a=0;
        end
        
        function [p,a] = coseno(max,exp,n)
            % Genera un diagrama de radiación coseno. Rango [-pi,pi]
            %   max = ganancia maxima
            %   exp = exponente del coseno
            %   n = numero de puntos
            a=linspace(-pi/2,pi/2,n);
            p=max.*cos(a).^exp;
        end
        
        function c = arrayN(n,max)
            % Devuelve un cell con n antenas 'coseno' distribuidas uniformemente
            % n = número de antenas
            % max = ganancia maxima
            c=cell(1,n);
            [p,a] = Antena.coseno(max,2,30);
            direcciones=0:2*pi/n:2*pi;
            direcciones=direcciones(1:n);
            for i=1:n
                c{i}=Antena();
                c{i}=c{i}.setDir(direcciones(i));
                c{i}=c{i}.setPattern(p,a);
            end
        end
    end
end

