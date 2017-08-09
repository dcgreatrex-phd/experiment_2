function [t_resp, t_choice, t_rt] = L_ex22_compute_response(startR, endR, keyCode, keyone, keytwo)
%ptb_2_2_compute_rt_choice - Compute which key id is associated with the key 
%press recorded within a passed keyCode logical array (generated using 
%KBCHECK()). Compute the response time using passed start and end CPT time 
%values. Assign a binary value indicating to which response category the 
%trial response belongs. The function retuns: 1) the name of the pressed 
%response key, 2) the category identifier (single value integer), 3) the 
%response time in seconds for the trial.
% 
% Syntax:  [t_resp, t_choice, t_rt] = L_ex22_compute_response(startR, endR, keyCode, keyone, keytwo)
%
% Input: 
%           startR:     CPU time value containing the start time of the 
%                       repsonse period.        
%
%           endR:       CPU time value containing the end time of the
%                       response period.
%
%           keyCode:    A 256-element logical array.  Each bit within the 
%                       logical array represents one keyboard key. If a 
%                       key is pressed, its bit is set, othewise the bit is 
%                       clear. To convert a keyCode to a vector of key  
%                       numbers use FIND(keyCode). To find a key's 
%                       keyNumber use KbName or KbDemo. - the array is 
%                       generated using KbCheck() during the response 
%                       period.
%
%           keyone:     the keyboard keyID for one response key.
%
%           keytwo:     the keyboard ketID for the other response key.
%
% Output:
% 
%           t_resp:     trial response variable. Contains the key name of 
%                       the repsonse key that was pressed.            
%
%           t_choice:   the trial integer response classifier indicating
%                       which response category the response belongs.
%
%           t_rt:       the trial response time in seconds.
%
% Example:
%
%           [t_resp, t_choice, t_rt] = L_ex22_compute_response(startR, endR, keyCode, 6, 16)
%
% m-files required: none
% Subfunctions: none
% MAT-files required: ROUND(); KbName(); LENGTH(); 
%
% Author: David C Greatrex
% Work Address: Centre for Music and Science, Cambridge University
% email: dcg32@cam.ac.uk
% Website: http://www.davidgreatrex.com
% may 2015; Last revision: 11-05-2015
    
%------------- BEGIN CODE ---------------
t_rt = round((endR-startR) * 1000) / 1000; % response time
t_resp=KbName(keyCode); % get key pressed by subject

if(length(t_resp))>1; % assign category response id (single value integer)
    t_resp = 'NR';
    t_choice = 0;
else
    if t_resp == keyone;
       t_choice = -1; % cardinal
    elseif t_resp == keytwo; 
       t_choice = 1; % horizontal
    else
       t_resp = 'NR';
       t_choice = 0; % no response
    end
end
%------------- END OF CODE --------------
