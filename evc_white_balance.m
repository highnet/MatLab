%
% Copyright 2017 Vienna University of Technology.
% Institute of Computer Graphics and Algorithms.
%

function [result] = evc_white_balance(input, white)
%evc_white_balance performs white balancing manually.

%   INPUT
%   input       ... image
%   white       ... a color (as RGB vector) that should become the new white

%   OUTPUT
%   result      ... result after white balance

% TODO: perform white balancing using the 'white' variable
% HINT: Make sure the program does not crash if 'white' is zero!
% NOTE: pixels brighter than 'white' will have values > 1.
%       This requires a normalization which will be performed
%       during the histogram clipping.
% NOTE: The following line can be removed. It prevents the framework
%       from crashing.

red = input(:,:,1);
green = input(:,:,2);
blue = input(:,:,3);

red = double(red);
green = double(green);
blue = double(blue);

if(white(1) == 0)
    white(1) = 1;
end

if(white(2) == 0)
    white(2) = 1;
end

if(white(3) == 0)
    white(3) = 1;
end

red = red / white(1);
green = green / white(2);
blue = blue / white(3);


result = cat(3,red,green,blue);

end