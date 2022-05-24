function PL_1stlevel_PATonly(subjects, beh_data_path,fmri_data_path, ...
    firstlevel_data_path)
% PL_1STLEVEL_PATONLY executes a GLM analysis of the Procedural Learning
% (PL) task; onset of pattern blocks are modelled as regressors, random
% blocks serve as implicit baseline; motion regressors are used as
% covariates;
% PL_1STLEVEL_PATONLY(subjects,beh_data_path,fmri_data_path, ...
% firstlevel_data_path) takes as 
% 1. argument: a cell of size 1xn number of subjects where each cell
%   contains a string or character array with a subject number, e.g. "001";
% 2. argument: a directory in form of a string leading to the behavioral
%   data, e.g. "D:\DATA\Subjects";
% 3. argument: a directory in form offMRI data folder containing all
%   subjects' data, e.g. "D:\DATA\Subjects";
% 4. argument contains a directory in form of a string indicating the data
%   folder where the 1st-level analysis output for all subjects should be
%   saved, e.g. "C:/PL_1stlevel/PATonly";
% $Author: A. Kasparbauer, A. Vorreuther $Date: 2022/05/03
arguments
    subjects (1,:) cell;
    beh_data_path {string, mustBeFolder};
    fmri_data_path {string, mustBeFolder};
    firstlevel_data_path {string, mustBeFolder};
end

sequence = {'PROCLEARN'};
batch_name = "1stlevel_PL_PATonly.mat";
problem_log = {};

%% Initialise SPM defaults
spm ('defaults', 'FMRI');
spm_jobman('initcfg');

%% loop over every subject
for i = 1:numel(subjects)
    matlabbatch = [];
    subject_name = subjects{i};

    %load Movement file
    mp = spm_select('FPList', fullfile(fmri_data_path,subject_name,sequence), ['^rp_.*','.*\.txt$']);

    %load Onsets and RTs for PL
    beh_sbj_path = fullfile(beh_data_path,subject_name);
    beh_sbj_onsets = fullfile(beh_sbj_path, 'ProcLearn.mat');

    if exist(beh_sbj_onsets) == 2
        load(beh_sbj_onsets, "substance", "PL");

        % output directory
        output_dir = fullfile(firstlevel_data_path,substance,subject_name);

        if ~exist(fullfile(output_dir, "SPM.mat"), "file") || isempty(dir(fullfile(fullfile(output_dir, "con*.nii"))))

            % load functional data
            func_data_path = fullfile(fmri_data_path,subject_name, string(sequence));
            prepro_data = cellstr(spm_select('FPList', func_data_path,'^swf.*\.img$'));
            size_func_data = size(prepro_data(:,1));

            % delete previous spm.mat
            type = exist(fullfile(output_dir),'dir');
            if type == 7
                cd (output_dir);
                delete *.mat;delete *.img;delete *.hdr;
            elseif type ~= 7
                mkdir(output_dir);
            end

            % display which subject and sequence is being processed
            fprintf('Processing subject "%s", "%s" %d files\n' ,...
                subject_name,string(sequence),size_func_data);


            RAN_onsets= round((cell2mat(PL.RAN.Onsets)/1000)/2.5);
            PAT_onsets = round((cell2mat(PL.PAT.Onsets)/1000)/2.5);
            RAN_duration =round((cell2mat(PL.RAN.Duration)/1000)/2.5);
            PAT_duration = round((cell2mat(PL.PAT.Duration)/1000)/2.5);

            RAN = [RAN_onsets, RAN_duration];
            PAT = [PAT_onsets, PAT_duration];
            BLOCKS = [RAN;PAT];
            BLOCKS = sortrows(BLOCKS,1);
            NO_SCANS = size(prepro_data,1);


            matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(output_dir);
            matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
            matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.5;
            matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
            matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
            matlabbatch{1}.spm.stats.fmri_spec.sess.scans = prepro_data;
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'PAT';
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = cell2mat(PL.PAT.Onsets)/1000;
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 	cell2mat(PL.PAT.Duration)/1000;
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 1;
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod.name = 'mean RT';
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod.param = cell2mat(PL.PAT.MRT_filteredRTS);
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod.poly = 1;
            % matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'RAN';
            % matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = cell2mat(PL.RAN.Onsets)/1000;
            % matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = cell2mat(PL.RAN.Duration)/1000;
            % matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
            % matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
            matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
            matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
            matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {mp};
            matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
            matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
            matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
            matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
            matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
            matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
            matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
            %%
            matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
            matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
            matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
            matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
            matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
            matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
            matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'fMRI model specification: SPM.mat File';
            matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
            matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
            matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
            matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
            matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
            %%
            matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
            matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
            matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
            matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
            matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
            matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
            matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
            matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'PAT';
            matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = 1;
            matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
            matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'PATxtime';
            matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [0 1];
            matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
            matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'PATxRTs';
            matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [0 0 1];
            matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
            % matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'RAN-PAT';
            % matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [-1 1];
            % matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
            matlabbatch{3}.spm.stats.con.delete = 0;

            %% run preprocessing batch & save batch template
            try
                % spm_jobman ('interactive', matlabbatch, '')
                spm_jobman ('run', matlabbatch, '')
                save(fullfile(output_dir, batch_name), 'matlabbatch');
            catch
                fprintf('PROBLEM with subject "%s", "%s"\n' ,...
                    subject_name,string(sequence));
                problem_log{end+1} = subject_name;
            end
        end
    end
end
writecell(problem_log, fullfile(fileparts(fmri_data_path), "PL_1stlevel_problem_log.csv"));
end