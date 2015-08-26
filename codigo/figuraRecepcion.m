function varargout = figuraRecepcion(varargin)
%FIGURARECEPCION M-file for figuraRecepcion.fig
%      FIGURARECEPCION, by itself, creates a new FIGURARECEPCION or raises the existing
%      singleton*.
%
%      H = FIGURARECEPCION returns the handle to a new FIGURARECEPCION or the handle to
%      the existing singleton*.
%
%      FIGURARECEPCION('Property','Value',...) creates a new FIGURARECEPCION using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to figuraRecepcion_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      FIGURARECEPCION('CALLBACK') and FIGURARECEPCION('CALLBACK',hObject,...) call the
%      local function named CALLBACK in FIGURARECEPCION.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help figuraRecepcion

% Last Modified by GUIDE v2.5 24-Aug-2015 03:38:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @figuraRecepcion_OpeningFcn, ...
                   'gui_OutputFcn',  @figuraRecepcion_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before figuraRecepcion is made visible.
function figuraRecepcion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for figuraRecepcion
handles.output = hObject;
handles.dependencia = 1;
% Preparación de seleccion de representación
handles.punteroPadre=varargin{1};
h=guidata(handles.punteroPadre);

set(handles.popupmenu1,'String',get(h.popupmenuNodos,'String'))
set(handles.popupmenu2,'String',get(h.popupmenuNodos,'String'))
set(handles.popupmenu1,'Value',2)
set(handles.popupmenu1,'UserData',2)
set(handles.popupmenu2,'Value',1)
set(handles.popupmenu2,'UserData',1)
handles.hlink=linkprop(handles.axes1,'position');

xlabel(handles.axes1,'Tiempo(s)');
ylabel(handles.axes1,'Potencia (dBm)');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes figuraRecepcion wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = figuraRecepcion_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on selection change in popupmenu1.
function popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(hObject,handles.popupmenu2)
    other=handles.popupmenu1;
else 
    other=handles.popupmenu2;
end

if get(hObject,'Value')==get(other,'Value')
    set(hObject,'Value',get(other,'UserData'))
    set(other,'Value',get(hObject,'UserData'))
    set(hObject,'UserData',get(hObject,'Value'))
    set(other,'UserData',get(other,'Value'))
else
    set(hObject,'UserData',get(hObject,'Value'))
end
hlink=linkprop(handles.axes1,'position');
if ~handles.dependencia
    actualizarRecepcion(handles);
end
% --- Executes during object creation, after setting all properties.
function popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function loadData(f,t,dt,listaNodos,recepcion,cobertura,consumo,ruta,coste,pos,tipoEnc,mapa,matriz3d,canal,i)
% Carga los datos necesarios para poder funcionar de forma autonoma
%   
try
    handles=guidata(f);
    handles.dependencia=0;
    handles.datos.t=t;
    handles.datos.dt=dt;
    handles.datos.listaNodos=listaNodos;
    handles.datos.recepcion=recepcion;
    handles.datos.cobertura=cobertura;
    handles.datos.tipoEnc=tipoEnc;
    [~,N,~]=size(consumo);
    [m,n]=size(ruta);
    handles.datos.ruta=ruta;
    handles.datos.nSaltos=coste;
    for I=1:m
        for J=1:i
            handles.datos.nSaltos(I,J)=length(ruta{I,J})-1;
        end
    end
    handles.datos.consumo=zeros(N,m,length(t));
    handles.datos.Ptx=consumo;
    for I=1:N
        handles.datos.Ptx(:,I,:)=handles.datos.Ptx(:,I,:)-handles.datos.Ptx(I,I,1);% se resta P_idle
        handles.datos.consumo(I,:,:)=consumo(I,I,1);
    end
    for t_index=1:i
        for enc_index=1:m
            if handles.datos.nSaltos(enc_index,t_index)>0
                for r=1:handles.datos.nSaltos(enc_index,t_index)
                    tx=ruta{enc_index,t_index}(r);
                    rx=ruta{enc_index,t_index}(r+1);
                    handles.datos.consumo(tx,enc_index,t_index)=consumo(rx,tx,t_index);
                end
            end
        end
    end
    handles.datos.consumo=dB(handles.datos.consumo);
    handles.datos.Ptx=dB(handles.datos.Ptx);
    handles.datos.coste=dB(coste);
    handles.datos.pos=pos;
    handles.datos.mapa=mapa;
    handles.datos.matriz3d=matriz3d;
    handles.datos.canal=canal;
    handles.datos.i=i;
    if isempty(matriz3d)
        set(handles.tipoMapa,'string','2D');
    end
    set(handles.slider1,'Visible','on')
    set(handles.slider1,'Max',i)
    set(handles.slider1,'Min',1)
    set(handles.slider1,'Value',i)
    set(handles.slider1,'SliderStep',[1/(i-1) 0.1])
    set(handles.edit1,'Enable','on')
    set(handles.edit1,'String',num2str(t(i)))
    set(handles.text3,'Visible','on')
    set(handles.text4,'Visible','on')
    set(handles.edit2,'Visible','on')
    set(handles.text5,'Visible','on')
    set(handles.popupmenu3,'Visible','on')
    set(handles.tipoDatos,'Visible','on')
    set(handles.tipoMapa,'Visible','on')
    set(handles.boton3d,'Visible','on')
    if isequal(handles.datos.tipoEnc,'Barrido')
        set(handles.popupmenu3,'string',Encaminamiento.cellTipos());
    else
        set(handles.popupmenu3,'string',handles.datos.tipoEnc);
    end
    handles.cursor=line([t(i) t(i)],get(handles.axes1,'YLim'),'Parent',handles.axes1,'Color','r');
    guidata(f,handles);
    slider1_Callback(handles.slider1, 0, handles)
catch e
    delete(f)
    rethrow(e)
end
function actualizarMapa(handles,t)
% Esta funcion se encarga de actualizar el mapa 

% Limpiar el mapa
delete(allchild(handles.mapa));
% Pintar los nodos
valor=get(handles.tipoMapa,'value');
switch valor
    case 1
        for i=1:length(handles.datos.listaNodos)
            plot(handles.mapa,...
                handles.datos.pos(i,1,t),...
                handles.datos.pos(i,2,t),...
                handles.datos.listaNodos{i}.estilo);
            text(handles.datos.pos(i,1,t),handles.datos.pos(i,2,t),...
                handles.datos.listaNodos{i}.name,'Parent', handles.mapa,'VerticalAlignment','top',...
                'HorizontalAlignment','center')% Parent indica sobre que axes se trabaja
        end
        % Pintar ruta
        nRuta=get(handles.popupmenu3,'value');
        plot(handles.mapa,...
            handles.datos.pos(handles.datos.ruta{nRuta,t},1,t),...
            handles.datos.pos(handles.datos.ruta{nRuta,t},2,t));
        xlabel(handles.mapa,'x(m)');
        ylabel(handles.mapa,'y(m)');
    case 2
        surf(handles.mapa,handles.datos.mapa.x,handles.datos.mapa.y,handles.datos.matriz3d(:,:,t))
    otherwise
        error('Entrada no válida');
end

function actualizarRecepcion(handles)
% Representa la grafica de enlace entre dos nodos, dependiendo de los que
% hayan sido seleccionados
delete(allchild(handles.axes1))%limpia figura
tx=get(handles.popupmenu1,'Value');
rx=get(handles.popupmenu2,'Value');
enc=get(handles.popupmenu3,'Value');
tipo=get(handles.tipoDatos,'value');
switch tipo
    case 1
        plot(handles.axes1,handles.datos.t(1:handles.datos.i),...
            squeeze(handles.datos.recepcion(rx,tx,1:handles.datos.i)));
        plot(handles.axes1,...
            [handles.datos.t(1) handles.datos.t(handles.datos.i)],...
            [handles.datos.listaNodos{get(handles.popupmenu2,'Value')}.rx.sensibilidad handles.datos.listaNodos{get(handles.popupmenu2,'Value')}.rx.sensibilidad],...
            'm');
        xlabel(handles.axes1,'Tiempo(s)');
        ylabel(handles.axes1,'Potencia (dBm)');
    case 2
        plot(handles.axes1,handles.datos.t(1:handles.datos.i),...
            squeeze(handles.datos.Ptx(rx,tx,1:handles.datos.i)));
        xlabel(handles.axes1,'Tiempo(s)');
        ylabel(handles.axes1,'Potencia (dBm)');
    case 3
        plot(handles.axes1,handles.datos.t(1:handles.datos.i),...
            squeeze(handles.datos.consumo(tx,enc,1:handles.datos.i)));
        xlabel(handles.axes1,'Tiempo(s)');
        ylabel(handles.axes1,'Potencia (dBm)');
    case 4
        [m,~]=size(handles.datos.nSaltos);
        estilo=Encaminamiento.cellColor();
        for I=1:m
            plot(handles.axes1,handles.datos.t(1:handles.datos.i),...
                squeeze(handles.datos.nSaltos(I,1:handles.datos.i)),estilo{I});
        end
        if m>1
            legend(handles.axes1,Encaminamiento.cellTipos());
            
        end
        xlabel(handles.axes1,'Tiempo(s)');
        ylabel(handles.axes1,'Nº de saltos');
    case 5
        [m,~]=size(handles.datos.nSaltos);
        estilo=Encaminamiento.cellColor();
        for I=1:m
            plot(handles.axes1,handles.datos.t(1:handles.datos.i),...
                squeeze(handles.datos.coste(I,1:handles.datos.i)),estilo{I});
        end
        if m>1
            legend(handles.axes1,Encaminamiento.cellTipos());
            %set(handles.axes1,'activepositionproperty','position')
        end
        xlabel(handles.axes1,'Tiempo(s)');
        ylabel(handles.axes1,'Potencia (dBm)');
    otherwise
        error('Entrada no válida');
end
set(handles.axes1,'position',[81 178 396 355])
slider1_Callback(handles.slider1, 0, handles);

function actualizarPR(handles,i)
%actualizar texto de potencia de recepcion
tx=get(handles.popupmenu1,'Value');
rx=get(handles.popupmenu2,'Value');
enc=get(handles.popupmenu3,'Value');
tipo=get(handles.tipoDatos,'value');
switch tipo
    case 1
        t=sprintf('%.3f dB',handles.datos.recepcion(rx,tx,i));
        set(handles.edit2,'String',t);
        if handles.datos.cobertura(rx,tx,i)
            set(handles.edit2,'BackgroundColor','g');
        else
            set(handles.edit2,'BackgroundColor','r');
        end
    case 2
        t=sprintf('%.3f dB',handles.datos.Ptx(rx,tx,i));
        set(handles.edit2,'String',t);
        set(handles.edit2,'BackgroundColor','white');
    case 3
        t=sprintf('%.3f dB',handles.datos.consumo(tx,enc,i));
        set(handles.edit2,'String',t);
        set(handles.edit2,'BackgroundColor','white');
    case 4
        v=get(handles.popupmenu3,'value');
        t=num2str(handles.datos.nSaltos(v,i));
        set(handles.edit2,'String',t);
        set(handles.edit2,'BackgroundColor','white');
    case 5
        v=get(handles.popupmenu3,'value');
        t=sprintf('%.3f dB',handles.datos.coste(v,i));
        set(handles.edit2,'String',t);
        set(handles.edit2,'BackgroundColor','white');
    otherwise
        error('Entrada no válida');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
i=get(hObject,'value');
i=round(i);
set(hObject,'Value',i);
set(handles.edit1,'String',num2str(handles.datos.t(i)));
% Actualizar mapa
actualizarMapa(handles,i);
updateCursor(handles,i)
actualizarPR(handles,i)

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v=str2double(get(hObject,'String'));
%index=find(handles.datos.t>=v,1,'first');
[~,index]=min(abs(handles.datos.t-v));
if isempty(index)
    slider1_Callback(handles.slider1, eventdata, handles)
else
    set(handles.slider1,'Value',index)
    slider1_Callback(handles.slider1, eventdata, handles)
end

function updateCursor(handles,i)
% Coloca el cursor en la posición correspondiente al slider
try
    delete(handles.cursor)
catch e
end
handles.cursor=line([handles.datos.t(i) handles.datos.t(i)],...
    get(handles.axes1,'YLim'),...
    'Parent',handles.axes1,'Color','r');
guidata(handles.axes1,handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
try
    h=guidata(handles.punteroPadre);
    if handles.dependencia
        mainUI('ejecutar_Callback',h.ejecutar, eventdata, h)
    else
        delete(hObject);
    end
catch e
    delete(hObject);
end


% --- Executes on selection change in tipoDatos.
function tipoDatos_Callback(hObject, eventdata, handles)
% hObject    handle to tipoDatos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

valor=get(hObject,'value');
switch valor
    case 1
        set(handles.text2,'visible','on');
        set(handles.popupmenu2,'visible','on');
        set(handles.text1,'visible','on');
        set(handles.popupmenu1,'visible','on');
    case 2
        set(handles.text2,'visible','on');
        set(handles.popupmenu2,'visible','on');
        set(handles.text1,'visible','on');
        set(handles.popupmenu1,'visible','on');
    case 3
        set(handles.text2,'visible','off');
        set(handles.popupmenu2,'visible','off');
        set(handles.text1,'visible','on');
        set(handles.popupmenu1,'visible','on');
    case 4
        set(handles.text2,'visible','off');
        set(handles.popupmenu2,'visible','off');
        set(handles.text1,'visible','off');
        set(handles.popupmenu1,'visible','off');
    case 5
        set(handles.text2,'visible','off');
        set(handles.popupmenu2,'visible','off');
        set(handles.text1,'visible','off');
        set(handles.popupmenu1,'visible','off');
    otherwise
        error('Entrada no válida');
end
actualizarRecepcion(handles);

% --- Executes on selection change in tipoMapa.
function tipoMapa_Callback(hObject, eventdata, handles)
% hObject    handle to tipoMapa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
slider1_Callback(handles.slider1, 0, handles)

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
actualizarRecepcion(handles)


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p=get(hObject,'currentpoint');
set(handles.edit1,'string',num2str(p(1)));
edit1_Callback(handles.edit1, 0, handles)


% --- Executes on button press in boton3d.
function boton3d_Callback(hObject, eventdata, handles)
% hObject    handle to boton3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
i=get(handles.slider1,'value');
tx=get(handles.popupmenu1,'value');
rx=get(handles.popupmenu2,'value');
nodotx=handles.datos.listaNodos{tx};
nodorx=handles.datos.listaNodos{rx};

matriz3d=zeros(length(handles.datos.mapa.x),length(handles.datos.mapa.y));
for I=1:length(handles.datos.mapa.x)
    for J=1:length(handles.datos.mapa.y)
        matriz3d(I,J)=Movimiento.distancia(handles.datos.pos(tx,:,i),[handles.datos.mapa.x(I) handles.datos.mapa.y(J)]);
    end
    matriz3d(I,:)=dB(prod(handles.datos.canal.calcularPerdidas(matriz3d(I,:),nodotx.tx.lambda)));
end
matriz3d=matriz3d+handles.datos.Ptx(rx,tx,i);
cobertura=matriz3d<nodorx.rx.sensibilidad;
figure()
f1=gca;
surf(f1,handles.datos.mapa.x,handles.datos.mapa.y,matriz3d);
figure()
f2=gca;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filtrado de cobertura
%F = [.05 .1 .05; .1 .4 .1; .05 .1 .05];
%cobertura=conv2(cobertura*1,F,'same');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
contourf(f2,handles.datos.mapa.x,handles.datos.mapa.y,~cobertura,'LineStyle','none');
hold on
colormap('autumn')
%pintar nodos
for n=1:length(handles.datos.listaNodos)
    plot(f2,...
        handles.datos.pos(n,1,i),...
        handles.datos.pos(n,2,i),...
        handles.datos.listaNodos{n}.estilo);
    text(handles.datos.pos(n,1,i),handles.datos.pos(n,2,i),...
        handles.datos.listaNodos{n}.name,'Parent', f2,'VerticalAlignment','top',...
        'HorizontalAlignment','center')% Parent indica sobre que axes se trabaja
end
% Pintar ruta
nRuta=get(handles.popupmenu3,'value');
plot(f2,...
    handles.datos.pos(handles.datos.ruta{nRuta,i},1,i),...
    handles.datos.pos(handles.datos.ruta{nRuta,i},2,i));
