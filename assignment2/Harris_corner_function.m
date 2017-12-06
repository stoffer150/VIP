function [ corners ] = Harris_corner_function( im, sigma, sz, t )
% Computes Harris Corner, takes grayscale image im, scale sigma, kernelsize sz and 
% threshold t as arguments

    % Create gaussian smoothing filter
    G = fspecial('gaussian',sz,sigma);
    
    % Create derivative filters
    dx = [-1,0,1];
    dy = dx';

    % Create gaussian derivative filters
    Gdx = conv2(dx,G,'same');
    Gdy = conv2(dy,G,'same');

    % Create entries for matrix M for all pixels
    Mx2 = conv2(im,Gdx,'same').^2;
    Mxy = conv2(im,Gdx,'same') .* conv2(im,Gdy,'same');
    My2 = conv2(im,Gdy,'same').^2;

    % Create Harris' corner measures for each pixel, 
    % k is set to 0.04 as standard
    k = 0.04;
    cim_matrix = ((Mx2 .* My2 - Mxy.^2) - k * (Mx2 + My2).^2).^2;
    cim_matrix = cim_matrix.^2;

    %  Perform NMS and threshold corner measure to find corner pixels
    cim = nms(cim_matrix);
    [y,x] = find(cim > t * max(max(cim)));
    corners = [x,y];

end

