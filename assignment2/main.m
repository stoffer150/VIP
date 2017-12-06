in_path = 'input/';
out_path = 'output/';
file = {'Img001_diffuse_smallgray', '.png'};

I = imread([in_path, file{1}, file{2}]);
output = Harris_corner_function(I, 1, 10, 0.5 );

imshow(output);

saveas(output, [out_path, file{1}, file{2}]);