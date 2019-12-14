function count = MoveServo(RGB,s,count,colorSTD)
%{
input: Matrix of RGB values for a sample (RGB), servo object (s). Input of
'0','1', or '2' for RGB will move to preset position, matrix of standardized color ranges (colorSTD)
output: Vector of color counts (count)
additional files: None
%}
if length(RGB) == 1
    if RGB == 0 % Deposit position
        writePosition(s,1);
    elseif RGB == 1 % Sensing position
        writePosition(s,0.7);
    elseif RGB == 2 % Chute position
        writePosition(s,0.4);
    else
        fprintf('Location not recognized. Please try again. \n')
    end
    return
end

angleMin = 0.1; % minimum angle of chute determined manually
angleMax = 0.9; % maximum angle of chute determined manually
gap = (angleMax - angleMin)/5; % angle gap
angle = angleMin:gap:angleMax;
tol = 2; % set tolerance for color convergence


% color convergence criteria: two measurements (R,G,B) must be within
% tolerance of the characteristic RGB as calibrated before the experiment
if sum(RGB > (colorSTD(1,:) - tol) & RGB < (colorSTD(1,:) + tol)) >= 2
   color = 1; % Red
elseif sum(RGB > (colorSTD(2,:) - tol) & RGB < (colorSTD(2,:) + tol)) >= 2
   color = 2; % Orange
elseif sum(RGB > (colorSTD(3,:) - tol) & RGB < (colorSTD(3,:) + tol)) >= 2
   color = 3; % Yellow
elseif sum(RGB > (colorSTD(4,:) - tol) & RGB < (colorSTD(4,:) + tol)) >= 2
   color = 4; % Green
elseif sum(RGB > (colorSTD(5,:) - tol) & RGB < (colorSTD(5,:) + tol)) >= 2
   color = 5; % Purple
else
   color = 6; % Unknown -- falls outside of calibrated ranges with tolerance
end


writePosition(s, angle(color)) % move servo to color's angle
count(color) = count(color) + 1; % update count vector for the color's position
end

