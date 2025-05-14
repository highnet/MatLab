%
% Copyright 2021 TU Wien.
% Institute of Computer Graphics and Algorithms.
%

function[P1P2, P2P3, P3P1, P1P2_length, P2P3_length, P3P1_length, ...
    normal, normalized_normal, Area, alpha, beta, gamma, angles_sum, ...
    angles_max, angles_min, angles_avg, fnc_handles] = Triangles()
% ATTENTION: Only implement sections that are marked with 'TODO'. You must
% not change anything that is not marked.

% DO NOT TOUCH - START
fnc_handles = {};
fnc_handles.define_triangle = @define_triangle;
fnc_handles.define_edges = @define_edges;
fnc_handles.compute_length = @compute_length;
fnc_handles.compute_normal = @compute_normal;
fnc_handles.compute_area = @compute_area;
fnc_handles.compute_angles = @compute_angles;
% DO NOT TOUCH - END

%% General Hints:
% If you want to check your implementation you can:
% -) Set a breakpoint to access variables at a certain point in the script.
% You can inspect their contents in the 'Workspace' window to the right.
% -) Leave out the ';' at the end of a statement/line so the result will be
% printed out in the command window.
% -) Do not rename the predefined variables, or else our test-system won't
% work (which is bad for both parties ;) )

%% Triangles
% 1) Construct 3 Vectors representing 3 Points that define a triangle.
% Implement this task in the function 'define_triangle'.
[P1, P2, P3] = define_triangle();


% 2) Construct the 3 vectors of the triangle: P1P2, P2P3 and P3P1.
% Implement this task in the function 'define_edges'.
[P1P2, P2P3, P3P1] = define_edges(P1, P2, P3);

% 3) Calculate the length of each edge
% Implement this task in the function 'compute_length'.
P1P2_length = compute_length(P1P2);
P2P3_length = compute_length(P2P3);
P3P1_length = compute_length(P3P1);

% 4) Compute the face normal of the triangle and its normalized version.
% Implement this task in the function 'compute_normal'.
[normal, normalized_normal] = compute_normal(P1P2, P2P3, P3P1);

% 5) Compute the Area of your triangle with the face normal.
% Implement this task in the function 'compute_area'.
Area = compute_area(normal);

% 6) Calculate the 3 angles of your triangle (in degrees).
% Implement this task in the function 'compute_angles'.
[alpha, beta, gamma, angles_sum, angles_min, angles_max, angles_avg] = ...
    compute_angles(P1P2, P2P3, P3P1);

end

function [P1, P2, P3] = define_triangle()
% Construct 3 Vectors representing 3 Points that define a triangle.
% Create the points P1, P2 and P3 with the following coordinates
% P1 =
%      1+C      -(1+A)      -(1+E)
% P2 =
%      -(1+G)   -(1+B)      1+H
% P3 =
%      -(1+D)   1+F         -(1+B)
% Where A,B,C,D,E,F,G,H are digits of your matriculation number in the following order:
% matriculation number: 'ABCDEFGH' -> A=0 B=1 C=4 D=0 E=8 F=1 G=8 H=9

P1 = [5, -1, -9];
P2 = [-9, -2, 10];
P3 = [-1, 2, -2];

end

function [P1P2, P2P3, P3P1] = define_edges(P1, P2, P3)
% Construct the 3 vectors of the triangle: P1P2, P2P3 and P3P1
% P1P2 is pointing from P1 to P2
% P2P3 is pointing from P2 to P3
% P3P1 is pointing from P3 to P1


P1P2 = [P2(1)-P1(1), P2(2)-P1(2), P2(3)-P1(3)];
P2P3 = [P3(1)-P2(1), P3(2)-P2(2), P3(3)-P2(3)];
P3P1 = [P1(1)-P3(1), P1(2)-P3(2), P1(3)-P3(3)];


end

function length = compute_length(edge)
% Calculate the length of an edge
% The positive length or magnitude of a vector is also known as the euclidian
% 'norm' of this vector.
% ATTENTION: you are not allowed to use the function 'norm' for this task,
% but you can compare the results of your calculation with the results you
% get by using the built-in Matlab function 'norm'.


length = sqrt(edge(1)^2 + edge(2)^2 + edge(3)^2);

end

function [normal, normalized_normal] = compute_normal(P1P2, P2P3, P3P1)
% Compute the face normal and of the triangle its normalized equivalent.
% You can use functions you have programmed until now or their Matlab
% equivalents(e.g. cross, dot, norm, etc.).
% normalize the normal!


% The cross product a × b is defined as a vector c that is perpendicular (orthogonal) to both a and b, with a direction given by the right-hand rule and a magnitude equal to the area of the parallelogram that the vectors span.
normal = cross(P1P2,-P3P1); % For a convex polygon , a surface normal can be calculated as the vector cross product of two (non-parallel) edges of the polygon.
normalized_normal = normalize(normal); % The normalized vector of normal is a vector in the same direction but with norm (length) 1.

end

function Area = compute_area(normal)
% Compute the Area of your triangle with the face normal.
% You can use functions you have programmed until now or their Matlab
% equivalents(e.g. cross, dot, norm, etc.).
% Beware of the direction of your vectors!

Area = 0.5 * length(normal); % Area of a 3D Pyramid is given by one half the length of the cross product

end

function [alpha, beta, gamma, angles_sum, angles_min, angles_max, ...
    angles_avg] = compute_angles(P1P2, P2P3, P3P1)
% Calculate the 3 angles of your triangle (in degrees)
% Name them 'alpha' at P1, 'beta' at P2 and 'gamma' at P3
% Beware of the direction and length of your vectors!
% You may use built-in Matlab functions.
% Use the matlab function 'acosd' to get the arccosine in degrees.
% Check your solution: Does the sum of your angles add up to the right amount?
% Save the exact sum of the three angles to 'angles_sum'.
% Save the maximum of the three angles to 'angles_max'.
% Save the minimum of the three angles to 'angles_min'.
% Save the arithmetic mean of the three angles to 'angles_avg' (Check the
% command 'mean')


%  Given two vectors P,Q in 3D Space  
%  the angle theta = arccos(P.Q / |P||Q|)

alpha = acosd(cross(P1P2,P2P3)/(sum(P1P2.*P1P2)*sum(P2P3.*P2P3)));
beta = acosd(cross(P2P3,P3P1)/(sum(P2P3.*P2P3)*sum(P3P1.*P3P1)));
gamma = acosd(cross(P3P1,P1P2)/(sum(P3P1.*P3P1)*sum(P1P2.*P1P2)));

% HINT: check the sum
angles_sum = alpha + beta + gamma;
angles_max = max(gamma,max(alpha,beta));
angles_min = min(gamma,min(alpha,beta));
angles_avg = mean([alpha beta gamma]);


end
