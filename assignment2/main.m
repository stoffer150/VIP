in_path = 'input/';
out_path = 'output/';
file = {'Img001_diffuse_smallgray', '.png'};

I = imread([in_path, file{1}, file{2}]);
points = Harris_corner_function(I, 0.5, 15, 0.005 );

output = place_markers(I, points);

imshow(output);

%imsave(output, [out_path, file{1}, file{2}]);