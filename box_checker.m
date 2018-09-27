function varargout = box_checker(varargin)
% BOX_CHECKER MATLAB code for box_checker.fig
%      BOX_CHECKER, by itself, creates a new BOX_CHECKER or raises the existing
%      singleton*.
%
%      H = BOX_CHECKER returns the handle to a new BOX_CHECKER or the handle to
%      the existing singleton*.
%
%      BOX_CHECKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BOX_CHECKER.M with the given input arguments.
%
%      BOX_CHECKER('Property','Value',...) creates a new BOX_CHECKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before box_checker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to box_checker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help box_checker

% Last Modified by GUIDE v2.5 27-Sep-2018 15:27:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @box_checker_OpeningFcn, ...
                   'gui_OutputFcn',  @box_checker_OutputFcn, ...
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


% --- Executes just before box_checker is made visible.
function box_checker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to box_checker (see VARARGIN)

% global present_frame;
% global present_rect;
% global present_img;
% global total_frame;

% Choose default command line output for box_checker
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes box_checker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = box_checker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function File_open_Callback(hObject, eventdata, handles)
% hObject    handle to File_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global present_frame;
global present_rect;
global present_img;
global total_frame;
global full_frame;
global filename;
global pathname;
global img_names;
global folder_name;
global step_size;
step_size = 1;
set(handles.edit_size, 'String', step_size);

flag_err = 0;
[filename pathname] = uigetfile({'*.png;*.jpg;*.bmp','image files (*.png,*.jpg,*.bmp)'; '*.*',  'All Files (*.*)'}, 'Pick a file');
if pathname ~= 0
    if strcmp(filename(end-2:end), 'png') || strcmp(filename(end-2:end), 'jpg') || strcmp(filename(end-2:end), 'bmp')

        % Find frame index
        img_names = dir([pathname, '*', filename(end-3:end)]);
        idx_tmp = findstr(pathname, '\');
        folder_name = pathname(idx_tmp(end-1)+1:idx_tmp(end)-1);
        total_frame = numel(img_names);
        i = 1; 
        while 1
           if strcmp(img_names(i).name, filename)
               present_frame = i;
               break;
           else
               i = i + 1;
           end
        end
        
        flag_bbox = get_image(present_frame);
        [handles, hObject] = get_rect(handles, hObject, flag_bbox);
    else
        flag_err = 1;
    end
else
    flag_err = 1;
end

if flag_err
    fprintf('[Error : file type]\n');
end


function edit_frame_idx_Callback(hObject, eventdata, handles)
% hObject    handle to edit_frame_idx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: get(hObject,'String') returns contents of edit_frame_idx as text
%        str2double(get(hObject,'String')) returns contents of edit_frame_idx as a double


% --- Executes during object creation, after setting all properties.
function edit_frame_idx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_frame_idx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_bbox_Callback(hObject, eventdata, handles)
% hObject    handle to edit_bbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_bbox as text
%        str2double(get(hObject,'String')) returns contents of edit_bbox as a double


% --- Executes during object creation, after setting all properties.
function edit_bbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_bbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_home.
function push_home_Callback(hObject, eventdata, handles)
% hObject    handle to push_home (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global present_frame;
present_frame = 1;
flag_bbox = get_image(present_frame);
[handles, hObject] = get_rect(handles, hObject, flag_bbox);
fprintf('[Home]\n');

% --- Executes on button press in push_nan.
function push_nan_Callback(hObject, eventdata, handles)
% hObject    handle to push_nan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles, hObject] = get_rect(handles, hObject, 'nan');
fprintf('[NaN]\n');


% --- Executes on button press in push_next.
function push_next_Callback(hObject, eventdata, handles)
% hObject    handle to push_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global present_frame;
global total_frame;
global full_frame;
if present_frame < total_frame && present_frame <= full_frame
    present_frame = present_frame + 1;
    flag_bbox = get_image(present_frame);
    [handles, hObject] = get_rect(handles, hObject, flag_bbox);
end
fprintf('[Next]\n');


% --- Executes on button press in push_rect.
function push_rect_Callback(hObject, eventdata, handles)
% hObject    handle to push_rect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles, hObject] = get_rect(handles, hObject, 'no_box');
fprintf('[Rect]\n');


% --- Executes on button press in push_end.
function push_end_Callback(hObject, eventdata, handles)
% hObject    handle to push_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global present_frame;
global full_frame;
global total_frame;
if full_frame < total_frame
    present_frame = full_frame + 1;
    flag_bbox = get_image(present_frame);
    [handles, hObject] = get_rect(handles, hObject, flag_bbox);
end
fprintf('[End]\n');

% --- Executes on button press in push_prev.
function push_prev_Callback(hObject, eventdata, handles)
% hObject    handle to push_prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global present_frame;
if present_frame ~= 1
    present_frame = present_frame - 1;
    flag_bbox = get_image(present_frame);
    [handles, hObject] = get_rect(handles, hObject, flag_bbox);
end
fprintf('[Prev]\n');


% --- Executes on button press in push_save.
function push_save_Callback(hObject, eventdata, handles)
% hObject    handle to push_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global present_frame;
global present_rect;
global filename;
global pathname;
global img_names;
global present_img;
global full_frame;
global total_frame;

% Save file
if present_frame > full_frame % Append
    fileID = fopen([pathname, 'groundtruth.txt'],'a+');
    fprintf(fileID, [num2str(present_rect(1)), ',', num2str(present_rect(2)), ',', num2str(present_rect(3)), ',', num2str(present_rect(4)), '\n']);
    full_frame = full_frame + 1;
    fclose(fileID);
    fprintf('[Save : append]\n');
else % Modify
    if exist([pathname, 'groundtruth.txt'], 'file') == 2
        GT = importdata([pathname, 'groundtruth.txt']);
    end
    fileID = fopen([pathname, 'groundtruth.txt'],'w+');
    GT(present_frame, :) = round(present_rect(:));
    for i = 1 : size(GT, 1)
        fprintf(fileID, [num2str(GT(i, 1)), ',', num2str(GT(i, 2)), ',', num2str(GT(i, 3)), ',', num2str(GT(i, 4)), '\n']);
    end
    fclose(fileID);
    fprintf(['[Save : modify]\n']);
end

if total_frame ~= present_frame
    present_frame = present_frame + 1;
    filename = img_names(present_frame).name;
    present_img = imread(strcat(pathname, filename));
    
    if present_frame > full_frame % Append
        flag_bbox = 'same_box';
    else % Modify
        flag_bbox = 'yes_box';
        present_rect = round(GT(present_frame, :)); % x, y, w, 
    end

    [handles, hObject] = get_rect(handles, hObject, flag_bbox);
else
    fprintf('---> Complete\n');
end



% --- Executes on button press in push_w.
function push_w_Callback(hObject, eventdata, handles)
% hObject    handle to push_w (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles, hObject] = get_rect(handles, hObject, 'w');


% --- Executes on button press in push_s.
function push_s_Callback(hObject, eventdata, handles)
% hObject    handle to push_s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles, hObject] = get_rect(handles, hObject, 's');


% --- Executes on button press in push_a.
function push_a_Callback(hObject, eventdata, handles)
% hObject    handle to push_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles, hObject] = get_rect(handles, hObject, 'a');


% --- Executes on button press in push_d.
function push_d_Callback(hObject, eventdata, handles)
% hObject    handle to push_d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles, hObject] = get_rect(handles, hObject, 'd');



% --- Executes on button press in push_q.
function push_q_Callback(hObject, eventdata, handles)
% hObject    handle to push_q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles, hObject] = get_rect(handles, hObject, 'q');


% --- Executes on button press in push_e.
function push_e_Callback(hObject, eventdata, handles)
% hObject    handle to push_e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles, hObject] = get_rect(handles, hObject, 'e');


% --- Executes on button press in push_x.
function push_x_Callback(hObject, eventdata, handles)
% hObject    handle to push_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global step_size;
step_size = step_size + 1;
set(handles.edit_size, 'String', step_size);


% --- Executes on button press in push_z.
function push_z_Callback(hObject, eventdata, handles)
% hObject    handle to push_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global step_size;
if step_size > 1
    step_size = step_size - 1;
    set(handles.edit_size, 'String', step_size);
end




% --- Executes on button press in push_up.
function push_up_Callback(hObject, eventdata, handles)
% hObject    handle to push_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles, hObject] = get_rect(handles, hObject, 'up');


% --- Executes on button press in push_down.
function push_down_Callback(hObject, eventdata, handles)
% hObject    handle to push_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles, hObject] = get_rect(handles, hObject, 'down');


% --- Executes on button press in push_left.
function push_left_Callback(hObject, eventdata, handles)
% hObject    handle to push_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles, hObject] = get_rect(handles, hObject, 'left');


% --- Executes on button press in push_right.
function push_right_Callback(hObject, eventdata, handles)
% hObject    handle to push_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles, hObject] = get_rect(handles, hObject, 'right');


% --- Executes on button press in radio_size.
% function radio_size_Callback(hObject, eventdata, handles)
% % hObject    handle to radio_size (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% global step_size;
% % step_size = str2double(get(hObject,'String'));
% % Hint: get(hObject,'Value') returns toggle state of radio_sizeq
% if hObject.Value
%     if strcmp(handles.edit_size.String, 'Size') || isnan(str2double(handles.edit_size.String)) || str2double(handles.edit_size.String) > 500
%         handles.edit_size.String = '1';
%     end
%     step_size = str2double(handles.edit_size.String);
% else
%     step_size = 1;
% end



function edit_size_Callback(hObject, eventdata, handles)
% hObject    handle to edit_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit_size as text
%        str2double(get(hObject,'String')) returns contents of edit_size as a double


% --- Executes during object creation, after setting all properties.
function edit_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function [handles, hObject] = get_rect(handles, hObject, flag_bbox)

global present_img;
global present_frame;
global present_rect;
global folder_name;
global total_frame;
global step_size;
imshow(present_img, 'Parent', handles.image_input);
name_frame_idx = [folder_name, ' ( ', num2str(present_frame), ' / ', num2str(total_frame), ' )'];
set(handles.edit_frame_idx, 'String', name_frame_idx);

% Switch flags
switch flag_bbox
    case 'same_box' % box does't exist
    case 'no_box' % box does't exist
        present_rect = round(getrect)'; %c(x), r(y), w, h
    case 'yes_box' % box exists
    case 'w'
        present_rect(2) = present_rect(2) - step_size;
        present_rect(4) = present_rect(4) + 2 * step_size;
    case 's'
        present_rect(2) = present_rect(2) + step_size;
        present_rect(4) = present_rect(4) - 2 * step_size;
    case 'a'
        present_rect(1) = present_rect(1) + step_size;
        present_rect(3) = present_rect(3) - 2 * step_size;
    case 'd'
        present_rect(1) = present_rect(1) - step_size;
        present_rect(3) = present_rect(3) + 2 * step_size;
    case 'q'
        present_rect(2) = present_rect(2) + step_size;
        present_rect(4) = present_rect(4) - 2 * step_size;
        present_rect(1) = present_rect(1) + step_size;
        present_rect(3) = present_rect(3) - 2 * step_size;
    case 'e'
        present_rect(2) = present_rect(2) - step_size;
        present_rect(4) = present_rect(4) + 2 * step_size;
        present_rect(1) = present_rect(1) - step_size;
        present_rect(3) = present_rect(3) + 2 * step_size;
    case 'up'
        present_rect(2) = present_rect(2) - step_size;
    case 'down'
        present_rect(2) = present_rect(2) + step_size;
    case 'right'
        present_rect(1) = present_rect(1) + step_size;
    case 'left'
        present_rect(1) = present_rect(1) - step_size;
    case 'nan'
        present_rect = ones(1, 4);
end

% Boundary condition (bbox)
if present_rect(1) < 1, present_rect(1) = 1; end
if present_rect(2) < 1, present_rect(2) = 1; end
if present_rect(1) + present_rect(3) > size(present_img, 2), present_rect(3) = size(present_img, 2) - present_rect(1); end
if present_rect(2) + present_rect(4) > size(present_img, 1), present_rect(4) = size(present_img, 1) - present_rect(2); end
if present_rect(3) < 1, present_rect(3) = 1; end
if present_rect(4) < 1, present_rect(4) = 1; end

% Show image
if ~prod(present_rect == 1)
    hold on;
    if strcmp(flag_bbox, 'no_box') || strcmp(flag_bbox, 'same_box')
        rectangle('Position',present_rect,'LineWidth',2,'EdgeColor','r');
    else
        rectangle('Position',present_rect,'LineWidth',2,'EdgeColor','g');
    end
    fprintf(['[Flag bbox : ', flag_bbox, ']\n']);
    crop_img = present_img(present_rect(2):present_rect(2)+present_rect(4), present_rect(1):present_rect(1)+present_rect(3), :);
    imshow(crop_img, 'Parent', handles.image_input_detail);
end

% gui handles
name_bbox = [num2str(present_rect(1)), ',', num2str(present_rect(2)), ',', num2str(present_rect(3)), ',', num2str(present_rect(4))];
set(handles.edit_bbox, 'String', name_bbox);
guidata(hObject, handles);


function flag_bbox = get_image(present_frame)

global filename;
global pathname;
global full_frame;
global present_rect;
global present_img;

% Find GT file and its contents (GT)
GT = zeros(0, 4);
if exist([pathname, 'groundtruth.txt'], 'file') == 2
    GT = importdata([pathname, 'groundtruth.txt']);
end

fileID = fopen([pathname, 'groundtruth.txt'],'a+');
if size(GT, 1) < present_frame - 1 % fill in "NAN"
    for j = 1 : present_frame - size(GT, 1) - 1
        fprintf(fileID,[num2str(1), ',', num2str(1), ',', num2str(1), ',', num2str(1), '\n']);
    end
    GT = cat(1, GT, ones(present_frame - size(GT, 1) - 1, 4));
    flag_bbox = 'same_box';
    full_frame = present_frame - 1;
elseif size(GT, 1) == present_frame - 1
    flag_bbox = 'same_box';
    full_frame = present_frame - 1;
else % GT exists
    full_frame = size(GT, 1);
    present_rect = round(GT(present_frame, 1:4)); % x, y, w, 
    if prod(present_rect == 1)
        flag_bbox = 'same_box';
    else
        flag_bbox = 'yes_box';
    end
end
fclose(fileID);

present_img = imread(strcat(pathname, filename));
        
        
        

    
    



% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
% disp(eventdata.Key)
switch eventdata.Key
    case 'f', File_open_Callback(hObject, eventdata, handles);
    case 'w', push_w_Callback(hObject, eventdata, handles);
    case 's', push_s_Callback(hObject, eventdata, handles);
    case 'a', push_a_Callback(hObject, eventdata, handles);
    case 'd', push_d_Callback(hObject, eventdata, handles);
    case 'q', push_q_Callback(hObject, eventdata, handles);
    case 'e', push_e_Callback(hObject, eventdata, handles);
    case 'z', push_z_Callback(hObject, eventdata, handles);
    case 'x', push_x_Callback(hObject, eventdata, handles);
    case 'insert', push_rect_Callback(hObject, eventdata, handles);
    case 'delete', push_nan_Callback(hObject, eventdata, handles);
    case 'home', push_home_Callback(hObject, eventdata, handles);
    case 'end', push_end_Callback(hObject, eventdata, handles);
    case 'pageup', push_prev_Callback(hObject, eventdata, handles);
    case 'pagedown', push_next_Callback(hObject, eventdata, handles);
    case 'uparrow', push_up_Callback(hObject, eventdata, handles);
    case 'downarrow', push_down_Callback(hObject, eventdata, handles);
    case 'leftarrow', push_left_Callback(hObject, eventdata, handles);
    case 'rightarrow', push_right_Callback(hObject, eventdata, handles);
    case 'space', push_save_Callback(hObject, eventdata, handles);
end
