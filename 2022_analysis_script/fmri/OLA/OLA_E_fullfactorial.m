function [matlabbatch,SPM] = OLA_E_fullfactorial(subjects, ...
    beh_data_path, fmri_data_path, firstlevel_data_path)
% OLA_E_FULLFACTORIAL generates a fullfactorial model with the factors
% spatial accuracy and substance group (see Kukolja et al., 2009)
% [matlabbatch,SPM] = OLA_E_FULLFACTORIAL(subjects,beh_data_path,
% fmri_data_path, firstlevel_data_path) takes as 
% 1. argument: a cell of size 1xn number of subjects where each cell
%   contains a string or character array with a subject number, e.g. "001".
% 2. argument: a directory in form of a string leading to the behavioral
%   data, e.g. "D:\DATA\Subjects";
% 3. argument: a directory in form of an fMRI data folder containing all
%   subjects' data, e.g. "D:\DATA\Subjects";
% 4. argument: a directory in form of a string indicating the data folder
%   where the 1st-level analysis output for all subjects should be saved,
%   e.g. "C:/OLA_1stlevel/OLA_E";
% Outputs the generated and saved matlabbatch and corresponding SPM 
%   file;
% $Author: A. Kasparbauer, A. Vorreuther $Date: 2022/04/27
arguments
    subjects (1,:) cell;
    beh_data_path {string, mustBeFolder};
    fmri_data_path {string, mustBeFolder};
    firstlevel_data_path {string, mustBeFolder};
end

sequence = {'OLA_E'};
batch_name = 'fullfactorial.mat';
problem_log = {};
SPM = [];

con_nr = {'con_0001','con_0002'}; % CORSCE & FALSCE
cd(firstlevel_data_path);
output_dir = "..\..\OLA_fullfactorial_SpatialAccuracy\OLA_E\";
mkdir(output_dir);
MPH_TD=[]; PLC_TD=[];NIC_TD=[];
m= 0; n= 0; c=0;

if ~exist(fullfile(output_dir, "SPM.mat"), "file")

    %% Initialise SPM defaults
    spm ('defaults', 'FMRI');
    spm_jobman('initcfg');

    %% loop over every subject
    for i = 1:numel(subjects)

        subject_name = subjects{i};

        % define path for each subject and load their substance group
        beh_sbj_path = fullfile(beh_data_path,subject_name);
        beh_sbj_substance_path = fullfile(beh_sbj_path, 'OLA.mat');
        load(beh_sbj_substance_path, "substance");

        confile_path = fullfile(firstlevel_data_path, substance, subject_name);
        confile_001 = fullfile(confile_path,[con_nr{1,1} '.nii']);
        confile_002 = fullfile(confile_path,[con_nr{1,2} '.nii']);
        TD = load(fullfile(beh_sbj_path,["TD_MEAN_"+sequence+".mat"]));

        if strcmp(substance, 'MPH')==1
            m = m+1;
            MPH_confiles(m,1) = confile_001;
            MPH_confiles(m,2) = confile_002;
            MPH_TD = [MPH_TD; TD.TD_MEAN];
        elseif strcmp(substance, 'NIC')==1
            n=n+1;
            NIC_confiles(n,1) = confile_001;
            NIC_confiles(n,2) = confile_002;
            NIC_TD = [NIC_TD; TD.TD_MEAN];
        elseif strcmp(substance, 'PLC')==1
            c= c+1;
            PLC_confiles(c,1) = confile_001;
            PLC_confiles(c,2) = confile_002;
            PLC_TD = [PLC_TD; TD.TD_MEAN];
        end
    end


    matlabbatch{1}.spm.stats.factorial_design.dir = {output_dir{1}};
    matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).name = 'CORSCE_FALSCE';
    matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).levels = 2;
    matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).dept = 1;
    matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).variance = 0;
    matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).gmsca = 0;
    matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).ancova = 0;
    matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).name = 'MPH_NIC_PLC';
    matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).levels = 3;
    matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).dept = 0;
    matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).variance = 1;
    matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).gmsca = 0;
    matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).ancova = 0;

    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).levels = [1
        1];
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).scans = cellstr(MPH_confiles(:,1));
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).levels = [1
        2];
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).scans = cellstr(NIC_confiles(:,1));
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(3).levels = [1
        3];
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(3).scans = cellstr(PLC_confiles(:,1));
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(4).levels = [2
        1];
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(4).scans = cellstr(MPH_confiles(:,2));
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(5).levels = [2
        2];
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(5).scans = cellstr(NIC_confiles(:,2));
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(6).levels = [2
        3];
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(6).scans = cellstr(PLC_confiles(:,2));

    matlabbatch{1}.spm.stats.factorial_design.des.fd.contrasts = 1;
    matlabbatch{1}.spm.stats.factorial_design.cov.c = [MPH_TD; NIC_TD;PLC_TD; MPH_TD; NIC_TD;PLC_TD];
    matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'TD_Mean';
    matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
    matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
    matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'PLC-MPH';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [-1 0 1 -1 0 1];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'MPH-PLC';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [1 0 -1 1 0 -1];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'PLC-NIC';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 -1 1 0 -1 1];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'NIC-PLC';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 1 -1 0 1 -1];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'NIC-MPH';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [-1 1 0 -1 1 0];
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'MPH-NIC';
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [1 -1 0 1 -1 0];
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';

    matlabbatch{3}.spm.stats.con.consess{7}.fcon.name = 'main effect of interest';
    matlabbatch{3}.spm.stats.con.consess{7}.fcon.weights = [eye(6)];
    matlabbatch{3}.spm.stats.con.consess{7}.fcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;

    %% run preprocessing batch & save batch template
    try
        %     spm_jobman ('interactive', matlabbatch, '')
        spm_jobman ('run', matlabbatch, '')
        save(fullfile(output_dir, batch_name), 'matlabbatch');
        SPM = load(fullfile(output_dir, "SPM.mat"));
    catch
        fprintf('PROBLEM with fullfactorial OLA_E\n');
        problem_log{end+1} = "1";
    end
    writecell(problem_log, fullfile(fileparts(fmri_data_path), "OLA_E_fullfactorial_problem_log.csv"));
else
    matlabbatch = load(fullfile(output_dir,batch_name));
    SPM = load(fullfile(output_dir,"SPM.mat"));
end
end