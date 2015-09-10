function varargout = mainUI(varargin)
% MAINUI MATLAB code for mainUI.fig
%      MAINUI, by itself, creates a new MAINUI or raises the existing
%      singleton*.
%
%      H = MAINUI returns the handle to a new MAINUI or the handle to
%      the existing singleton*.
%
%      MAINUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINUI.M with the given input arguments.
%
%      MAINUI('Property','Value',...) creates a new MAINUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mainUI

% Last Modified by GUIDE v2.5 24-Aug-2015 06:14:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainUI_OpeningFcn, ...
                   'gui_OutputFcn',  @mainUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mainUI is made visible.
function mainUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainUI (see VARARGIN)

% Choose default command line output for mainUI
handles.n=1;
handles.output = hObject;
handles.simulando=0;
handles.detener=0;
handles.datos.mapa=Mapa(100,100,1);
axis(handles.mapa,handles.datos.mapa.limites());
handles.datos.listaNodos={};
handles.datos.canal=Canal();
handles.datos.Execute=[];% indica el modo de ejecución
% Modo pruebas
if length(varargin)==1
    handles.pruebas=varargin{1};
else 
    handles.pruebas=0;
end
guidata(hObject, handles);
if handles.pruebas
    set(handles.editBuscar, 'String',...
        'D:\UNIVERSIDAD\TFG\code\simulador\EjemploListaNodos.m');
    botonCargar_Callback(hObject, 1, handles)
end

% UIWAIT makes mainUI wait for user response (see UIRESUME)
%uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mainUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;
% if handles.pruebas
%     close all;
% else
%     delete(gcf);
% end

function editMapa_Callback(hObject, eventdata, handles)
% hObject    handle to editMapa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.datos.mapa=mapaUI(handles.datos.mapa);
axis(handles.mapa,handles.datos.mapa.limites());
handles.datos.canal=handles.datos.canal.setVectorDistancia(1,handles.datos.mapa.distanciaMaxima());
guidata(hObject,handles);

% --- Executes on button press in botonCargar.
function botonCargar_Callback(hObject, eventdata, handles)
% hObject    handle to botonCargar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CurrentPath=cd;
archivo=get(handles.editBuscar, 'String');
k=strfind(archivo,'\');
if isempty(k)
    k=strfind(archivo,'/');
end
if isempty(k)
    error('La ruta introducida no es valida');
end
path=archivo(1:k(end));
nombreFuncion=archivo(k(end)+1:end-2);
cd(path);
eval(strcat(['puntero=@' nombreFuncion ';']));
cd(CurrentPath);
data=puntero();
if ischar(data{1})
    handles.datos.Execute=data;
    handles.datos.ruta=path;
    set(handles.ModoSim,'string','Varias simulaciones')
    uipanel1_alternate(0,handles);
else
    uipanel1_alternate(1,handles);
    handles.datos.Execute=[];
    set(handles.ModoSim,'string','Simulación única')
    handles.datos.listaNodos=data{1};
    set(handles.editDuracion,'String',num2str(data{2}));
    set(handles.editDt,'String',num2str(data{3}));
    handles.datos.mapa=data{4};
    axis(handles.mapa,handles.datos.mapa.limites());
    setPopupEnc(data{5},handles);
    handles.datos.canal=data{6};
    set(handles.checkSilencio,'value',data{7})
    set(handles.checkFast,'value',data{8})
    set(handles.checkParalelo,'value',data{9})
    set(handles.check3D,'value',data{10})
    try
        Nodo.checkListaNodos(handles.datos.listaNodos);
    catch e
        errordlg(e.message)
        rethrow(e)
    end
    if eventdata~=1
        msgbox('Éxito al cargar','Éxito')
    end
    actualizarMapa(handles.datos.listaNodos,length(handles.datos.listaNodos),[],handles.mapa);
    actualizar_popupmenuNodos(handles.popupmenuNodos, eventdata, handles)
end
    guidata(hObject,handles);

function createTextBox(hObject, eventdata, handles)
% hObject    handle to editX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% resume gui
try
    if isequal(get(gcf, 'waitstatus'), 'waiting')
       uiresume(gcf);
    else
        if handles.pruebas
            close all
        end
        delete(gcf); %Hint: delete(hObject) closes the figure
    end
catch
    delete(gcf)
end

function listaNodosNueva = eliminarNodo(listaNodos,n)
% n     es la posición que ocupa el nodo en listaNodos, y que va a ser
%       eliminado
if n>length(listaNodos) || n<1
    error('Index out of bounds');
else
    old=1;
    new=1;
    while old<=length(listaNodos)
        if old==n
            old=old+1;
        else
            listaNodosNueva{new}=listaNodos{old};
            old=old+1;
            new=new+1;
        end
    end
end

function actualizarMapa(listaNodos,listaNodos_length, r,axesHandle)
% Actualiza el mapa, pintando a los nodos de 'listaNodos' en su posicion
% actual

% Limpiar el mapa
delete(allchild(axesHandle));
% Pintar los nodos
pos=zeros(listaNodos_length,2);
for i=1:listaNodos_length
    plot(axesHandle,listaNodos{i}.mov.pos(1),listaNodos{i}.mov.pos(2),listaNodos{i}.estilo);
    text(listaNodos{i}.mov.pos(1),listaNodos{i}.mov.pos(2),listaNodos{i}.name,'Parent', axesHandle,'VerticalAlignment','top','HorizontalAlignment','center')% Parent indica sobre que axes se trabaja
    pos(i,:)=listaNodos{i}.mov.pos;
end
% Pintar ruta
if ~isempty(r)
    plot(axesHandle,pos(r,1),pos(r,2));
end

% --- Executes on button press in botonCrear.
function botonCrear_Callback(hObject, eventdata, handles)
% hObject    handle to botonCrear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nuevo=NodoUI();
if ~isequal(class(nuevo),'Nodo')
    return
else
    n=length(handles.datos.listaNodos)+1;
    handles.datos.listaNodos{n}=nuevo;
    guidata(hObject,handles);
end
actualizarMapa(handles.datos.listaNodos,n,[],handles.mapa);
actualizar_popupmenuNodos(handles.popupmenuNodos, eventdata, handles)


% --- Executes on button press in botonEliminarNodo.
function botonEliminarNodo_Callback(hObject, eventdata, handles)
% hObject    handle to botonEliminarNodo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n=get(handles.popupmenuNodos,'Value');
handles.datos.listaNodos=eliminarNodo(handles.datos.listaNodos,n) %% editar n
actualizar_popupmenuNodos(handles.popupmenuNodos, eventdata, handles);
l=length(handles.datos.listaNodos);
actualizarMapa(handles.datos.listaNodos,l,[],handles.mapa);
guidata(hObject,handles);


% --- Executes on button press in botonEditar.
function botonEditar_Callback(hObject, eventdata, handles)
% hObject    handle to botonEditar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n=get(handles.popupmenuNodos,'value');
nuevo=NodoUI(handles.datos.listaNodos{n});
handles.datos.listaNodos{n}=nuevo;
guidata(hObject,handles);

actualizarMapa(handles.datos.listaNodos,length(handles.datos.listaNodos),[],handles.mapa);
actualizar_popupmenuNodos(handles.popupmenuNodos, eventdata, handles)


function actualizar_popupmenuNodos(hObject, eventdata, handles)
% Se encarga de actualizar popupmenuNodos. Hay que llamarla siempre despues
% de editar la lista de nodos. 
if isempty(handles.datos.listaNodos)
    set(handles.popupmenuNodos,'String','No hay nodos');
    l=1;
else
    texto=cell(1,length(handles.datos.listaNodos));
    l=length(handles.datos.listaNodos);
    for i=1:l
        texto{i}=handles.datos.listaNodos{i}.name;
    end
    set(handles.popupmenuNodos,'String',texto);
end
v=get(hObject,'value');
if v>l
    set(hObject,'value',l);
end


% --------------------------------------------------------------------
function nuevoNodo_Callback(hObject, eventdata, handles)
% hObject    handle to nuevoNodo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p=get(handles.mapa, 'CurrentPoint');
n=length(handles.datos.listaNodos)+1;
nuevo=NodoUI(Nodo(p(2,1),p(2,2),strcat(['Nodo ' num2str(n)])));
if ~isequal(class(nuevo),'Nodo')
    return
else
    n=length(handles.datos.listaNodos)+1;
    handles.datos.listaNodos{n}=nuevo;
    guidata(hObject,handles);
end
actualizarMapa(handles.datos.listaNodos,n,[],handles.mapa);
actualizar_popupmenuNodos(handles.popupmenuNodos, eventdata, handles)

% --------------------------------------------------------------------
function nuevoNodoRapido_Callback(hObject, eventdata, handles)
% hObject    handle to nuevoNodoRapido (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p=get(handles.mapa, 'CurrentPoint');
n=length(handles.datos.listaNodos)+1;
handles.datos.listaNodos{n}=Nodo(p(2,1),p(2,2),strcat(['Nodo ' num2str(n)]));
guidata(hObject,handles);
actualizarMapa(handles.datos.listaNodos,n,[],handles.mapa);
actualizar_popupmenuNodos(handles.popupmenuNodos, eventdata, handles);


% --------------------------------------------------------------------
function canal_Callback(hObject, eventdata, handles)
% hObject    handle to canal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.datos.canal=handles.datos.canal.setVectorDistancia(1,handles.datos.mapa.distanciaMaxima());
handles.datos.canal=canalUI(handles.datos.canal);
guidata(hObject,handles);

% --- Executes on button press in botonBuscar.
function botonBuscar_Callback(hObject, eventdata, handles)
% hObject    handle to botonBuscar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile;
set(handles.editBuscar, 'String',strcat(pathname,filename));

% --- Executes on button press in checkParalelo.
function checkParalelo_Callback(hObject, eventdata, handles)
% hObject    handle to checkParalelo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=get(hObject,'value');
if a
    set(handles.checkSilencio,'visible','off')
    set(handles.checkFast,'visible','off')
else
    set(handles.checkSilencio,'visible','on')
    set(handles.checkFast,'visible','on')
end
handles.h=0;
guidata(hObject,handles);

function updateProgress(p,handles)
% Edita los elementos que muestran el tanto porciento de ejecución de la
% simulación
barh(handles.progressBar,p,'g');
porcentaje_sim=strcat([sprintf('%3.2f',p) '%']);
set(handles.tsim,'String',porcentaje_sim);

function reactivate(hObject)
% Esta función se utiliza para preparar la interfaz para realizar una nueva
% simulación, tras terminar la simulación actual. Para ello, hay que
% pasarla como argumento a la función ONCLEANUP
handles=guidata(hObject);
handles.simulando=false;
handles.detener=false;
etiquetaSimulando(handles);
handles.n=handles.n+1;
set(hObject,'String','Iniciar simulación')
set(handles.seguimiento,'visible','off')
guidata(hObject,handles);

if handles.simulando
    try
        delete(handles.representacion.figuraRecepcion)
    catch
    end
end

function etiquetaSimulando(handles)
% Cambia la etiqueda de simulación, dependiendo del estado
if handles.simulando
    set(handles.etiquetaSimulando,'string','Simulando...')
else
    set(handles.etiquetaSimulando,'string','Ready')
end

% --- Executes during object creation, after setting all properties.
function popupEnc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupEnc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
c=Encaminamiento.cellTipos();
c{end+1}='Barrido';
set(hObject,'String',c);

function setPopupEnc(text,handles)
% Se cambia el valor de popupEnc, ajustandolo al valor de 'text'
tipos=get(handles.popupEnc,'string');
valor=0;
for i=1:length(tipos)
    if isequal(tipos{i},text)
        valor=i;
        break
    end
end
if valor==0
    error('El texto introducido no coincide con los posibles');
end
set(handles.popupEnc,'value',valor);

function uipanel1_alternate(modo,handles)
% Alterna las opciones que aparecen en el primer panel, según el tipo de simulación
% modo=1  --> una simulación
% modo=0 --> varias simulaciones
a=allchild(handles.uipanel1);
if modo
    for i=1:length(a)
        set(a(i),'visible','on');
    end
    set(handles.text10,'visible','off');
    set(handles.nRep,'visible','off')
else
    for i=1:length(a)
        set(a(i),'visible','off');
    end
    set(handles.text10,'visible','on');
    set(handles.nRep,'visible','on')
end


% --- Executes on button press in ejecutar.
function ejecutar_Callback(hObject, eventdata, handles)
% hObject    handle to ejecutar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Se comprueba si se está simulando
if handles.simulando
    handles.detener=1;
    guidata(hObject,handles);
    return
else
    handles.simulando=1;
    etiquetaSimulando(handles);
    set(hObject,'String','Detener')
    guidata(hObject,handles);
    % Creación de un metodo de limpieza. Util si se pulsa ctrl-c, ya que
    % sin este metodo, la aplicación se quedaría colgada. 
    limpieza=onCleanup(@()reactivate(hObject));
    pause(1e-9)% Con el pause, se permite que se actualice la GUI para que aparezca simulando
end
S=@squeeze;% Solventa un problema en la computación paralela
%% Inicialización de parametros
if isempty(handles.datos.Execute)
    %% Comprobacion de numero minimo de nodos
    listaNodos=handles.datos.listaNodos;
    listaNodos_length=length(listaNodos);
    if listaNodos_length<2
        errordlg('Se debe de introducir un minimo de 2 nodos')
        error('Se debe de introducir un minimo de 2 nodos')
    end
    silencio=get(handles.checkSilencio,'value');
    fastmode=get(handles.checkFast,'value');
    paralelo=get(handles.checkParalelo,'value');
    C3D=get(handles.check3D,'value');
    if paralelo
        silencio=1;
    end

    dt=str2double(get(handles.editDt,'string'));
    t=0:dt:str2double(get(handles.editDuracion,'string'));
    t_length=length(t);
    canal=handles.datos.canal;
    mapa=handles.datos.mapa;
    UMBRAL=canal.getUmbral();
    canal=canal.setVectorDistancia(1,mapa.distanciaMaxima);
    tipoEnc=get(handles.popupEnc,'string');
    tipoEnc=tipoEnc{get(handles.popupEnc,'value')};
    nSim=1;
    nRep=1;
    if isequal(tipoEnc,'Barrido')
        enc=Encaminamiento('dijkstra',2,1,canal.calcularDopt(listaNodos{1},listaNodos{2},UMBRAL));
    else
        enc=Encaminamiento(tipoEnc,2,1,canal.calcularDopt(listaNodos{1},listaNodos{2},UMBRAL));
    end
else
    set(handles.seguimiento,'visible','on')
    silencio=true;
    C3D=false;
    tipoEnc='Barrido';
    nSim=length(handles.datos.Execute);
    nRep=str2num(get(handles.nRep,'string'));
    if nRep<1 || rem(nRep,1) 
        error('Número de repeticiones de cada simulación no válido')
    end
end
% parametros de barrido en algoritmos de encaminamiento
tiposEnc=Encaminamiento.cellTipos();
barrido_length=length(tiposEnc);
%media de simulacion
final_coste=zeros(nSim,barrido_length);
simulacion_coste=zeros(nRep,barrido_length);
final_saltos=final_coste;
simulacion_saltos=simulacion_coste;
final_validez=final_coste;
simulacion_validez=simulacion_coste;

%% Figura de resultados 
handles.representacion.figuraRecepcionTx=2;
handles.representacion.figuraRecepcionRx=1;
if ~silencio
    handles.representacion.figuraRecepcion=figuraRecepcion(handles.figure1);
    frh=guidata(handles.representacion.figuraRecepcion);
    axis(frh.mapa,handles.datos.mapa.limites());
end

%% Actualización de handles
guidata(hObject,handles);
tic;
for nS=1:nSim
    if ~isempty(handles.datos.Execute)
        current=cd();
        cd(handles.datos.ruta)
        eval(strcat(['F=@()' handles.datos.Execute{nS} ';']));
        cd(current);
    end
    for nR=1:nRep
        set(handles.seguimiento,'string',sprintf('Sim: %d/%d  Rep: %d/%d',nS,nSim,nR,nRep));
        pause(1e-20)
        if ~isempty(handles.datos.Execute)
            cd(handles.datos.ruta)
            data=F();
            cd(current);
            fastmode=true;
            paralelo=data{9};
            dt=data{3};
            listaNodos=data{1};
            listaNodos_length=length(listaNodos);
            t=0:dt:data{2};
            t_length=length(t);
            canal=data{6};
            mapa=data{4};
            name=data{11};
            UMBRAL=canal.getUmbral();
            canal=canal.setVectorDistancia(1,mapa.distanciaMaxima);
            enc=Encaminamiento('dijkstra',2,1,canal.calcularDopt(listaNodos{1},listaNodos{2},UMBRAL));
        end
        % inicializacion de matrices
        pos=zeros(listaNodos_length,2,t_length);
        UMBRAL=canal.getUmbral();
        canal=canal.setVectorDistancia(1,mapa.distanciaMaxima);
        cobertura=zeros(listaNodos_length,listaNodos_length,t_length);
        consumo=zeros(listaNodos_length,listaNodos_length,t_length);
        recepcion=zeros(listaNodos_length,listaNodos_length,t_length);
        if ~isequal(tipoEnc,'Barrido')
            barrido_length=1;
        end
        if C3D
            matriz3d=zeros(length(mapa.x),length(mapa.y),t_length);
        else
            matriz3d=[];
        end
        coste=zeros(barrido_length,t_length);
        ruta=cell(barrido_length,t_length);
        % Con este segmento de codigo, se garantiza que los nodos con movimiento
        % aleatorio cambien de direccion cada 2 segundos de simulación
        cambio_direccion_mov_aleatorio=ceil(2/dt);
        v_cambio_dir=zeros(1,t_length);
        v_cambio_dir(1:cambio_direccion_mov_aleatorio:end)=1;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if paralelo
            %% Matriz de encaminamientos
            % Creando este cell se evita un error en el parfor-loop
            if barrido_length==1
                ENCS{1}=enc;
            else
                ENCS=cell(1,barrido_length);
                for i=1:barrido_length
                    ENCS{i}=enc.setTipo(tiposEnc{i});
                end
            end
            %% Bucle de simulación
            %% Movimiento
            % Cada muestra depende de la anterior, por eso se calcula fuera del bucle parfor 
%             velocidad=zeros(listaNodos_length,2,t_length);
%             for i=1:t_length
%                 posicion=zeros(listaNodos_length,2);
%                 for j=1:listaNodos_length
%                     velocidad(j,:,i)=listaNodos{j}.mov.v;
%                     posicion(j,:)=listaNodos{j}.mov.pos;
%                     listaNodos{j}.mov=listaNodos{j}.mov.mover(dt,t(i),handles.datos.mapa,v_cambio_dir(i));
%                 end
%                 pos(:,:,i)=posicion;
%             end
            
            
            velocidad=zeros(listaNodos_length,2,t_length);
            parfor j=1:listaNodos_length
%                 posicion=zeros(1,2,t_length);
                for i=1:t_length
                    velocidad(j,:,i)=listaNodos{j}.mov.v;
                    pos(j,:,i)=listaNodos{j}.mov.pos;
                    listaNodos{j}.mov=listaNodos{j}.mov.mover(dt,t(i),mapa,v_cambio_dir(i));
                end
            end
            
            %% Calculo de matriz de distancias
            D=zeros(listaNodos_length,listaNodos_length,t_length);%inicializar d
            parfor i=1:t_length
                FTS=zeros(2,listaNodos_length);
                d_=zeros(listaNodos_length);
                % Calculo FTS
                for I=1:listaNodos_length
                    FTS(1,I)=Movimiento.distancia(pos(enc.d,:,i),pos(I,:,i));
                    FTS(2,I)=Movimiento.distancia(pos(enc.s,:,i),pos(I,:,i));
                end
                if fastmode
                    FTS=FTS(1,:)<=FTS(1,enc.s)&FTS(2,:)<=FTS(2,enc.d)*1.25;
                else
                    FTS=FTS(1,:)<=FTS(1,enc.s);
                end

                % Calculo distancias
                for I=1:listaNodos_length-1
                    for J=I:1:listaNodos_length
                        if FTS(I)&&FTS(J)
                            d_(I,J)=Movimiento.distancia(pos(I,:,i),pos(J,:,i))
                        else
                            d_(I,J)=inf;
                        end
                    end
                end
                D(:,:,i)=d_+d_';
            end
            
            
            PERDIDAS=zeros(listaNodos_length,listaNodos_length,3,t_length);
            parfor rx=1:listaNodos_length
                PERDIDAS_=zeros(1,listaNodos_length,3,t_length);
                for tx=rx:listaNodos_length
                    if any(~isinf(D(rx,tx,:)))
                        PERDIDAS_(1,tx,1,:)=canal.calcularPathloss(D(rx,tx,:),listaNodos{tx}.tx.lambda);
                        PERDIDAS_(1,tx,2,:)=canal.calcularShadowing(D(rx,tx,:));
                    else
                        PERDIDAS_(1,tx,:,:)=nan;
                    end
                end
                PERDIDAS(rx,:,:,:)=PERDIDAS_;
            end
            PERDIDAS=PERDIDAS+permute(PERDIDAS,[2 1 3 4]);% simetria
            PERDIDAS(:,:,3,:)=canal.calcularMultipath(listaNodos_length,listaNodos_length,t_length);
            
            % Cálculos
            parfor i=1:t_length
                %% Calculo de matriz de distancias
                d=D(:,:,i);
                if C3D
                    MATRIZ3D=zeros(length(mapa.x),length(mapa.y));
                    for I=1:length(mapa.x)
                        for J=1:length(mapa.y)
                            MATRIZ3D(I,J)=Movimiento.distancia(pos(1,:,i),[mapa.x(I) mapa.y(J)]);
                        end
                        MATRIZ3D(I,:)=dB(prod(canal.calcularPerdidas(MATRIZ3D(I,:),listaNodos{1}.tx.lambda)));
                    end
                    matriz3d(:,:,i)=MATRIZ3D;
                end

                %% Calculo de los enlaces entre nodos y cobertura. Guardado de posición, antes de mover los nodos
                ct=zeros(listaNodos_length);
                CONSUMO=zeros(listaNodos_length);
                for rx=1:listaNodos_length
                    % Se guarda la posicion
                    for tx=1:listaNodos_length
                        if rx~=tx && ~isinf(d(rx,tx))
                            vtx_rx=Movimiento.v2complex(pos(rx,:,i)-pos(tx,:,i));
                            G=listaNodos{tx}.tx.ganancia(Movimiento.v2complex(velocidad(tx,:,i))./vtx_rx)*listaNodos{rx}.tx.ganancia(Movimiento.v2complex(velocidad(rx,:,i))./(-vtx_rx));
                            %perdidasCanal=canal.calcularPerdidas(d(rx,tx),listaNodos{tx}.tx.lambda);
                            perdidasCanal=PERDIDAS(rx,tx,:,i);
                            Ptx=listaNodos{tx}.tx.ajustarPotencia(perdidasCanal(1),listaNodos{rx}.rx.sensibilidad,G,UMBRAL);
                            CONSUMO(rx,tx)=listaNodos{tx}.P_idle+Ptx;
                            recepcion(rx,tx,i)=dB(G.*prod(perdidasCanal).*Ptx);
                            if recepcion(rx,tx,i)>=listaNodos{rx}.rx.sensibilidad
                                ct(rx,tx)=1;
                            end
                        else
                            CONSUMO(rx,tx)=nan;
                            recepcion(rx,tx,i)=nan;
                        end
                    end
                    CONSUMO(rx,rx)=listaNodos{rx}.P_idle;
                end
                % Almacenamiento en matrices
                cobertura(:,:,i)=ct;
                consumo(:,:,i)=CONSUMO;
                %% Creación de ruta 
                COSTE=zeros(1,barrido_length);
                RUTA=cell(1,barrido_length);
                for I=1:barrido_length
                    try
                        [COSTE(I),RUTA{I}]=ENCS{I}.Calcular(enc,d,pos(:,:,i),CONSUMO,ct);
                    catch e
                        if isequal(e.message,'No se puede establecer ninguna ruta')
                            COSTE(I)=inf;
                            RUTA{I}=[];
                        else
                            rethrow(e)
                        end
                    end
                end
                coste(:,i)=COSTE;
                ruta(:,i)=RUTA;
            end
            if isempty(handles.datos.Execute)
                handles=guidata(hObject);
                set(hObject,'String','Iniciar simulación')
                tiempoTotal=toc;
                handles.representacion.figuraRecepcion=figuraRecepcion(handles.figure1);
                frh=guidata(handles.representacion.figuraRecepcion);
                axis(frh.mapa,mapa.limites());
                plot(frh.axes1,t,...
                    S(recepcion(handles.representacion.figuraRecepcionRx,...
                    handles.representacion.figuraRecepcionTx,:)));
                plot(frh.axes1,...
                    [t(1) t(end)],...
                    [listaNodos{handles.representacion.figuraRecepcionRx}.rx.sensibilidad listaNodos{handles.representacion.figuraRecepcionRx}.rx.sensibilidad],...
                    'm');
                figuraRecepcion('loadData',frh.figure1,t,dt,listaNodos,recepcion,cobertura,consumo,ruta,coste,pos,tipoEnc,mapa,matriz3d,canal,t_length);
                % Marcado de cierre de simulación
                handles.simulando=0;
                msgbox(sprintf('Simulación realizada con éxito. Tiempo empleado: %d m %2d s',floor(tiempoTotal/60),round(rem(tiempoTotal,60))),'Éxito')
                guidata(hObject,handles)
            end
        else
            %% Bucle de simulación
            for i=1:t_length
                %% Actualización de handles
                handles=guidata(hObject);
                %% Comprobar detención
                if handles.detener
                    set(hObject,'String','Iniciar simulación')
                    handles.simulando=0;
                    handles.detener=0;
                    guidata(hObject,handles);
                    if silencio
                        handles.representacion.figuraRecepcion=figuraRecepcion(handles.figure1);
                        frh=guidata(handles.representacion.figuraRecepcion);
                        axis(frh.mapa,mapa.limites());
                        plot(frh.axes1,t(1:i),...
                            S(recepcion(handles.representacion.figuraRecepcionRx,...
                            handles.representacion.figuraRecepcionTx,1:i)));
                        plot(frh.axes1,...
                            [t(1) t(i)],...
                            [listaNodos{handles.representacion.figuraRecepcionRx}.rx.sensibilidad listaNodos{handles.representacion.figuraRecepcionRx}.rx.sensibilidad],...
                            'm');
                    end
                    figuraRecepcion('loadData',frh.figure1,t,dt,listaNodos,recepcion,cobertura,consumo,ruta,coste,pos,tipoEnc,mapa,matriz3d,canal,i-1);
                    set(handles.tsim,'String','');
                    msgbox('Simulación detenida')
                    return
                end
                %% Porcentaje de simulacion
                porcentaje=i/t_length*100;
                updateProgress(porcentaje,handles);

                %% Calculo de matriz de distancias
                d=zeros(listaNodos_length);%inicializar d
                FTS=zeros(1,listaNodos_length);
                if fastmode
                    % Calculo FTS
                    for I=1:listaNodos_length
                        FTS(I)=Movimiento.distancia(listaNodos{enc.d}.mov.pos,listaNodos{I}.mov.pos);
                    end
                    FTS=FTS(enc.d,:)<=FTS(enc.d,enc.s);

                    %Calculo distancias
                    for I=1:listaNodos_length-1
                        for J=I+1:listaNodos_length
                            if FTS(I)&&FTS(J)
                                d(I,J)=Movimiento.distancia(listaNodos{I}.mov.pos,listaNodos{J}.mov.pos);
                            else
                                d(I,J)=inf;
                            end
                        end
                    end

                    % d es una matriz triangular superior. Ahora se duplica para hacerla
                    % simetrica
                    d=d+d';
                else 
                    for I=1:listaNodos_length-1
                        for J=I+1:listaNodos_length
                            d(I,J)=Movimiento.distancia(listaNodos{I}.mov.pos,listaNodos{J}.mov.pos);
                        end
                    end
                    % d es una matriz triangular superior. Ahora se duplica para hacerla
                    % simetrica
                    d=d+d';
                end
                %% Calculo de los enlaces entre nodos y cobertura. Guardado de posición, antes de mover los nodos
                ct=zeros(listaNodos_length);
                if fastmode
                    for rx=1:listaNodos_length
                        % Se guarda la posicion
                        pos(rx,:,i)=listaNodos{rx}.mov.pos;
                        for tx=1:listaNodos_length
                            if (rx~=tx) && ~isinf(d(rx,tx))
                                vtx_rx=Movimiento.v2complex(listaNodos{rx}.mov.pos-listaNodos{tx}.mov.pos);
                                G=listaNodos{tx}.tx.ganancia(Movimiento.v2complex(listaNodos{tx}.mov.v)./vtx_rx)*listaNodos{rx}.tx.ganancia(Movimiento.v2complex(listaNodos{rx}.mov.v)./(-vtx_rx));
                                perdidasCanal=canal.calcularPerdidas(d(rx,tx),listaNodos{tx}.tx.lambda);
                                Ptx=listaNodos{tx}.tx.ajustarPotencia(perdidasCanal(1),listaNodos{rx}.rx.sensibilidad,G,UMBRAL);
                                consumo(rx,tx,i)=listaNodos{tx}.P_idle+Ptx;
                                recepcion(rx,tx,i)=dB(G.*prod(perdidasCanal).*Ptx);
                                if recepcion(rx,tx,i)>=listaNodos{rx}.rx.sensibilidad
                                    ct(rx,tx)=1;
                                end
                            else
                                consumo(rx,tx,i)=nan;
                                recepcion(rx,tx,i)=nan;
                            end
                        end
                        consumo(rx,rx,i)=listaNodos{rx}.P_idle;
                        % Se mueve el nodo
                        listaNodos{rx}.mov=listaNodos{rx}.mov.mover(dt,t(i),mapa,v_cambio_dir(i));
                    end
                else
                    for rx=1:listaNodos_length
                        % Se guarda la posicion
                        pos(rx,:,i)=listaNodos{rx}.mov.pos;
                        for tx=1:listaNodos_length
                            if rx~=tx
                                vtx_rx=Movimiento.v2complex(listaNodos{rx}.mov.pos-listaNodos{tx}.mov.pos);
                                G=listaNodos{tx}.tx.ganancia(Movimiento.v2complex(listaNodos{tx}.mov.v)./vtx_rx)*listaNodos{rx}.tx.ganancia(Movimiento.v2complex(listaNodos{rx}.mov.v)./(-vtx_rx));
                                perdidasCanal=canal.calcularPerdidas(d(rx,tx),listaNodos{tx}.tx.lambda);
                                Ptx=listaNodos{tx}.tx.ajustarPotencia(perdidasCanal(1),listaNodos{rx}.rx.sensibilidad,G,UMBRAL);
                                consumo(rx,tx,i)=listaNodos{tx}.P_idle+Ptx;
                                recepcion(rx,tx,i)=dB(G.*prod(perdidasCanal).*Ptx);
                                if recepcion(rx,tx,i)>=listaNodos{rx}.rx.sensibilidad
                                    ct(rx,tx)=1;
                                end
                            else
                                consumo(rx,tx,i)=listaNodos{rx}.P_idle;
                                recepcion(rx,tx,i)=nan;
                            end
                        end
                        % Se mueve el nodo
                        listaNodos{rx}.mov=listaNodos{rx}.mov.mover(dt,t(i),mapa,v_cambio_dir(i));
                    end
                end

                % Almacenamiento en vector de cobertura
                cobertura(:,:,i)=ct;

                %% Cálculo 3D
                if C3D
                    for I=1:length(mapa.x)
                        for J=1:length(mapa.y)
                            matriz3d(I,J,i)=Movimiento.distancia(pos(1,:,i),[mapa.x(I) mapa.y(J)]);
                        end
                        matriz3d(I,:,i)=dB(prod(canal.calcularPerdidas(matriz3d(I,:,i),listaNodos{1}.tx.lambda)));
                    end
                end

                %% Creación de ruta 
                for I=1:barrido_length
                    if barrido_length>1
                        enc=enc.setTipo(tiposEnc{I});
                    end
                    try
                        [coste(I,i),ruta{I,i}]=enc.Calcular(enc,d,pos(:,:,i),consumo(:,:,i),ct);
                    catch e
                        if isequal(e.message,'No se puede establecer ninguna ruta')
                            coste(I,i)=inf;
                            ruta{I,i}=[];
                        else
                            rethrow(e)
                        end
                    end
                end
                %% Representacion de datos en figura externa
                if ~silencio
                    try
                        % mapa
                        set(frh.edit1,'String',num2str(t(i)));
                        actualizarMapa(listaNodos,listaNodos_length,ruta{i},frh.mapa);
                        handles.representacion.figuraRecepcionTx=get(frh.popupmenu1,'Value');
                        handles.representacion.figuraRecepcionRx=get(frh.popupmenu2,'Value');
                        delete(allchild(frh.axes1));
                        plot(frh.axes1,t(1:i),...
                            S(recepcion(handles.representacion.figuraRecepcionRx,...
                            handles.representacion.figuraRecepcionTx,1:i)));
                        plot(frh.axes1,...
                            [t(1) t(i)],...
                            [listaNodos{handles.representacion.figuraRecepcionRx}.rx.sensibilidad listaNodos{handles.representacion.figuraRecepcionRx}.rx.sensibilidad],...
                            'm');
                    catch e
                        set(hObject,'String','Iniciar simulación')
                        handles.simulando=0;
                        handles.detener=0;
                        guidata(hObject,handles);
                        msgbox('Simulación detenida')
                        rethrow(e);
                    end
                end

                %% Pausa. Necesaria para que dibuje en tiempo real
                pause(1e-20);
            end
            if isempty(handles.datos.Execute)
                handles.simulando=false;
                guidata(hObject,handles);
                set(hObject,'String','Iniciar simulación')
                tiempoTotal=toc;
                if silencio
                    handles.representacion.figuraRecepcion=figuraRecepcion(handles.figure1);
                    frh=guidata(handles.representacion.figuraRecepcion);
                    axis(frh.mapa,mapa.limites());
                    plot(frh.axes1,t,...
                        S(recepcion(handles.representacion.figuraRecepcionRx,...
                        handles.representacion.figuraRecepcionTx,:)));
                    plot(frh.axes1,...
                        [t(1) t(end)],...
                        [listaNodos{handles.representacion.figuraRecepcionRx}.rx.sensibilidad listaNodos{handles.representacion.figuraRecepcionRx}.rx.sensibilidad],...
                        'm');
                end
                figuraRecepcion('loadData',frh.figure1,t,dt,listaNodos,recepcion,cobertura,consumo,ruta,coste,pos,tipoEnc,mapa,matriz3d,canal,t_length);
                msgbox(sprintf('Simulación realizada con éxito. Tiempo empleado: %d m %2d s',floor(tiempoTotal/60),round(rem(tiempoTotal,60))),'Éxito')
            end
        end
        %simulacion_coste(nR,:)=mean(coste(isfinite(coste)),2)';
        [m,n]=size(ruta);
        saltos=zeros(m,n);
        for I=1:m
            validos=isfinite(coste(I,:));
            simulacion_coste(nR,I)=mean(coste(I,validos));
            simulacion_validez(nR,I)=sum(validos)/length(coste(I,:))*100;
            for J=1:n
                saltos(I,J)=length(ruta{I,J})-1;
            end
        end
        simulacion_saltos(nR,:)=mean(saltos,2)';
    end
    final_coste(nS,:)=mean(simulacion_coste,1);
    final_saltos(nS,:)=mean(simulacion_saltos,1);
    final_validez(nS,:)=mean(simulacion_validez,1);
    if ~isempty(handles.datos.Execute)
        nombres{nS}=name;
    end
end
if ~isempty(handles.datos.Execute)
    final_coste=dB(final_coste);
    estilo_plot=Encaminamiento.cellEstilo();
    figure('name', strcat(['Simulacion ' num2str(handles.n) '. Coste']),'numbertitle','off')
    a1=gca;
    hold on
    figure('name', strcat(['Simulacion ' num2str(handles.n) '. Número de saltos']),'numbertitle','off')
    a2=gca;
    hold on
    figure('name', strcat(['Simulacion ' num2str(handles.n) '. Validez de las medidas']),'numbertitle','off')
    a3=gca;
    hold on
    [~,n]=size(final_coste);
    for i=1:n
        plot(a1,final_coste(:,i),estilo_plot{i});
        plot(a2,final_saltos(:,i),estilo_plot{i});
        plot(a3,final_validez(:,i),estilo_plot{i});
    end
    legend(a1,tiposEnc)
    ylabel(a1,'Potencia total (dB)')
    set(a1,'xtick',1:nSim);
    set(a1,'xticklabel',nombres);
    legend(a2,tiposEnc)
    ylabel(a2,'Número de saltos')
    set(a2,'xtick',1:nSim);
    set(a2,'xticklabel',nombres);
    legend(a3,tiposEnc)
    ylabel(a3,'Validez de las medidas')
    set(a3,'xtick',1:nSim);
    set(a3,'xticklabel',nombres);
end
