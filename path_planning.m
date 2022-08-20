function varargout = path_planning(varargin)
% PATH_PLANNING MATLAB code for path_planning.fig
%      PATH_PLANNING, by itself, creates a new PATH_PLANNING or raises the existing
%      singleton*.
%
%      H = PATH_PLANNING returns the handle to a new PATH_PLANNING or the handle to
%      the existing singleton*.
%
%      PATH_PLANNING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PATH_PLANNING.M with the given input arguments.
%
%      PATH_PLANNING('Property','Value',...) creates a new PATH_PLANNING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before path_planning_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to path_planning_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help path_planning

% Last Modified by GUIDE v2.5 21-Aug-2022 03:11:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @path_planning_OpeningFcn, ...
                   'gui_OutputFcn',  @path_planning_OutputFcn, ...
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

% --- Executes just before path_planning is made visible.
function path_planning_OpeningFcn(hObject, eventdata, handles, varargin)
clc;
global edge_x;
global edge_y;
global Valid;
Valid = zeros(29, 29, 1);

for index = 1: 1: 30
    Valid(1, index, 1) = 1;
    Valid(index, 1, 1) = 1;
    Valid(30, index, 1) = 1;
    Valid(index, 30, 1) = 1;
end

for x = 1: 1: 30
    for y = 1: 1: 30
        if (Valid(x, y) == 1)
            edge_x = [edge_x, x - 0.5];
            edge_y = [edge_y, y - 0.5];
        end
    end
end

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes path_planning wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = path_planning_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_point.
function start_point_Callback(hObject, eventdata, handles)
global start;
hold on;
plot(start(1), start(2),'whites',...
    'LineWidth',1,...
    'MarkerSize',15,...
    'MarkerEdgeColor','white',...
    'MarkerFaceColor',[1, 1, 1]);
handles.goal_point.Value = 0;
handles.obstacle_point.Value = 0;
obs = ginput(1);
if (obs(1) < 30 && obs(2) < 30)
    obs_x = round(obs(1) - 0.5) + 0.5;
    obs_y = round(obs(2) - 0.5) + 0.5;
    start = [obs_x, obs_y];
end
handles.start_point.Value = 0;
disp(start);
plot(start(1), start(2),'whites',...
    'LineWidth',1,...
    'MarkerSize',15,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1, 0, 0]);




% --- Executes on button press in goal_point.
function goal_point_Callback(hObject, eventdata, handles)
global goal;
hold on;
plot(goal(1), goal(2),'whites',...
    'LineWidth',1,...
    'MarkerSize',15,...
    'MarkerEdgeColor','white',...
    'MarkerFaceColor',[1, 1, 1]);
handles.obstacle_point.Value = 0;
handles.start_point.Value = 0;
obs = ginput(1);
if (obs(1) < 30 && obs(2) < 30)
    obs_x = round(obs(1) - 0.5) + 0.5;
    obs_y = round(obs(2) - 0.5) + 0.5;
    goal = [obs_x, obs_y];
end
handles.goal_point.Value = 0;
disp('goal: ');
disp(goal);
plot(goal(1), goal(2),'whites',...
    'LineWidth',1,...
    'MarkerSize',15,...
    'MarkerEdgeColor','green',...
    'MarkerFaceColor',[0, 1, 0]);


% --- Executes on button press in obstacle_point.
function obstacle_point_Callback(hObject, eventdata, handles)
global obstacle;
global Valid;
hold on;
handles.goal_point.Value = 0;
handles.start_point.Value = 0;
disp(obstacle);
obs = [0, 0];
while (obs(1) < 30 && obs(2) < 30)
    obs = ginput(1);
    if (obs(1) < 30 && obs(2) < 30)
        obs_x = round(obs(1) - 0.5) + 0.5;
        obs_y = round(obs(2) - 0.5) + 0.5;
        obstacle = [obstacle; [obs_x, obs_y]];
        Valid(obs_x + 0.5, obs_y + 0.5) = 1;
    end
    plot(obstacle(:, 1), obstacle(:, 2),'whites',...
        'LineWidth',1,...
        'MarkerSize',20,...
        'MarkerEdgeColor',[0, 0, 0],...
        'MarkerFaceColor',[0, 0, 0]);
end
handles.obstacle_point.Value = 0;

% --- Executes on button press in make_map.
function make_map_Callback(hObject, eventdata, handles)
clc;
global edge_x;
global edge_y;
global obstacle;
obstacle = [];
hold off;
plot(edge_x,edge_y,'whites',...
    'LineWidth',1,...
    'MarkerSize',19,...
    'MarkerEdgeColor','black',...
    'MarkerFaceColor',[0, 0, 0]);

% --- Executes on mouse press over axes background.
function map_ButtonDownFcn(hObject, eventdata, handles)

% --- Executes on button press in Dijkstra.
function Dijkstra_Callback(hObject, eventdata, handles)
global Valid;
global start;
global goal;
D = Dijkstra;
D.Dijkstra_path(Valid, start, goal);
