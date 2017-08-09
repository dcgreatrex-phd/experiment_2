function onset_shift = L_ex22_onsetasynchrony(rhythmic_flag, n_target)
%L_EX22_ONSETASYNCHRONY - generates an array of timing values in which to
%shift a periodic pulse of length n_target. If rhythmic_flag == 0 then the
%returned array will contain zeros and thus maintain peridicity when
%applied to the exeperimental IOI sequence. If ryhthmic_flag == 1 a IOI
%shifts will be randonmly selected from a discrete number of non metrically
%relating IOI values. The returned array, when applied to the experimental
%IOI sequence will result in a jittering, pseudo ramdomised aperiodicity
%from which a steady pulse cannot be extracted.
% 
% Syntax:  onset_shift = L_ex22_onsetasynchrony(rhythmic_flag, n_target)
%
% Input: 
%           rhythmic_flag:      binary classification variable. If 0 the
%                               function will return an array of zeros, 
%                               meaning that the experimental IOI sequence 
%                               will remain periodic. If 1 the function 
%                               will return an array of psuedo randomised 
%                               IOI shift values.
%
%           n_target:           number of targets in the experimental 
%                               target sequence.           
%
% Output:
% 
%           onset_shift:        array containing timing shift values to be 
%                               applied to the experimental IOI sequence.        
%
% Example:
%
%           onset_array = L_ex22_onsetasynchrony(1, 8)
%
% m-files required: none
% Subfunctions: none
% MAT-files required: length()
%
% Author: David C Greatrex
% Work Address: Centre for Music and Science, Cambridge University
% email: dcg32@cam.ac.uk
% Website: http://www.davidgreatrex.com
% May 2015; Last revision: 08-may-2015
    
%value = [-0.132,-0.088,-0.044,0,0.044,0.088,0.132]; % array of non-metric
%displacement values -- 7s == 44; 5s == 49;59;60
%------------- BEGIN CODE -------------- 
window_bound = 0.030;

if rhythmic_flag == 0 % generate onset_shift array.
    onset_shift(1:n_target) = 0; % return an array of zeros
    return;
else
    lastr1 = 0;% generate random permiation of integers 1:8
    lastr2 = 0;
    onset_shift = [];
    for i = 1:n_target
        while true
            r = (0.167-(-0.133)).*rand(1,1) + (-0.133);
            if lastr1 ~= 0
                if (r >= (lastr1-window_bound)) && (r <= (lastr1+window_bound)) ;
                    continue
                else
                    if lastr2 ~= 0
                        if (r >= (lastr2-window_bound)) && (r <= (lastr2+window_bound)) ;
                            continue
                        else
                            break
                        end
                    else
                        break
                    end
                end
            else
                break
            end
        end
        %onset_shift(i) = value(r); % update onset array
        onset_shift(i) = r;
        if lastr1 ~= 0
            lastr2 = lastr1;
        end
        lastr1 = r;
    end
end
%------------- END OF CODE --------------