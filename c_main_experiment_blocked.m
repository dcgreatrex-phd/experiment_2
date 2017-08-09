function c_main_experiment_blocked(subNo)

%------------- BEGIN CODE --------------

% Add the function folder to MATLAB path
addpath('./functions/') 

rhythm_type = 2;

%---------------------
% Variable definitions
%---------------------
format long;
text_size = 28; % default text size
IOI = 0.333; % duration of standard pulse IOI
mean_thresh = 0.52; % distribution mean threshold for detecting correct answer 75% of the time.
sd = 0.25; % sd deviation to cover the entire range of values

n_blocks = 8; % number of blocks
n_introbeats = 4; % number of introduction cue loops
n_target = 8; % number of target beats
keyone = 'c'; % response keys - cardinal
keytwo = 'm'; % response key - horizontal
pausekey = 'p'; % pause trigger key
response = 4.00; % maximum response time allowed

beep_dur = 0.200; %IOI - (IOI/20); % duration of all sine tone target notes IOI-0.050
feedback = 1; % give corrective feedback on each trial: 1 == YES; 0 == NO
feedback_dur = 0.100; % length of feedback tones
feedback_gap = 0.250; % duration between response and feedback tones
bonusamount = 0.50; % amount in pounds of the bonus increment

%---------------------
% path definitions
%---------------------
p_folder_in = strcat('input/'); % location of input P folder
p_folder_out = strcat('output/P_', num2str(subNo), '/'); % location of output P folder
n_outfiles = 1; % number of outfile required
input_periodic = strcat(p_folder_in,'trial_periodic.txt');
input_aperiodic = strcat(p_folder_in,'trial_aperiodic.txt');% full path of P trial direction file    
sound_folder = 'stimuli/sounds/'; % location of stimuli image folder
sound_files =  {'woodblock_200_fadooutlast10.wav', 'bclarinetb2.2.wav'}; % 'bclarinetb2.2.wav' ; 'oboebb3.2.wav' ; 
img_folder = 'stimuli/images/'; % location of stimuli image folder

%---------------------
% open result and log files
%--------------------- 
for i = 1:n_outfiles
    outfile{i} = strcat('output_p', num2str(subNo),'_',num2str(i),'.txt');
    outpath{i}= strcat(p_folder_out, outfile);
end
[check, datafilepointer(1)]=ml_open_outfiles_v1(p_folder_out, outfile{i}, 1);

if ~check; % end program if unable to open out files successfully
    return;
end   
% add headings to output files
fprintf(datafilepointer(1),'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n', ...  
    'sub_no','block','trialno', 'introbeats','n_targetbeats', 'IOI', 'trialtype', 'mean_threshold', 'sd', ...
    'rhythmic_flag', ...
    'DU1', 'DU2', 'DU3', 'DU4', 'DU5', 'DU6', 'DU7', 'DU8', ...
    'A1','A2','A3','A4','A5','A6','A7','A8',... 
    'IOI1-2','IOI2-3','IOI3-4','IOI4-5','IOI5-6','IOI6-7','IOI7-8',...
    'r_key', 'choice', 'correct', 'rt');

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
    % Load global images
    %---------------------
    img_loc{1} = ([xs-900/2, ys-((500/2)-150), xs+900/2, ys+((500/2)+150)]);
    img_loc{2} = ([((xs-50/2)-200), ys-((50/2)+250), ((xs+50/2)-200), ys+((50/2)-250)]);
    img_loc{3} = ([((xs-50/2)+200), ys-((50/2)+250), ((xs+50/2)+200), ys+((50/2)-250)]);
    img_loc{4} = ([xs-300/2, ys-(300/2), xs+300/2, ys+(300/2)]);
    img_loc{5} = ([(xs-150/2), ys-(150/2), xs+(150/2), ys+(150/2)]);
    img_tex = {};
    for i = 1:6;
        img=strcat(img_folder,strcat('pic_',num2str(i),'.jpg'));
        imdata=imread(char(img)); 
        img_tex{i}=Screen('MakeTexture', w, imdata);
    end 

    %---------------------
    % block loop:
    %---------------------  
    groupone = [1,3,5,7];
    bonus = 0;
    for block = 1:n_blocks;
        if rhythm_type == 1;
            if ismember(block, groupone);
                input_file = input_periodic;
                %---------------------
                % load trial information from file  
                %---------------------  
                % objnumber = assending integer index for input file rows 1->n
                % rhythmic = binary 1 or 0. 1 == the trial should contain varying rhythms. 0 == the trial should present tones isochronously.
                % type = either intergers 1 or -1: -1 = sequence belongs to the cardinal category, 1 = sequence belongs to the horizontal category   
                [objnumber,rhythmic,type] = textread(input_file,'%d %d %d');
                ntrials=length(objnumber); % get number of trials
                randomorder=randperm(ntrials); % random permiatations
                objnumber=objnumber(randomorder); % randomise input list
                rhythmic=rhythmic(randomorder);
                type=type(randomorder); 

                message = strcat(num2str(block),'\n\n The following sequences will be played with a \n\n PREDICTABLE BEAT \n\n\n click to start..');  % write block message
                ptb_onscreen_text (w, message);  % present block message - wait for click    
            else
                input_file = input_aperiodic;
                %---------------------
                % load trial information from file  
                %---------------------  
                % objnumber = assending integer index for input file rows 1->n
                % rhythmic = binary 1 or 0. 1 == the trial should contain varying rhythms. 0 == the trial should present tones isochronously.
                % type = either intergers 1 or -1: -1 = sequence belongs to the cardinal category, 1 = sequence belongs to the horizontal category   
                [objnumber,rhythmic,type] = textread(input_file,'%d %d %d');
                ntrials=length(objnumber); % get number of trials
                randomorder=randperm(ntrials); % random permiatations
                objnumber=objnumber(randomorder); % randomise input list
                rhythmic=rhythmic(randomorder);
                type=type(randomorder); 

                message = strcat(num2str(block),'\n\n The following sequences will be played with an \n\n UNPREDICTABLE BEAT \n\n\n click to start..');  % write block message
                ptb_onscreen_text (w, message);  % present block message - wait for click  
            end
        else
            if ismember(block, groupone);
                input_file = input_aperiodic;
                %---------------------
                % load trial information from file  
                %---------------------  
                % objnumber = assending integer index for input file rows 1->n
                % rhythmic = binary 1 or 0. 1 == the trial should contain varying rhythms. 0 == the trial should present tones isochronously.
                % type = either intergers 1 or -1: -1 = sequence belongs to the cardinal category, 1 = sequence belongs to the horizontal category   
                [objnumber,rhythmic,type] = textread(input_file,'%d %d %d');
                ntrials=length(objnumber); % get number of trials
                randomorder=randperm(ntrials); % random permiatations
                objnumber=objnumber(randomorder); % randomise input list
                rhythmic=rhythmic(randomorder);
                type=type(randomorder); 

                message = strcat(num2str(block),'\n\n The following sequences will be played with an \n\n UNPREDICTABLE BEAT \n\n\n click to start..');  % write block message
                ptb_onscreen_text (w, message);  % present block message - wait for click  
            else
                input_file = input_periodic;
                %---------------------
                % load trial information from file  
                %---------------------  
                % objnumber = assending integer index for input file rows 1->n
                % rhythmic = binary 1 or 0. 1 == the trial should contain varying rhythms. 0 == the trial should present tones isochronously.
                % type = either intergers 1 or -1: -1 = sequence belongs to the cardinal category, 1 = sequence belongs to the horizontal category   
                [objnumber,rhythmic,type] = textread(input_file,'%d %d %d');
                ntrials=length(objnumber); % get number of trials
                randomorder=randperm(ntrials); % random permiatations
                objnumber=objnumber(randomorder); % randomise input list
                rhythmic=rhythmic(randomorder);
                type=type(randomorder); 

                message = strcat(num2str(block),'\n\n The following sequences will be played with a \n\n PREDICTABLE BEAT \n\n\n click to start..');  % write block message
                ptb_onscreen_text (w, message);  % present block message - wait for click    
            end
        end

        %---------------------
        % trial loop:
        %---------------------
        b_a_array = [];
        for trial = 1:ntrials;

            Screen('DrawTexture', w, img_tex{1}, [], img_loc{1}); % draw response graphic - periodic
            Screen('Flip', w, 0); 

            %---------------------
            % assign trial variables, generate distribution values and create sound schedules:
            %---------------------                   

            % 1. proability density function tiltrated to participant 75% accuracy threshold
            DU =  ml_pdf_func(type(trial), mean_thresh, sd, -1, 1, n_target);

            %---------------------  
            % load sound files and slave channels:
            %---------------------  
            [~, pahandle_click, pabuffer_click, pahandle_sine, pabuffer_sine, pahandle_feedback, pa_noise, angle] = L_ex22_loadaudioslave(sound_folder, sound_files, beep_dur, DU);
            L_ex22_testangle(DU, angle);

            %---------------------
            % generate onset asychrony array
            %---------------------  
            onset_as = L_ex22_onsetasynchrony(rhythmic(trial), n_target);

            %---------------------
            % assign pahandles and pabuffers to trial specific sound schedules
            %---------------------
            [count, timegap] = L_ex22_audioschedules(IOI, n_introbeats, pahandle_click, pabuffer_click, pahandle_sine, pabuffer_sine, onset_as);

            %---------------------
            % trial presentation:
            %---------------------            
            [StartResponse, EndResponse, keyCode] = L_ex22_presentresponse2(subNo, w, IOI, pahandle_click, pahandle_sine,  pa_noise, response, c_keypress, h_keypress, pause_keypress, img_loc, img_tex, count, rhythmic(trial));

            %---------------------
            % compute response data
            %---------------------
            [t_resp, t_choice, t_rt] = L_ex22_compute_response(StartResponse, EndResponse, keyCode, keyone, keytwo);

            % calcualte response accuarcy and sound appropriate feedback tones.
            t_correct = L_ex22_feedback(type(trial), t_choice, pahandle_feedback(1), pahandle_feedback(2), EndResponse, feedback, feedback_gap, feedback_dur);

            %---------------------
            % save trial data
            %---------------------
            fprintf(datafilepointer(1),'%d %d %d %d %d %.3f %d %.4f %.4f %d %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %s %d %d %.3f \n', ...  
            subNo, block, objnumber(trial), n_introbeats, n_target, IOI, type(trial), mean_thresh, sd, ...
            rhythmic(trial), ...
            DU(1), DU(2), DU(3), DU(4), DU(5), DU(6), DU(7), DU(8),...
            angle(1),angle(2),angle(3),angle(4),angle(5),angle(6),angle(7),angle(8),...
            timegap(1),timegap(2),timegap(3),timegap(4),timegap(5),timegap(6),timegap(7),...  
            t_resp, t_choice, t_correct, t_rt);

            % append answer to block answer array
            b_a_array(end+1) = t_correct;

            %%% Clear screen textures and wait before starting a new trial
            Screen('DrawTexture', w, img_tex{1}, [], img_loc{1}); % draw response graphic - periodic
            Screen('Flip', w, EndResponse+feedback_gap+(feedback_dur*2));
            
        end

        % Roulette - select a random number length of b_a_array
        n = randi([1, length(b_a_array)]);
        if b_a_array(n) == 1;
            win = 1;
            bonus = bonus + bonusamount;
        else
            win = 0;
        end

        % present the particpant with the roulette answer
        Screen('DrawTexture', w, img_tex{4}, [], img_loc{4});
        message = strcat('End of the block \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Click to see if you won a bonus prize?');  % write block message
        DrawFormattedText(w, message, 'center','center', WhiteIndex(w));
        [~,StartRoulette] = Screen('Flip', w, 0);
        GetClicks();
        if win == 1;
            Screen('DrawTexture', w, img_tex{5}, [], img_loc{5});
            message = strcat('Yes - you have won a bonus of £', num2str(bonusamount), '\n\n\n\n\n\n\n\n\n\n\n\n Your total bonus prize winnings are : £', num2str(bonus), '\n\n Click to continue...');  % write block message
            DrawFormattedText(w, message, 'center', 'center', WhiteIndex(w));
            Screen('Flip', w, 0);
            GetClicks();
        else
            Screen('DrawTexture', w, img_tex{6}, [], img_loc{5});
            message = strcat('Not this time \n\n\n\n\n\n\n\n\n\n\n\n Your total bonus prize winnings are : £', num2str(bonus), '\n\n Click to continue...');  % write block message
            DrawFormattedText(w, message, 'center', 'center', WhiteIndex(w));
            Screen('Flip', w, 0);
            GetClicks();
        end
        
        if block == (n_blocks/2);
            message = strcat('Take a break! \n\n\n\n End of the experimental stage \n\n\n\n Click when instructed to do so...');  % write block message
            ptb_onscreen_text (w, message);  % present block message - wait for click    
        end            
    end
    

    
    fprintf(strcat('\n\n REWARD NOTIFICATION: DG - The participant needs to be paid a bonus reward of £', num2str(bonus), '\n\n'));

    %---------------------
    % clean up:
    %---------------------
    Screen('Flip', w, 0);
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