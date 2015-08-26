classdef Canal
    %En esta clase se definen los metodos referentes al modelado de propagación en el canal 
    
    properties
        pathloss;%String. Modelo de pathloss
        pathlossParams;%Cell. Parametros de pathloss
        shadowing;%String. Modelo de shadowing
        shadowingParams;%Cell. Parametros de shadowing
        shadowingVector%Vector con el shadowing generado
        d; % Vector de distancias, para obtener el shadowing. Se mide en metros
        nDecadas;% Numero de decadas que abarca el vector de distancias
        multipath;%String. Modelo de multipath
        multipathParams;%Cell. Parametros de multipath
    end
    
    properties(Constant)
        n=1e4;%Número de puntos del vector de distancias y shadowing
        oscilaciones=20;%20 oscilaciones por decada en el shadowing 
    end
    
    methods
        function this = Canal(varargin)
            % Este es el constructor de la clase. Crea un canal
            % predeterminado
            switch nargin
                case 0 
                    this=this.setPathloss('fspl',{});
                    this=this.setShadowing('logn',{0,0.5});
                    this=this.setMultipath('rayl',{0.3});
                    this=this.setVectorDistancia(1,141);
                case 1
                    this=this.setPathloss('fspl',{});
                    this=this.setShadowing('no',{});
                    this=this.setMultipath('rayl',{0.01});
                    this=this.setVectorDistancia(1,varargin{1});
                otherwise
                    error('Numero de argumentos introducido no valido');
            end
             
        end
        
        function this=setVectorDistancia(this,min,max)
            % Genera un vector de distancias. Este es necesario para
            % generar el shadowing.
            % 
            % min: distancia mánima en metros
            % max: distancia máxima en metros
            if min>=max
                error('El minimo es mayor que el máximo')
            end
            min=log10(min);
            max=log10(max);
            this.nDecadas=max-min;
            this.d=logspace(min,max,this.n);
            this=this.generateShadowing();
        end
        
        function this=generateShadowing(this)
            % Con esta función se genera el shadowing. Para ello, se toman
            % 20 muestras por decada, y se interpola el vector para tener
            switch this.shadowing
                case 'logn'
                    Fs=round(this.n./this.nDecadas./this.oscilaciones);
                    d_short=this.d(1:Fs:end);
                    d_short=[d_short this.d(end)];
                    s_short=random('logn',this.shadowingParams{1},this.shadowingParams{2},1,length(d_short));
                    this.shadowingVector=interp1(d_short,s_short,this.d,'pchip');
            end
        end
        
        function this = setShadowing(this,t,c)
            % Funcion que se encarga de establecer el tipo de shadowing en
            % un canal
            if ischar(t)
                t=lower(t);
                switch t
                    case 'logn'
                        this.shadowing=t;
                        if length(c)==2
                            this.shadowingParams=c;
                        else
                            error('El numero de argumentos no es valido')
                        end
                    case 'no'
                        this.shadowing=t;
                        this.shadowingParams=c;
                    otherwise
                        error('Nombre de distribucion no valido')
                end  
                if ~isempty(this.d)
                    this=this.generateShadowing();
                end
            else
                error('La primera variable debe ser un "String" que indique la distribución a utilizar');
            end
        end
        
        function this = setMultipath(this,t,c)
            % Funcion que se encarga de establecer el tipo de multipath en
            % un canal
            if ischar(t)
                t=lower(t);
                switch t
                    case 'rayl'
                        this.multipath=t;
                        if length(c)==1
                            this.multipathParams=c;
                        else
                            error('El numero de argumentos no es valido')
                        end
                    case 'rician'
                        this.multipath=t;
                        if length(c)==2
                            this.multipathParams=c;
                        else
                            error('El numero de argumentos no es valido')
                        end
                    case 'wbl'
                        this.multipath=t;
                        if length(c)==2
                            this.multipathParams=c;
                        else
                            error('El numero de argumentos no es valido')
                        end
                    case 'no'
                        this.multipath=t;
                        this.multipathParams=c;
                    otherwise
                        error('Nombre de distribucion no valido')
                end 
            else
                error('La primera variable debe ser un String que indique la distribución a utilizar')
            end
        end
            
        
        function this = setPathloss(this,t,c)
            % Establece el modelo de Pathloss
            %
            %   setPathloss('fspl',{})
            %
            %   setPathloss('simpl',{k(dB),d0(m),gamma})
            if ischar(t)
                t=lower(t);
                switch t
                    case 'fspl'
                        this.pathloss=t;
                        this.pathlossParams=c;
                    case 'simpl'
                        this.pathloss=t;
                        if length(c)==3
                            this.pathlossParams=c;
                        else
                            error('El numero de argumentos no es valido')
                        end
                    otherwise
                        error('Nombre de modelo no valido')
                end
            else
                error('La primera variable debe ser un String que indique la distribución a utilizar')
            end
        end
        
        function p=calcularPathloss(this,d,l)
        % Calcula el Pathloss del canal actual dada una distancia y una
        % lambda
            switch this.pathloss
                case 'fspl'
                    p=Canal.fspl_lin(d,l);
                case 'simpl'
                    p=this.simpl_lin(d);
            end
        end
        
        function p=calcularShadowing(this,d)
        % Calcula el shadowing.
            l=length(d);
            p=ones(1,l);
            switch this.shadowing
                case 'logn'
                    if l==1
                        [~,index]=min(abs(this.d-d));
                        p=this.shadowingVector(index);
                    else
                        for i=1:l
                           [~,index]=min(abs(this.d-d(i)));
                            p(i)=this.shadowingVector(index); 
                        end
                    end
            end
        end
        
        function p=calcularMultipath(this,m,n,o)
        % Calcula multipath dependiendo de la distribucion deseada y los
        % parametros que se indiquen
            a=this.multipath;
            switch a
                case 'rayl'
                    p=random(a,this.multipathParams{1},m,n,o);
                case 'rician'
                    p=random(a,this.multipathParams{1},this.multipathParams{2},m,n,o);
                case 'wbl'
                    p=random(a,this.multipathParams{1},this.multipathParams{2},m,n,o);
                case 'no'
                    p=ones(m,n,o);
            end
        end
        
        function out=calcularPerdidas(this,d,l)
            % Calcula las perdidas totales de enlace, dado un vector de
            % distancias y un lambda (l) en metros
            n=length(d);
            out=zeros(3,n);
            out(1,:)=this.calcularPathloss(d,l);
            out(2,:)=this.calcularShadowing(d);
            out(3,:)=this.calcularMultipath(1,n,1);
        end
        
        function umbral=getUmbral(this)
            % Calcula cuanto varían las perdidas totales con respecto al
            % pathloss en media. Este dato se utiliza como umbral para
            % establecer una potencia de transmisión adecuada a la
            % distancia que separa a los nodos. 
            % Ver clase TRANSMISOR para mas información
            
            %metodo antiguo
%             variacion=this.calcularShadowing(this.d).*this.calcularMultipath(this.n);
%             umbral=abs(dB(mean(variacion)));
%             minimo=abs(dB(min(variacion)));
%             umbral=umbral+abs(minimo-umbral)/3;
            variacion=this.calcularShadowing(this.d).*this.calcularMultipath(1,this.n,1);
            perdidas=variacion(variacion<1);
            [y,x]=hist(perdidas,100);
            y=y/length(perdidas);
            y=flip(y);
            x=flip(x);
            y=cumsum(y);
            index=find(y>0.98,1);
            umbral=-dB(x(index));
        end
        
        function d=calcularDopt(this,NodoTx,NodoRx,umbral)
            % Devuelve la distancia óptima para la cual el gasto energetico es mínimo
            switch this.pathloss
                case 'fspl'
                    d=sqrt((NodoTx.tx.lambda .^2 .* (NodoTx.P_idle + NodoRx.P_idle))./...
                        (16.*pi.^2.*lin(NodoRx.rx.sensibilidad+umbral)./(NodoRx.rx.gain .* NodoTx.tx.gain)));
                case 'simpl'
                    d=nthroot((NodoTx.tx.lambda.^2*(NodoTx.P_idle+NodoRx.P_idle))./...
                        (16.*pi.^2.*power(this.pathlossParams{2},2-this.pathlossParams{3}).*(this.pathlossParams{3}-1).*lin(NodoRx.rx.sensibilidad+umbral)./(NodoRx.rx.gain.*NodoTx.tx.gain)),...
                        this.pathlossParams{3});
                otherwise
                    error('Modelo de Pathloss erroneo');
            end
        end
        
        function p=simpl(this,d)
            % Calculo de perdidas del modelo simplificado en dB
            mayor=d>this.pathlossParams{2};
            p=this.pathlossParams{1}+dB(this.pathlossParams{2}./d).*this.pathlossParams{3};
            p=p.*mayor+this.pathlossParams{1}.*(~mayor);
        end
        
        function p=simpl_lin(this,d)
            % Calculo de perdidas del modelo simplificado en unidades lineales
            k=lin(this.pathlossParams{1});
            mayor=d>this.pathlossParams{2};
            p=k.*(this.pathlossParams{2}./d).^this.pathlossParams{3};
            p=p.*mayor+k.*(~mayor);
        end
    end
    
    methods(Static)
        function p = fspl(d,lambda)
            % Esta funcion calcula las perdidas por propagación en espacio
            % libre y las devuelve en dB
            % 
            %   p = fspl(d,lambda)  d es distancia, lambda longitud de onda
            %   en m
            p=2*dB(lambda./(4*pi*d)); %el 2 sale de multiplicando del interior de dB (logaritmo)
        end
        
        function p = fspl_lin(d,lambda)
            % Esta funcion calcula las perdidas por propagación en espacio
            % libre y las devuelve en dB
            % 
            %   p = fspl(d,lambda)  d es distancia, lambda longitud de onda
            %   en m
            p=(lambda./(4*pi*d)).^2;
        end
    end
end

