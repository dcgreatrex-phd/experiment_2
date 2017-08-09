function [startR, endR, keyCode] = L_ex22_presentresponse2(subNo, w, IOI, pa_click, pa_target, pa_mask, maxResp, l_key, r_key, pause_key,  img_loc, img_tex, count, rhythmic)
%L_EX22_PRESENTRESPONSE - An experimental script that presents a trial
%stimulus, records response and reaction time data and returns this data
%for post trial processing. The function contains a number of subfuctions
%and facilitates a pause mechanism which allows the user to pause the
%experimental script after any trial.
% 
% Syntax:  [StartR, EndR, keyCode] = L_ex22_presentresponse(subNo, w, IOI, pa_click, pa_target, maxResp, l_key, r_key, pause_key,  img_loc, img_tex, pa_noise, count)
%
% Input: 
%           subNo:      subject's experimental number - id.
%
%           w:          experimental screen handler.
%
%           IOI:        interonset interval of the periodic auditory pulse.
%
%           pa_click:   slave handle of the audio click schedule.
%
%           pa_target:  slave handle of the audio target schedule.
%
%           pa_mask:    slave handle of the audio mask schedule.
%
%           maxResp:    maximum time allowed to respond.
%
%           l_key:      keyboard key code of the left response key -
%                       keyCode = KbName('x')
%
%           r_key:      keyboard key code of the right response key -
%                       keyCode = KbName('x')
%
%           pause_key:  keyboard key code of the pause response key -
%                       keyCode = KbName('x')
%
%           img_loc:    array containing all image texture locations.
%
%           img_tex:    array containing all image textures.
%
%           count:      numeric value of the length of the target audio 
%                       schedule - in seconds.
%
%           rhythmic:   binary classifier highlighting whether the it is a
%                       periodic or aperiodic trial.
%
% Output:
% 
%           startR:     CPU time of the start of the response period.
%
%           endR:       CPU time of the end of the response period.
%
%           keyCode:    A 256-element logical array.  Each bit within the 
%                       logical array represents one keyboard key. If a key 
%                       is pressed, its bit is set, othewise the bit is 
%                       clear. To convert a keyCode to a vector of key  
%                       numbers use FIND(keyCode). To find a key's 
%                       keyNumber use KbName or KbDemo from the
%                       psychtoolbox package. keyCode is generated using
%                       the KbCheck() function.
%
% Example:
%
%           [startR, endR, keyCode] = L_ex22_presentresponse(1, w, 0.333, a, b, 4.00, c, d, e, f, g, h, 2.656, 1)
%
% m-files required:  ptb_onscreen_text.m
% Subfunctions:  ptb_onscreen_text()
% MAT-files required: WaitSecs(); Screen(); PsychPortAudio(); mod();
% KbCheck(); keyCode(); GetSecs();
%
% Author: David C Greatrex
% Work Address: Centre for Music and Science, Cambridge University
% email: dcg32@cam.ac.uk
% Website: http://www.davidgreatrex.com
% May 2015; Last revision: 08-may-2015
    
%------------- BEGIN CODE -------------- 
WaitSecs(IOI);    

%---------------------
% Check for pause and initialise keyboard:
%---------------------
[~, ~, keyCode2]=KbCheck(-1);  % Initialize KbCheck:
pause = 0;
if keyCode2(pause_key)==1
    % raise pause flag if pause key is being pressed
    pause = 1;    
end

[~, ~, keyCode]=KbCheck(-1);% Initialize KbCheck:

%---------------------
% Prepare screen
%---------------------
Screen('DrawTexture', w, img_tex{1}, [], img_loc{1}); % draw trial image

%---------------------
% Start sequence
%---------------------
[~,StartTime] = Screen('Flip', w, 0); % start trial

% 1.2 start all audio schedules simultaneously
%PsychPortAudio('Start', pa_click, [], (StartTime)); % present click
%PsychPortAudio('Start', pa_target, [], (StartTime + (IOI*3)));
PsychPortAudio('Start', pa_click, [], StartTime); % start pre mask - pa_mask
PsychPortAudio('Start', pa_target, [], StartTime); % start auditory sequence

%---------------------
% Close auditory handles
%---------------------
%PsychPortAudio('Stop', pa_click, 3); % close click handle
PsychPortAudio('Stop', pa_click, 3); % close pre mask handle -- pa_mask
PsychPortAudio('Stop', pa_target, 3); % close target handle

%---------------------
% End sequence
%---------------------
PsychPortAudio('Start', pa_click, [], (StartTime + count)); % start post mask

%---------------------
% Open response window
%---------------------
Screen('DrawTexture', w, img_tex{1}, [], img_loc{1}); % draw response graphic - periodic

if mod(subNo,2) == 0 % counter balance response keys using odd/even subNo
    Screen('DrawTexture', w, img_tex{2}, [], img_loc{2});
    Screen('DrawTexture', w, img_tex{3}, [], img_loc{3});
else
    Screen('DrawTexture', w, img_tex{3}, [], img_loc{2});
    Screen('DrawTexture', w, img_tex{2}, [], img_loc{3});
end    

%---------------------
% Record reaction times
%---------------------   
[~,startR] = Screen('Flip', w, (StartTime + 0.200 + count)); % start response time
EndTime=startR + maxResp; % define time out variable
[keyCode,startR,endR] = ml_reactiontime(keyCode, startR, maxResp, l_key, r_key); % Check for keyboard responses

%---------------------
% prepare screen for next trial
%--------------------- 
Screen('DrawTexture', w, img_tex{1}, [], img_loc{1}); % draw response graphic
Screen('Flip', w, StartTime);
 
%---------------------
% pause holding screen
%---------------------
if pause == 1;% Pause sequence if the letter p has been pressed
    disp('Taking a pause');
    message = 'Pause key has been pressed. \n\n Take a short break and then click to continue with the experiment';  % write block message
    ptb_onscreen_text (w, message);  % present block message - wait for click
    endR = GetSecs;
end

%---------------------
% Close auditory handles
%--------------------- 
PsychPortAudio('Stop', pa_click, 3); % close post mask handle - pa_mask

%------------- END OF CODE --------------