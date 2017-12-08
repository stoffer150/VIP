function [sim] = similarity(vec1, vec2)
    sim = sum((vec1 - vec2).^2, 1);
end