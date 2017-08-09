function threshold = L_ex22_threshold(subNo, p_folder_out, output_file)

    % open output datafile
    input = strcat(p_folder_out, output_file);
    disp(input);
    
    [sub, trial_tot, trial_type, outvalue, ~, resp_key, t_choice, t_response, t_rt, t_reversals, ~, ~, ~] = textread(input,'%d %d %d %.4f %.4f %s %d %d %.4f %d %d %d %d', 'headerlines',1);
    ntrials=length(trial_tot);
    
    % Create an empty cell array ready to be populated by 
    C = cell((ntrials+1), 9);

    % Loop through data and add to cell array
    counter = 1;
    for trial=1:(ntrials+1); 
        if (counter == 1)
            C{1,1} = 'sub';
            C{1,2} = 'total_trial_no';
            C{1,3} = 'trial_type';
            C{1,4} = 'outvalue'; 
            C{1,5} = 'resp_key';
            C{1,6} = 't_choice'; 
            C{1,7} = 't_response';
            C{1,8} = 't_rt';
            C{1,9} = 't_reversals';
            counter = counter + 1;
        else                
            C{counter, 1} = sub(trial-1);
            C{counter, 2} = trial_tot(trial-1);
            C{counter, 3} = trial_type(trial-1);
            C{counter, 4} = outvalue(trial-1);
            C{counter, 5} = resp_key(trial-1);
            C{counter, 6} = t_choice(trial-1);
            C{counter, 7} = t_response(trial-1);
            C{counter, 8} = t_rt(trial-1);
            C{counter, 9} = t_reversals(trial-1);
            counter = counter + 1;
        end
    end

    ds = cell2dataset(C);
    ds1 = sortrows(ds,{'total_trial_no'});
    
    % fix the reversal flag
    for i = 1:length(ds1.total_trial_no)
        if i == length(ds1.total_trial_no)
            ds1.fixed_flag(i) = max(t_reversals)+1;
        else
            ds1.fixed_flag(i) = ds1.t_reversals(i+1);  
        end
    end   
    
    ds2 = ds1;
    
     % delete any rows which are not reversal trials
    for i = 1:size(ds2,1)
        if i == 1
            ds2.flag(i) = 1;
            delete1(i) = true;
            continue
        end
        if ds2.fixed_flag(i) == ds2.fixed_flag(i-1) 
            ds2.flag(i) = 1;
            delete1(i) = true;
        else
            ds2.flag(i) = 0;
            delete1(i) = false;
        end
    end
    if ismember(1,delete1)
        ds2(delete1, :) = [];
    end

    % remove first 2 reversals from before2
    if size(ds2.total_trial_no)>=2
        ds2(1,:) = [];
        ds2(1,:) = [];
    elseif size(ds2.total_trial_no)== 1
        ds2(1,:) = [];
    end
    
    % calcualte median value from column outvalue
    threshold = mean(ds1.outvalue);
    
    %--------------------------------------------
    % Create two line charts for before and after
    %--------------------------------------------
    ds3 = dataset(ds1.outvalue);

    % draw plot
    h = figure;
    plot(ds3);
    title(strcat('Participant_', num2str(subNo), ' : Adaptive Threshold Procedure')), xlabel('trial number'), ylabel('Mean of probability density function');

    % add horzontal lines for metronome and also both median values
    line('XData', [0 length(ds3.Var1)], 'YData', [threshold threshold], 'LineStyle', '-', ...
        'LineWidth', 1, 'Color','m')

    % save plot to file
    saveas(h,strcat(p_folder_out,'P_', num2str(subNo),'_threshold_plot_'),'jpg');

end