function sequence = ml_pdf_func(direction, abs_mu, sd, lbound, ubound, seq_length)
%ML_PDF_FUNC - Generates an array of X randomly sampled numbers taken from 
%a probability density function (PDF) with a prespecified mean and standard
%deviation (SD). The mean and SD of the returned array is within 0.01
%variance of that of the PDF function from which the array was sampled. All
%array values lie within the range specified by the lower and upper bound 
%inputs. The mean of the distribution can either be positive or
%negative as specified by 'sign' and the length of the sequence is governed 
%by 'seq_length'.
% 
% Syntax:  sequence = ml_pdf_func(sign, abs_mu, sd, lbound, ubound, seq_length)
%
% Input: 
%           sign:       positive or negative indicator for whether the mean
%                       of the PDF function is higher or lower than zero.
%
%           abs_mu:     the absoulte mean value of the required PDF.
%
%           sd:         the standard deviation of the required PFD.
%
%           lbound:     the lower bound of the sampled sequence.
%
%           ubound:     the upper bound of the sampled sequence.
%
%           seq_length: the length of the required output sequence
%
% Output:
% 
%           sequence:   an array containing a numerical sequence that
%                       matches the input sampling criteria.
%
% Example:
%
%           sequence = ml_pdf_func(-1, 0.10, 0.25, -1, 1, 8)
%
% m-files required: none
% Subfunctions: none
% MAT-files required: MAKEDIST(); PDF(); PLOT(); RANDOM(); MEAN(); STD()
%
% Author: David C Greatrex
% Work Address: Centre for Music and Science, Cambridge University
% email: dcg32@cam.ac.uk
% Website: http://www.davidgreatrex.com
% May 2015; Last revision: 27-oct-2015
% changes: plus values set to be 1/10 of mean and sd input - 27102015
    
%------------- BEGIN CODE -------------- 
mu = abs_mu*direction; %calculate mean

% define variance criteria for sequence selection
array_sd_var = 0.01;
array_mu_var = 0.01;
    
% generate probability distribution function - with mean mu and sd
pd = makedist('Normal', mu, sd);
x = lbound:.001:ubound;
pdf_normal = pdf(pd,x);
plot(x,pdf_normal,'LineWidth',2)

% generate distribution sequence
while true  
    % select 8 random numbers from probability density function
    for i = 1:seq_length; 
        pdf_seq(i) = random(pd); 
    end
    % repeat if sequence numbers are outside of decision information bound
    if min(pdf_seq) < lbound || max(pdf_seq) > ubound
        continue
    end
    % ensure sd of sequence is within variance criteria
    if std(pdf_seq) < (sd-array_sd_var) || std(pdf_seq) > (sd+array_sd_var);
        continue
    end   
    % ensure mean of sequence is within variance criteria
    if mean(pdf_seq) > (mu + array_mu_var) || mean(pdf_seq)  < (mu -  array_mu_var);
        continue
    end
    % sequence j meets criteria. Report result and return function.
    sequence = pdf_seq;
    disp(strcat('the mean is:', num2str(mean(pdf_seq))));
    disp(strcat('the sd is:', num2str(std(pdf_seq))));
    return
end
%------------- END OF CODE --------------