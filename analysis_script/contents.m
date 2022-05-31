% contents of analysis script folder
% (only matlab files included)
%
% for more information on each function type help [function]
%
%% behavioral
% main							          - to run behavioral analysis
% analyzePL						        - behaviroal analysis of procedural learning task
% analyzeOLA					        - behaviroal analysis of encoding and retrieval session of object location association task
% plotPL						          - MRTs of pattern vs. random trials are plotted
%
%% fmri
% main 							          - to run fmri data analysis
% signalChange 					      - obtain percentage of signal change for all substance groups in a region of interest
% preprocess					        - preprocessing steps for all tasks are completed
% preprocesPL					        - preprocessing steps for procedural learning task
% preprocessOLA_E				      - preprocessing stepts for encoding of OLA task
% preprocessOLA_R				      - preprocessing stepts for retrieval of OLA task
% PL_1stlevel_PATonly			    - first-level analysis of PL task
% PL_fullfactorial				    - second-level analysis of PL task, fullfactorial model
% PL_anova						        - second-level analysis of PL task, ANOVA
% OLA_E_1stlevel				      - first-level analysis of OLA encoding phase
% OLA_E_fullfactorial			    - second-level analysis of OLA encoding phase, fullfactorial model
% OLA_R_1stlevel				      - first-level analysis of OLA retrieval phase
% OLA_R_fullfactorial			    - second-level analysis of OLA retrieval phase, fullfactorial model
% OLA_anova						        - second-level analysis of OLA task, ANOVA for both phases
%
%% utils
% importPaths					        - setup paths of folder structure and import them to other functions
% list_vp_names					      - get all VP names (subject ids) from data folder
% addMedicationList				    - load in substance group list for subjects
% createROI						        - saves a copy of all .nii files in a folder structure as roi pointlist
% getROI						          - prompts user to select a ROI for analysis
% displayResults				      - display results of second-level analyses with options for thresholds and masking
% barwitherr					        - extension to bar plot to include error bars
% convertTextToColumnVectors  - convert numeric strings to column vectors
% dlmcell						          - write cell array to text file
% img2rois						        - adaptation of MarsBaR img2rois function; used in createROI function
