function [seq_dur, timegap] = L_ex22_audioschedules(IOI, n_intro, pa_click, pabuf_click, pa_target, pabuf_target, onset_as)
%L_EX22_AUDIOSCHEDULES - Experimental script assigning click and target
%tones to separate audio schedules that can then be used to present
%accurately timed tone onsets as per the trial requirement.
% 
% Syntax:  seq_dur = L_ex_22_audioschedules(IOI, n_intro, pabuf_click, pa_click, pa_target, pabuf_target, onset_as)
%
% Input: 
%
%           IOI:            IOI of the periodic sequence in seconds.
%
%           n_intro:        number of intro beats prior to sequence start.
%
%           pa_click:       audio handle for the click tones.
%
%           pabuf_click:    audio buffer for the click tones.
%
%           pa_target:      audio handle for the target tones.
%
%           pa_target:      audio buffer for the target tones.
%
%           onset_as:       array containing onset asynchrony values that
%                           need to be added to the target sequence whilst 
%                           constructing the target audio schedule.
%
% Output:
% 
%           seq_dur:        length in seconds for how long the entire 
%                           target sequence lasts.
%
% Example:
%
%           seq_dur = L_ex_22_audioschedules(0.333, 4, a, b, c, d, [0,0,0,0,0,0,0,0])
%
% m-files required: none
% Subfunctions: none
% MAT-files required: PsychportAudio(); lenght();
%
% Author: David C Greatrex
% Work Address: Centre for Music and Science, Cambridge University
% email: dcg32@cam.ac.uk
% Website: http://www.davidgreatrex.com
% May 2015; Last revision: 08-may-2015
    
%------------- BEGIN CODE -------------- 
cmdCode = -(1 + 16); % set AddToSchedule special command to ensure accurate timing presentation
   
%---------------------
% assign click sequence to an audio schedule
%---------------------  
% PsychPortAudio('UseSchedule', pa_click, 1);
% for i = 1:((n_intro+8)/2);            
%     if i == 1;
%         PsychPortAudio('AddToSchedule', pa_click, pabuf_click);
%     else
%         PsychPortAudio('AddToSchedule', pa_click, cmdCode, IOI*2);
%         PsychPortAudio('AddToSchedule', pa_click, pabuf_click);
%     end
% end    

%---------------------
% assign target tone sequence to an audio schedule
%---------------------
PsychPortAudio('UseSchedule', pa_target, 1);
seq_dur = 0;
timegap = [];
for i = 1:length(pabuf_target)
    if i == 1 % assign onset asychrony to each of the target sequence values
        PsychPortAudio('AddToSchedule', pa_target, cmdCode, (IOI + onset_as(i)));
        PsychPortAudio('AddToSchedule', pa_target, pabuf_target(i));
        seq_dur = seq_dur + (IOI + onset_as(i));
    else
        PsychPortAudio('AddToSchedule', pa_target, cmdCode, (IOI - onset_as(i-1) + onset_as(i)));
        PsychPortAudio('AddToSchedule', pa_target, pabuf_target(i));
        seq_dur = seq_dur + (IOI - onset_as(i-1) + onset_as(i));
        timegap(end+1) = IOI + onset_as(i);
    end
end
PsychPortAudio('AddToSchedule', pa_target, cmdCode, IOI);
seq_dur = seq_dur + IOI;
%------------- END OF CODE --------------