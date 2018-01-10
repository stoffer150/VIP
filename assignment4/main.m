
%--------------- PART 1 - Beethoven ------------------%

% Load data
load('Beethoven.mat');

% Show images
figure;
imshow(I(:,:,1),[])

figure;
imshow(I(:,:,2),[])

figure;
imshow(I(:,:,3),[])

% Create matrix J
num_lights = size(I, 3);

J = [];

for i = 1:num_lights
    nz = I(:,:, i);
    nz = nz(mask);
    J(i, :) = nz(:);
end

% Compute albedo and norm field
M = S\J;
albedo = vecnorm(M);
N = M ./ albedo;

% Show albedo as image
double_mask = double(mask);
double_mask(double_mask>0) = albedo;

figure;
imshow(double_mask,[]);

% Extract normals from N
n1 = zeros(size(mask));
n2 = zeros(size(mask));
n3 = ones(size(mask));

n1(double_mask>0) = N(1,:);
n2(double_mask>0) = N(2,:);
n3(double_mask>0) = N(3,:);

% Compute depth map and display it
depth_map = unbiased_integrate(n1,n2,n3,mask);
display_depth(depth_map);


%----------------- PART 2 - Buddha -------------------%

% Load data
load('Buddha.mat');

% Show images
figure;
imshow(I(:,:,1),[])

figure;
imshow(I(:,:,2),[])

figure;
imshow(I(:,:,3),[])

% Create matrix J
num_lights = size(I, 3);

J = [];

for i = 1:num_lights
    nz = I(:,:, i);
    nz = nz(mask);
    J(i, :) = nz(:);
end

% Compute albedo and norm field
M = S\J;
albedo = vecnorm(M);
N = M ./ albedo;

% Show albedo as image
double_mask = double(mask);
double_mask(double_mask>0) = albedo;

figure;
imshow(double_mask,[]);

% Extract normals from N
n1 = zeros(size(mask));
n2 = zeros(size(mask));
n3 = ones(size(mask));

n1(double_mask>0) = N(1,:);
n2(double_mask>0) = N(2,:);
n3(double_mask>0) = N(3,:);

% Compute depth map and display it
depth_map = unbiased_integrate(n1,n2,n3,mask);
display_depth(depth_map);