function signalchange = signalChange(subjects, sequence, conds, ...
    beh_data_path, firstlevel_data_path)
% SIGNALCHANGE Analyse the percentage of signal change during all tasks
% by means of the marsbar toolbox;
% signalchange = SIGNALCHANGE (subjects,beh_data_path, ...
% firstlevel_data_path) takes as 
% 1. argument: a cell of size 1xn number of subjects where each cell 
%   contains a string or character array with a subject number, e.g. "001";
% 2. argument: the sequence name of the sequence to be analysed,
%   e.g. "OLA_R" or "PROCLEARN";
% 3. argument: a cell containing all names of conditions
%   that are important for the current analysed sequence, e.g. "{'CORSCE',
%   'FALSCE'}" for OLA encoding phase;
% 4. argument: a directory in form of
%   a string leading to the behavioral data, e.g. "D:\DATA\Subjects";
% 5. argument: a directory in form of a string indicating
%   the data folder where the 1st-level analysis output for all subjects
%   should be saved, e.g. "C:/PL_1stlevel/PATonly";
% Outputs a cell containing the percentage of signal change for all
%   subjects
% $Author: A. Kasparbauer, A. Vorreuther $Date: 2022/05/16
arguments
    subjects (1,:) cell;
    sequence string;
    conds (1,:) cell;
    beh_data_path {string, mustBeFolder};
    firstlevel_data_path {string, mustBeFolder};
end

problem_log = {};

% output directory
if string(sequence) == "PROCLEARN"
    out_dir = "PL";
else
    out_dir = sequence;
end
output_dir = fullfile(fileparts(beh_data_path), "results", out_dir+"_ROI");
mkdir(output_dir);

%% initialise SPM defaults
spm ('defaults', 'FMRI');
spm_jobman('initcfg');
marsbar('on')

% load in files of regions of interest
roi_default_path = fullfile(fileparts(fileparts(beh_data_path)), ...
    "2022_analysis_script\data\ROIs");
[roi_filename, roi_path] = uigetfile('*.mat',"Select ROI file for " ...
    + string(sequence), roi_default_path);
[~, roi_name] = fileparts(roi_filename);
roi_file = fullfile(roi_path,roi_filename);

%% loop over every subject
for i = 1:numel(subjects)
    try
        subject_name = subjects{i};

        % define path for each subject and load their substance group
        beh_sbj_path = fullfile(beh_data_path,subject_name);
        if string(sequence) == "PROCLEARN"
            substance_mat = 'ProcLearn.mat';
        else
            substance_mat = 'OLA.mat';
        end
        beh_sbj_substance_path = fullfile(beh_sbj_path, substance_mat);
        load(beh_sbj_substance_path, "substance")
        confile_path = fullfile(firstlevel_data_path, substance, ...
            subject_name);
        SPM = load(fullfile(confile_path, 'SPM.mat'));
        % necessary for mardo(SPM) operation if files were moved
        SPM.SPM.swd = confile_path; 

        % define spm and roi
        D = mardo(SPM);
        R = maroi(roi_file);
        dur = 0;
        % fetch data into marsbar data object
        Y = get_marsy(R, D, 'mean');
        % get contrasts from original design
        xCon = get_contrasts(D);
        % estimate design on ROI data
        E = estimate(D, Y);
        % put contrasts from original design back into design object
        E = set_contrasts(E, xCon);
        % get design betas
        b = betas(E);

        for e = 1:numel(conds)
            % regressor: Successful Stop (1) or Unsuccessful Stop (2) 
            % or Continue Trial (3):');
            if e ==1
                % PROCLEARN, CORSCE, CORSCR
                e_spec = [1 1];
            elseif e==2
                % FALSCE, FALSCR
                e_spec = [1 2];
            elseif e==3
                % NEWCOR
                e_spec = [1 3];
            end

            % get stats and stuff for all contrasts into 
            % statistics structure
            marsS = compute_contrasts(E, 1:length(xCon));
            signal = event_signal(E, e_spec, dur);
            signal_events(1,e) =signal;
        end
        signalchange{i,1} = subject_name;
        signalchange{i,2} = substance;

        signal = mat2cell(signal_events,1, ones(1,numel(conds)));
        signalchange(i,3:2+numel(conds)) = signal(1, 1:numel(conds));
    catch
        fprintf('PROBLEM with subject "%s", "%s" \n' ,...
            subject_name,string(sequence));
        problem_log{end+1} = string(subject_name) + " " + string(sequence);
        writecell(problem_log, fullfile(fileparts(beh_data_path), ...
            string(sequence)+"_signalchange_problem_log.csv"));       
    end
end
try
    header = ['LBID', 'substance', string(conds)];
    T = cell2table(signalchange, 'VariableNames',header);
    output_filename ="signalchange_"+string(roi_name)+".txt";
    writetable(T,fullfile(output_dir, output_filename))

    %% plot signal change
    MPH = cell2mat(signalchange(strcmp(signalchange(:,2),'MPH'), ...
        3:2+numel(conds)));
    NIC = cell2mat(signalchange(strcmp(signalchange(:,2),'NIC'), ...
        3:2+numel(conds)));
    PLC = cell2mat(signalchange(strcmp(signalchange(:,2),'PLC'), ...
        3:2+numel(conds)));

    mean_MPH = mean(MPH); sem_MPH = std(MPH)/sqrt(length(MPH));
    mean_NIC = mean(NIC); sem_NIC = std(NIC)/sqrt(length(NIC));
    mean_PLC = mean(PLC); sem_PLC = std(PLC)/sqrt(length(PLC));

    y = [mean_MPH mean_NIC mean_PLC; sem_MPH sem_NIC sem_PLC];

    % defaults for this blog post
    width =4.5;     % Width in inches
    height = 2.5;    % Height in inches
    alw = 0.75;    % AxesLineWidth
    fsz = 11;      % Fontsize
    lw = 2;      % LineWidth
    msz = 8;       % MarkerSize
    grey = [0.4 , 0.4 , 0.4] ;
    figure(1)

    % the properties we've been using in the figures
    pos = get(gcf, 'Position');
    % size
    set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]);
    % properties
    set(gca, 'FontSize', fsz, 'LineWidth', alw)
    set(0,'defaultLineLineWidth',lw);
    set(0,'defaultLineMarkerSize',msz);
    set(0,'defaultLineLineWidth',lw);
    set(0,'defaultLineMarkerSize',msz);

    % set the default size for display
    defpos = get(0,'defaultFigurePosition');
    set(0,'defaultFigurePosition', [defpos(1) defpos(2) ...
        width*100, height*100]);

    % set the defaults for saving/printing to a file
    set(0,'defaultFigureInvertHardcopy','on');
    set(0,'defaultFigurePaperUnits','inches');
    defsize = get(gcf, 'PaperSize');
    left = (defsize(1)- width)/2;
    bottom = (defsize(2)- height)/2;
    defsize = [left, bottom, width, height];
    set(0, 'defaultFigurePaperPosition', defsize);

    clf;

    [hBar, hErrorbar] = barwitherr([ ...
        y(2,1:numel(conds)); ...
        y(2,numel(conds)+1:numel(conds)*2); ...
        y(2,numel(conds)*2+1:numel(conds)*3) ], ...
        [ ...
        y(1,1:numel(conds)); ...
        y(1,numel(conds)+1:numel(conds)*2); ...
        y(1,numel(conds)*2+1:numel(conds)*3) ], ...
        'k');

    set(hBar, 'FaceColor',grey, 'BarWidth', 0.5);
    set(gca,'XTickLabel',{'MPH','NIC','PLC'}, 'Box','off');

    colors = ["red", "green", "blue"];
    for c=1:numel(conds)
        set(hBar(c),'FaceColor', colors(c),'DisplayName', ...
            string(conds(c)));
    end
    legend(hBar);

    if string(sequence) == "PROCLEARN"
        set(gca, 'YTick', -0.005 :0.001: 0.005);ylim([-0.007 0.005]);
    else
        set(gca, 'YTick', -0.1 :0.1: 0.4);ylim([-0.2 0.4])
    end

    set(hErrorbar, 'Linewidth',2);
    xlabel('Group');
    ylabel('% signal change');

    % applyhatch_plusC(gcf,'\-x.',[],[],[],600,2)

    graph_name = [fullfile(output_dir,roi_name)];
    saveas(figure(1), graph_name,'svg');
    close;
catch
    return;
end
end