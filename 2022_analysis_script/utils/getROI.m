function [roi_file, roi_name] = getROI(beh_data_path, title, ext)
% GETROI Return a ROI file path and ROI name;
% [roi_file, roi_name] = GETROI(beh_data_path) takes as 
% 1. argument: a directory in form of a string leading to the 
%   behavioral data, e.g. "D:\DATA\Subjects";
% 2. argument: the title used in the UI window, e.g., name of the sequence 
%   to be analysed like "OLA_R";
% 3. argument: the extension of files that may be used, e.g., "*.mat" or
%   "*.nii";
% Outputs ROI file path in form of a string and the name of the selected
%   file in form of a string;
% $Author: A. Vorreuther, $Date: 2022/05/23
arguments
    beh_data_path {string, mustBeFolder}
    title {mustBeText}
    ext {mustBeText}
end
roi_default_path = fullfile(fileparts(fileparts(beh_data_path)), ...
    "2022_analysis_script\data\ROIs");
[roi_filename, roi_path] = uigetfile(ext,"Select ROI file for " ...
    + string(title), roi_default_path);
[~, roi_name] = fileparts(roi_filename);
roi_file = fullfile(roi_path,roi_filename);
end