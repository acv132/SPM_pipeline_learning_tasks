function subjects = list_vp_names (data_path)
% LIST_VP_NAMES Read the name of all subfolders in a folder and 
% create a vector with all the names;
% LIST_VP_NAMES(datapath) takes as input argument a directory specified
% as string
% $Author: A. Kasparbauer, A. Vorreuther $Date: 2022/04/20
arguments
    data_path {string, mustBeFolder};
end
directories =  dir(data_path);
directories = directories([directories.isdir]);
directories(strncmp({directories.name}, '.', 1)) = [];
amount = length(directories);

for i = 1 : amount
    subject = directories(i,1).name;
    subjects{i} = {subject};
end