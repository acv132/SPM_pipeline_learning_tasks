function createROI()
% CREATEROI() uses a (slightly) adapted version of the MarsBaR function 
% img2rois to create a ROI .mat file for each of the .nii files in the 
% directory "..\data\ROIs";
% $Author: A. Vorreuther $Date: 2022/05/30


% Start marsbar to make sure spm_get works
marsbar('on')

cd('..\data\ROIs\')
ROIs_dir = pwd;
sequences = {'PL', 'OLA'};

for s=sequences
    % Directory to store (and load) ROIs
    roi_dir = fullfile(ROIs_dir, s);

    % get .nii files
    files = dir(fullfile(string(roi_dir), '*.nii'));
     % create roi pointlists (marsbar data type)
    for fidx=1:length(files)
        f = files(fidx);
        name = split(f.name, '.');
        name = name{1};
        img2rois(fullfile(f.folder, f.name),roi_dir, name, 'i');
    end
end
end