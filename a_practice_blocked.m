function a_practice_blocked(subNo)

%------------- BEGIN CODE --------------

% Add the function folder to MATLAB path
addpath('./functions/') 

rhythm_type = 1;

%---------------------
% Variable definitions
%---------------------
format long;
text_size = 28; % default text size
IOI = 0.333; % duration of standard pulse IOI
sd = 0.25; % sd deviation to cover the entire range of values

n_introbeats = 1; % number of introduction cue loops
n_target = 8; % number of target beats
keyone = 'c'; % response keys - cardinal
keytwo = 'm'; % response key - horizontal
pausekey = 'p'; % pause trigger key
response = 4.00; % maximum response time allowed

beep_dur = 0.200; %IOI - (IOI/20); % duration of all sine tone target notes IOI-0.050
feedback = 1; % give corrective feedback on each trial: 1 == YES; 0 == NO
feedback_tone = 0.100; % length of feedback tones
feedback_gap = 0.250; % duration between response and feedback tones


%---------------------
% path definitions
%--------------------- 
sound_folder = 'stimuli/sounds/'; % location of stimuli image folder
sound_files =  {'woodblock_200_fadooutlast10.wav', 'bclarinetb2.2.wav'}; % 'bclarinetb2.2.wav' ; 'oboebb3.2.wav' ; 
img_folder = 'stimuli/images/'; % location of stimuli image folder

%---------------------
% Experimental code:
%---------------------   
try        
    %---------------------
    % screen set up:
    %---------------------     
    ptb_screen_setup() % prepare MATLAB for ptb
    [~, w, wRect, ~] = ptb_open_screen(text_size); % open a new experimental window
    [~, ~] = Screen('WindowSize', w); % max x and y screen pixels
    [xs,ys] = RectCenter(wRect); % coordinates for screen mid point
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % Enable Alpha blending
    if mod(subNo,2)== 0
        c_keypress=KbName(keyone); % assign response key 1
        h_keypress=KbName(keytwo); % assign response key 2
    else
        keyone = 'm'; % cardinal
        keytwo = 'c'; % horizontal
        c_keypress=KbName(keyone); % assign response key 1
        h_keypress=KbName(keytwo); % assign response key 2
    end
    pause_keypress=KbName(pausekey);
    GetSecs; % initiate timing functions
    WaitSecs(1);

    %---------------------
    % Load universal images
    %---------------------
    img_loc{1} = ([xs-900/2, ys-((500/2)-150), xs+900/2, ys+((500/2)+150)]);
    img_loc{2} = ([((xs-50/2)-200), ys-((50/2)+250), ((xs+50/2)-200), ys+((50/2)-250)]);
    img_loc{3} = ([((xs-50/2)+200), ys-((50/2)+250), ((xs+50/2)+200), ys+((50/2)-250)]);
    img_tex = {};
    for i = 1:3;
        img=strcat(img_folder,strcat('pic_',num2str(i),'.jpg'));
        imdata=imread(char(img)); 
        img_tex{i}=Screen('MakeTexture', w, imdata);
    end   
    
    %---------------------
    % trial loop:
    %---------------------
        
    %message = strcat('Click to begin the practice trials');  % write block message
    %ptb_onscreen_text (w, message);  % present block message - wait for click  
    
    per_reverse = [];
    aper_reverse = [];
    mean_thresh = 0.50;
    t_correct = 2;
    for trial = 1:80;
        
        if trial == 18
            message = strcat('Hows it going? Do you have any questions? \n\n\n click to continue..');  % write block message
            ptb_onscreen_text (w, message);  % present block message - wait for click  
        end
            
        % set trial type
        if (randi([1 2],1,1)) == 1;
            trial_type = 1;
        else
            trial_type = -1;
        end

        if rhythm_type == 1;
            if trial <=40;
                rhythmic = 0;
            else
                rhythmic = 1;
            end
            if trial == 1;
                L_ex22_auditory_sweep(subNo, w, img_tex, img_loc);
                message = strcat('The sequence will now be played with a \n\n PREDICTABLE BEAT \n\n click to start..');  % write block message
                ptb_onscreen_text (w, message);  % present block message - wait for click  
            elseif trial == 18;
                L_ex22_auditory_sweep(subNo+1, w, img_tex, img_loc);     
            elseif trial == 41;
                L_ex22_auditory_sweep(subNo, w, img_tex, img_loc);   
                message = strcat('The sequence will now be played with an \n\n UNPREDICTABLE BEAT \n\n click to start..');  % write block message
                ptb_onscreen_text (w, message);  % present block message - wait for click
            elseif trial == 57
                L_ex22_auditory_sweep(subNo+1, w, img_tex, img_loc);   
            end
        else
            if trial <=40;
                rhythmic = 1;
            else
                rhythmic = 0;
            end
            if trial == 1;
                message = strcat('The sequence will now be played with an \n\n UNPREDICTABLE BEAT\n\n click to start..');  % write block message
                ptb_onscreen_text (w, message);  % present block message - wait for click  
            elseif trial == 18;
                L_ex22_auditory_sweep(subNo, w, img_tex, img_loc);  
            elseif trial == 41;
                L_ex22_auditory_sweep(subNo, w, img_tex, img_loc);
                message = strcat('The sequence will now be played with a \n\n PREDICTABLE BEAT\n\n click to start..');  % write block message
                ptb_onscreen_text (w, message);  % present block message - wait for click  
            elseif trial == 57
                L_ex22_auditory_sweep(subNo, w, img_tex, img_loc); 
            end
        end
        
        % set mean threshold randomly between range
        %mean_thresh = (0.50-0.10).*rand(1,1) + 0.10;
        if trial < 18;
            if t_correct == 1;
                mean_thresh = mean_thresh - 0.02;
            elseif t_correct == 0;
                mean_thresh = mean_thresh + 0.02;
            end
        elseif trial < 41;
            if t_correct == 1;
                if last_t_correct ~= 2 && last_t_correct ~= t_correct;
                    per_reverse(end+1) = mean_thresh;
                end
                mean_thresh = mean_thresh - 0.02;
            elseif t_correct == 0;
                if last_t_correct ~= 2 && last_t_correct ~= t_correct;
                    per_reverse(end+1) = mean_thresh;
                end
                mean_thresh = mean_thresh + (0.02)*3;
            end
        elseif trial < 57;
            if t_correct == 1;
                mean_thresh = mean_thresh - 0.02;
            elseif t_correct == 0;
                mean_thresh = mean_thresh + 0.02;
            end
        else
            if t_correct == 1;
                if last_t_correct ~= 2 && last_t_correct ~= t_correct;
                    aper_reverse(end+1) = mean_thresh;
                end
                mean_thresh = mean_thresh - 0.02;
            elseif t_correct == 0;
                if last_t_correct ~= 2 && last_t_correct ~= t_correct;
                    per_reverse(end+1) = mean_thresh;
                end
                mean_thresh = mean_thresh + (0.02*3);
            end
        end
            
        if mean_thresh < 0.04;
            mean_thresh = 0.07;
        elseif mean_thresh > 0.68
            mean_thresh = 0.65;
        end
        if trial == 41;
            mean_thresh = 0.50;
        end
        fprintf(strcat('The last correct value was :', num2str(t_correct),'\n\n')); 
        fprintf(strcat('The mean is :', num2str(mean_thresh), '\n\n')); 
        

        Screen('DrawTexture', w, img_tex{1}, [], img_loc{1}); % draw response graphic
        Screen('Flip', w, 0);
        
        %---------------------
        % assign trial variables, generate distribution values and create sound schedules:
        %---------------------                   

        % 1. proability density function tiltrated to participant 75% accuracy threshold
        DU =  ml_pdf_func(trial_type, mean_thresh, sd, -1, 1, n_target);

        %---------------------  
        % load sound files and slave channels:
        %---------------------  
        [~, pahandle_click, pabuffer_click, pahandle_sine, pabuffer_sine, pahandle_feedback, pa_noise, angle] = L_ex22_loadaudioslave(sound_folder, sound_files, beep_dur, DU);
        L_ex22_testangle(DU, angle);

        %---------------------
        % generate onset asychrony array
        %---------------------  
        onset_as = L_ex22_onsetasynchrony(rhythmic, n_target);

        %---------------------
        % 2. assign pahandles and pabuffers to trial specific sound schedules
        %---------------------
        count = L_ex22_audioschedules(IOI, n_introbeats, pahandle_click, pabuffer_click, pahandle_sine, pabuffer_sine, onset_as);

        %---------------------
        % trial presentation:
        %---------------------            
        [StartResponse, EndResponse, keyCode] = L_ex22_presentresponse2(subNo, w, IOI, pahandle_click, pahandle_sine, pa_noise, response, c_keypress, h_keypress, pause_keypress, img_loc, img_tex, count, rhythmic);

        %---------------------
        % compute response data
        %---------------------
        [~, t_choice, ~] = L_ex22_compute_response(StartResponse, EndResponse, keyCode, keyone, keytwo);

        % calcualte response accuarcy and sound appropriate feedback tones.
        last_t_correct = t_correct;
        t_correct = L_ex22_feedback(trial_type, t_choice, pahandle_feedback(1), pahandle_feedback(2), EndResponse, feedback, feedback_gap, feedback_tone);

        %%% Clear screen textures and wait before starting a new trial
        Screen('DrawTexture', w, img_tex{1}, [], img_loc{1}); % draw response graphic - periodic       
        Screen('Flip', w, EndResponse+feedback_gap+(feedback_tone*2));
    end
    
    L_ex22_auditory_sweep(subNo, w, img_tex, img_loc)
    Screen('Close', [img_tex{1}, img_tex{2}, img_tex{3}]);

    disp(per_reverse);
    fprintf(strcat('\n\n MEAN  PERIODIC PRACTICE THRESHOLD : ', num2str(mean(per_reverse)), '\n\n'));
    disp(aper_reverse);
    fprintf(strcat('\n\n MEAN  APERIODIC PRACTICE THRESHOLD : ', num2str(mean(aper_reverse)), '\n\n\n\n\n\n\n\n\n\n\n\n\n\n'));

    %---------------------
    % clean up:
    %---------------------
    Screen('Flip', w, 0);
    GetClicks();
    PsychPortAudio('Close');
    ptb_cleanup ()
    clear all     
catch

    % Echo error message and exit
    psychrethrow(psychlasterror); 
    ptb_cleanup ()
    clear all       
end 
%------------- END OF CODE --------------