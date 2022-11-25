function varargout = Msgbox(varargin)
% MSGBOX MATLAB code for Msgbox.fig
%      MSGBOX, by itself, creates a new MSGBOX or raises the existing
%      singleton*.
%
%      H = MSGBOX returns the handle to a new MSGBOX or the handle to
%      the existing singleton*.
%
%      MSGBOX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MSGBOX.M with the given input arguments.
%
%      MSGBOX('Property','Value',...) creates a new MSGBOX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Msgbox_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Msgbox_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Msgbox

% Last Modified by GUIDE v2.5 02-Dec-2021 12:58:12

% Begin initialization code - DO NOT EDIT
warning off;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Msgbox_OpeningFcn, ...
                   'gui_OutputFcn',  @Msgbox_OutputFcn, ...
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


% --- Executes just before Msgbox is made visible.
function Msgbox_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Msgbox (see VARARGIN)

msgContent = 'This is a message. Put your content here.';
msgTtile = 'Info';
try
    msgContent = varargin{1};
    msgTtile = varargin{2};
    msgContentPosition = varargin{3};
    set(handles.msgContent, 'HorizontalAlignment', msgContentPosition);
end
set(handles.msgContent, 'string', msgContent);
set(handles.msgTitle, 'string', msgTtile);
set(handles.MsgboxFig, 'name', 'Info');

% Choose default command line output for Msgbox
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Msgbox wait for user response (see UIRESUME)
% uiwait(handles.MsgboxFig);


% --- Outputs from this function are returned to the command line.
function varargout = Msgbox_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close MsgboxFig.
function MsgboxFig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to MsgboxFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in buttonOK.
function buttonOK_Callback(hObject, eventdata, handles)
% hObject    handle to buttonOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.MsgboxFig);


% --- Executes on key press with focus on MsgboxFig or any of its controls.
function MsgboxFig_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to MsgboxFig (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(eventdata.Key)
    buttonOK_Callback(hObject, eventdata, handles);
end