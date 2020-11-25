function varargout = GuI_130214(varargin)
% GUI_130214 MATLAB code for GuI_130214.fig
%      GUI_130214, by itself, creates a new GUI_130214 or raises the existing
%      singleton*.
%
%      H = GUI_130214 returns the handle to a new GUI_130214 or the handle to
%      the existing singleton*.
%
%      GUI_130214('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_130214.M with the given input arguments.
%
%      GUI_130214('Property','Value',...) creates a new GUI_130214 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GuI_130214_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GuI_130214_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GuI_130214

% Last Modified by GUIDE v2.5 30-Sep-2017 12:58:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GuI_130214_OpeningFcn, ...
                   'gui_OutputFcn',  @GuI_130214_OutputFcn, ...
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


% --- Executes just before GuI_130214 is made visible.
function GuI_130214_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GuI_130214 (see VARARGIN)

% Choose default command line output for GuI_130214
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GuI_130214 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GuI_130214_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Browse_TrainI_Imfoldrer.
function Browse_TrainI_Imfoldrer_Callback(hObject, eventdata, handles)
% hObject    handle to Browse_TrainI_Imfoldrer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_name = uigetdir('', 'Select the directory of images');
if ( folder_name ~= 0 )
    handles.folder_name = folder_name;
    guidata(hObject, handles);
else
    return;
end


% --- Executes on button press in Input_qimage.
function Input_qimage_Callback(hObject, eventdata, handles)
% hObject    handle to Input_qimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
[filename, pathname] = uigetfile({'*.*';'*.bmp';'*.jpg';'*.gif'});
q = imread([pathname,filename]);
queryImage = imresize(q, [400 300]);
Features=Feature(queryImage);
qFeatures = [Features]
handles.qFeature = qFeatures;
axes(handles.axes1);
imshow(queryImage);title('Query Image');
clear('q', 'filename', 'pathname', 'queryImage', ...
            'Features', 'qFeatures', 'queryImage');
guidata(hObject,handles);



% --- Executes on button press in Feature_extract_storeDB.
function Feature_extract_storeDB_Callback(hObject, eventdata, handles)
% hObject    handle to Feature_extract_storeDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (~isfield(handles, 'folder_name'))
    errordlg('Please select an image directory first!');
    return;
end
jpgImagesDir = fullfile(handles.folder_name, '*.jpg');
num_of_jpg_images = numel( dir(jpgImagesDir) );
totalImages = num_of_jpg_images;
jpg_files = dir(jpgImagesDir);
if ( ~isempty( jpg_files ))
    jpg_counter = 0;
    for k = 1:totalImages
        if ( (num_of_jpg_images - jpg_counter) > 0)
            imgInfoJPG = imfinfo( fullfile( handles.folder_name, jpg_files(jpg_counter+1).name ) );
            if ( strcmp( lower(imgInfoJPG.Format), 'jpg') == 1 )
                sprintf('%s \n', jpg_files(jpg_counter+1).name)
                I = imread( fullfile( handles.folder_name, jpg_files(jpg_counter+1).name ) );
                [pathstr, name, ext] = fileparts( fullfile( handles.folder_name, jpg_files(jpg_counter+1).name ) );
                I= imresize(I, [400 300]);
                
            end
            jpg_counter = jpg_counter + 1;
        end
         Features=Feature(I);
         Train_dataset(k, :) = [Features];
    end
  
   [filename, pathname] = uiputfile('*.xls', 'Choose a file name'); 
    outname = fullfile(pathname, filename); 
    xlswrite(outname, Train_dataset);
 
    clear('Train_dataset', 'jpg_counter', 'png_counter', 'bmp_counter');
end
% --- Executes on button press in loads_dataset.
function loads_dataset_Callback(hObject, eventdata, handles)
% hObject    handle to loads_dataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
label=zeros(15,1);
[fname, pthname] = uigetfile('*.xls', 'Select the Dataset');
if (fname ~= 0)
    dataset_fullpath = strcat(pthname, fname);
    [pathstr, name, ext] = fileparts(dataset_fullpath);
    if ( strcmp(lower(ext), '.xls') == 1)
        filename = fullfile( pathstr, strcat(name, ext) );
        %handles.imageDataset = load(filename);
         [~,~,handles.imageDataset] = xlsread(filename,'sheet1');
        guidata(hObject, handles);
        helpdlg('Dataset loaded successfuly in excel sheet!');
    else
        errordlg('You have not selected the correct file type');
    end
else
    return;
end


% --- Executes on button press in Show_type.
function Show_type_Callback(hObject, eventdata, handles)
% hObject    handle to Show_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%t = classregtree(handles.imageDataset.Train_dataset(1:end,1:end-1),handles.imageDataset.Train_dataset(1:end,end));
 label=zeros(450,1);
 label(1:90,end)=1;
 label(91:180,end)=2;
 label(181:270,end)=3;
 label(270:360,end)=4;
 label(361:450,end)=5;


%t = fitctree(cell2mat(handles.imageDataset),label);
%ctree=compact(t);
%y=predict(ctree,handles.qFeature);
verbose = true;
classifier = AdaBoost_mult(two_level_decision_tree, verbose); % blank classifier
nTree = 15;

C = classifier.train(cell2mat(handles.imageDataset), label, [], nTree);
y  = C.predict(handles.qFeature);

%view(t,'Mode','Graph');
disp(y);
if  y == 1
    R1 = 'Bus';
    set(handles.type,'string',R1);
    msgbox({'Bus'},...
   'Object Name','help');
 
    
 
elseif y == 2
    R7 = 'Dinosar';
    
    set(handles.type,'string',R7);
    msgbox({'Dinosor'},...
   'Object Name','help');

elseif y == 3
    R7 = 'Elephant';
    
    set(handles.type,'string',R7);
    msgbox({'Elephant'},...
   'Object Name','help');
elseif y == 4
    R7 = 'Flower';
    
    set(handles.type,'string',R7);
    msgbox({'Flower'},...
   'Object Name','help');
    

else
    R7 = 'Hill';
    
    set(handles.type,'string',R7);
    msgbox({'Hill'},...
   'Object Name','help');
   
    
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function Rmean_Callback(hObject, eventdata, handles)
% hObject    handle to Rmean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rmean as text
%        str2double(get(hObject,'String')) returns contents of Rmean as a double


% --- Executes during object creation, after setting all properties.
function Rmean_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rmean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function gmean_Callback(hObject, eventdata, handles)
% hObject    handle to gmean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gmean as text
%        str2double(get(hObject,'String')) returns contents of gmean as a double


% --- Executes during object creation, after setting all properties.
function gmean_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gmean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bmean_Callback(hObject, eventdata, handles)
% hObject    handle to bmean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bmean as text
%        str2double(get(hObject,'String')) returns contents of bmean as a double


% --- Executes during object creation, after setting all properties.
function bmean_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bmean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rmode_Callback(hObject, eventdata, handles)
% hObject    handle to rmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rmode as text
%        str2double(get(hObject,'String')) returns contents of rmode as a double


% --- Executes during object creation, after setting all properties.
function rmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gmode_Callback(hObject, eventdata, handles)
% hObject    handle to gmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gmode as text
%        str2double(get(hObject,'String')) returns contents of gmode as a double


% --- Executes during object creation, after setting all properties.
function gmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bluemode_Callback(hObject, eventdata, handles)
% hObject    handle to bluemode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bluemode as text
%        str2double(get(hObject,'String')) returns contents of bluemode as a double


% --- Executes during object creation, after setting all properties.
function bluemode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bluemode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rIQR_Callback(hObject, eventdata, handles)
% hObject    handle to rIQR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rIQR as text
%        str2double(get(hObject,'String')) returns contents of rIQR as a double


% --- Executes during object creation, after setting all properties.
function rIQR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rIQR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gIQR_Callback(hObject, eventdata, handles)
% hObject    handle to gIQR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gIQR as text
%        str2double(get(hObject,'String')) returns contents of gIQR as a double


% --- Executes during object creation, after setting all properties.
function gIQR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gIQR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function blueIQR_Callback(hObject, eventdata, handles)
% hObject    handle to blueIQR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blueIQR as text
%        str2double(get(hObject,'String')) returns contents of blueIQR as a double


% --- Executes during object creation, after setting all properties.
function blueIQR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blueIQR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function type_Callback(hObject, eventdata, handles)
% hObject    handle to type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of type as text
%        str2double(get(hObject,'String')) returns contents of type as a double


% --- Executes during object creation, after setting all properties.
function type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in extract_qfeatures.
function extract_qfeatures_Callback(hObject, eventdata, handles)
% hObject    handle to extract_qfeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Rmean,'string',handles.qFeature(1,1));
set(handles.gmean,'string',handles.qFeature(1,2));
set(handles.bmean,'string',handles.qFeature(1,3));
set(handles.rmode,'string',handles.qFeature(1,4));
set(handles.gmode,'string',handles.qFeature(1,5));
set(handles.bluemode,'string',handles.qFeature(1,6));
% set(handles.rIQR,'string',handles.qFeature(1,7));
% set(handles.gIQR,'string',handles.qFeature(1,8));
% set(handles.blueIQR,'string',handles.qFeature(1,9));
