function displayResults(spm, title, contrastOptions)
% DISPLAYRESULTS Display the results of an analysis in SPM and is
% equivalent to the pipeline process of clicking on 'Results' in the SPM
% user interface,
% DISPLAYRESULTS(spm, title, contrastOptions) takes as
% 1. argument: an SPM struct as generated by an SPM analysis pipeline;
% 2. argument: the title of the task/results in form of a string;
% 3. argument: contrast display options in form of a struct;
% $Author: A. Vorreuther $Date: 2022/05/24
arguments
    spm struct;
    title {mustBeText};
    contrastOptions struct = struct( ...
        'whichCon', Inf, ...
        'threshType', 'FWE', ...
        'threshold', 0.0500, ...
        'extent', 0, ...
        'export', "none", ...
        'deletePrevious', false, ...
        'applyContrastAsMask', 0, ...
        'maskType', 0, ...
        'maskThreshold', 0.0500, ...
        'applyImageAsMask', 'none' ...
        );
end
contrastOptions = defineDefaultconOptions(...
    contrastOptions); % see above for defaults

%% delete old exported results
if contrastOptions.deletePrevious == true
    for exp=1:numel(contrastOptions.export)
        if contrastOptions.deletePrevious
            cd(spm.SPM.swd)
            delete(["spm*." + contrastOptions.export{exp}])
        end
    end
end

%% setup batch job structure
if contrastOptions.whichCon == Inf
    contrastOptions.whichCon = length(spm.SPM.xCon);
end
doContrastMask = contrastOptions.applyContrastAsMask ~= 0;
doImageMask = isfile(contrastOptions.applyImageAsMask);
for c=1:contrastOptions.whichCon
    results = struct;
    results.matlabbatch{1}.spm.stats.results ...
        .spmmat = cellstr(fullfile(spm.SPM.swd, "SPM.mat"));
    results.matlabbatch{1}.spm.stats.results ...
        .conspec(1).titlestr = char(join([title, spm.SPM.xCon(c).name]));
    results.matlabbatch{1}.spm.stats.results ...
        .conspec(1).contrasts = c;
    results.matlabbatch{1}.spm.stats.results ...
        .conspec(1).threshdesc = contrastOptions.threshType ;
    results.matlabbatch{1}.spm.stats.results ...
        .conspec(1).thresh = contrastOptions.threshold;
    results.matlabbatch{1}.spm.stats.results ...
        .conspec(1).extent = contrastOptions.extent;
    results.matlabbatch{1}.spm.stats.results ...
        .conspec(1).conjunction = 1;

    %% contrast/image as mask is defined (or not)
    % contrast mask
    if ~doContrastMask
        results.matlabbatch{1}.spm.stats.results ...
            .conspec(1).mask.none = 1;
    else
        contrastMask = spm.SPM.xCon(contrastOptions ...
            .applyContrastAsMask).name;
        results.matlabbatch{1}.spm.stats.results ...
            .conspec(1).titlestr = char({[title, ' ', spm.SPM...
            .xCon(c).name], ['contrast mask: ', contrastMask]});
        results.matlabbatch{1}.spm.stats.results.conspec(1).mask.contrast ...
            .contrasts = contrastOptions.applyContrastAsMask;
        results.matlabbatch{1}.spm.stats.results.conspec(1).mask.contrast ...
            .thresh = contrastOptions.maskThreshold;
        results.matlabbatch{1}.spm.stats.results.conspec(1).mask.contrast ...
            .mtype = contrastOptions.maskType;
    end

    % image mask
    if doImageMask
        [~,img] = fileparts(contrastOptions.applyImageAsMask);
        results.matlabbatch{1}.spm.stats.results ...
            .conspec(2).titlestr = char({[title, ' ', spm.SPM...
            .xCon(c).name] ['image mask: ',img]});
        results.matlabbatch{1}.spm.stats.results ...
            .conspec(2).contrasts = c;
        results.matlabbatch{1}.spm.stats.results ...
            .conspec(2).threshdesc = contrastOptions.threshType ;
        results.matlabbatch{1}.spm.stats.results ...
            .conspec(2).thresh = contrastOptions.threshold;
        results.matlabbatch{1}.spm.stats.results ...
            .conspec(2).extent = contrastOptions.extent;
        results.matlabbatch{1}.spm.stats.results ...
            .conspec(2).conjunction = 1;
        results.matlabbatch{1}.spm.stats.results ...
            .conspec(2).mask.image.name = cellstr(contrastOptions...
            .applyImageAsMask);
        results.matlabbatch{1}.spm.stats.results ...
            .conspec(2).mask.image.mtype = contrastOptions.maskType;
    end

    results.matlabbatch{1}.spm.stats.results.units = 1;

    %% export results
    if ~strcmp(contrastOptions.export, "none")
        for exp=1:numel(contrastOptions.export)
            results.matlabbatch{1}.spm.stats.results ...
                .export{exp}.(contrastOptions.export{exp}) = true;
        end
    end

    %% run batch
    try
        spm_jobman ('run', results.matlabbatch, '')
    catch
        fprintf("PROBLEM with display of results for " ...
            + string(title) + "\n");
    end
end
    function conOpt = defineDefaultconOptions(conOpt)
        % DEFINEDEFAULTCONOPTIONS Return conOpt as defined by input arg but
        % with missing struct fields filled in by default values;
        % DEFINEDEFAULTCONOPTIONS(conOpt) takes
        % 1. Argument: struct containing contrast options for result
        %   display;
        % Outputs conOpt struct with default values in fields that were
        %   previously undefined;
        default_options = struct( ...
            'whichCon', Inf, ...
            'threshType', 'FWE', ...
            'threshold', 0.0500, ...
            'extent', 0, ...
            'export', "none", ...
            'deletePrevious', false, ...
            'applyContrastAsMask', 0, ...
            'maskType', 0, ...
            'maskThreshold', 0.0500, ...
            'applyImageAsMask', 'none' ...
            );
        % add default options to conOpt if not provided by user
        sf = fieldnames(conOpt);
        df = fieldnames(default_options);
        % fields missing in conOpt
        missingIdx = find(~ismember(df,sf));
        % assign missing fields to conOpt
        for i = 1:length(missingIdx)
            conOpt.(df{missingIdx(i)}) = default_options...
                .(df{missingIdx(i)});
        end
    end
end