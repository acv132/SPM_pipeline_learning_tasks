% function main
% fMRI data analysis with SPM12
% project: Procedural Learning (PL) task and Object Location Association
% (OLA) task
% $Author: A. Vorreuther $Date: 2022/05/18

clear;

%% imports
addpath(".", "..\utils", "OLA", "PL", "preprocessing");
load("..\results\behavioral\NEUTRAL.mat");

% import your data paths with this function
[project_path,beh_data_path,fmri_data_path] = importPaths;

subjects = list_vp_names(beh_data_path);

%% configs: PLEASE ADJUST TO YOUR LIKING

do_preprocess = false;

do_PL_analysis = false; % to run 1st-level, fullfactorial, and ANOVA
show_PL_Results = true; % to save images of results; CAUTION: takes a while too
do_PL_signalChangeROI = false; % to run signal change analysis with marsbar

do_OLA_analysis = false;
show_OLA_Results = false;
do_OLA_E_signalChangeROI = false;
do_OLA_R_signalChangeROI = false;


% options for how and which contrasts are displayed in displayResults
% function; if an option is not defined, a default is used in the method
% you may also redefine certain options for each task individually by
% inserting a different config in the code below
contrastOptions.whichCon = Inf; % Inf: all are displayed;
% 1: only first contrast etc.
contrastOptions.threshType = 'FWE'; % type of threshold : FWE , none
contrastOptions.threshold = 0.0500; % significance threshold
contrastOptions.extent = 0; % in voxels

% define a contrast as mask to apply to results; 0: no mask, integer number
% of a contrast to apply this contrast as mask, e.g. 1; to find out, which
% contrast corresponds to a certain number, load in the SPM file of interest
% and type {yourSPMofinterest}.SPM.xCon(1).name into the command prompt
contrastOptions.applyContrastAsMask = 1;
% maskType: whether the mask should be inclusive (0) or exclusive (1)
contrastOptions.maskType = 0;
contrastOptions.maskThreshold = 0.0500; % threshold for mask

% if set to true, you can additionally define an image ('*.nii') as mask 
% to apply to results of PL and OLA task, respectively;
useImageMask = true;

% enter export of results as array into cell; allowed are
% pdf, jpg, png, csv, ps, eps, fig, tif, xls;
% example: {'png', 'csv', 'fig'};
contrastOptions.export = {'png', 'csv'};
contrastOptions.deletePrevious = true; % whether to delete old exports of results

% necessary to display results
if show_PL_Results
    do_PL_analysis = true;
end
if show_OLA_Results
    do_OLA_analysis = true;
end

%% some subjects are excluded
excluded_subjects = [
    "7418",  ... % too many misses
    "9745",  ... % participant performed task wrong
    "9770",  ... % fmri data cut off at the top
    "10004", ... % motion difference between Scans >3
    "10021", ... % instruction wrong
    "10122", ... % hippocampus data cut off
    "10384", ... % motion difference between Scans >3
    "10633", ... % instruction wrong
    ]' ;

% a total of 71 subjects was used for PL analysis
PL_subjects = convertStringsToChars(setdiff(string(subjects), ...
    string(excluded_subjects)));

% Kukolja et al. (2013): based on the chi-square criterion calculated in
% "..\behavioral\main.m", several participants were excluded for the OLA
% task and are consequently also excluded from corresponding fMRI
% data analysis
chi_criterion = cell(1,length(subjects));
for s=1:length(subjects)
    c = NEUTRAL{1, s}.OLA.chisquare_p;
    if strcmp(c,'non-significant')
        chi_criterion(s) = subjects(s);
    end
end
chi_criterion = chi_criterion(~cellfun('isempty',chi_criterion));

save('..\results\behavioral\chi_criterion.mat', 'chi_criterion');
OLA_subjects = convertStringsToChars(setdiff(string(subjects), ...
    string(chi_criterion)));
% excluded_subjects = [excluded_subjects;
%     "9359";	% to little FALSCE trials (Kukolja et al., 2013)
%     "9842"	% to little FALSCE trials
%     ];
% Kukolja: < 12; where does the 12 come from? for this experiment, likely
% not the same number as the amount of trials is different

% a total of 55 subjects was used for OLA analysis
OLA_subjects = convertStringsToChars(setdiff(OLA_subjects, ...
    string(excluded_subjects)));


% for now, all subjects (that are not excluded for a specific reason)
% are used for both analyses; feel free to comment this line out and
% thereby use only the above defined subjects for the OLA task
OLA_subjects = PL_subjects;

%% preprocessing
% use preprocess_PL, preprocess_OLA_E, or preprocess_OLA_R to preprocess
% only some of the tasks
if do_preprocess
    tic
    preprocess(PL_subjects, fmri_data_path);
    %     preprocess_PL(PL_subjects, fmri_data_path);
    disp("PREPROCESSING complete");
    toc
end

%% PL analysis

if do_PL_analysis
    tic
    [~,~,~,firstlevel_data_path] = importPaths( ...
        "results/PL_1stlevel/PATonly");
    % 1st-level analysis
    PL_1stlevel_PATonly(PL_subjects, beh_data_path, fmri_data_path, ...
        firstlevel_data_path);
    % fullfactorial
    [matlabbatch_PL, SPM_PL] = PL_fullfactorial(PL_subjects, ...
        beh_data_path, fmri_data_path, firstlevel_data_path);
    % ANOVA
    [matlabbatch_ANOVA_PL, SPM_ANOVA_PL] = PL_anova(PL_subjects, ...
        beh_data_path,fmri_data_path, firstlevel_data_path);
    disp("PL ANALYSIS complete")
    toc
end

%% OLA analysis

if do_OLA_analysis
    % Encoding phase
    tic
    [~,~,~,firstlevel_data_path] = importPaths( ...
        "results/OLA_1stlevel/OLA_E");
    % 1st-level analysis
    OLA_E_1stlevel(OLA_subjects, beh_data_path, fmri_data_path, ...
        firstlevel_data_path);
    % fullfactorial
    [matlabbatch_OLA_E, SPM_OLA_E] = OLA_E_fullfactorial(OLA_subjects, ...
        beh_data_path, fmri_data_path, firstlevel_data_path);
    disp("OLA ENCODING complete");
    toc
    % Retrieval phase
    tic
    [~,~,~,firstlevel_data_path] = importPaths( ...
        "results/OLA_1stlevel/OLA_R");
    % 1st-level analysis
    OLA_R_1stlevel(OLA_subjects, beh_data_path, fmri_data_path, ...
        firstlevel_data_path);
    % fullfactorial
    [matlabbatch_OLA_R, SPM_OLA_R] = OLA_R_fullfactorial(OLA_subjects, ...
        beh_data_path, fmri_data_path, firstlevel_data_path);
    disp("OLA RETRIEVAL complete");
    toc
    % ANOVA for both phases
    tic
    [~,~,~,firstlevel_data_path] = importPaths("results/OLA_1stlevel");
    [matlabbatch_ANOVA_OLA, SPM_ANOVA_OLA] = OLA_anova(OLA_subjects, ...
        beh_data_path, fmri_data_path, firstlevel_data_path);
    disp("OLA ANOVAS complete");
    toc
end

%% results of analyses above saved as graphics

if show_PL_Results
    if useImageMask
        [roi_file, roi_name] = getROI(beh_data_path, ...
            "contrast mask in displayResults", '*.nii');
        contrastOptions.applyImageAsMask = roi_file;
    end

    contrastOptions.applyContrastAsMask = find(strcmp({SPM_PL.SPM.xCon.name}, ...
        'Main effect of MPH_NIC_PLC')==1);
    displayResults(SPM_PL, 'PL fullfactorial', contrastOptions);
    contrastOptions.applyContrastAsMask = find(strcmp( ...
        {SPM_ANOVA_PL.SPM.xCon.name}, 'group difference')==1);
    displayResults(SPM_ANOVA_PL, 'PL ANOVA', contrastOptions);
end
if show_OLA_Results
    if useImageMask
        [roi_file, roi_name] = getROI(beh_data_path, ...
            "contrast mask in displayResults", '*.nii');
        contrastOptions.applyImageAsMask = roi_file;
    end
    contrastOptions.applyContrastAsMask = find(strcmp( ...
        {SPM_OLA_E.SPM.xCon.name}, 'Main effect of CORSCE_FALSCE')==1);
    displayResults(SPM_OLA_E, 'OLA_E fullfactorial', contrastOptions);
    contrastOptions.applyContrastAsMask = find(strcmp( ...
        {SPM_OLA_R.SPM.xCon.name}, 'Main effect of CORSCR_FALSCR')==1);
    displayResults(SPM_OLA_R, 'OLA_R fullfactorial', contrastOptions);
    contrastOptions.applyContrastAsMask = find(strcmp( ...
        {SPM_ANOVA_OLA{1}.SPM.xCon.name}, 'group difference')==1);
    displayResults(SPM_ANOVA_OLA{1}, 'OLA_E ANOVA', contrastOptions);
    displayResults(SPM_ANOVA_OLA{2}, 'OLA_R ANOVA', contrastOptions);
end

%% signal change analysis and results

if do_PL_signalChangeROI
    tic
    [~,~,~,firstlevel_data_path] = importPaths( ...
        "results/PL_1stlevel/PATonly");
    [signalchange_PL] = signalChange(PL_subjects, 'PROCLEARN', ...
        {'PATbyTIME'}, beh_data_path, firstlevel_data_path);
    disp("SIGNAL CHANGE ANALYSIS PL complete")
    toc
end
if do_OLA_E_signalChangeROI
    tic
    [~,~,~,firstlevel_data_path] = importPaths( ...
        "results/OLA_1stlevel/OLA_E");
    [signalchange_OLA_E] = signalChange(PL_subjects, 'OLA_E', ...
        {'CORSCE', 'FALSCE'}, beh_data_path, firstlevel_data_path);
    toc
    disp("SIGNAL CHANGE ANALYSIS OLA_E complete")
end
if do_OLA_R_signalChangeROI
    tic
    [~,~,~,firstlevel_data_path] = importPaths( ...
        "results/OLA_1stlevel/OLA_R");
    [signalchange_OLA_R] = signalChange(PL_subjects, 'OLA_R', ...
        {'CORSCR', 'FALSCR', 'NEWCOR'}, beh_data_path, ...
        firstlevel_data_path);
    disp("SIGNAL CHANGE ANALYSIS OLA_R complete")
    toc
end
