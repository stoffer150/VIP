function [I_out] = place_markers(I, markers)
    size_x = size(I, 1);
    size_y = size(I, 2);
    element = {};
    element.radius = 4;
    element.size = element.radius * 2 + 1;
    element.overlay = zeros(element.size, element.size, 3, 'double');
    element.overlay(element.radius:element.radius+2, :, 1) = 255;
    element.overlay(:, element.radius:element.radius+2, 1) = 255;
    element.mask = ones(element.size, element.size, 3, 'double');
    element.mask(element.radius:element.radius+2, :, :) = 0;
    element.mask(:, element.radius:element.radius+2, :) = 0;
    I_out = cat(3, I, I, I);
    for n = 1:size(markers, 1)
        marker = markers(n, :);
        x = marker(2)-element.radius:marker(2)+element.radius;
        y = marker(1)-element.radius:marker(1)+element.radius;
        
        x_s = (x <= size_x & x >= 0);
        x(~x_s) = [];
        
        y_s = (y <= size_y & y >= 0);
        y(~y_s) = [];
        
        masked = I_out(x, y, :) .* element.mask(x_s, y_s, :);
        overlayed = masked + element.overlay(x_s, y_s, :);
        overlayed(overlayed > 255) = 255;
        overlayed(overlayed < 0) = 0;
        I_out(x, y, :) = overlayed;
    end
end