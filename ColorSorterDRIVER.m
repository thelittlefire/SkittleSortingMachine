%% Color Sorter Project | Isadora Shamah, Nate Goff, Sid Hillwig
%{
input: None
output: metaCount, a matrix of data across trials
additional files: CalibrateColor.m, ColorSorter.m, MoveServo.m, CollectRGB.m
%}
%% Housekeeping
clear all; clc; delete(instrfindall); % clear workspace fully, including previous instruments
%% Connect arduino and servo motors
% a = arduino(); % identify arduino for servos
% s1 = servo(a,'D3'); % identify servo motor controlling mobile platform
% s2 = servo(a,'D6'); % identify servo motor controlling chute

% arduino = serial('COM1'); % register serial connection to arduino object for color sensor
% set(arduino, 'BaudRate', 115200, 'DataBits', 8, 'StopBits',1, 'Terminator', ...
%     'CR/LF', 'ByteOrder', 'bigEndian', 'Parity', 'none'); % configure qualities of connection
% fopen(arduino); % prompt arduino to run stored sketch
% fprintf(arduino,'*IDN?');
% pause(2)
% bytes = get(arduino, 'BytesAvailable'); % check how many bytes are available in buffer to be used
%% Pre-Experiment Setup
%{
With the mobile platform at the color sensing position, manually place a
Skittle in the circular slot. Add Skittles to the funnel.
%}
%% Color Calibration
[colorSTD,bytes] = CalibrateColor(); % Calibration of skittle colors before data collection
%% Color Sorting
nTrials = 10; % number of trials to perform
nPop = 50; % population of skittles to sort
metaCount = ColorSorter(a,nTrials,nPop,colorSTD,bytes); % perform skittle sorting experiments (trials)


