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

% Last Modified by GUIDE v2.5 23-Aug-2022 00:52:52

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
global map_size;
global Valid;
handles.size_50.Value = 1;
handles.map_style.Value = 1;
map_size = 50;
Valid = zeros(map_size - 1, map_size - 1, 1);
for index = 1: 1: map_size
    Valid(1, index, 1) = 1;
    Valid(index, 1, 1) = 1;
    Valid(map_size, index, 1) = 1;
    Valid(index, map_size, 1) = 1;
end
plot_x = [];
plot_y = [];
for x = 1: 1: map_size
    for y = 1: 1: map_size
        if (Valid(x, y) == 1)
            plot_x = [plot_x, x - 0.5];
            plot_y = [plot_y, y - 0.5];
        end
    end
end
plot(plot_x,plot_y,'whites',...
    'LineWidth',1,...
    'MarkerSize',round(575 / map_size),...
    'MarkerEdgeColor','black',...
    'MarkerFaceColor',[0, 0, 0]);
hold on;

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes path_planning wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = path_planning_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function map_style_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in map_style.
function map_style_Callback(hObject, eventdata, handles)
global map_size;
global Valid;
map_style = get(hObject, 'Value');
switch map_style
    case 1
        if handles.size_30 == 1
            map_size = 30;
        elseif handles.size_50 == 1
            map_size = 50;
        elseif handles.size_100 == 1
            map_size = 100;
        else
            map_size = 50;
        end
        Valid = zeros(map_size - 1, map_size - 1, 1);
        for index = 1: 1: map_size
            Valid(1, index, 1) = 1;
            Valid(index, 1, 1) = 1;
            Valid(map_size, index, 1) = 1;
            Valid(index, map_size, 1) = 1;
        end

    case 2
        load('map/map_30.mat');
        map_size = 30;
        Valid = map_30;
        handles.size_30.Value = 1;
        handles.size_50.Value = 0;
        handles.size_100.Value = 0;
    case 3
        load('map/map_50.mat');
        map_size = 50;
        Valid = map_50;
        handles.size_30.Value = 0;
        handles.size_50.Value = 1;
        handles.size_100.Value = 0;
    case 4
        load('map/map_100.mat');
        map_size = 100;
        Valid = map_100;
        handles.size_30.Value = 0;
        handles.size_50.Value = 0;
        handles.size_100.Value = 1;
end

% --- Executes on button press in start_point.
function start_point_Callback(hObject, eventdata, handles)
global start;
global map_size;
global Valid;
hold off;
plot_x = [];
plot_y = [];
for x = 1: 1: map_size
    for y = 1: 1: map_size
        if (Valid(x, y) == 1)
            plot_x = [plot_x, x - 0.5];
            plot_y = [plot_y, y - 0.5];
        end
    end
end
plot(plot_x,plot_y,'whites',...
    'LineWidth',1,...
    'MarkerSize',round(575 / map_size),...
    'MarkerEdgeColor','black',...
    'MarkerFaceColor',[0, 0, 0]);
hold on;
handles.goal_point.Value = 0;
handles.obstacle_point.Value = 0;
obs = ginput(1);
if (obs(1) < map_size && obs(2) < map_size)
    obs_x = round(obs(1) - 0.5) + 0.5;
    obs_y = round(obs(2) - 0.5) + 0.5;
    start = [obs_x, obs_y];
end
handles.start_point.Value = 0;
disp(start);
plot(start(1), start(2),'whiteo',...
    'LineWidth',1,...
    'MarkerSize',round(360/ map_size),...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1, 0, 0]);




% --- Executes on button press in goal_point.
function goal_point_Callback(hObject, eventdata, handles)
global goal;
global map_size;
global Valid;
hold off;
plot_x = [];
plot_y = [];
for x = 1: 1: map_size
    for y = 1: 1: map_size
        if (Valid(x, y) == 1)
            plot_x = [plot_x, x - 0.5];
            plot_y = [plot_y, y - 0.5];
        end
    end
end
hold on;
handles.obstacle_point.Value = 0;
handles.start_point.Value = 0;
obs = ginput(1);
if (obs(1) < map_size && obs(2) < map_size)
    obs_x = round(obs(1) - 0.5) + 0.5;
    obs_y = round(obs(2) - 0.5) + 0.5;
    goal = [obs_x, obs_y];
end
handles.goal_point.Value = 0;
disp('goal: ');
disp(goal);
plot(goal(1), goal(2),'whiteo',...
    'LineWidth',1,...
    'MarkerSize',round(360/ map_size),...
    'MarkerEdgeColor','green',...
    'MarkerFaceColor',[0, 1, 0]);


% --- Executes on button press in obstacle_point.
function obstacle_point_Callback(hObject, eventdata, handles)
global obstacle;
global Valid;
global map_size;
hold on;
handles.goal_point.Value = 0;
handles.start_point.Value = 0;
disp(obstacle);
obs = [0, 0];
while (obs(1) < map_size && obs(2) < map_size)
    obs = ginput(1);
    if (obs(1) < map_size && obs(2) < map_size)
        obs_x = round(obs(1) - 0.5) + 0.5;
        obs_y = round(obs(2) - 0.5) + 0.5;
        if Valid(obs_x + 0.5, obs_y + 0.5) == 1
            Valid(obs_x + 0.5, obs_y + 0.5) = 0;
            plot(obs_x, obs_y,'whites',...
                'LineWidth',1,...
                'MarkerSize',round(575 / map_size),...
                'MarkerEdgeColor',[1, 1, 1],...
                'MarkerFaceColor',[1, 1, 1]);
            continue
        end
        obstacle = [obstacle; [obs_x, obs_y]];
        Valid(obs_x + 0.5, obs_y + 0.5) = 1;
        plot(obs_x, obs_y,'whites',...
            'LineWidth',1,...
            'MarkerSize',round(575 / map_size),...
            'MarkerEdgeColor',[0, 0, 0],...
            'MarkerFaceColor',[0, 0, 0]);
    end
end
handles.obstacle_point.Value = 0;

% --- Executes on button press in make_map.
function make_map_Callback(hObject, eventdata, handles)
hold off;
global map_size;
global Valid;
plot_x = [];
plot_y = [];
for x = 1: 1: map_size
    for y = 1: 1: map_size
        if (Valid(x, y) == 1)
            plot_x = [plot_x, x - 0.5];
            plot_y = [plot_y, y - 0.5];
        end
    end
end
plot(plot_x,plot_y,'whites',...
    'LineWidth',1,...
    'MarkerSize',round(575 / map_size),...
    'MarkerEdgeColor','black',...
    'MarkerFaceColor',[0, 0, 0]);
hold on;

% --- Executes on mouse press over axes background.
function map_ButtonDownFcn(hObject, eventdata, handles)

% --- Executes on button press in size_30.
function size_30_Callback(hObject, eventdata, handles)
global map_size;
map_size = 30;
global Valid;
Valid = zeros(map_size - 1, map_size - 1, 1);
for index = 1: 1: map_size
    Valid(1, index, 1) = 1;
    Valid(index, 1, 1) = 1;
    Valid(map_size, index, 1) = 1;
    Valid(index, map_size, 1) = 1;
end
handles.map_style.Value = 1;
handles.size_50.Value = 0;
handles.size_100.Value = 0;

% --- Executes on button press in size_50.
function size_50_Callback(hObject, eventdata, handles)
global map_size;
map_size = 50;
global Valid;
Valid = zeros(map_size - 1, map_size - 1, 1);
for index = 1: 1: map_size
    Valid(1, index, 1) = 1;
    Valid(index, 1, 1) = 1;
    Valid(map_size, index, 1) = 1;
    Valid(index, map_size, 1) = 1;
end
handles.map_style.Value = 1;
handles.size_30.Value = 0;
handles.size_100.Value = 0;


% --- Executes on button press in size_100.
function size_100_Callback(hObject, eventdata, handles)
global map_size;
map_size = 100;
global Valid;
Valid = zeros(map_size - 1, map_size - 1, 1);
for index = 1: 1: map_size
    Valid(1, index, 1) = 1;
    Valid(index, 1, 1) = 1;
    Valid(map_size, index, 1) = 1;
    Valid(index, map_size, 1) = 1;
end
handles.map_style.Value = 1;
handles.size_30.Value = 0;
handles.size_50.Value = 0;


% --- Executes on button press in clear_path.
function clear_path_Callback(hObject, eventdata, handles)
hold off;
global map_size;
global Valid;
global start;
global goal;
plot_x = [];
plot_y = [];
for x = 1: 1: map_size
    for y = 1: 1: map_size
        if (Valid(x, y) == 1)
            plot_x = [plot_x, x - 0.5];
            plot_y = [plot_y, y - 0.5];
        end
    end
end
plot(plot_x,plot_y,'whites',...
    'LineWidth',1,...
    'MarkerSize',round(575 / map_size),...
    'MarkerEdgeColor','black',...
    'MarkerFaceColor',[0, 0, 0]);
hold on;
plot(start(1), start(2),'whiteo',...
    'LineWidth',1,...
    'MarkerSize',round(360/ map_size),...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1, 0, 0]);

plot(goal(1), goal(2),'whiteo',...
    'LineWidth',1,...
    'MarkerSize',round(360/ map_size),...
    'MarkerEdgeColor','green',...
    'MarkerFaceColor',[0, 1, 0]);
%{
if handles.size_30.Value == 1
    map_30 = Valid;
    save('map/map_30.mat', 'map_30');
end
if handles.size_50.Value == 1
    map_50 = Valid;
    save('map/map_50.mat', 'map_50');
end
if handles.size_100.Value == 1
    map_100 = Valid;
    save('map/map_100.mat', 'map_100');
end
%}
    

% --- Executes on button press in A_star.
function A_star_Callback(hObject, eventdata, handles)
global Valid;
global start;
global goal;
global map_size;
A = A_star;
A.A_star_path(Valid, start, goal, map_size);

% --- Executes on button press in RRT.
function RRT_Callback(hObject, eventdata, handles)
global Valid;
global start;
global goal;
global map_size;
R = RRT;
R.RRT_path(Valid, start, goal, map_size);

% --- Executes on button press in RRT_connect.
function RRT_connect_Callback(hObject, eventdata, handles)
global Valid;
global start;
global goal;
global map_size;
R = RRT_connect;
R.RRT_connect_path(Valid, start, goal, map_size);
