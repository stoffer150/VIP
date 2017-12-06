in_path = 'input/';
out_path = 'output/';
files =  [{'Img001_diffuse_smallgray'; '.png'}, ...
         {'Img002_diffuse_smallgray'; '.png'}, ...
         {'Img009_diffuse_smallgray'; '.png'}];

% PART 1
for file = files
    I = imread([in_path, file{1}, file{2}]);
    points = Harris_corner_function(I, 1, 25, 0.01 );

    output = place_markers(I, points);

    figure();
    imshow(output);
    imwrite(output,[out_path, file{1}, file{2}])
end

% PART 2
