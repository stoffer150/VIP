in_path = 'input/';
out_path = 'output/';
files =  [{'Img001_diffuse_smallgray'; '.png'}, ...
         {'Img002_diffuse_smallgray'; '.png'}, ...
         {'Img009_diffuse_smallgray'; '.png'}];

% PART 1
count = 1;
for file = files
    I = imread([in_path, file{1}, file{2}]);
    I = double(I);
    points = Harris_corner_function(I, 1, 25, 0.0001 );
    
    assignin('base', strcat('points_im', num2str(count)), points);

    figure();
    imshow(I,[]);
    hold on
    plot(points(:,1),points(:,2),'r*');
    hold off
    filename = sprintf('interest_points%s',num2str(count));
    print([out_path, filename], '-dpng');
    pause(1);
    close;

    count = count + 1;
end

% PART 2

N = [5,7,9,13];
for i = 1:length(N)
    n = N(i);
    descriptors1 = extract( strcat(in_path, files{1,1}, files{2,1}), points_im1, n );
    descriptors2 = extract( strcat(in_path, files{1,2}, files{2,2}), points_im2, n );
    im1 = imread(strcat(in_path, files{1,1}, files{2,1}));
    im2 = imread(strcat(in_path, files{1,2}, files{2,2}));

    % Match interest points
    [matches,stats] = find_matchings(descriptors1, descriptors2,100000);
    p1 = points_im1(matches(1,:),:);
    p2 = points_im2(matches(2,:),:);

    % Plot matched interest points on top of images
    figure;
    showMatchedFeatures(im1,im2,p1,p2,'montage','PlotOptions',{'ro','go','c-'});
    legend('Image 1 points','Image 2 points', 'Location','NorthWest');

    % Save plot figure
    filename = sprintf('matches%s',num2str(n));
    print([out_path,filename], '-dpng');
    pause(1);
    close;
end