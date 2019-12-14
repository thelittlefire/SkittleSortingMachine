%% Color Sorter Project - Color Clustering | Isadora Shamah, Nate Goff, Sid Hillwig
function [colorSTD,bytes,a] = CalibrateColor()
%{
input: User (string) input of color to calibrate once skittle is placed
above color sensor
output: () containing confident RGB ranges for colors (colorSTD)
additional files: None
%}
%% Housekeeping
clear all; clc; delete(instrfindall); % clear workspace fully, including previous instruments
%% Connect arduino
a = serial('COM1'); % register arduino object
set(a, 'BaudRate', 115200, 'DataBits', 8, 'StopBits',1, 'Terminator', ...
    'CR/LF', 'ByteOrder', 'bigEndian', 'Parity', 'none'); % configure qualities of connection
fopen(a); % prompt arduino to run stored sketch
pause(1)
fprintf(a,'*IDN?');
pause(1)
bytes = get(a, 'BytesAvailable'); % check how many bytes are available in buffer to be used
%% Calibrate
flag = 0; % initialize as not satisfied with calibration
RED = []; ORA = []; YEL = []; GRE = []; PUR = []; % initialize color matrices
timeCollect = 104; % set timespan to collect data over
numRows = floor((timeCollect-4)/3); % calculate number of experiments
STD = zeros(numRows,3,5); % Set up 3D array of calibrated colors
while flag == 0 % allow for calibration to be adjusted while operator not satisfied
    while isempty(RED) || isempty(ORA) || isempty(YEL) || isempty(GRE) || isempty(PUR) % run calibration while any color vector is empty
        % Prompt for manual color calibration
        response = input('Input color to calibrate:\nRed (R)\nOrange (O)\nYellow (Y)\nGreen (G)\nPurple (P)\n\nInput: \n','s');
        if isempty(response)
            fprintf('Please input a color to calibrate\n')
            clear response
       elseif ~strcmpi(response,'R') && ~strcmpi(response,'O') && ~strcmpi(response,'Y') && ~strcmpi(response,'G') && ~strcmpi(response,'P')
           fprintf('Invalid input. Please try again.\n')
           clear response
           return
        end
        %% Collecting RGB values
        if (bytes >= 1) % make sure there is space in the buffer to store data
            RGBvec = zeros(timeCollect-1,1); % allocate RGBvec, noting the first output of the sketch is not stored
            for i = 1:timeCollect
                %warning('off','MATLAB:serial:fscanf:unsuccessfulRead');
                colorscan = fscanf(a);
                if i >= 2 % skip storing one-time initialization output (debugging tool)
                    RGBvec(i-1) = str2double(colorscan); % record RGBvec
                end
                %warning('on','MATLAB:serial:fscanf:unsuccessfulRead');
                pause(0.1);
            end
            RGBvec = RGBvec(4:end); % trim off initializing RGB measurements
        end

        %% Turning RGBvec to matrix for easier use
        % 1st COL: (R) 2nd COL: (G) 3rd COL: (B)
        row = 1;
        RGB = zeros(numRows,3); % allocate RGB matrix
        for k = 3:3:length(RGBvec)
            RGB(row,:) = RGBvec(k-2:k); % store 3 indexes at a time as a row
            row = row + 1; % move to next row
        end
        %% Store RGB calibration data descriptively according to manual input of color being calibrated
        if strcmpi(response,'R')
            STD(:,:,1) = RGB;
            RED = RGB;
        elseif strcmpi(response,'O')
            STD(:,:,2) = RGB;
            ORA = RGB;
        elseif strcmpi(response,'Y')
            STD(:,:,3) = RGB;
            YEL = RGB;
        elseif strcmpi(response,'G')
            STD(:,:,4) = RGB;
            GRE = RGB;
        elseif strcmpi(response,'P')
            STD(:,:,5) = RGB;
            PUR = RGB;
        end

        % If all colors are calibrated, continue with calculations
        if isempty(RED) || isempty(ORA) || isempty(YEL) || isempty(GRE) || isempty(PUR) % check if empty, returns 1 if empty
            fprintf('Please continue calibration.\n') % if any color matrix empty, prompt to continue
            clear response
        end
    end
    % Allow for poor calibration to be remedied
    satisfaction = input('Are you satisfied with the performed calibration? Yes (Y) No (N)\n\nInput: \n','s');
    if isempty(satisfaction)
        fprintf('Please indicate your satisfaction with the calibration performed to continue.\n')
    elseif strcmpi(satisfaction,'Y')
        flag = 1; % Operator is satisfied
    elseif ~strcmpi(satisfaction,'Y') && ~strcmpi(satisfaction,'N')
        fprintf('Invalid input. Please try again.\n')
    else
        redo = input('Which color would you like to recalibrate?\nRed (R)\nOrange (O)\nYellow (Y)\nGreen (G)\nPurple (P)\n\nInput: \n','s');
        if strcmpi(redo,'R')
            RED = [];
        elseif strcmpi(redo,'O')
            ORA = [];
        elseif strcmpi(redo,'Y')
            YEL = [];
        elseif strcmpi(redo,'G')
            GRE = [];
        elseif strcmpi(redo,'P')
            PUR = [];
        else
            fprintf('Invalid input. Please try again.\n')
        end
    end
end

%% Characteristic RGB determination for each color
colorSTD = zeros(5,3);
for k = 1:5 % iterate through each color
    colorSTD(k,:) = mode(STD(:,:,k));
end
end