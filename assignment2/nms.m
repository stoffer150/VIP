function [ maximas ] = nms( A )
% Perform non maxima suppression on matrix A, returns A without non maxima
% values

% Define mask to area around point
mask = ones(3,3);
mask(5) = 0;

% Find max value in area around point
B = ordfilt2(A,8,mask);

% Find points which have bigger value than area around itself
maximas = A .* (A > B);

end

