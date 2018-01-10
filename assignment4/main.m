% load('Buddha.mat');
load('Beethoven.mat');

%------------------------------------------%

num_lights = size(I, 3);

J = [];

for n = 1:num_lights
    nz = I(:,:, n);
    nz = nz(mask);
    J(n, :) = nz(:);
end

M = S\J;

albedo = vecnorm(M);

%depth_map = unbiased_integrate(M(1,:),M(2,:),M(3,:),mask);

