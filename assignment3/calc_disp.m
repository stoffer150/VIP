function dispa = calc_disp(im1,im2,s,pre_disp)
    if nargin < 4
        pre_disp = zeros(size(im1), 'uint8');
    end
    dispa = zeros(size(im1), 'uint8');
    
    [row,col] = size(im1);
    h_pad = floor(s(1)/2);
    v_pad = floor(s(2)/2);
    
    for i = 1:row
        disp([int2str(i)])
        for j = 1:col

            d = uint64(pre_disp(i,j));
            
            %Calculate template
            temp = im1(max(i-v_pad, 1):min(i+v_pad, row), ...
                       max(j-h_pad, 1):min(j+h_pad, col));
            temp = double(temp) + rand(size(temp))*0.01;
            temp_center = [i - max(i-v_pad, 1) + 1, j - max(j-h_pad, 1) + 1];
            
            %Scale of A field
            a_scale = 2;
            
            %Calculate x coordinates for use in A
            x_idx = max(j-d*2-h_pad*a_scale, 1):max(min([j-d*2+h_pad*a_scale, j+h_pad, col]), size(temp,2)+h_pad);
            
            %Calculate A
            A = im2(max(i-v_pad, 1):min(i+v_pad, row),x_idx);
            A_center = double([temp_center(1), min(d*2+v_pad*a_scale, j - 1) + 1]);
            
            %Calclate normalized correlation
            corr = normxcorr2(temp,A);
            corr_center = A_center + size(temp) - temp_center;
            
            %Clip it to only relevant matches
            corr = corr(corr_center(1), h_pad*2:end-h_pad);
            
            %Find maximum index;
            max_ind = find(corr == max(corr));
            max_ind = max_ind(1);
            
%             if max_ind == 1
%                 max_ind = find(corr == max(corr(2:end)));
%             end
            
            %Calculate the difference in pixel-position
            diff = corr_center(2) - (max_ind + h_pad*2);

            %Special case
            if diff < 0
               max_ind = find(corr == max(corr(1:end-1)));
               max_ind = max_ind(1);
               diff = corr_center(2) - (max_ind + h_pad*2);
            end
            
            %Store result
            dispa(i,j) = diff;
        end
    end
end