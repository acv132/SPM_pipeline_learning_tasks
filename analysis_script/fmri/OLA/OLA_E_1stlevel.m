function OLA_E_1stlevel(subjects, beh_data_path, fmri_data_path, ...
    firstlevel_data_path)
% OLA_E_1STLEVEL executes a GLM analysis of the Object Location Association
% Task as used by Kukolja et al. (2009);
% Onsets for all events: CORSCE, FALSCE, FORGSCE, MISS are listed in
% OLA.mat in the individual behavioural data folder; only correct
% source judgement events are modelled;
% OLA_E_1STLEVEL(subjects,beh_data_path,fmri_data_path, ...
% firstlevel_data_path) takes as 
% 1. argument: a cell of size 1xn number of subjects where each cell
%   contains a string or character array with a subject number, e.g. "001";
% 2. argument: a directory in form of a string leading to the behavioral
%   data, e.g. "D:\DATA\Subjects";
% 3. argument: a directory in form offMRI data folder containing all
%   subjects' data, e.g. "D:\DATA\Subjects";
% 4. argument contains a directory in form of a string indicating the data
%   folder where the 1st-level analysis output for all subjects should be
%   saved, e.g. "C:/OLA_1stlevel/OLA_E";
% $Author: A. Kasparbauer, A. Vorreuther $Date: 2022/04/20
arguments
    subjects (1,:) cell;
    beh_data_path {string, mustBeFolder};
    fmri_data_path {string, mustBeFolder};
    firstlevel_data_path {string, mustBeFolder};
end

sequence = {'OLA_E'};
batch_name = "1stlevel_OLA_E.mat";
problem_log = {};

%% Initialise SPM defaults
spm ('defaults', 'FMRI');
spm_jobman('initcfg');

%% loop over every subject
for i = 1:numel(subjects)
    matlabbatch = [];
    subject_name = subjects{i};

    %load Movement file
    mp = spm_select('FPList', fullfile(fmri_data_path,subject_name,sequence), '^rp.');
    %load Onsets and RTs for OLA_E
    beh_sbj_path = fullfile(beh_data_path,subject_name);
    beh_sbj_onsets = fullfile(beh_sbj_path, 'OLA.mat');

    if exist(beh_sbj_onsets) == 2
        load(beh_sbj_onsets, "substance", "OLA");

        % output directory
        output_dir = fullfile(firstlevel_data_path,substance,subject_name);

        if ~exist(fullfile(output_dir, "SPM.mat"), "file") || isempty(dir(fullfile(fullfile(output_dir, "con*.nii"))))

            forg_items = OLA.OLD.FORGSCE.N;
            miss_items = OLA.OLD.MISSSCE.N;

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

            %% matlabbatch
            matlabbatch{1}.spm.stats.fmri_spec.dir = {output_dir{1}};
            matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
            matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.5;
            matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
            matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
            matlabbatch{1}.spm.stats.fmri_spec.sess.scans = prepro_data;
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'CORSCE';
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = OLA.OLD.CORSCE.Onsets;
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 1;
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'FALSCE';
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = OLA.OLD.FALSCE.Onsets;
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 1;
            matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});

            t=2;

            if forg_items>0 % for items that were labelled as new in retrieval
                t=t+1;
                matlabbatch{1}.spm.stats.fmri_spec.sess.cond(t).name = 'FORGSCE';
                matlabbatch{1}.spm.stats.fmri_spec.sess.cond(t).onset = OLA.OLD.FORGSCR.Onsets;
                matlabbatch{1}.spm.stats.fmri_spec.sess.cond(t).duration = 0;
                matlabbatch{1}.spm.stats.fmri_spec.sess.cond(t).tmod = 1;
                matlabbatch{1}.spm.stats.fmri_spec.sess.cond(t).pmod = struct('name', {}, 'param', {}, 'poly', {});
            end


            if (miss_items(1)> 0)% for items that were missed in retreival
                t=t+1;
                matlabbatch{1}.spm.stats.fmri_spec.sess.cond(t).name = 'MISS';
                matlabbatch{1}.spm.stats.fmri_spec.sess.cond(t).onset = [OLA.OLD.MISSSCR.Onsets; OLA.NEW.MISS.Onsets];
                matlabbatch{1}.spm.stats.fmri_spec.sess.cond(t).duration = 0;
                matlabbatch{1}.spm.stats.fmri_spec.sess.cond(t).tmod = 1;
                matlabbatch{1}.spm.stats.fmri_spec.sess.cond(t).pmod = struct('name', {}, 'param', {}, 'poly', {});

            end

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
            %%
            matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
            matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
            matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
            matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
            matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
            matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
            matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
            matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
            matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
            %% contrasts
            matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'CORSCE';
            matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = 1;
            matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
            matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'FALSCE';
            matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [0 0 1];
            matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
            matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'FORGSCE';
            matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [0 0 0 0 1];
            matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
            matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'CORSCE-FALSCE';
            matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [1 0 -1];
            matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

            if (forg_items(1))> 0
                matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'CORSCE-FORGSCE';
                matlabbatch{3}.spm.stats.con.consess{5}.tcon.convec = [1 0 0 0 -1];
                matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
                matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'CORSCE+FALSCE-FORGSCE';
                matlabbatch{3}.spm.stats.con.consess{6}.tcon.convec = [0.5 0 0.5 0 -1];
                matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';

            end
            matlabbatch{3}.spm.stats.con.delete = 0;
            %% run preprocessing batch & save batch template
            try
%                   spm_jobman ('interactive', matlabbatch, '')
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
writecell(problem_log, fullfile(fileparts(fmri_data_path), "OLA_E_1stlevel_problem_log.csv"));
end
