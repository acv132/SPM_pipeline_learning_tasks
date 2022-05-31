function preprocess(subjects, fmri_data_path)
% PREPROCESS is a preprocessing function for the PL and OLA data (it
% combines all the other preprocessing functions since they do not differ
% in the configs)
% PREPROCESS(subjects, fmri_data_path) takes as the
% 1.argument: a cell of size 1xn number of subjects where each cell
%   contains a string or character array with a subject number, e.g. "001";
% 2. argument: a directory in form of a string leading to the fMRI data
%   folder containing all subjects, e.g. "D:\DATA\Subjects".
% $Author: A. Kasparbauer, A. Vorreuther $Date: 2022/04/19
arguments
    subjects (1,:) cell;
    fmri_data_path {string, mustBeFolder};
end
sequences = {'PROCLEARN', 'OLA_E','OLA_R'};
problem_log = {};

%% Initialise SPM defaults
spm ('defaults', 'FMRI');
spm_jobman('initcfg');

%% loop over every subject
for i =1:numel(subjects)
    for s=1:numel(sequences)

        sequence = sequences(s);
        subject_name = subjects{i};
        % dirs per subject
        sbj_path = fullfile(fmri_data_path,subject_name);
        func_path = fullfile(sbj_path,sequence);
        struc_path = fullfile(sbj_path,'T1');
        subject_name = subjects{i};

        completed = exist(fullfile(sbj_path,string(sequence), ...
            'preprocessing_'+string(sequence)+'.mat'), "file") && ...
            ~isempty(dir(fullfile(sbj_path,string(sequence), "swf*.hdr")));
        if completed
            cd(func_path)
            delete f*.img; delete f*.hdr;
            delete w*.img; delete w*.hdr;
            delete r*.img; delete r*.hdr;
        end

        % skips preprocessing for the subject if the matlab batch file was
        % already generated (hence, preprocessing already occurred)
        if ~exist(fullfile(sbj_path,string(sequence),'preprocessing_'+string(sequence)+'.mat'), "file") || isempty(dir(fullfile(fullfile(sbj_path,string(sequence), "swf*.hdr"))))
            % load structural image
            filt = ['^s',subject_name,'.*\img$'];
            structural = spm_select ('FPList', struc_path, filt);

            % delete potential old preprocessing saves
            cd(func_path)
            delete s*.img; delete s*.hdr; delete w*.img; delete w*.hdr;
            delete r*.img; delete r*.hdr;

            % load functional data
            func_data = cellstr(spm_select('FPList',func_path ,'^f.*\.img$'));
            func_files=size(func_data,1);

            % display which subject and sequence is being processed
            fprintf('Preprocessing subject "%s", "%s" %d files\n' ,...
                subject_name,string(sequence),func_files);

        %% matlabbatch
        % Realign: Estimate & Reslice
        matlabbatch{1}.spm.spatial.realign.estwrite.data = {func_data};
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = {''};
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [0 1];
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
        % Coregister: Estimate
        matlabbatch{2}.spm.spatial.coreg.estimate.ref(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
        matlabbatch{2}.spm.spatial.coreg.estimate.ref(1).src_output = substruct('.','rmean');
        matlabbatch{2}.spm.spatial.coreg.estimate.source = {structural};
        matlabbatch{2}.spm.spatial.coreg.estimate.other = {''};
        matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
        matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
        matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
        % Old Segment
        matlabbatch{3}.spm.tools.oldseg.data(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
        matlabbatch{3}.spm.tools.oldseg.output.GM = [0 0 1];
        matlabbatch{3}.spm.tools.oldseg.output.WM = [0 0 1];
        matlabbatch{3}.spm.tools.oldseg.output.CSF = [0 0 0];
        matlabbatch{3}.spm.tools.oldseg.output.biascor = 1;
        matlabbatch{3}.spm.tools.oldseg.output.cleanup = 0;
        matlabbatch{3}.spm.tools.oldseg.opts.tpm = {
            [getenv('userprofile') '\Documents\MATLAB\spm12\toolbox\OldSeg\grey.nii']
            [getenv('userprofile') '\Documents\MATLAB\spm12\toolbox\OldSeg\white.nii']
            [getenv('userprofile') '\Documents\MATLAB\spm12\toolbox\OldSeg\csf.nii']
            };
        matlabbatch{3}.spm.tools.oldseg.opts.ngaus = [2
            2
            2
            4];
        matlabbatch{3}.spm.tools.oldseg.opts.regtype = 'mni';
        matlabbatch{3}.spm.tools.oldseg.opts.warpreg = 1;
        matlabbatch{3}.spm.tools.oldseg.opts.warpco = 25;
        matlabbatch{3}.spm.tools.oldseg.opts.biasreg = 0.0001;
        matlabbatch{3}.spm.tools.oldseg.opts.biasfwhm = 60;
        matlabbatch{3}.spm.tools.oldseg.opts.samp = 2;
        matlabbatch{3}.spm.tools.oldseg.opts.msk = {''};
        % Old Normalise: Write
        matlabbatch{4}.spm.tools.oldnorm.write.subj.matname(1) = cfg_dep('Segment: Norm Params Subj->MNI', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','snfile', '()',{':'}));
        matlabbatch{4}.spm.tools.oldnorm.write.subj.resample(1) = cfg_dep('Realign: Estimate & Reslice: Realigned Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','cfiles'));
        matlabbatch{4}.spm.tools.oldnorm.write.subj.resample(2) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
        matlabbatch{4}.spm.tools.oldnorm.write.roptions.preserve = 0;
        matlabbatch{4}.spm.tools.oldnorm.write.roptions.bb = [-78 -112 -70
            78 76 85];
        matlabbatch{4}.spm.tools.oldnorm.write.roptions.vox = [2 2 2];
        matlabbatch{4}.spm.tools.oldnorm.write.roptions.interp = 1;
        matlabbatch{4}.spm.tools.oldnorm.write.roptions.wrap = [0 0 0];
        matlabbatch{4}.spm.tools.oldnorm.write.roptions.prefix = 'w';
        matlabbatch{5}.spm.tools.oldnorm.write.subj.matname(1) = cfg_dep('Segment: Norm Params Subj->MNI', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','snfile', '()',{':'}));
        matlabbatch{5}.spm.tools.oldnorm.write.subj.resample(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
        matlabbatch{5}.spm.tools.oldnorm.write.roptions.preserve = 0;
        matlabbatch{5}.spm.tools.oldnorm.write.roptions.bb = [-78 -112 -50
            78 76 85];
        % Old Normalise: Write
        matlabbatch{5}.spm.tools.oldnorm.write.roptions.vox = [1 1 1];
        matlabbatch{5}.spm.tools.oldnorm.write.roptions.interp = 1;
        matlabbatch{5}.spm.tools.oldnorm.write.roptions.wrap = [0 0 0];
        matlabbatch{5}.spm.tools.oldnorm.write.roptions.prefix = 'w';
        % Smooth
        matlabbatch{6}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
        matlabbatch{6}.spm.spatial.smooth.data(2) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
        matlabbatch{6}.spm.spatial.smooth.fwhm = [8 8 8];
        matlabbatch{6}.spm.spatial.smooth.dtype = 0;
        matlabbatch{6}.spm.spatial.smooth.im = 0;
        matlabbatch{6}.spm.spatial.smooth.prefix = 's';

            %% run and save batch
            try
                % spm_jobman('interactive', matlabbatch, '');
                spm_jobman ('run', matlabbatch, '')
                save(fullfile(sbj_path,string(sequence),'preprocessing_'+string(sequence)+'.mat'), 'matlabbatch');
            catch
                fprintf('PROBLEM with subject "%s", "%s" %d files\n' ,...
                    subject_name,string(sequence),func_files);
                problem_log{end+1} = string(subject_name) + " " + string(sequence);
            end
            writecell(problem_log,fullfile(fileparts(fmri_data_path), "preprocessing_problem_log.csv"));

            % delete saves from preprocessing steps (except final one) to
            % save space
            cd(func_path)
            delete w*.img; delete w*.hdr;
            delete r*.img; delete r*.hdr;
        end
    end
end