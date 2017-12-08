function [ descriptors ] = extract( im, points, n )

I = imread(im);
I = double(I);

[row, col] = size(I);
im_pad = zeros(row + 2*n, col + 2*n);
im_pad(n+1:row+n,n+1:col+n) = I;
points_shift = points + n;

steps = floor(n / 2);
descriptors = zeros(n*n,size(points,1));

for i = 1:size(points,1)
    
    p = points_shift(i,:);
    descriptors(:,i) = reshape(im_pad(p(2)-steps : p(2) + steps, p(1)-steps : p(1) + steps), [n*n,1]);
    
end

end