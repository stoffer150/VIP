function [best_match, stats] = find_matchings(d1, d2, thres)
    
    stats = {};
    stats.num_comparisons = 0;
    stats.num_d1 = 0;
    stats.num_d2 = 0;
    stats.num_d1_ambi_filtered = 0;
    stats.num_d2_ambi_filtered = 0;
    stats.num_two_way_filtered = 0;
    stats.num_thresholded = 0;
    stats.mean_total = 0;
    stats.mean_accepted = 0;
    stats.std_accepted = 0;

    n_d1 = size(d1, 2);
    n_d2 = size(d2, 2);
    
    d1_tensor = repelem(d1, 1, 1, n_d2);
    d2_tensor = repelem(d2, 1, 1, n_d1);
    
    %From d1 to d2
    
    diff = sum((d1_tensor - permute(d2_tensor, [1, 3, 2])).^2, 1);
    
    [sorted_diff, idx] = sort(diff, 3);
    
    min_diff = sorted_diff(:,:,1);
    min_idx = idx(:,:,1);
    
    match1 = [1:n_d1; min_idx; min_diff];
    
    stats.num_d1 = size(match1, 2);
    
    %Filter for discarding matches, where second best is not a terrible
    %choice either
    filter = match1(3,:) > 0.2 .* sorted_diff(:,:,2);
    rem_idx1 = 1:n_d1;
    rem_idx1(filter) = []; %Indexes of remaining matches
    match1(:,filter) = []; %Remaining matches
    
    stats.num_d1_ambi_filtered = size(match1, 2);
    
    %From d2 to d1
    diff = permute(diff, [1 3 2]);
    
    [sorted_diff, idx] = sort(diff, 3);
    
    min_diff = sorted_diff(:,:,1);
    min_idx = idx(:,:,1);
    
    match2 = [1:n_d2; min_idx; min_diff];
    
    stats.num_d2 = size(match2, 2);
    
    %Discard matches, where second best is not a terrible choice either.
    %These are set to NaN, so we can index into the array in the next step
    match2(:,match2(3,:) > 0.2 .* sorted_diff(:,:,2)) = NaN;
    
    stats.num_d2_ambi_filtered = sum(~isnan(match2(1,:)),2);
    
    %Do a two way comparison
    
    best_match = match1(:,match2(2,match1(2,:)) == rem_idx1);
    
    stats.num_two_way_filtered = size(best_match, 2);
    %Filter bad similarities
    
    best_match(:,best_match(3,:) > thres) = [];
    
    %Stats
    
    stats.num_before_two_way = min(size(match1, 2), size(match2, 2));
    
    
    stats.num_d2_to_d1 = size(match2(:,match2(3,:) <= thres), 2);
    
    stats.mean_total = mean(mean(diff, 3), 2);
    
    stats.mean_accepted = mean(best_match(3,:), 2);
    
    stats.num_thresholded = size(best_match, 2);
    
    stats.num_comparisons = n_d1 * n_d2;
    
    stats.std_accepted = std(best_match(3,:))
    
    best_match = best_match(1:2, :);
    
end