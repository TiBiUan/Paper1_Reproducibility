function [idx1,idx2,le,le2] = GSPTB_CreateSplit(n1,n2,K_Family)
    
    % This contains all our indices, which we want to partition
    idx = randperm(n1+n2);
    idx_fin = idx;

    % This will contain both partitions
    idx1 = [];

    % We will gradually append indices to the first set, accounting for
    % family structure; once we finish, we then create the second set as
    % the remaining indices. We gradually append until we reach the desired
    % size
    i = 1;

    while(length(idx1)<n1)
        
        % First, we sample a candidate random index (first element of idx)
        tmp_idx = idx(1);

        % We want to assess the family relationships for this particular
        % subject
        tmp_fam = K_Family(tmp_idx,:);

        % We get the indices
        tmp = find(tmp_fam == 1);

        idx1 = [idx1,tmp];
        idx1 = unique(idx1);

        le(i) = length(idx1);

        idx(ismember(idx,tmp)) = [];

        le2(i) = length(idx);

        clear tmp
        clear tmp_fam

        i = i+1;
    end

    idx2 = idx_fin(~ismember(idx_fin,idx1));

end