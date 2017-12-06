function [ int_points ] = Laplacian_of_gaussian(im,nmb_scales)
% Compute scale-space interest points by Laplacian of gaussian

% Calculate sigma values
sigma_n = zeros(1,nmb_scales);
sigma_0 = 10.24;

for i = 1:nmb_scales
    sigma_n(i) = 1.4^i * sigma_0; % Factor between scales = 1.4 (Lindeberg)
end

% Calculate scale-space representation
sn_log = zeros(size(im,1),size(im,2),nmb_scales);

for i = 1:nmb_scales
    sn_log_filter = sigma_n(i)^2 .* fspecial('log',[round(sigma_n(i)),round(sigma_n(i))],sigma_n(i));
    sn_log(:,:,i) = conv2(im,sn_log_filter,'same').^2; % Square to get both maximas and minimas
end

% Perform non maximal suppression in every scale
for i = 1:nmb_scales
    sn_log(:,:,i) = nms(sn_log(:,:,i));
end

% Define mask for area around point
mask = ones(3,3);
mask(5) = 0;

% Discard maximas if they are not maximas over scales
for i = 1:nmb_scales
    if i == 1
        % Find max value in area around point for surrounding scales
        above = ordfilt2(sn_log(:,:,i+1),8,mask);
        % Find points which have bigger value than area around itself
        sn_log(:,:,i) = sn_log(:,:,i) .* (sn_log(:,:,i) > above);
    elseif i == nmb_scales
        % Find max value in area around point for surrounding scales
        under = ordfilt2(sn_log(:,:,i-1),8,mask);
        % Find points which have bigger value than area around itself
        sn_log(:,:,i) = sn_log(:,:,i) .* (sn_log(:,:,i) > under);
    else
        % Find max value in area around point for surrounding scales
        under = ordfilt2(sn_log(:,:,i-1),8,mask);
        above = ordfilt2(sn_log(:,:,i+1),8,mask);
        % Find points which have bigger value than area around itself
        sn_log(:,:,i) = sn_log(:,:,i) .* (sn_log(:,:,i) > under) .* (sn_log(:,:,i) > above);
    end
end

% Save interest points
int_points = zeros(0,3);

for i = 1:nmb_scales
    [y,x] = find(sn_log(:,:,i) > 0);
    nmb_points = size(x,1);
    int_points(end+1:end+nmb_points,:) = [x,y,(ones(nmb_points,1) .* sigma_n(i))];
end

end