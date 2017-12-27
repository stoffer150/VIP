function disp = calc_disp(im1,im2,s,pre_disp)
    if nargin < 4
        pre_disp = zeros(size(im1));
    end
    disp = zeros(size(im1));
    
    [row,col] = size(im1);
    h_pad = floor(s(1)/2);
    v_pad = floor(s(2)/2);
    im_pad = zeros(row+h_pad*2,col+v_pad*2);
    im_pad(h_pad+1:h_pad+row,v_pad+1:v_pad+col) = im1;
    im1 = im_pad;
    im_pad(h_pad+1:h_pad+row,v_pad+1:v_pad+col) = im2;
    im2 = im_pad;
    
    for i = h_pad + 1:h_pad+row
        for j = v_pad + 1:v_pad+col
            d = pre_disp(i - h_pad,j - v_pad);
            temp = im1(i-h_pad : i+h_pad,j-v_pad :j+v_pad);
            A = im2(i-h_pad :i+h_pad,j+d-v_pad :end);
            corr = normxcorr2(temp,A);
            c_sz = size(corr);
            max_ind = find(corr(ceil(c_sz(1)/2),:) == max(corr(ceil(c_sz(1)/2),:)));
            disp(i - h_pad,j - v_pad) = -(j - max_ind(1)) + d;
        end
    end
    
end