function varargout = NodoUI(varargin)
% NODOUI MATLAB code for NodoUI.fig
%      NODOUI, by itself, creates a new NODOUI or raises the existing
%      singleton*.
%
%      H = NODOUI returns the handle to a new NODOUI or the handle to
%      the existing singleton*.
%
%      NODOUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NODOUI.M with the given input arguments.
%
%      NODOUI('Property','Value',...) creates a new NODOUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NodoUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NodoUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NodoUI

% Last Modified by GUIDE v2.5 26-Aug-2015 02:59:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NodoUI_OpeningFcn, ...
                   'gui_OutputFcn',  @NodoUI_OutputFcn, ...
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


% --- Executes just before NodoUI is made visible.
function NodoUI_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NodoUI (see VARARGIN)

% Choose default command line output for NodoUI
handles.output = hObject;
if isstruct(varargin)
    set(handles.editName,'String',strcat('Nodo',num2str(varargin{1})));
end
handles.vMov={handles.text25,...
    handles.edit20,...
    handles.text26,...
    handles.text22,...
    handles.edit19,...
    handles.text24,...
    };
popupmenu1_Callback(handles.popupmenu1, 0, handles)

switch length(varargin)
    case 0
        handles.NodoAntiguo=0;
    case 1
        handles.NodoAntiguo=varargin{1};
        %load
end
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes NodoUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NodoUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if handles.salida
    %creacion del nodo
    varargout{1}=Nodo(handles.datos.editX,handles.datos.editY);
    varargout{1}.P_idle=lin(handles.datos.editP);
    varargout{1}.name=handles.datos.editName;
    varargout{1}.tx=varargout{1}.tx.setAntenas({Antena(lin(handles.datos.editGainTx))});
    varargout{1}.tx.pmax=lin(handles.datos.editPowerMax);
    varargout{1}.tx.pmin=lin(handles.datos.editPowerMin);
    varargout{1}.tx=varargout{1}.tx.setF(handles.datos.editF);
    varargout{1}.rx=varargout{1}.rx.setF(handles.datos.editF);
    varargout{1}.rx=varargout{1}.rx.setAntenas({Antena(lin(handles.datos.editGainRx))});
    varargout{1}.rx.sensibilidad=handles.datos.editSens;
    switch get(handles.popupmenu1,'value')
        case 1
            varargout{1}.mov=varargout{1}.mov.setTipo(handles.datos.tipoMov);
        case 2
            varargout{1}.mov=varargout{1}.mov.setTipo(handles.datos.tipoMov,handles.datos.p1);
        case 3
            varargout{1}.mov=varargout{1}.mov.setTipo(handles.datos.tipoMov,handles.datos.p1,handles.datos.p2);
    end
    varargout{1}.estilo=handles.datos.editColor;
    
else    
    varargout{1} = handles.NodoAntiguo;
end

%Close figure
delete(hObject); 


% --- Executes during object creation, after setting all properties.
function createTextBox(hObject, eventdata, handles)
% hObject    handle to editX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%comprobación del botón de activación
if isequal(hObject,handles.botonAnadir)
    handles.salida=1;
    %comprobación de campos
    todoCorrecto=1;
    
    [esNumero valor]=validarNumero(handles.editX);
    if esNumero
        handles.datos.editX=valor;
    else
        todoCorrecto=0;
    end
    
    [esNumero valor]=validarNumero(handles.editY);
    if esNumero
        handles.datos.editY=valor;
    else
        todoCorrecto=0;
    end
    
    [esNumero valor]=validarNumero(handles.editPowerMax);
    if esNumero
        handles.datos.editPowerMax=valor;
    else
        todoCorrecto=0;
    end
    
    [esNumero valor]=validarNumero(handles.editPowerMin);
    if esNumero
        handles.datos.editPowerMin=valor;
    else
        todoCorrecto=0;
    end
    
    [esNumero valor]=validarNumero(handles.editGainTx);
    if esNumero
        handles.datos.editGainTx=valor;
    else
        todoCorrecto=0;
    end
    
    [esNumero valor]=validarNumero(handles.editGainRx);
    if esNumero
        handles.datos.editGainRx=valor;
    else
        todoCorrecto=0;
    end
    
    [esNumero valor]=validarNumero(handles.editSens);
    if esNumero
        handles.datos.editSens=valor;
    else
        todoCorrecto=0;
    end
    
    [esNumero valor]=validarNumero(handles.editF);
    if esNumero
        handles.datos.editF=valor;
    else
        todoCorrecto=0;
    end
    
    [esNumero valor]=validarNumero(handles.editP);
    if esNumero
        handles.datos.editP=valor;
    else
        todoCorrecto=0;
    end
    
    handles.datos.editColor=get(handles.editColor,'String');
    
    texto=get(handles.editName,'String');
    if ~isequal(texto,'')
        handles.datos.editName=texto;
    else
        todoCorrecto=0;
        set(handles.editName,'BackgroundColor','red');
    end
    
    switch get(handles.popupmenu1,'value')
        case 1
            handles.datos.tipoMov='fixed';
        case 2
            handles.datos.tipoMov='random';
            
            [esNumero valor]=validarNumero(handles.edit20);
            if esNumero
                handles.datos.p1=valor;
            else
                todoCorrecto=0;
            end
        case 3
            handles.datos.tipoMov='const';
            
            [esNumero valor]=validarNumero(handles.edit20);
            if esNumero
                handles.datos.p1=valor;
            else
                todoCorrecto=0;
            end
            [esNumero valor]=validarNumero(handles.edit19);
            if esNumero
                handles.datos.p2=valor;
            else
                todoCorrecto=0;
            end
    end
    
    if todoCorrecto
        guidata(hObject,handles);
    else
        errordlg('Falta algun campo por rellenar','Error');
        return
    end
else
    handles.salida=0;
end
%actualizar handles
guidata(hObject,handles);
%resume gui
if isequal(get(gcf, 'waitstatus'), 'waiting')
   uiresume(gcf);
else
   delete(gcf); %Hint: delete(hObject) closes the figure
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over editX.
function limpiarTexto(hObject, eventdata, handles)
% hObject    handle to textBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'String','');



function callbackNumero(hObject, eventdata, handles)
% hObject    handle to TextBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editX as text
%        str2double(get(hObject,'String')) returns contents of editX as a double
v = str2double(get(hObject, 'String'));
if isnan(v)
    set(hObject, 'String', 0);
    errordlg('El campo debe contener un número','Error');
end

function [a v] = validarNumero(hObject)
%Comprueba que no quede ningún campo vacio, y pinta de rojo los que están
%vacios. Devuelve 1 si los campos son validos

%a  indica si es un numero
%v  valor
a=1;
v=str2double(get(hObject, 'String'));
if isnan(v)
    set(hObject,'BackgroundColor','red');
    a=0;
end

function setTexto(varargin)
% establece el texto en el vector indicado
v=varargin{1};
if nargin-1~=length(v)
    error('Número de argumentos invalido');
end
for i=1:length(v)
    t=varargin{i+1};
    if isequal(t,0)
        set(v{i},'visible','off')
    else
        set(v{i},'visible','on')
        set(v{i},'string',t)
    end
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

v=get(hObject,'value');
switch v
    case 1
        setTexto(handles.vMov,...
            0,0,0,...
            0,0,0);
    case 2
        setTexto(handles.vMov,...
            'V','','m/s',...
            0,0,0);
    case 3
        setTexto(handles.vMov,...
            'Vx','','m/s',...
            'Vy','','m/s');
    otherwise
        error('Número de argumentos inválido')
end
