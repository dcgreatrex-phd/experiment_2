function [trial_type, trial_type_count] = L_ex22_staircase_trialtype(trial_type_old, trial_type_count)
    %%% generate a correct trial type based on the old trial type and
    %%% staircase procedure flags
    
    %---------------------
    % 1 - randomly assign a trial type - either -1 or 1 
    %---------------------
    random = randi(2);
    if random == 1
        trial_type = 1;
    elseif random == 2
        trial_type = -1;
    end
    
    %---------------------
    % 2 - increment or reset trial type count - this count allow the 
    % avoidance of mulitple trial types in succession
    %---------------------
    if trial_type_old == 0;
        trial_type_count = 1;
    elseif trial_type_old == trial_type;
        trial_type_count = trial_type_count + 1;
    else
        trial_type_count = 1;
    end
    
    %---------------------
    % 3 - force trial type change if trial_type_count is four or more.
    %---------------------
    if trial_type_count >= 4
        if trial_type == -1
            trial_type = 1;
        elseif trial_type == 1
            trial_type = -1;
        end
        % reset trial type count back to 1.
        trial_type_count = 1;
    end
end