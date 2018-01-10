% load('Buddha.mat');
load('Beethoven.mat');

%------------------------------------------%

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
imagesc(double_mask);
colormap gray;

% Extract normals from N
n1 = zeros(size(mask));
n2 = zeros(size(mask));
n3 = ones(size(mask));

n1(double_mask>0) = N(1,:);
n2(double_mask>0) = N(2,:);
n3(double_mask>0) = N(3,:);

% Compute depth map
depth_map = unbiased_integrate(n1,n2,n3,mask);