function [project_path,beh_data_path,fmri_data_path, firstlevel_data_path] = importPaths(varargin)
% IMPORTPATHS is used to define import paths for running the analysis;
% the paths created are a 
%       project_path: path leading to the project
%       beh_data_path: path leading to the behavioral data
%       fmri_data_path: path leading to the fMRI data
% IMPORTPATHS(varargin) optionally takes a string input to define a 
%       firstlevel_data_path: path leading to the save dir of the 
%                             first-level analysis output
% $Author: A. Vorreuther $Date: 2022/03/28

project_path =  "F:\2022_Project_PrakAnna\_DATA\";
beh_data_path = fullfile (project_path, 'Behavioural');
fmri_data_path = fullfile(project_path,'Subjects');

try
    if and(nargout==4, or(nargin < 1, class(varargin{1}) ~= "string"))
        warning("To define a first-level data path, please provide " + ...
            "a dir in form of a string.");
    elseif and(nargout<4, nargin > 0)
        warning("First-level data path not saved into an output " + ...
            "variable.");
    end
    firstlevel_data_path = fullfile(project_path, varargin{1});
catch
    firstlevel_data_path = 0;
end
end