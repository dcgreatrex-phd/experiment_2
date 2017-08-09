function [pamaster, pa_click, pabuf_click, pa_target, pabuf_target, pa_feedback, pa_mask, angle] = L_ex22_loadaudioslave(sound_folder, sound_files, beep_dur, DU)
%L_EX22_LOADAUDIOSLAVE - an experimental script that completes the
%following procedures: 1) extracts audio data from an array of audio files.
%2) Opens a master psychportaudio handle and sub slave handles and adjusts
%channel volumes. 3)Fills slave buffers with required audio sounds being used
%throughout the experiment. 4) Calculates angle from an input Decision
%Update (DU) array. 5) Loads audio tones with specific localisation
%parameters. 6) Creates a mask stimulus.
% 
% Syntax:  [check, datafilepointer]=ptb_open_outfiles(outfolder, outfile, log)
%
% Input: 
%           soundfolder:  folder on local machine in which the sound files
%                         being used in the experiment are saved.
%
%           sound_files:  a string array of the names of each audio file
%                         being used in the experiment.
%
%           beep_dur:     the duration of the tones used in the mask
%                         stimulus.
%
%           targetfreq:   the frequency of the tones being used in the mask
%                         stimulus.
%
%           DU:           an array of numerical values indicating the
%                         amount of decision update information that each 
%                         of the target sequence tones contain.
%
% Output:
% 
%           pamaster:     handle of the master audio psychportaudio track.
%
%           pa_click:     handle of the click track slave channel.
%
%           pa_target:    handle of the target seqeunce slave channel.
%
%           pabuf_target: buffer of the target sequence slave channel.
%
%           pa_feedback:  handle of the feedback tone slave channel.
%
%           pa_mask:      handle of the mask stimulus slave.
%
%           angle:        array containing all of the calculated angles
%                         corresponding to the decision update (DU) array.
%
% Example:
%
%           [a,b,c,d,e,f,g] = L_ex22_loadaudioslave('output/sound/',['sound1.wav','sound2.wav'], 0.200, 125,[0.1,0.22,-0.32,0.43])
%
% m-files required: ptb_extractaudiodata.m; ptb_open_audiomaster.m; ml_gentone.m; ml_IID_ITD_HRTF.m;  
% Subfunctions: ptb_extractaudiodata(); ptb_open_audiomaster(); ml_gentone(); ml_IID_ITD_HRTF();
% MAT-files required: length(); PsychPortAudio(); round(); 
%
% Author: David C Greatrex
% Work Address: Centre for Music and Science, Cambridge University
% email: dcg32@cam.ac.uk
% Website: http://www.davidgreatrex.com
% May 2015; Last revision: 07-may-2015
    
%------------- BEGIN CODE --------------     

%---------------------
% load wav files
%---------------------
for i = 1:length(sound_files)
    wave{i} = ptb_extractaudiodata(sound_folder, sound_files{i}); % extract wave and channel data into cell array
end

%---------------------
% initialse master audio handle
%---------------------
[pamaster, freq] = ptb_open_audiomaster(); % master handle
PsychPortAudio('Volume', pamaster, 0.5);

disp(freq);

%---------------------
% open slave handles
%--------------------- 
pa_click = PsychPortAudio('OpenSlave', pamaster, 1); % click slave
PsychPortAudio('Volume', pa_click, 0.5);
pa_target = PsychPortAudio('OpenSlave', pamaster, 1); % sine tone slave
PsychPortAudio('Volume', pa_target, 0.3);
pa_mask = PsychPortAudio('OpenSlave', pamaster, 1); % mask tone slave
PsychPortAudio('Volume', pa_mask, 0.1);


for i = 1:2; % feedback slaves
    pa_feedback(i) = PsychPortAudio('OpenSlave', pamaster, 1); 
    PsychPortAudio('Volume', pa_feedback(i), 0.3);
end 

%---------------------
% load sounds - click track
%---------------------
pabuf_click = PsychPortAudio('CreateBuffer', [], wave{1}); % load click sound
PsychPortAudio('FillBuffer', pa_click, pabuf_click);

%---------------------
% load sounds - feedback track
%---------------------
feedback_low = ml_gentone(400, 0.100, freq, 1);% generate tones
feedback_low = [feedback_low ; feedback_low];
feedback_high = ml_gentone(800, 0.100, freq, 1);
feedback_high = [feedback_high ; feedback_high];

pabuf_feedback(1) = PsychPortAudio('CreateBuffer', [], feedback_low);% load feedback sounds
pabuf_feedback(2) = PsychPortAudio('CreateBuffer', [], feedback_high);
PsychPortAudio('FillBuffer', pa_feedback(1), pabuf_feedback(1)); 
PsychPortAudio('FillBuffer', pa_feedback(2), pabuf_feedback(2));

%---------------------
% load sounds - target tone sequence
%---------------------
sinesound = {};
leftout = 0; rightout = 0; inner = 0;
for i = 1:length(DU); 

    dir = randi(2,1); % randomly select side of central fixation - 1 = left side 2 = right side
    seg = randi(2,1); % randomly select outer or inner segment - 1 = outer 2 = inner

    % raise flag when an area segment has been selected
    if dir == 1 && seg == 1 && leftout == 0; % left outer
        leftout = 1;
    elseif dir == 2 && seg == 1 && rightout == 0; % right outer
        rightout = 1;
    elseif dir == 1 && seg == 2 && inner == 0; % inner (either left or right inner segments)
        inner = 1;
    end

    % stop tones being assigned to more than two of the horizontal segments in one trial
    if DU(i) >= 0 && leftout == 1 && rightout == 1
        if seg == 2;
            seg = 1;
        end
    elseif DU(i) >= 0 && leftout == 1 && inner == 1
        if dir == 2 && seg == 1
            dir = 1;
        end
    elseif DU(i) >= 0 && rightout == 1 && inner == 1
        if dir == 1 && seg == 1
            dir = 2;
        end
    end

    % calcualate angles associated with DU values
    if dir == 1 % sound on left side of head
        if seg == 1 % outer segment
            r = 45/2;
            a = r/100; % angle for 1% du change
            a_change = (DU(i)*100)*a; % change in angle
            angle(i) = (67.5 + a_change)*-1;

        else % inner segment                
            r = 45/2;
            a = r/100; % angle for 1% du change
            a_change = (DU(i)*100)*a; % change in angle
            angle(i) = (22.5 - a_change)*-1;

        end
        % create sound file
        sinesound{i} = ml_IID_ITD_HRTF(angle(i), wave{2}', freq);

    else % sound on right side of head
        if seg == 1 % outer segment  
            r = 45/2;
            a = r/100; % angle for 1% du change
            a_change = (DU(i)*100)*a; % change in angle
            angle(i) = 67.5 + a_change;

        else % inner segment       
            r = 45/2;
            a = r/100; % angle for 1% du change
            a_change = (DU(i)*100)*a; % change in angle
            angle(i) = 22.5 - a_change;

        end
        % create sound file
        sinesound{i} = ml_IID_ITD_HRTF(angle(i), wave{2}', freq);
    end 

    % round angle to 4 decimal points
    angle = round(angle * 10000) / 10000;

    pabuf_target(i) = PsychPortAudio('CreateBuffer', [], sinesound{i}); 
    PsychPortAudio('FillBuffer', pa_target, pabuf_target(i));  
end   

%---------------------
% create sequence masks
%--------------------- 
mask = ml_noise(beep_dur,freq,1);
pabuf_noise = PsychPortAudio('CreateBuffer', [], mask);
PsychPortAudio('FillBuffer', pa_mask, pabuf_noise);

%------------- END OF CODE --------------