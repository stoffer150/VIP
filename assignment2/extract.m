function [ descriptors ] = extract( im, points, n )

% Read in image
I = imread(im);
I = double(I);

% Pad image with zeros
[row, col] = size(I);
im_pad = zeros(row + 2*n, col + 2*n);
im_pad(n+1:row+n,n+1:col+n) = I;

% Shift points to match padding
points_shift = points + n;

% Compute descriptors
steps = floor(n / 2);
descriptors = zeros(n*n,size(points,1));

for i = 1:size(points,1)
    
    p = points_shift(i,:);
    descriptors(:,i) = reshape(im_pad(p(2)-steps : p(2) + steps, p(1)-steps : p(1) + steps), [n*n,1]);
    
end

end