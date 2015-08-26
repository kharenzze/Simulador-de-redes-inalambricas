function varargout = mapaUI(varargin)
% MAPAUI MATLAB code for mapaUI.fig
%      MAPAUI, by itself, creates a new MAPAUI or raises the existing
%      singleton*.
%
%      H = MAPAUI returns the handle to a new MAPAUI or the handle to
%      the existing singleton*.
%
%      MAPAUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAPAUI.M with the given input arguments.
%
%      MAPAUI('Property','Value',...) creates a new MAPAUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mapaUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mapaUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mapaUI

% Last Modified by GUIDE v2.5 17-Aug-2015 04:37:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mapaUI_OpeningFcn, ...
                   'gui_OutputFcn',  @mapaUI_OutputFcn, ...
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


% --- Executes just before mapaUI is made visible.
function mapaUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mapaUI (see VARARGIN)

if length(varargin)==1
    handles.mapaAntiguo=varargin{1};
else
    delete(handles.figure1);
    error('Número de argumentos de entrada no valido')
end
set(handles.edit1,'string',num2str(handles.mapaAntiguo.alto));
set(handles.edit2,'string',num2str(handles.mapaAntiguo.ancho));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mapaUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mapaUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargout{1}=handles.nuevoMapa;
delete(handles.figure1);

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

function validar(handles)
% Función que se encarga de comprobar que los datos introducidos son de
% tipo correcto 
alto=str2num(get(handles.edit1,'string'));
if ~(alto>0 && isfinite(alto))
    errordlg('"Alto" debe ser un número positivo')
    error('"Alto" debe ser un número positivo');
end
ancho=str2num(get(handles.edit2,'string'));
if ~(ancho>0 && isfinite(ancho))
    errordlg('"Ancho" debe ser un número positivo')
    error('"Ancho" debe ser un número positivo');
end
dens=str2num(get(handles.edit3,'string'));
if ~(dens>0 && mod(dens,1)==0)
    errordlg('"Densidad" debe ser un entero positivo')
    error('"Densidad" debe ser un entero positivo');
end
handles.nuevoMapa=Mapa(alto,ancho,dens);
guidata(handles.figure1,handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(hObject,handles.BAceptar)
    validar(handles)
else
    handles.nuevoMapa=handles.mapaAntiguo;
    guidata(handles.figure1,handles);
end
if isequal(get(gcf, 'waitstatus'), 'waiting')
   uiresume(gcf);
else
   delete(gcf); %Hint: delete(hObject) closes the figure
end
