%
% Copyright 2017 Vienna University of Technology.
% Institute of Computer Graphics and Algorithms.
%

function [result] = evc_compute_binary(input, x, top)
%evc_compute_binary computes a binary image with the specified threshold x.
%
%   INPUT
%   input ... RGB image
%   x     ... scalar threshold
%   top   ... if 0, the output should be inverted such that 0 becomes 1
%             and 1 becomes 0.
%   OUTPUT
%   result... binary RGB image which must contain either zeros or ones. The
%             result has to be of type double! Make sure that all three
%             channels are preserved (the operation has to be performed on
%             every channel).


% TODO: Compute a binary image with the threshold x. Values less or equal
%       to x are mapped to 0, values greater than x are mapped to 1.
%       The input image might contain values greater than 1 so im2bw can't
%       be used (it would crash).
%       If top == 0 the output should be inverted such that 0 becomes 1
%       and 1 becomes 0 (swap 0 and 1).
% NOTE: The following line can be removed. It prevents the framework from
%       crashing.

red = input(:,:,1);
green = input(:,:,2);
blue = input(:,:,3);

if(top == 0)
    red(red <= x) = 1;
    green(green <= x) = 1;
    blue(blue <= x) = 1;
else
    red(red <= x) = 0;
    green(green <= x) = 0;
    blue(blue <= x) = 0;
end

end

