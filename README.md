#====================================================
# Title:       Experiment 2: Complex averaging and prior knowledge
# Author:      David Greatrex
# Last edited: 30/08/2017
#====================================================

# Overview:

Experiments 1 and 2 are designed to answer two specific research questions. The first question asks whether complex auditory-spatial averaging decisions are sensitive to temporal variability in the stimulus. As both experiments used the same task, this question applies to both studies.
The second question asks whether prior knowledge about the rhythmic variability of a stimulus enhances or inhibits the ability to make complex auditory-spatial averaging decisions. This was tested by randomising the order of trials in experiment 1, so that participants did not know whether a trial would contain a periodic or aperiodic sequence, and by providing explicit instructions about the timing of the sequence whilst blocking trials in experiment 2. 

On each trial participants listened to a tone sequence comprising 8 presentations of tone k, presented via headphone lateralisation at 8 different spatial locations bounded within a range from far left (-90 degree azimuth) to far right (+90 degree azimuth). Tone lateralisation was manipulated via both interaural intensity differences and interaural time differences. This was paired with an on-screen image marking the cardinal (-90 degree, 0 degree, +90 degree) and diagonal (-45 degree, +45 degree) spatial axes relative to the participant's midline. 
The sequence was preceded and followed by a click and presented either periodically, with fixed interonset intervals (IOI) of 333 ms (3 Hz), or aperiodically, with pseudo randomised IOIs between 200 ms and 500 ms. The latter resulted in a jittering unpredictable rhythm. 
Upon hearing the final click, participants judged whether the average orientation of the eight tones was closer to the cardinal or diagonal spatial axes. Participants made a forced binary response and received corrective feedback on each trial. The experiment contained no trials in which the average was exactly mid-way between both categories.

# Requirements:

MATLAB (MathWorks) - the program was build in version R2015b. Psychtoolbox3 (http://psychtoolbox.org/) - version 3.0.13 - Flavor: beta - Corresponds to SVN Revision 8038.

# Installation:

Clone the repository to a local folder and set MATLABs current directory to the selected folder. Ensure you change any hardcoded URLs within any of the main run files to match you computers directory structure. The main run files are called: 
 - a_practice_blocked
 - b_localisation_staircase
 - c_main_experiment_blocked

Each run file relates to a separate stage of the experimental procedure described in the experimental method.