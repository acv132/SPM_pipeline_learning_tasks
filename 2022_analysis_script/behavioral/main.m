function main
% Behavioral data analysis
% $Author: A. Vorreuther $Date: 2022/03/28

clear;
addpath("..\utils", "OLA", "PL")

% import your data paths with this function
[~,beh_data_path,~] = importPaths;

subjects =list_vp_names(beh_data_path);

if isfile("..\results\behavioral\NEUTRAL.mat")
    disp('NEUTRAL.mat already generated');
else
    createNEUTRALmat(beh_data_path, subjects);
end
if isfile("..\results\behavioral\SPSS_taskvariables.csv")
    disp('SPSS_taskvariables.csv already generated');
else
    createSPSSinput;
end

MedList = addMedicationList;

analyzeOLA(beh_data_path, subjects, MedList)

analyzePL(beh_data_path, subjects, MedList)
plotPL

end

function createNEUTRALmat(beh_data_path, subjects)
% createNEUTRALmat Creates subject structure array of behavioral
% measurements
% createNEUTRALmat(beh_data_path, subjects) takes as first argument a
% directory in form of a string leading to the behavioral data folder 
% containing all subjects, e.g. "D:\DATA\Behavioral"; the second argument
% should be a cell of size 1xn number of subjects where each cell contains
% a string or character array with a subject number, e.g. "001".
% $Author: A. Kasparbauer, A. Vorreuther
missing_data = [];
for i = 1 : numel(subjects)

    subject_name = subjects{1,i};

    beh_sbj_path = fullfile(beh_data_path,subject_name);
    ola_file = fullfile(beh_sbj_path, 'OLA.mat');
    proclearn_file = fullfile(beh_sbj_path,'ProcLearn.mat');
    try
        load(ola_file{1});
        load(proclearn_file{1});
    catch
        disp('File(s) not found for subject "' + string(subject_name) + '"\n');
        missing_data(end + 1) = string(subject_name);
    end
    fprintf ('Processing subject "%s"\t Substance %s\n' , string(subject_name),string(substance));

    NEUTRAL{i}.substance = substance;
    NEUTRAL{i}.subject_name = subject_name;
    NEUTRAL{i}.OLA = OLA;
    NEUTRAL{i}.PL = PL;

end
save('..\results\behavioral\NEUTRAL.mat', 'NEUTRAL');
save('..\results\behavioral\missing_data.mat', 'missing_data');
disp('READY');

clear;

end

function createSPSSinput
% createSPSSinput creates SPSS data input matrix of behavioral data from
% NEUTRAL.mat file (see createNEUTRALmat function above)
% $Author: A. Kasparbauer, A. Vorreuther

load("..\results\behavioral\NEUTRAL.mat", "NEUTRAL");
for i = 1:size(NEUTRAL,2)

    substance = NEUTRAL{1,i}.substance;
    subject_name = NEUTRAL{1,i}.subject_name;

    SPSS_MAT{i,1} = subject_name;
    SPSS_MAT{i,2} = substance;

    fprintf ('Processing subject "%s"\t Substance %s\n' , string(subject_name),string(substance));

    % OLA variables
    SPSS_MAT{i,3}= NEUTRAL{1,i}.OLA.OLD.correctJ.Per;
    SPSS_MAT{i,4}= NEUTRAL{1,i}.OLA.OLD.correctJ.MRT;
    SPSS_MAT{i,5}= NEUTRAL{1,i}.OLA.OLD.correctJ.SD;

    SPSS_MAT{i,6}= NEUTRAL{1,i}.OLA.OLD.falseJ.Per;
    SPSS_MAT{i,7}= NEUTRAL{1,i}.OLA.OLD.falseJ.MRT;
    SPSS_MAT{i,8}= NEUTRAL{1,i}.OLA.OLD.falseJ.SD;

    SPSS_MAT{i,9}= NEUTRAL{1,i}.OLA.OLD.CORSCR.Per;
    SPSS_MAT{i,10}= NEUTRAL{1,i}.OLA.OLD.CORSCR.MRT_CORSCR;
    SPSS_MAT{i,11}= NEUTRAL{1,i}.OLA.OLD.CORSCR.SD_CORSCR;

    SPSS_MAT{i,12}= NEUTRAL{1,i}.OLA.OLD.FALSCR.Per;
    SPSS_MAT{i,13}= NEUTRAL{1,i}.OLA.OLD.FALSCR.MRT_FALSCR;
    SPSS_MAT{i,14}= NEUTRAL{1,i}.OLA.OLD.FALSCR.SD_FALSCR;


    SPSS_MAT{i,15}= NEUTRAL{1,i}.OLA.OLD.FORGSCR.Per;
    SPSS_MAT{i,16}= NEUTRAL{1,i}.OLA.OLD.FORGSCR.MRT_FORGSCR;
    SPSS_MAT{i,17}= NEUTRAL{1,i}.OLA.OLD.FORGSCR.SD_FORGSCR;

    SPSS_MAT{i,18}= NEUTRAL{1,i}.OLA.OLD.MISSSCR.Per;

    SPSS_MAT{i,19}= NEUTRAL{1,i}.OLA.NEW.COR.PER;
    SPSS_MAT{i,20}= NEUTRAL{1,i}.OLA.NEW.COR.MRT;
    SPSS_MAT{i,21}= NEUTRAL{1,i}.OLA.NEW.COR.SD;

    SPSS_MAT{i,22}= NEUTRAL{1,i}.OLA.NEW.FAL.PER;
    SPSS_MAT{i,23}= NEUTRAL{1,i}.OLA.NEW.FAL.MRT;
    SPSS_MAT{i,24}= NEUTRAL{1,i}.OLA.NEW.FAL.SD;

    SPSS_MAT{i,25}= NEUTRAL{1,i}.OLA.NEW.MISS.PER;

    SPSS_MAT{i,26}= NEUTRAL{1,i}.OLA.dprime;
    SPSS_MAT{i,27}= NEUTRAL{1,i}.OLA.response_criterion.c;
    SPSS_MAT{i,28}= NEUTRAL{1,i}.OLA.response_criterion.beta;
    SPSS_MAT{i,29}= NEUTRAL{1,i}.OLA.chisquare_value;
    SPSS_MAT{i,30}= NEUTRAL{1,i}.OLA.chisquare_p;

    % PL variables
    SPSS_MAT{i,31}= NEUTRAL{1,i}.PL.OVERALL_MEAN_RT;
    SPSS_MAT{i,32}= NEUTRAL{1,i}.PL.OVERALL_SD_RT;
    SPSS_MAT{i,33}= NEUTRAL{1,i}.PL.OVERALL_ERR;

    SPSS_MAT(i,34:43)= NEUTRAL{1,i}.PL.RAN.Errors(1:10,3);
    SPSS_MAT(i,44:53)= NEUTRAL{1,i}.PL.RAN.MRT_filteredRTS(1:10,1);
    SPSS_MAT(i,54:63)= NEUTRAL{1,i}.PL.RAN.SD_filteredRTS(1:10,1);
    SPSS_MAT(i,64:73)= NEUTRAL{1,i}.PL.RAN.Median_filteredRTS(1:10,1);


    SPSS_MAT(i,74:83)= NEUTRAL{1,i}.PL.PAT.Errors(1:10,3);
    SPSS_MAT(i,84:93)= NEUTRAL{1,i}.PL.PAT.MRT_filteredRTS(1:10,1);
    SPSS_MAT(i,94:103)= NEUTRAL{1,i}.PL.PAT.SD_filteredRTS(1:10,1);
    SPSS_MAT(i,104:113)= NEUTRAL{1,i}.PL.PAT.Median_filteredRTS(1:10,1);
    SPSS_MAT(i,114:123)=mat2cell(NEUTRAL{1,i}.PL.RAN.SEQ_blockMRT,[1],[1 1 1 1 1 1 1 1 1 1]);
    SPSS_MAT(i,124:133)= mat2cell(NEUTRAL{1,i}.PL.PAT.SEQ_blockMRT,[1],[1 1 1 1 1 1 1 1 1 1]);


    MRT_PL_EFFECT =  mat2cell(NEUTRAL{1,i}.PL.MRT_PL_EFFECT,[1 1 1 1 1 1 1 1 1 1],[1]);
    MEDIAN_PL_EFFECT =  mat2cell(NEUTRAL{1,i}.PL.MEDIAN_PL_EFFECT,[1 1 1 1 1 1 1 1 1 1],[1]);

    SPSS_MAT(i,134:143)= MRT_PL_EFFECT;
    SPSS_MAT(i,144:153)= MEDIAN_PL_EFFECT;
    SPSS_MAT(i,154:157)=mat2cell(NEUTRAL{1,i}.PL.PAT.SEQ_type,[1 1 1 1],[1]);
    SPSS_MAT(i,158:161)=mat2cell(NEUTRAL{1,i}.PL.PAT.SEQ_amount,[1 1 1 1],[1]);

end

header = {'LBID', 'Drug',...
    'Per_correctJudgement','MRT_correctJudgement', 'SD_correctJudgement',...
    'Per_falseJudgement','MRT_falseJudgement', 'SD_falseJudgement',...
    'Per_CORSCR', 'MRT_CORSCR', 'SD_CORSCR',...
    'Per_FALSCR', 'MRT_FALSCR', 'SD_FALSCR',...
    'Per_FORGSCR', 'MRT_FORGSCR', 'SD_FORGSCR',...
    'Per_MISSCR',...
    'Per_CORNEW', 'MRT_CORNEW','SD_CORNEW',...
    'Per_FALNEW', 'MRT_FALNEW','SD_FALNEW',...
    'Per_MISSNEW',...
    'OLA_dprime', 'OLA_responsebias_c','OLA_responsebias_beta','OLA_CHISQUARE','OLA_P_CHISQUARE_P'...
    'PL_MRT','PL_SD','PL_ERR',...
    'ERR_RAN01','ERR_RAN02','ERR_RAN03','ERR_RAN04','ERR_RAN05','ERR_RAN06','ERR_RAN07','ERR_RAN08','ERR_RAN09','ERR_RAN10',...
    'MRT_RAN01','MRT_RAN02','MRT_RAN03','MRT_RAN04','MRT_RAN05','MRT_RAN06','MRT_RAN07','MRT_RAN08','MRT_RAN09','MRT_RAN10',...
    'SD_RAN01','SD_RAN02','SD_RAN03','SD_RAN04','SD_RAN05','SD_RAN06','SD_RAN07','SD_RAN08','SD_RAN09','SD_RAN10',...
    'MEDIAN_RAN01','MEDIAN_RAN02','MEDIAN_RAN03','MEDIAN_RAN04','MEDIAN_RAN05','MEDIAN_RAN06','MEDIAN_RAN07','MEDIAN_RAN08','MEDIAN_RAN09','MEDIAN_RAN10',...
    'ERR_PAT01','ERR_PAT02','ERR_PAT03','ERR_PAT04','ERR_PAT05','ERR_PAT06','ERR_PAT07','ERR_PAT08','ERR_PAT09','ERR_PAT10',...
    'MRT_PAT01','MRT_PAT02','MRT_PAT03','MRT_PAT04','MRT_PAT05','MRT_PAT06','MRT_PAT07','MRT_PAT08','MRT_PAT09','MRT_PAT10',...
    'SD_PAT01','SD_PAT02','SD_PAT03','SD_PAT04','SD_PAT05','SD_PAT06','SD_PAT07','SD_PAT08','SD_PAT09','SD_PAT10',...
    'MEDIAN_PAT01','MEDIAN_PAT02','MEDIAN_PAT03','MEDIAN_PAT04','MEDIAN_PAT05','MEDIAN_PAT06','MEDIAN_PAT07','MEDIAN_PAT08','MEDIAN_PAT09','MEDIAN_PAT10',...
    'MRT_SEQ_RAN01','MRT_SEQ_RAN02','MRT_SEQ_RAN03','MRT_SEQ_RAN04','MRT_SEQ_RAN05','MRT_SEQ_RAN06','MRT_SEQ_RAN07','MRT_SEQ_RAN08','MRT_SEQ_RAN09','MRT_SEQ_RAN10',...
    'MRT_SEQ_PAT01','MRT_SEQ_PAT02','MRT_SEQ_PAT03','MRT_SEQ_PAT04','MRT_SEQ_PAT05','MRT_SEQ_PAT06','MRT_SEQ_PAT07','MRT_SEQ_PAT08','MRT_SEQ_PAT09','MRT_SEQ_PAT10',...
    'PL_EFFECT_MRT_01','PL_EFFECT_MRT_02','PL_EFFECT_MRT_03','PL_EFFECT_MRT_04','PL_EFFECT_MRT_05','PL_EFFECT_MRT_06','PL_EFFECT_MRT_07','PL_EFFECT_MRT_08','PL_EFFECT_MRT_09','PL_EFFECT_MRT_10',...
    'PL_EFFECT_MEDIAN_01','PL_EFFECT_MEDIAN_02','PL_EFFECT_MEDIAN_03','PL_EFFECT_MEDIAN_04','PL_EFFECT_MEDIAN_05','PL_EFFECT_MEDIAN_06','PL_EFFECT_MEDIAN_07','PL_EFFECT_MEDIAN_08','PL_EFFECT_MEDIAN_09','PL_EFFECT_MEDIAN_10',...
    'SEQ_1','SEQ_2','SEQ_3','SEQ_4','SEQ_1_amount','SEQ_2_amount','SEQ_3_amount','SEQ_4_amount' };

SPSS_MAT = [header; SPSS_MAT];

dlmcell('..\results\behavioral\SPSS_taskvariables.csv',SPSS_MAT,',');

% TODO: Why dlmcell instead of this code?
% % Convert cell to a table and use first row as variable names
% T = cell2table(SPSS_MAT(2:end,:),'VariableNames',SPSS_MAT(1,:));
% % Write the table to a CSV file
% writetable(T,'SPSS_taskvariables_new.csv')

clear;
disp('READY');

end

