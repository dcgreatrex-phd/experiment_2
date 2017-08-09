function b_localisation_staircase(subNo)

%------------- BEGIN CODE --------------

% Add the function folder to MATLAB path
addpath('./functions/') 

%---------------------
% Variable definitions
%---------------------
format long;
text_size = 28; % default text size
IOI = 0.333; % duration of standard pulse IOI
sd = 0.25; % standard deviation of probability density function

n_introbeats = 4; % number of introduction cue loops
n_target = 8; % number of target beats
keyone = 'c'; % response keys - cardinal
keytwo = 'm'; % response key - horizontal
pausekey = 'p'; % pause trigger key
response = 4.00; % maximum response time allowed

beep_dur = 0.200; %IOI - (IOI/10); % duration of all sine tone target notes IOI-0.050
feedback = 1; % give corrective feedback on each trial: 1 == YES; 0 == NO
feedback_tone = 0.100; % length of feedback tones
feedback_gap = 0.250; % duration between response and feedback tones


%---------------------
% path definitions
%---------------------
p_folder_out = strcat('output/P_', num2str(subNo), '/'); % location of output P folder  
n_outfiles = 2; % number of outfile required
sound_folder = 'stimuli/sounds/'; % location of stimuli image folder
sound_files =  {'woodblock_200_fadooutlast10.wav', 'bclarinetb2.wav'}; % 'bclarinetb2.wav' ; 'oboebb3.2.wav'
img_folder = 'stimuli/images/'; % location of stimuli image folder

%---------------------
% open result and log files
%--------------------- 
for i = 1:n_outfiles
    outfile{i} = strcat('staircase_p', num2str(subNo),'_',num2str(i),'.txt');
end
% open outfiles
[check1, datafilepointer(1)]=ml_open_outfiles_v1(p_folder_out, outfile{1}, 1);
[~, datafilepointer(2)]=ml_open_outfiles_v1(p_folder_out, outfile{2}, 0);
if ~check1; % end program if unable to open out files successfully
    return;
end

% add headings to outfiles
fprintf(datafilepointer(1),'%s %s %s %s %s %s %s %s %s %s %s %s %s\n', ...  
    'subNo','trial_no','trial_type','mean_thresh', 'sd', 't_resp','t_choice','t_correct','t_rt','reversals','low_flag','high_flag','finish');

fprintf(datafilepointer(2),'%s %s %s %s\n', ...  
        'sub_no','trial_no','reversals','threshold');

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
    for i = 1:5;
        img=strcat(img_folder,strcat('pic_',num2str(i),'.jpg'));
        imdata=imread(char(img)); 
        img_tex{i}=Screen('MakeTexture', w, imdata);
    end   

    %---------------------
    % trial loop:
    %---------------------
    rhythmic=0;
    trial_no_total = 1;
    trial_type = 0;
    trial_type_count = 0;
    step_unit = 0.02;
    start = 1;
    start_value = 0.70;
    mean_thresh = 0;
    t_correct = 0;
    step_direction = 0;
    reversals = 0;
    low_flag = 0;
    high_flag = 0;
    
    L_ex22_auditory_sweep(subNo, w, img_tex, img_loc);
    message = strcat('Click to start..');  % write block message
    ptb_onscreen_text (w, message);  % present block message - wait for click  

    while true
            
        %---------------------            
        % assign trial type depending on experimental criteria
        %---------------------     
        trial_type_old = trial_type; % 1 - get previous trial type number 
        [trial_type, trial_type_count] = L_ex22_staircase_trialtype(trial_type_old, trial_type_count); % run the trial type generator and checks

        %---------------------
        % assign staircase onset value
        %---------------------                
        [mean_thresh,step_direction,reversals,start,finish,low_flag,high_flag] = L_ex22_oneupthreedown(start_value, step_unit, start, trial_no_total, mean_thresh, t_correct, step_direction, reversals, low_flag, high_flag);
        if finish == 1
            break
        end

        Screen('DrawTexture', w, img_tex{1}, [], img_loc{1});           
        Screen('Flip', w);

        %---------------------
        % assign trial variables, generate distribution values and create sound schedules:
        %---------------------                      
        if mean_thresh >= 0.70;
            sd = 0.12;
        else
            sd = 0.25;
        end
        % 1. proability density function tiltrated to participant 75% accuracy threshold
        DU = ml_pdf_func(trial_type, mean_thresh, sd, -1, 1, n_target);

        %---------------------  
        % load sound files and slave channels:
        %---------------------  
        [~, pabuffer_click, pahandle_click, pahandle_sine, pabuffer_sine, pahandle_feedback, pa_noise, angle] = L_ex22_loadaudioslave(sound_folder, sound_files, beep_dur, DU);
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
        [StartResponse, EndResponse, keyCode] = L_ex22_presentresponse(subNo, w, IOI, pahandle_click, pahandle_sine, pa_noise, response, c_keypress, h_keypress, pause_keypress, img_loc, img_tex, count, rhythmic);

        %---------------------
        % compute response data
        %---------------------
        [t_resp, t_choice, t_rt] = L_ex22_compute_response(StartResponse, EndResponse, keyCode, keyone, keytwo);

        %---------------------
        % calcualte response accuarcy and sound appropriate feedback tones.
        %---------------------
        t_correct = L_ex22_feedback(trial_type, t_choice, pahandle_feedback(1), pahandle_feedback(2), EndResponse, feedback, feedback_gap, feedback_tone);

        %---------------------
        % save trial data
        %---------------------
        fprintf(datafilepointer(1),'%d %d %d %.4f %.4f %s %d %d %.4f %d %d %d %d\n', ...  
        subNo, trial_no_total, trial_type, mean_thresh, sd, t_resp, t_choice, t_correct, t_rt, reversals, low_flag, high_flag, finish);

        %%% Clear screen textures and wait before starting a new trial
        trial_no_total = trial_no_total + 1;
        Screen('DrawTexture', w, img_tex{1}, [], img_loc{1});
        Screen('Flip', w, EndResponse+feedback_gap+(feedback_tone*2));       
    end

    Screen('Close', [img_tex{1}, img_tex{2}, img_tex{3}]);
    
    %---------------------
    % calcualate threshold value, plot and save charts
    %---------------------
    threshold = L_ex22_threshold(subNo, p_folder_out, outfile{1});
    fprintf(datafilepointer(2),'%d %d %d %.4f \n', ...  
        subNo, trial_no_total, reversals, threshold);

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