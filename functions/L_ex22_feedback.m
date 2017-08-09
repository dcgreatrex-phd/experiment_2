function t_correct = L_ex22_feedback(t_type, t_choice, pa_low, pa_high, endR, f, f_gap, f_dur)
%L_EX22_FEEDBACK - calculates the accuracy of the
%response by comparing the passed t_choice variable to that of the passed 
%t_type variable. If both variables contain the same information, the 
%response was correct. In this case, an assending dual auditory tone 
%sequence is sounded. If the values in the two variables are differnt, 
%the response was incorret. In this case a decending dual auditory tone 
%sequence is sounded. The function needs to have as input both response 
%variables, pa audio handles for two different pitched tones, and variables 
%defining the feedback. The function returns a binary indicator 
%highlighting whether the response was correct or not. 
% 
% Syntax:  t_correct = L_ex22_feedback(t_type, t_choice, pa_low, pa_high, endR, f, f_gap, f_dur)
%
% Input: 
%           t_type:     integer variable classifying the trial condition: 
%                       -1 == cardinal condition, 1 == horizontal 
%                       condition.
%
%           t_choice:   integer variable classifying whether the respose
%                       was either cardinal or horizontal. -1 == cardinal. 
%                       1 == horizontal.
%
%           pa_low:     auditory handle for the low feedback tone.
%
%           pa_high:    auditory handle for the high feedback tone.
%
%           endR:       CPU time value marking the end of the response
%                       period.
%
%           f:          binary indicator highlighting whether feedback
%                       should be given. 1 == Feedback. 0 == No Feedback.
%
%           f_gap:      the duration between the end of the response period
%                       and feedback tones.
%
%           f_dur:      the duration of each feedback tone.
%
% Output:
% 
%           t_correct:  binary response indicator highlighting whether the 
%                       response was correct or incorrect.            
%
% Example:
%
%           t_correct = L_ex22_feedback(-1, -1, pa_low, pa_high, endR, 1, 0.250, 0.100)
%
% m-files required: none
% Subfunctions: none
% MAT-files required: PsychoPortAudio();
%
% Author: David C Greatrex
% Work Address: Centre for Music and Science, Cambridge University
% email: dcg32@cam.ac.uk
% Website: http://www.davidgreatrex.com
% may 2015; Last revision: 11-05-2015
    
%------------- BEGIN CODE ---------------
if t_choice ~= t_type % if choice and trial variables do not match
    t_correct = 0;
     if f == 1 % play incorrect feedback tone  
         PsychPortAudio('Start', pa_high, 1, (endR+f_gap), [], (endR+f_gap+f_dur));
         PsychPortAudio('Start', pa_low, 1, (endR+f_gap+f_dur), [], (endR+f_gap+(f_dur*2)));
         PsychPortAudio('Stop', pa_high, 3);
         PsychPortAudio('Stop', pa_low, 3);
     end
else
    t_correct = 1; % if choice and trial variables match
     if f == 1 % play correct feedback tone sequence
        PsychPortAudio('Start', pa_low, 1, (endR+f_gap), [], (endR+f_gap+f_dur));
        PsychPortAudio('Start', pa_high, 1, (endR+f_gap+f_dur), [], (endR+f_gap+(f_dur*2)));
        PsychPortAudio('Stop', pa_low, 3);
        PsychPortAudio('Stop', pa_high, 3);
    end
end
%------------- END OF CODE --------------