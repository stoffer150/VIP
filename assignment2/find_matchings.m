function [best_match, stats] = find_matchings(d1, d2, thres)
    
    stats = {};
    stats.num_comparisons = 0;
    stats.num_before_two_way = 0;
    stats.num_before_thresholding = 0;
    stats.num_final = 0;
    stats.mean_total = 0;
    stats.mean_accepted = 0;
    stats.num_d1_to_d2 = 0;
    stats.num_d2_to_d1 = 0;

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
    
    stats.num_before_thresholding = size(best_match, 2);
    %Filter bad similarities
    
    best_match(:,best_match(3,:) > thres) = [];
    
    %Stats
    
    stats.num_before_two_way = min(size(match1, 2), size(match2, 2));
    
    stats.num_d1_to_d2 = size(match1(:,match1(3,:) <= thres), 2);
    
    stats.num_d2_to_d1 = size(match2(:,match2(3,:) <= thres), 2);
    
    stats.mean_total = mean(mean(diff, 3), 2);
    
    stats.mean_accepted = mean(best_match(3,:), 2);
    
    stats.num_final = size(best_match, 2);
    
    stats.num_comparisons = n_d1 * n_d2
    
    best_match = best_match(1:2, :);
    
end