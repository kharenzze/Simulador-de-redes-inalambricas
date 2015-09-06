function varargout = canalUI(varargin)
% CANALUI MATLAB code for canalUI.fig
%      CANALUI, by itself, creates a new CANALUI or raises the existing
%      singleton*.
%
%      H = CANALUI returns the handle to a new CANALUI or the handle to
%      the existing singleton*.
%
%      CANALUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CANALUI.M with the given input arguments.
%
%      CANALUI('Property','Value',...) creates a new CANALUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before canalUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to canalUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help canalUI

% Last Modified by GUIDE v2.5 20-Jul-2015 02:33:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @canalUI_OpeningFcn, ...
                   'gui_OutputFcn',  @canalUI_OutputFcn, ...
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


% --- Executes just before canalUI is made visible.
function canalUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to canalUI (see VARARGIN)

% crear canal predeterminado
handles.canal=varargin{1};
handles.canalInicial=varargin{1};
handles.cancelar=1;

% Rellenar los popupmenus
set(handles.efecto,'String',{'Pathloss','Shadowing','Multipath'});
handles.tipos={ ...
                {'Espacio libre','Modelo simplificado'},...
                {'Lognormal','Ninguno'},...
                {'Rayleigh','Rician','Weibull','Ninguno'},...
                };
handles.tiposSimp={ ...
                {'fspl','simpl'},...
                {'logn','no'},...
                {'rayl','rician','wbl','no'},...
                };
handles.vectorTexto=[handles.text1 handles.text9 handles.text2 handles.text10 handles.text3 handles.text11];
handles.vectorEdit=[handles.edit1 handles.edit2 handles.edit3];
set(handles.tipo,'String',handles.tipos{1});

set(handles.uipanel4,'UserData',handles.radiobutton1);

% Update handles structure
guidata(hObject, handles);
efecto_Callback(handles.efecto, 0, handles);
actualizarAxes()
% UIWAIT makes canalUI wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = canalUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if handles.cancelar
    varargout{1} = handles.canalInicial;
else
    varargout{1} = handles.canal;
end
delete(hObject);

% --- Executes on button press in botonAceptar.
function botonAceptar_Callback(hObject, eventdata, handles)
% hObject    handle to botonAceptar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in efecto.
function efecto_Callback(hObject, eventdata, handles)
% hObject    handle to efecto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v=get(hObject,'Value');
set(handles.tipo,'String',handles.tipos{v});
% dependiendo del valor tomado, se cambian los demas objetos
switch v
    case 1
        switch handles.canal.pathloss
            case 'fspl'
                set(handles.tipo,'Value',1);
                setTexto();
                setEdits(handles.canal.pathlossParams);
            case 'simpl'
                set(handles.tipo,'Value',2);
                setTexto('K','dB','d0','m','g','');
                textoGriego(handles.vectorTexto(5),1);
                setEdits(handles.canal.pathlossParams);
        end
    case 2
        switch handles.canal.shadowing;
            case 'logn'
                set(handles.tipo,'Value',1);
                setTexto('m','','s','');
                textoGriego(handles.vectorTexto(1),1);
                textoGriego(handles.vectorTexto(3),1);
                setEdits(handles.canal.shadowingParams);
            case 'no'
                set(handles.tipo,'Value',2);
                setTexto();
                setEdits(handles.canal.shadowingParams);
        end
    case 3
        switch handles.canal.multipath;
            case 'rayl'
                set(handles.tipo,'Value',1);
                setTexto('b','');
                setEdits(handles.canal.multipathParams);
            case 'rician'
                set(handles.tipo,'Value',2);
                setTexto('s','','s','');
                textoGriego(handles.vectorTexto(3),1);
                setEdits(handles.canal.multipathParams);
            case 'wbl'
                set(handles.tipo,'Value',3);
                setTexto('a','','b','');
                setEdits(handles.canal.multipathParams);
            case 'no'
                set(handles.tipo,'Value',4);
                setTexto();
                setEdits(handles.canal.multipathParams);
        end
end
actualizarAxes()

% --- Executes on selection change in tipo.
function tipo_Callback(hObject, eventdata, handles)
% hObject    handle to tipo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v=get(handles.efecto,'Value');
v2=get(handles.tipo,'Value');
set(handles.tipo,'String',handles.tipos{v});
% dependiendo del valor tomado, se cambian los demas objetos
switch v
    case 1
        switch v2
            case 1
                setTexto();
                setEdits({});
            case 2
                setTexto('K','dB','d0','m','g','');
                textoGriego(handles.vectorTexto(5),1);
                setEdits(cell(1,3));
        end
        if isequal(handles.tiposSimp{v}{v2},handles.canal.pathloss)
            setEdits(handles.canal.pathlossParams);
        end
    case 2
        switch v2
            case 1
                setTexto('m','','s','');
                textoGriego(handles.vectorTexto(1),1);
                textoGriego(handles.vectorTexto(3),1);
                setEdits(cell(1,2));
            case 2
                setTexto();
                setEdits({});
        end
        if isequal(handles.tiposSimp{v}{v2},handles.canal.shadowing)
            setEdits(handles.canal.shadowingParams);
        end
    case 3
        switch v2
            case 1
                setTexto('b','');
                setEdits(cell(1));
            case 2
                setTexto('s','','s','');
                textoGriego(handles.vectorTexto(3),1);
                setEdits(cell(2));
            case 3
                setTexto('a','','b','');
                setEdits(cell(2));
            case 4
                setTexto();
                setEdits({});
        end
        if isequal(handles.tiposSimp{v}{v2},handles.canal.multipath)
            setEdits(handles.canal.multipathParams);
        end
end

function textoGriego(obj,t)
% Prepara un objeto para poder escribir letras griegas en él
if t
    set(obj,'FontSize',12)
    set(obj,'FontName','symbol')
else
    set(obj,'FontSize',8)
    set(obj,'FontName','MS Sans Serif')
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % Comprobación del boton pulsado
    if isequal(hObject,handles.botonAceptar)
        handles.cancelar=0;
        guidata(hObject,handles)
    end     

    % Resume figure
    if isequal(get(gcf, 'waitstatus'), 'waiting')
       uiresume(gcf);
    else
       delete(gcf); %Hint: delete(hObject) closes the figure
    end
catch 
    delete(gcf);
    warning('Parece que algo no ha ido bien al cerrar la figura');
end
% --- Executes on button press in botonAplicar.
function botonAplicar_Callback(hObject, eventdata, handles)
% hObject    handle to botonAplicar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c=loadEdits();
modelo=[get(handles.efecto,'Value') get(handles.tipo,'Value')];
name=handles.tiposSimp{modelo(1)}{modelo(2)};
switch modelo(1)
    case 1
        handles.canal=handles.canal.setPathloss(name,c);
    case 2
        handles.canal=handles.canal.setShadowing(name,c);
    case 3
        handles.canal=handles.canal.setMultipath(name,c);
end
guidata(hObject,handles);
actualizarAxes()


% --- Executes when selected object is changed in uipanel4.
function uipanel4_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel4 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel4,'UserData',hObject);
actualizarAxes()
guidata(hObject,handles)

function setTexto(varargin)
% Prepara el texto de que se muestra en funcion de los parametros de
% entrada. Es útil cuando el usuario cambia de efecto o tipo. Ejemplo de
% uso: 
%   setTexto('a','m') - Rellena la primera linea de texto con los
%   textos introducidos, y desactiva el resto de campos de texto
if nargin >6 || mod(nargin,2)
    error('Numero de argumntos de entrada invalido');
end
handles=guidata(gcf);
for i=1:6
    if i<=nargin
        set(handles.vectorTexto(i),'Visible','on')
        set(handles.vectorTexto(i),'String',varargin{i})
        textoGriego(handles.vectorTexto(i),0);
    else
        set(handles.vectorTexto(i),'Visible','off')
    end
end

function setEdits(c)
% Establece el texto de los edits a través del los datos numericos del cell
%'c'
handles=guidata(gcf);
l=length(c);
for i=1:3
    if i<=l
        set(handles.vectorEdit(i),'String',c{i});
        set(handles.vectorEdit(i),'Visible','on');
    else
        set(handles.vectorEdit(i),'Visible','off');
    end
end

function c=loadEdits()
% Crea un cell con numeros 
handles=guidata(gcf);
c={};
for i=1:3
    if isequal('on',get(handles.vectorEdit(i),'Visible'))
        c{i}=str2num(get(handles.vectorEdit(i),'String'));
    else
        return
    end
end

function actualizarAxes()
% Esta función se encarga de represenar en la gráfica la información
% referente al efecto seleccionado, o una vista general del modelo de canal
% si está seleccionada. 
handles=guidata(gcf);
a=handles.axes1;
h=get(handles.uipanel4,'UserData');
l=lambda(2.4e9);
d_log=handles.canal.d;
n=length(d_log);%n puntos
d_lin=linspace(d_log(1),d_log(end),n);
if isequal(handles.radiobutton3,h)
    %vista general
    y=handles.canal.calcularPerdidas(handles.canal.d,l);
    plot(a,log10(d_log),dB(prod(y)),'r');
    hold(a,'on')
    plot(a,log10(d_log),dB(prod(y(1:2,:))),'g');
    plot(a,log10(d_log),dB(y(1,:)),'k');
    hold(a,'off')
    xlabel('Distancia (Décadas)')
    ylabel('Perdidas (dB)');
    legend({'Total','Pathloss + shadowing','Pathloss'})
else
    efecto=get(handles.efecto,'Value');
    if efecto==1
        if isequal(h,handles.radiobutton1)
            y=handles.canal.calcularPathloss(d_lin,l);
            plot(a,d_lin,dB(y))
            xlabel('Distancia (m)')
            ylabel('Perdidas (dB)');
        else
            y=handles.canal.calcularPathloss(d_log,l);
            plot(a,log10(d_log),dB(y))
            xlabel('Distancia(Décadas)')
            ylabel('Perdidas (dB)');
        end
    elseif efecto==2
        if isequal(handles.canal.shadowing,'no')
            cla(a)
            return
        elseif isequal(handles.canal.shadowing,'logn')
            n=100*n;
            muestras=random('logn',handles.canal.shadowingParams{1},...
                handles.canal.shadowingParams{2},1,n);
            [y,x]=hist(dB(muestras),150);
            if isequal(h,handles.radiobutton1)
                [y,x]=hist(muestras,150);
                plot(x,y/n);
                xlabel('Valor (lineal)')
                ylabel('Probabilidad');
            else
                [y,x]=hist(dB(muestras),150);
                plot(x,y/n);
                xlabel('Valor (dB)')
                ylabel('Probabilidad');    
            end
        end
    else
        n=100*n;
        muestra=handles.canal.calcularMultipath(1,n,1);
        if isequal(h,handles.radiobutton1)
            [y,x]=hist(muestra,150);
            plot(x,y/n);
            xlabel('Valor (lineal)')
            ylabel('Probabilidad'); 
        else
            [y,x]=hist(dB(muestra),150);
            plot(x,y/n);
            xlabel('Valor (dB)')
            ylabel('Probabilidad'); 
        end
    end
end
