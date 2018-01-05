close all
clear

first_im = rgb2gray(imread('tsukuba/scene1.row3.col1.ppm'));
second_im = rgb2gray(imread('tsukuba/scene1.row3.col2.ppm'));

first_im = imgaussfilt(first_im, 0.01);
second_im = imgaussfilt(second_im, 0.01);

imsize = min(size(first_im, 1), size(second_im, 2));

num_scales = floor(log2(imsize));

num_scales = min(4, num_scales);

scales = cell(num_scales,1);
disparities = cell(num_scales,1);

scales{1} = {first_im, second_im};

prev1 = first_im;
prev2 = second_im;

disp('Making pyramids...')
for level = 2:num_scales
    prev1 = impyramid(prev1,'reduce');
    prev2 = impyramid(prev2,'reduce');
    scales{level} = {prev1, prev2};
end
disp('Calculating dispartities...')
for level = num_scales:-1:1
    im1 = scales{level}{1};
    im2 = scales{level}{2};
    disp(level)
    if level < num_scales
        disparities{level} = ...
            calc_disp(im1, im2, [7, 7], imresize(disparities{level+1}, 2, 'nearest'));
    else
        disparities{level} = ...
            calc_disp(im1, im2, [7, 7]);
    end
end

gt_disp = imread('tsukuba/truedisp.row3.col3.pgm');

disp('Calculating statistics...')
for n = num_scales:-1:1
    disparity = disparities{n, 1};
    disparity = disparity - min(disparity(:));
    disparity = uint8(double(disparity) ./ double(max(disparity(:))) * 255);
    imwrite(disparity, ['disparity', int2str(n), '.png']);
    figure();
    imshow(disparity);
end
err = abs((disparities{1,1} - gt_disp));
err = err(:);

mean_err = mean(err);

err_std = std(double(err));

num_large_errs = size(err(err >= 3), 1);

frac_large_errs = num_large_errs / size(err, 1);


