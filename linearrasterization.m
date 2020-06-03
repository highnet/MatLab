%
% Copyright 2017 Vienna University of Technology.
% Institute of Computer Graphics and Algorithms.
%

function linerasterization(mesh, framebuffer)
%LINERASTERIZATION iterates over all faces of mesh and draws lines between
%                  their vertices.
%     mesh                  ... mesh object to rasterize
%     framebuffer           ... framebuffer

for i = 1:numel(mesh.faces)
    for j = 1:mesh.faces(i)
        v1 = mesh.getFace(i).getVertex(j);
        v2 = mesh.getFace(i).getVertex(mod(j, mesh.faces(i))+1);
        drawLine(framebuffer, v1, v2);
    end
end
end

function drawLine(framebuffer, v1, v2)
%DRAWLINE draws a line between v1 and v2 into the framebuffer using the DDA
%         algorithm.
%         ATTENTION: Coordinates of the line have to be rounded with the
%         function 'round(...)'.
%     framebuffer           ... framebuffer
%     v1                    ... vertex 1
%     v2                    ... vertex 2

[x1, y1, depth1] = v1.getScreenCoordinates();
[x2, y2, depth2] = v2.getScreenCoordinates();

framebuffer.setPixel(x1, y1, 0, [1, 0, 0])

% TODO 1: Implement this function.
% BONUS:  Solve this task without using loops and without using loop
%         emulating functions (e.g. arrayfun).

% the DDA algorithm interpolates values in interval by computing 
% for each Xi the equations Xi = Xi−1 + 1, Yi = Yi−1 + m, where m is the slope of the line.

deltaX = abs(x2-x1);  % Calculate the absolute difference of the X and Y value from starting to end points
deltaY = abs(y2-y1);  

% Calculate which direction(positive or negative) X and Y point towards
signX = sign(x2-x1); % Calculate the sign in the difference of the difference of the X and Y value from starting to end points
signY = sign(y2-y1);

% DDA starts by calculating the smaller of dy or dx for a unit increment of the other.
if deltaX >= deltaY % If the difference in X is less than the difference in Y
    steps = deltaX; 
else % If the difference in Y is less than the difference in X
    steps = deltaY; 
end
deltaX = deltaX / steps; % Set the unit step increment 
deltaY = deltaY / steps; % Set the unit step increment

x = x1;
y = y1;
i = 0;

xCanvas = round(x); % Sample the float number X coordinate to integer number X coordinate for drawing in the canvas
yCanvas = round(y); % Sample the float number Y coordinate to integer number Y coordinate for drawing in the canvas

while i <= steps
    framebuffer.setPixel(xCanvas, yCanvas, 0, [1, 1, 1]) % Draw pixel on canvas
    x = x + deltaX * signX; % Increment x accordingly: x plus deltaX in the signX direction
    y = y + deltaY * signY; % Increment y accordingly: y plus deltaY in the signY direction
    i = i+1; % Increment iteration
    
    xCanvas = round(x);
    yCanvas = round(y);
end

end
