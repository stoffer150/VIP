function [ds] = dissimilarity(vec1, vec2)
    ds = sum((vec1 - vec2).^2, 1);
end