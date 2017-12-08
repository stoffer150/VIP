function [best_match, stats] = find_matchings(d1, d2, thres)
    
    stats = {};
    stats.mean_total = 0;
    stats.mean_accepted = 0;
    stats.num_d1_to_d2 = 0;
    stats.num_d2_to_d1 = 0;
    stats.num_total = 0;

    n_d1 = size(d1, 2);
    n_d2 = size(d2, 2);
    
    d1_tensor = repelem(d1, 1, 1, n_d2);
    d2_tensor = repelem(d2, 1, 1, n_d1);
    
    %From d1 to d2
    
    diff = sum((d1_tensor - permute(d2_tensor, [1, 3, 2])).^2, 1);
    
    [min_diff, idx] = min(diff, [], 3);
    
    match1 = [1:n_d1; idx; min_diff];
    
    
    
    %From d2 to d1
    diff = permute(diff, [1 3 2]);
    
    [min_diff, idx] = min(diff, [], 3);
    
    match2 = [1:n_d2; idx; min_diff];
    
    %Do a two way comparison
    
    best_match = match1(:,match2(2,match1(2,:)) == 1:n_d1);
    
    %Filter bad similarities
    
    best_match(:,best_match(3,:) > thres) = [];
    
    best_match = best_match(1:2, :);
    
end