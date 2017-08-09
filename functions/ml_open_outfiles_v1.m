function [check, datafilepointer]=ml_open_outfiles(outfolder, outfile, log)
%ML_OPEN_OUTFILES - Opens an output folder and writable files with an option
%for a log file. The function checks whether an output folder already
%exists and if not, opens one. It then checks whether the requested output 
%file exists and opens a writable file if not. If a log is requested, an 
%a log file is opened and set to record all MATLAB terminal output using 
%the diary function - DIARY(). A warning is thrown if the outfile 
%already exists. The function returns a boolean check stating whether 
%the operation was successful or not as well as a file handler associated 
%with the new outfile.
% 
% Syntax:  [check, datafilepointer]=ptb_open_outfiles(outfolder, outfile, log)
%
% Input: 
%           outfolder:  full path extension from the current working 
%                       directory to the folder containing the requested 
%                       outfile. The path should finish with '/'.
%
%           outfile:    name of the output file. This should be a string 
%                       and contain the file extension.
%
%           log:        a binary variable [0 or 1] indicating whether a log
%                       file should also be made in the same directory path.
%
% Output:
% 
%           check:      boolean [TRUE/FALSE] response indicating whether 
%                       the operation to open the requested file was 
%                       successful or not. TRUE == successful; FALSE == not 
%                       successful.
%
%           datafilepointer:    file handler to be used by fprintf() when
%                               writing data to the new outfile.
%
% Example:
%
%           [check,datafilepointer]=ptb_open_outfiles('output/ex_2_2_localisation/',
%           'file.txt', 1) % open an outfile with accompanying log file.
%
% m-files required: ml_file_check.m; ml_create_file.m
% Subfunctions: ml_file_check(); ml_create_file();
% MAT-files required: none
%
% Author: David C Greatrex
% Work Address: Centre for Music and Science, Cambridge University
% email: dcg32@cam.ac.uk
% Website: http://www.davidgreatrex.com
% May 2015; Last revision: 07-may-2015
    
%------------- BEGIN CODE -------------- 
outpath= strcat(outfolder, outfile); %concatenate the full outfile path

if ml_file_check(outfolder)==false;
    % create outfolder if it does not exist
    mkdir(outfolder)
end
if ml_file_check(outpath);
    % throw exception and exit if output file exists      
    warningMessage = sprintf(strcat('Warning: the output file ', outpath ,'\n\n already exists. \n\n Danger of over writing existing data!:\n\n %s', fullfile(cd, outpath)));
    uiwait(msgbox(warningMessage));
    check = false;
    datafilepointer = 0;
    return;
else
    [datafilepointer] = ml_create_file(outpath); % open writable result file
    if log == 1
        logpath = strcat(outfolder, strcat('log_',outfile));
        ml_create_file(logpath); % open writable log file
        diary(logpath);
    end
end
check = true;
return;
%------------- END OF CODE --------------