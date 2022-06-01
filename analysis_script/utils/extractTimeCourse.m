function tc_table = extractTimeCourse(beh_data_path, SPM, roi_files, ...
    roi_names, titlename)
% EXTRACTTIMECOURSE Extract the time course in one or several ROIs for a
% given SPM file;
% tc_table = EXTRACTTIMECOURSE(beh_data_path, SPM) takes as 
% 1. argument: a directory in form of a string leading to the 
%   behavioral data, e.g. "D:\DATA\Subjects";
% 2. argument: an SPM file to use for data retrieval;
% 3. argument: one or several ROI files as string;
% 4. argument: one or several ROI names as string;
% 5. argument: a string containing a title for the save file;
% Outputs a table containing the time courses for all selected ROIs and 
% saves table in "_DATA\results\timeCourses" folder;
% $Author: A. Kasparbauer, A. Vorreuther $Date: 2022/06/01
arguments
    beh_data_path {string, mustBeFolder};
    SPM {struct};
    roi_files {string, mustBeFile};
    roi_names {string};
    titlename {string};
end

output_dir = fullfile(fileparts(beh_data_path), 'results\timeCourses');
mkdir(output_dir);

tc_table = table();
[~,lbids] = fileparts(fileparts(SPM.xY.P));
[~,sgroups] = fileparts(fileparts(fileparts(SPM.xY.P)));
tc_table.LBID = lbids;
tc_table.substance = sgroups;

for r=1:length(roi_files)
    roi_name = roi_names{r};
    roi_file = roi_files{r};

    D = mardo(SPM);
    R = maroi(roi_file);
    Y = get_marsy(R, D, 'mean');

    tc_table.(roi_name) = summary_data(Y);

end
output_filename ="timecourses_"+string(titlename)+".txt";
writetable(tc_table,fullfile(output_dir, output_filename),'Delimiter',';')