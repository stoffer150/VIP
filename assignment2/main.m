in_path = 'input/';
out_path = 'output/';
files =  [{'Img001_diffuse_smallgray'; '.png'}, ...
         {'Img002_diffuse_smallgray'; '.png'}, ...
         {'Img009_diffuse_smallgray'; '.png'}];

% PART 1
count = 1;
for file = files
    I = imread([in_path, file{1}, file{2}]);
    points = Harris_corner_function(I, 1, 25, 0.01 );
    
    assignin('base', strcat('points_im', num2str(count)), points);

    count = count + 1;
    output = place_markers(I, points);

    figure();
    imshow(output);
    imwrite(output,[out_path, file{1}, file{2}]);
end

% PART 2

n = 5;
descriptors1 = extract( strcat(in_path, files{1,1}, files{2,1}), points_im1, n );
descriptors2 = extract( strcat(in_path, files{1,2}, files{2,2}), points_im2, n );

% Match interest points
matches = find_matchings(descriptors1, descriptors2);
p1 = points_im1(matches(1,:),:);
p2 = points_im2(matches(2,:),:);

% Plot matched interest points on top of images
figure;
showMatchedFeatures(im1,im2,p1,p2,'montage');
legend('Image 1 points','Image 2 points', 'Location','SouthEast');

% Save plot figure
filename = sprintf('matches');
print(filename, '-dpng');