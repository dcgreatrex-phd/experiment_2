function [out_value, direction_new, reversals,start,finish,low_flag, high_flag] = L_ex22_oneupthreedown(start_value, step_unit, start, trial_no, current_value, last_response, direction_old, reversals, low_flag, high_flag)
    % generate a mean value that follows the staircasing proceedure of
    % Kaernback, 1999. This is a 1 up, 3 down proceedure that converges to
    % a probability of 0.75 percent accuracy.
    
    max_reversals = 21;
    
    %-------------------------------------
    % 1. 1 down 3 up staircase rule
    %-------------------------------------
    if start == 1 % assign start value if it is the first in the sequence  
        out_value = start_value;
        direction_new = 0; reversals = 0; start = 0; finish = 0; % update flags
        return
    else % calculate out value based on the 1 up 3 down staircase rule 
        if last_response == 1 % the previous response was correct                            
            if trial_no <= 6 % trial number is less than 5 - decrease current value by stepsize * x. X is a scaling factor than only applies to the initial trials  
                out_value = current_value - (step_unit*5);                    
                direction_new = -1; % set direction_new flag
            else % trial number is more than 5 - decrease current value by stepsize.   
                out_value = current_value - step_unit;               
                direction_new = -1; % set direction_new flag to -1
            end                               
        elseif last_response == 0; % the previous response was incorrect 
            if trial_no <= 6
                out_value = current_value;
                direction_new = 0; % set direction_new flag 
            else    
                out_value = current_value + (step_unit * 3); % increment current value by stepsize * 3 - 3 up              
                direction_new = 1; % set direction_new flag 
            end
        end
    end

    %-------------------------------------
    % 2.1 check for low out_values
    %-------------------------------------
    if out_value < 0.02 % force a reversal
        out_value = 0.07;
        direction_new = 1;
        low_flag = low_flag + 1;
    end
    
    %-------------------------------------
    % 2.2 check for high out_values
    %-------------------------------------
    if out_value >= 0.85 % force a reversal
        out_value = 0.80;
        direction_new = -1;
        high_flag = high_flag + 1;
    end   
    
    %-------------------------------------
    % 2.3 check for reversal - if reversal increment counter
    %-------------------------------------
    if direction_old ~= 0;
        if direction_old ~= direction_new
            reversals = reversals + 1;
        end
    end
    
    %-------------------------------------
    % 2.4 raise finish flag if the number of reversals has crossed the max for the session or the low_flag has exceeded its max criteria .
    %-------------------------------------
    if reversals >= max_reversals
        finish = 1;
    elseif low_flag >= 3
        disp('low flag threshold has been breached!')
        finish = 1;
    elseif high_flag >= 3
        disp('high flag threshold has been breached!')
        finish = 1;
    else    
        finish = 0;
    end   
end