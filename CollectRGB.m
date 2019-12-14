function RGB = CollectRGB(a,n,bytes)
%% Set up serial connection if it is not established
if n > 1 % serial connection not set up previously by calibration
    delete(instrfindall); clear a; % delete previous objects (arduino object from MoveServo)
    a = serial('COM1'); % register arduino object
    set(a, 'BaudRate', 115200, 'DataBits', 8, 'StopBits',1, 'Terminator', ...
        'CR/LF', 'ByteOrder', 'bigEndian', 'Parity', 'none'); % configure qualities of connection
    fopen(a); % prompt arduino to run stored sketch
    fprintf(a,'*IDN?');
    pause(0.1)
    bytes = get(a, 'BytesAvailable'); % check how many bytes are available in buffer to be used
end
%% Collecting RGB values
timeCollect = 104; % set timespan to collect data over

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
numRows = floor(length(RGBvec)/3);
RGB = zeros(numRows,3);
for k = 3:3:length(RGBvec)
    RGB(row,:) = RGBvec(k-2:k); % store 3 indexes at a time as a row
    row = row + 1; % move to next row
end

%% Delete serial connection to make way for arduino object
clear a; delete(instrfindall)
end