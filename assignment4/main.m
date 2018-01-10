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
n = M ./ albedo;

% Show albedo as image
albmask = double(mask);
albmask(albmask>0) = albedo;
imshow(albmask,[]);

% Compute depth map
depth_map = unbiased_integrate(n(1,:),n(2,:),n(3,:),mask);

