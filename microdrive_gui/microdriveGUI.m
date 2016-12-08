function varargout = microdriveGUI(varargin)
% MICRODRIVEGUI MATLAB code for microdriveGUI.fig
%      MICRODRIVEGUI, by itself, creates a new MICRODRIVEGUI or raises the existing
%      singleton*.
%
%      H = MICRODRIVEGUI returns the handle to a new MICRODRIVEGUI or the handle to
%      the existing singleton*.
%
%      MICRODRIVEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MICRODRIVEGUI.M with the given input arguments.
%
%      MICRODRIVEGUI('Property','Value',...) creates a new MICRODRIVEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before microdriveGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to microdriveGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help microdriveGUI

% Last Modified by GUIDE v2.5 08-Dec-2016 17:07:40
% By Teja Pratap Bollu (Goldberg Lab)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @microdriveGUI_OpeningFcn, ...
    'gui_OutputFcn',  @microdriveGUI_OutputFcn, ...
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


% --- Executes just before microdriveGUI is made visible.
function microdriveGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to microdriveGUI (see VARARGIN)

% Choose default command line output for microdriveGUI
handles.output = hObject;

for i=1:127
    str_increments{i} = num2str(i);
end
for i=1:20
    str_comport{i}= strcat('COM',num2str(i));
end
handles.serial_open_flag=0;
handles.dir_flip = 0;

set(handles.serial_conn_menu,'String',str_comport);
set(handles.inc_list,'String',str_increments);
set(handles.serial_conn_menu,'Value',4);
set(handles.inc_list,'Value',5);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes microdriveGUI wait for user response (see UIRESUME)
% uiwait(handles.baseapp);

% --- Outputs from this function are returned to the command line.
function varargout = microdriveGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on key press with focus on baseapp and none of its controls.
function baseapp_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to baseapp (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
s1_obj = handles.serial_obj;
str_inc=get(handles.inc_list,'Value');
dir_flip = handles.dir_flip;
    if strcmp(eventdata.Key,'rightarrow') || strcmp(eventdata.Key,'uparrow')
        moveinfo= (str_inc + dir_flip*128);
        count_info = str_inc + 2*str_inc*(-1)*(dir_flip);
    elseif strcmp(eventdata.Key,'leftarrow') || strcmp(eventdata.Key,'downarrow')
        moveinfo = uint8(str_inc+(~dir_flip)*128);
        count_info = str_inc + 2*str_inc*(-1)*(~dir_flip);
    else
        return;
    end
if strcmp(s1_obj.status,'open')
    fwrite(s1_obj,moveinfo);
    str_netchange = get(handles.netmovement,'String');
    str_netchange = num2str(str2num(str_netchange)+ count_info);
    set(handles.netmovement,'String',str_netchange);
else
    h  = errordlg('COM port needs to be connected to update values');
    return;
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton_up.
function pushbutton_up_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s1_obj = handles.serial_obj;
dir_flip = handles.dir_flip;
str_inc=get(handles.inc_list,'Value');
if strcmp(s1_obj.status,'open')
    fwrite(s1_obj,uint8(str_inc+dir_flip*128));
    str_netchange = get(handles.netmovement,'String');
    count_info = str_inc + 2*str_inc*(-1)*(dir_flip);
    str_netchange = num2str(str2num(str_netchange)+ count_info);
    set(handles.netmovement,'String',str_netchange);
else
    h  = errordlg('COM port needs to be connected to update values');
    return;
end
set(handles.pushbutton_up,'Selected','off');
guidata(hObject, handles);


% --- Executes on button press in pushbutton_down.
function pushbutton_down_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s1_obj = handles.serial_obj;
dir_flip = handles.dir_flip;
str_inc=get(handles.inc_list,'Value');
if strcmp(s1_obj.status,'open')
    fwrite(s1_obj,uint8(str_inc+(~dir_flip)*128));
    count_info = str_inc + 2*str_inc*(-1)*(~dir_flip);
    str_netchange = get(handles.netmovement,'String');
    str_netchange = num2str(str2num(str_netchange)+ count_info);
    set(handles.netmovement,'String',str_netchange);
else
    h  = errordlg('COM port needs to be connected to update values');
    return;
end
guidata(hObject, handles);

% --- Executes on button press in Serial_Connect.
function Serial_Connect_Callback(hObject, eventdata, handles)
% hObject    handle to Serial_Connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    str_comport = get(handles.serial_conn_menu,'String');
    str_comport = str_comport{get(handles.serial_conn_menu,'Value')};
    if handles.serial_open_flag==0
        s1 = serial(str_comport,'BaudRate',9600);
        fopen(s1);
        if strcmp(s1.Status,'open')
            handles.serial_open_flag=1;
            handles.serial_obj = s1;
            set(handles.Serial_Connect,'String','Serial Close');
        end
    else
        set(handles.Serial_Connect,'String','Serial Open');
        s1 = handles.serial_obj;
        handles.serial_open_flag=0;
        fclose(s1);
    end
catch e
    h  = errordlg(e.message);
    return;
end
guidata(hObject, handles);


% --- Executes on selection change in inc_list.
function inc_list_Callback(hObject, eventdata, handles)
% hObject    handle to inc_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns inc_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from inc_list


% --- Executes during object creation, after setting all properties.
function inc_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inc_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in serial_conn_menu.
function serial_conn_menu_Callback(hObject, eventdata, handles)
% hObject    handle to serial_conn_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns serial_conn_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from serial_conn_menu


% --- Executes during object creation, after setting all properties.
function serial_conn_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to serial_conn_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_dirflip.
function checkbox_dirflip_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_dirflip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dir_flip=get(hObject,'Value');
handles.dir_flip = dir_flip;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of checkbox_dirflip


% --- Executes on button press in pushbutton_setzero.
function pushbutton_setzero_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_setzero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.netmovement,'String','0');
guidata(hObject, handles);


% --- Executes when user attempts to close baseapp.
function baseapp_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to baseapp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    s1_obj = handles.serial_obj;
    fclose(s1_obj);
catch
    %continue to close
end

% Hint: delete(hObject) closes the figure
delete(hObject);
