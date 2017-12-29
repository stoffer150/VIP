close all
clear

first_im = double(rgb2gray(imread('tsukuba/scene1.row3.col1.ppm')));
second_im = double(rgb2gray(imread('tsukuba/scene1.row3.col2.ppm')));

noise = 0.01*rand(size(first_im));
first_im = first_im + noise;
second_im = second_im + noise;

imsize = min(size(first_im, 1), size(second_im, 2));

num_scales = floor(log2(imsize));

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
            calc_disp(im1, im2, [5, 5], imresize(disparities{level+1}, 2, 'nearest'));
    else
        disparities{level} = ...
            calc_disp(im1, im2, [5, 5]);
    end
end

gt_disp = imread('tsukuba/truedisp.row3.col3.pgm');


disparity = disparities{1};
disparity = disparity - min(disparity);
disparity = uint8(disparity ./ max(disparity) * 255);
err = abs((disparity - gt_disp));
err = err(:);

mean_err = mean(err);

err_std = std(double(err));

num_large_errs = size(err(err >= 3), 1);

frac_large_errs = num_large_errs / size(err, 1);


