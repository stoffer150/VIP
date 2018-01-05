img = double(rgb2gray(imread('tsukuba/scene1.row3.col1.ppm')));
test1 = img(1:10,1:10);
test2 = zeros(10,10);
test2(1:10,2:10) = img(1:10,1:9);
disp = calc_disp(test1,test2,[3,3]);