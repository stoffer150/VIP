close all
clear

first_im = imread('tsukuba/scene1.row3.col1.ppm');
second_im = imread('tsukuba/scene1.row3.col2.ppm');

size = min(size(first_im, 1), size(second_im, 2));

num_scales = floor(log2(size));

num_scales = min(4, num_scales);

scales = cell(num_scales,1);
disparities = cell(num_scales,1);

scales{1} = {first_im, second_im};

prev1 = first_im;
prev2 = second_im;

for level = 2:num_scales
    prev1 = impyramid(prev1,'reduce');
    prev2 = impyramid(prev2,'reduce');
    scales{level} = {prev1, prev2};
end

for level = num_scales:-1:1
    im1 = scales{level}{1};
    im2 = scales{level}{2};
    
    if level < num_scales
        disparities{level} = ...
            calc_disp(im1, im2, [5, 5], disparities{level+1})
    else
        disparities{level} = ...
            calc_disp(im1, im2, [5, 5])
    end
end