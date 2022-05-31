function [roi_files, roi_names] = getROI(beh_data_path, title, ext)
% GETROI Return one or multiple ROI file paths and ROI names by prompting 
% the user to select at least one file;
% [roi_file, roi_name] = GETROI(beh_data_path) takes as 
% 1. argument: a directory in form of a string leading to the 
%   behavioral data, e.g. "D:\DATA\Subjects";
% 2. argument: the title used in the UI window, e.g., name of the sequence 
%   to be analysed like "OLA_R";
% 3. argument: the extension of files that may be used, e.g., "*.mat" or
%   "*.nii";
% Outputs ROI file paths in form of a string and the names of the selected
%   files in form of a string;
% $Author: A. Vorreuther, $Date: 2022/05/23
arguments
    beh_data_path {string, mustBeFolder}
    title {mustBeText}
    ext {mustBeText}
end
roi_default_path = fullfile(fileparts(fileparts(beh_data_path)), ...
    "2022_analysis_script\data\ROIs");
[roi_filename, roi_path] = uigetfile(ext,"Select ROI file for " ...
    + string(title), roi_default_path, 'Multiselect', 'on');
[~, roi_names] = fileparts(roi_filename);
roi_files = fullfile(roi_path,roi_filename);
end