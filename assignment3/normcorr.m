function corr = normcorr(patch1,rest, h_pad)
    corr = zeros(1,size(rest,2) - 2*h_pad);
    for i = h_pad + 1:size(rest,2) - h_pad
        patch2 = rest(:,i - h_pad:i + h_pad);
        corr_patches = normxcorr2(patch1,patch2);
        c_sz = size(corr_patches);
        mid_x = ceil(c_sz(2)/2); 
        mid_y = ceil(c_sz(1)/2);
        corr(i-h_pad) = corr_patches(mid_y,mid_x);
    end
end