function L_ex22_auditory_sweep(subNo, w, img_tex, img_loc, notext)

if nargin < 5 % set default sampling freq
    notext = 0;
end

sound_folder = 'stimuli/sounds/'; % location of stimuli image folder
sound_files =  {'woodblock_200_fadooutlast10.wav', 'bclarinetb2.2.wav'}; % 'bclarinetb2.2.wav' ; 'oboebb3.2.wav' ; 
IOI = 0.333;
keyone = 'y'; % response keys - cardinal
keytwo = 'n'; % response key - horizontal
y_keypress=KbName(keyone); % assign response key 1
n_keypress=KbName(keytwo); % assign response key 2

[~, ~, keyCode]=KbCheck(-1);% Initialize KbCheck:
%---------------------
% start audio handle
%---------------------
[sweepmaster, freq] = ptb_open_audiomaster(); % master handle
PsychPortAudio('Volume', sweepmaster, 0.5);

%---------------------
% load wav files
%---------------------
wave = ptb_extractaudiodata(sound_folder, sound_files{2}); % extract wave and channel data into cell array

%---------------------
% open slave handles
%--------------------- 
pa_sweep = PsychPortAudio('OpenSlave', sweepmaster, 1); % sine tone slave
PsychPortAudio('Volume', pa_sweep, 0.3);

%---------------------
% load sweep handles
%---------------------
if mod(subNo,2) == 0;
    angle = [0,0,-45,-45,45,45,-90,-90,90,90];
else
    angle = [0,0,45,45,-45,-45,90,90,-90,-90];
end
    
for i = 1:length(angle);
    sinesound{i} = ml_IID_ITD_HRTF(angle(i), wave', freq);
    pabuf_sweep(i) = PsychPortAudio('CreateBuffer', [], sinesound{i}); 
    PsychPortAudio('FillBuffer', pa_sweep, pabuf_sweep(i));
end

%---------------------
% assign sweep to an audio schedule
%---------------------
pause = [3,5,7,9];
cmdCode = -(1 + 16); % set AddToSchedule special command to ensure accurate timing presentation
PsychPortAudio('UseSchedule', pa_sweep, 1);
for i = 1:length(pabuf_sweep)
    if ismember(i,pause)
        PsychPortAudio('AddToSchedule', pa_sweep, cmdCode, 0.500);
        PsychPortAudio('AddToSchedule', pa_sweep, pabuf_sweep(i));
    else
        PsychPortAudio('AddToSchedule', pa_sweep, cmdCode, IOI);
        PsychPortAudio('AddToSchedule', pa_sweep, pabuf_sweep(i)); 
    end
end      

%---------------------
% Present welcome message
%---------------------
if notext == 0;
    message = strcat('Click to hear sounds on each axis');  % write block message
    ptb_onscreen_text (w, message);  % present block message - wait for click  
end

%---------------------
% Prepare screen
%---------------------
Screen('DrawTexture', w, img_tex{1}, [], img_loc{1}); % draw trial image

%---------------------
% Start sequence
%---------------------
[~,StartTime] = Screen('Flip', w, 0); % start trial

%---------------------
% play audio schedule
%---------------------
PsychPortAudio('Start', pa_sweep, [], 0); % start auditory sequence

%---------------------
% Close auditory handles
%---------------------
PsychPortAudio('Stop', pa_sweep, 3); % close target handle
