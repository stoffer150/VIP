close all
clear

first_ims = {'tsukuba/scene1.row3.col1.ppm','venus/im0.ppm','map/im1.pgm'};
second_ims = {'tsukuba/scene1.row3.col3.ppm','venus/im2.ppm','map/im0.pgm'};
true_disps = {'tsukuba/truedisp.row3.col3.pgm','venus/disp2.pgm','map/disp0.pgm'};

for i = 1:3
    first_im = imread(first_ims{i});
    second_im = imread(second_ims{i});

    first_im = imgaussfilt(first_im, 0.01);
    second_im = imgaussfilt(second_im, 0.01);

    imsize = min(size(first_im, 1), size(second_im, 2));

    num_scales = floor(log2(imsize));

    num_scales = min(4, num_scales);

    scales = cell(num_scales,1);
    disparities = cell(num_scales, 4, num_scales, 1);

    scales{1} = {first_im, second_im};

    prev1 = first_im;
    prev2 = second_im;

    disp('Making pyramids...')
    for level = 2:num_scales
        prev1 = impyramid(prev1,'reduce');
        prev2 = impyramid(prev2,'reduce');
        scales{level} = {prev1, prev2};
    end

    for s = 1:num_scales
        for k = 5:2:11
            disp('Calculating dispartities...')
            for level = s:-1:1
                im1 = scales{level}{1};
                im2 = scales{level}{2};
                disp(level)
                if level < s
                    disparities{s, (k-5) / 2 + 1, level} = ...
                        calc_disp(im1, im2, [k, k], repelem(disparities{s, (k-5) / 2 + 1, level+1},2,2));
                else
                    disparities{s, (k-5) / 2 + 1, level} = ...
                        calc_disp(im1, im2, [k, k]);
                end

                if level == 1
                    disparity = disparities{s, (k-5) / 2 + 1, 1};
                    disparity = disparity - min(disparity(:));
                    disparity = double(disparity) ./ double(max(disparity(:))) * 255;
                    imwrite(uint8(disparity), ['disparity_s', int2str(s), '_k', int2str(k), 'set_', num2str(i), '.png']);
                end
            end
        end
    end

    gt_disp = imread(true_disps{i});

    disp('Calculating statistics...')
    for n = num_scales:-1:1
        disparity = disparities{num_scales, 2, n, 1};
        disparity = disparity - min(disparity(:));
        disparity = double(disparity) ./ double(max(disparity(:))) * 255;
        imwrite(uint8(disparity), ['disparity', int2str(n), 'set_', num2str(i), '.png']);
        figure();
        imshow(disparity);
    end

    disp('Calculating...')
    for k = 5:2:11
        for s = 1:4
            if i == 1
                dispar = double(8*(disparities{s, (k-5) / 2 + 1,1}));
            else
                dispar = double((disparities{s, (k-5) / 2 + 1,1}));
            end
            disp(strcat('k = ',num2str(k), ', scales used = ',num2str(s)))
            err = abs(double(gt_disp) - dispar);
            imwrite(err, ['err_s', int2str(s), '_k', int2str(k), 'set_', num2str(i), '.png']);
            err = err(:);

            mean_err = mean(err);
            disp(strcat('Mean error: ', num2str(mean_err)))

            err_std = std(double(err));
            disp(strcat('Standard deviation: ', num2str(err_std)))

            num_large_errs = size(err(err >= 3), 1);
            disp(strcat('Number of large errors: ', num2str(num_large_errs)))

            frac_large_errs = num_large_errs / size(err, 1);
            disp(strcat('Faction of large errors: ', num2str(frac_large_errs)))
        end
    end
end