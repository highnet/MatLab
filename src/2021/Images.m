%
% Copyright 2021 TU Wien.
% Institute of Computer Graphics and Algorithms.
%

function[image_double, image_swapped, image_mark_green, image_masked, ...
    image_reshaped, gauss_kernel, image_convoluted, image_edge, fnc_handles] = Images()
% ATTENTION: Only implement sections that are marked with 'TODO'. You must
% not change anything that is not marked.

% DO NOT TOUCH - START
fnc_handles = {};
fnc_handles.swap_channels = @swap_channels;
fnc_handles.mark_green = @mark_green;
fnc_handles.mask_image = @mask_image;
fnc_handles.reshape_image = @reshape_image;
fnc_handles.edge_filter = @edge_filter;
fnc_handles.evc_filter = @evc_filter;
% DO NOT TOUCH - END

%% Initialization. Do not change anything here
input_path = 'mandrill_color.jpg';
output_path = 'mandrill_output.png';

%% General Hints:
% If you want to check your implementation you can:
% -) Set a breakpoint to access variables at a certain point in the script.
% You can inspect their contents in the 'Workspace' window to the right.
% -) Leave out the ';' at the end of a statement/line so the result will be
% printed out in the command window.
% -) Do not rename the predefined variables, or else our test-system won't
% work (which is bad for both parties ;) )

%% I. Images basics
% 1) Load image from 'input_path' and store it in 'image'
image = imread(input_path);

% 2) Convert the image from 1) to double format with range [0, 1]. DO NOT USE LOOPS.
image_double = im2double(image);

% 3) Swap the channels of an image
% Implement this task in the function 'swap_channels'.
image_swapped = swap_channels(image_double);

% 4) Display the swapped image
imshow(image_swapped);

% 5) Write the swapped image to the path specified in output_path. The
% image should be in png format.
imwrite(image_swapped,output_path);

% 6) Logical images
% Implement this task in the function 'mark_green'.
image_mark_green = mark_green(image_double);

% 7) Mask an image conditionally
% Implement this task in the function 'mask_image'.
image_masked = mask_image(image_double, image_mark_green);

% 8) Change the shape of an image
% Implement this task in the function 'reshape_image'.
image_reshaped = reshape_image(image_double);

%% II. Filters and convolutions

% 1) Use fspecial to create a 5x5 gaussian filter with sigma=2.0 and store
% it in 'gauss_kernel'
gauss_kernel = fspecial('gaussian',[5 5],2.0);

% 2) Implement the function 'evc_filter'.
image_convoluted = evc_filter(image_swapped, gauss_kernel);

% 3) Highlight the horizontal edges of an image using the sobel filter.
% Implement this task in the function 'edge_filter'.
image_edge = edge_filter(image_reshaped);

end

function image_swapped = swap_channels(image_double)
% Use the parameter 'image_double' (image from step 2) to create an image
% where the red and the green channels are swapped. The result should be
% stored in 'image_swapped'. DO NOT USE LOOPS.

red = image_double(:,:,1);
green = image_double(:,:,2);
blue = image_double(:,:,3);

red_copy = red;
red = green;
green = red_copy;

image_swapped = cat(3,red,green,blue);

end

function image_mark_green = mark_green(image_double)
% Create a logical image where every pixel is marked that has a value
% greater or equal to 0.7 in the green channel. The result should be stored
% in 'image_mark_green'. Use the parameter 'image_double' (image from step
% 2) for this step. DO NOT USE LOOPS.
% HINT:
% see http://de.mathworks.com/help/matlab/matlab_prog/find-array-elements-that-meet-a-condition.html).

green = image_double(:,:,2);

image_mark_green = green >= 0.7;

end

function image_masked = mask_image(image_double, image_mark_green)
% Set all pixels in 'image_double' (the double image from step 2) to black
% where 'image_mark_green' is true (where green >= 0.7). Store the result
% in 'image_masked'. DO NOT USE LOOPS.
% HINT: You can use 'repmat' to complete this task.


mask = repmat(image_mark_green, [1 1 3]);
image_double(mask) = 0;
image_masked = image_double;


end

function image_reshaped = reshape_image(image_double)
% Convert the parameter 'image_double' (the double image from step 2) to a
% grayscale image and reshape it from 512x512 to 1024x256. Cut off the
% right half of the image and attach it to the bottom of the left half.
% The result should be stored in 'image_reshaped' DO NOT USE LOOPS.
% HINT: Matlab adresses matrices with "height x width"

image_reshaped = rgb2gray(image_double);
right_half = imcrop(image_reshaped,[257 0 257 512]);
left_half = imcrop(image_reshaped,[0 0 256 512]);
image_reshaped = cat(1,left_half,right_half);


end

function [result] = evc_filter(input, kernel)
% Returns the input image filtered with the kernel
% input: An rgb-image
% kernel: The filter kernel
%
% You are allowed to use loops for this task. You can assume that the
% kernel is always of size 5x5. For pixels outside the image use 0.
% Do not use the conv or the imfilter or similar functions here.
% The output image should have the same size as the input image.

red = input(:,:,1);
green = input(:,:,2);
blue = input(:,:,3);
[height, width, dim] = size(input);
new_green = im2double(zeros(height,width));
new_red = im2double(zeros(height,width));
new_blue = im2double(zeros(height,width));
sumR = 0;
sumG = 0;
sumB = 0;

for row = 1:height % Iterate through each pixel
    for column = 1:width % Iterate through each pixel
        for kdx = -2:2 % kdx and kdy are the cyclic coordinates for the 5x5 mask with distance from the center.
            for kdy = -2:2
                mx = row+kdx; % the matrix x and y values are offset by the current row and column...
                my = column+kdy; % ...and by the current dx and dy
                if (mx > 0 && my > 0 && mx <= height && my <= width) % if matrix x and y are within bounds of the image
                    sumR = sumR + kernel(kdx+3,kdy+3) * red(mx,my); % multiply the kernel value with the matrix value...
                    sumG = sumG + kernel(kdx+3,kdy+3) * green(mx,my);
                    sumB = sumB + kernel(kdx+3,kdy+3) * blue(mx,my);%...and increment the sum
                end
            end
        end
                  new_red(row,column) = sumR; % set the convoluted color...
                  new_green(row,column) = sumG;
                  new_blue(row,column) = sumB;
                  sumR = 0;%...and reset for next iteration
                  sumG = 0;
                  sumB = 0;
    end 
end

result = cat(3,new_red,new_green,new_blue);

end

function image_edge = edge_filter(image_reshaped)
% Create an image showing the horizontal edges in 'image_reshaped' using
% the sobel filter. For this task you can use imfilter/conv.
% The result should be stored in 'image_edge'. DO NOT USE LOOPS.
% ATTENTION: Do not use 'evc_filter' for this task! The output image should
% have the same size as the input image.
% For this task it is your choice how you handle pixels outside the image,
% but you should use a typical method to do this. (e.g. zero padding,
% border replication, etc.) Take a look at the imfilter documentation.

sobel_filter = fspecial('sobel'); % create sobel filter

image_edge = imfilter(image_reshaped,sobel_filter); % apply filter

end
