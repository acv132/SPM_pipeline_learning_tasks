function analyzePL(beh_data_path, subjects, MedList)
% analyzePL analyses random vs patterned trials of the Procedural Learning
% (PL) task
% analyzePL(beh_data_path, subjects, MedList) takes as first argument
% a directory in form of a string leading to the behavioral data folder 
% containing all subjects, e.g. "D:\DATA\Behavioral"; 
% the second argument should be a cell of size 1xn number of subjects 
% where each cell contains a string or character array with a subject 
% number, e.g. "001"; 
% the third argument should be a cell of size n number of subjecty x 2 
% where one row contains the subject number and the second contains a 
% string indicating the substance group the subject was assigned to.
% $Author: A. Kasparbauer, A. Vorreuther $Date: 2022/03/28
pl_errors = [];
for i = 1 : numel(subjects)

    subject_name = subjects{1,i};
    subject_name = subject_name{1};

    % fMRI_sbj_path = fullfile (fMRI_data_path, subjects{i});
    beh_sbj_path = fullfile(beh_data_path,subject_name);
    if ~isfile(fullfile(beh_sbj_path, 'ProcLearn.mat'))
        try
            % create column vector output
            ProcLearn_raw = convertTextToColumnVectors(beh_sbj_path, ['ProcLearn.*final']);

            % find substance from txt file
            subject_ID = str2double(subject_name);
            substance =cell2mat(MedList(([MedList{:,1}]==subject_ID),2));
            ProcLearn=[];

            for s = 10:size(ProcLearn_raw,1)-1

                stimulus = ProcLearn_raw{s,3};
                button_press = ProcLearn_raw{s,9};
                correct = ProcLearn_raw{s,10};
                onset = ProcLearn_raw{s,6};
                duration = ProcLearn_raw{s,7};
                RT = ProcLearn_raw{s,8};
                block_no = ProcLearn_raw{s,15};

                if strcmp(stimulus, 'A_1')==1 || strcmp(stimulus,'A_2')==1 || strcmp(stimulus,'A_3') ==1 || strcmp(stimulus, 'A_4')==1
                    block_type = 'PAT';
                    block_name = ['PAT' num2str(block_no)];
                    seq_name = strsplit(stimulus,'_');
                    seq_no = str2num(seq_name{1,2});
                elseif strcmp(stimulus,'A_0')==1
                    block_type ='RAN';
                    block_name = ['RAN' num2str(block_no)];
                    seq_no = 0;
                else block_type = [];block_name =[];seq_no =[];
                end


                xpos = sign(cell2mat(ProcLearn_raw(s+1,18))); % 1 if greater than zero, 0 when smaller than 0
                ypos = sign(cell2mat(ProcLearn_raw(s+1,19)));

                %     Stimuli Position
                if xpos == 1 && ypos == 1; direction = 'right_up'; quadrant = 2;
                elseif xpos == -1 && ypos == 1; direction = 'left_up';  quadrant = 1;
                elseif xpos == -1 && ypos == -1; direction = 'left_down'; quadrant = 3;
                elseif xpos == 1 && ypos == -1; direction = 'right_down'; quadrant = 4;
                else quadrant =0;
                end

                ProcLearn{s,1} = stimulus;
                ProcLearn{s,2} =  block_type;
                ProcLearn{s,3} =  block_name;
                ProcLearn{s,4} =  duration;
                ProcLearn{s,5} =  onset;
                ProcLearn{s,6} =  button_press;
                ProcLearn{s,7} =  RT;
                ProcLearn{s,8} = correct ;
                ProcLearn{s,9} = quadrant;
                ProcLearn{s,10} = block_no;
                ProcLearn{s,11} = seq_no;


            end
            clearvars s stimulus block_type block_name duration onset button_press RT correct quadrant block_no seq_no seq_name xpos ypos direction
            ProcLearn(any(cellfun(@isempty,ProcLearn),2),:) = []; % delete empty cells
            %   clearvars stmulus block_no block_type duration onset button_press RT correct ProcLearn_raw

            header = {'Sequence', 'Block_type', 'Bock_name', 'duration', 'onset', 'Button','RT','correct','Quadrant','BlockNumber','SEQ_Number'};
            ProcLearn_file = [header; ProcLearn];

            textfile_name= [subject_name '^ProcLearn.csv'];
            textfile_path = fullfile(beh_sbj_path,textfile_name);
            dlmcell(textfile_path, ProcLearn_file,',');


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            N_trials = size(ProcLearn,1);
            OVERALL_MEAN_RT = mean(cell2mat(ProcLearn(:,4)));
            OVERALL_SD_RT = std(cell2mat(ProcLearn(:,4)));
            OVERALL_ERR = sum(cell2mat(ProcLearn(:,8))==1);


            fprintf ('Processing subject "%s"\t Substance %s\n' , subject_name,substance);

            fprintf('Overall mean "%.2f"\n ' , OVERALL_MEAN_RT);
            fprintf('Overall SD "%.2f"\n ' , OVERALL_SD_RT);
            fprintf('Overall ERR trials "%.0f"\n\n ' , OVERALL_ERR);


            RT_high_cutoff = OVERALL_MEAN_RT+ 2.5*OVERALL_SD_RT;
            RT_low_cutoff = 200;


            %%%%%%%%%%%%%%%%%%%%%% SEQUENCES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% PATTERN
            A1_all = ProcLearn(strcmp(ProcLearn(:,1),'A_1'),4:end);
            A2_all = ProcLearn(strcmp(ProcLearn(:,1),'A_2'),4:end);
            A3_all = ProcLearn(strcmp(ProcLearn(:,1),'A_3'),4:end);
            A4_all = ProcLearn(strcmp(ProcLearn(:,1),'A_4'),4:end);

            PAT_all =cell2mat([A1_all;A2_all;A3_all;A4_all]);
            PAT_all = sortrows(PAT_all,2);

            N_A1 = size(A1_all,1)/5;
            N_A2 = size(A2_all,1)/5;
            N_A3 = size(A3_all,1)/5;
            N_A4 = size(A4_all,1)/5;

            SEQ_amount = [N_A1;N_A2;N_A3;N_A4];

            % median of 4 Trials in 5 Trials Sequence is used to create mean of
            % Block
            t=0;
            for k = 1: 5: size(PAT_all,1)-5

                if sum((PAT_all(k:k+4,5))==0)
                    t = t+1;
                    RTs = (PAT_all(k+1:k+4,1));
                    median_RTs = median(RTs);
                    block_no = (PAT_all(k,7));
                    seq_no = (PAT_all(k,8));
                    onset = (PAT_all(k,2));

                    PAT_seq_med(t,1) = seq_no;
                    PAT_seq_med(t,2) = block_no;
                    PAT_seq_med(t,3) = median_RTs;
                    PAT_seq_med(t,4) = onset;

                end

            end
            %

            %MEAN for Blocks
            for l= 1:10
                PAT_SEQ(l,1) = mean(PAT_seq_med(PAT_seq_med(:,2)==l,3));
            end
            % Mean for Seq
            for q = 1:4
                SEQ(q,1) = mean(PAT_seq_med(PAT_seq_med(:,1)==q,3));
            end

            clearvars seq_no block_no median RTs t k l

            %% RANDOM
            A0_all = ProcLearn(strcmp(ProcLearn(:,1),'A_0'),4:end);
            RAN_all = cell2mat(A0_all);


            size_RAN = round(size(RAN_all,1)./4).*4; % The number of Random Trials needs to be a multiplier of 4
            t=0;
            for k = 1: 4: size_RAN-4

                if sum((RAN_all(k:k+3,5))==0)
                    t = t+1;
                    RTs = (RAN_all(k+1:k+3,1));
                    median_RTs = median(RTs);
                    block_no = (RAN_all(k,7));
                    seq_no = (RAN_all(k,8));
                    onset = (RAN_all(k,2));

                    RAN_seq_med(t,1) = seq_no;
                    RAN_seq_med(t,2) =block_no;
                    RAN_seq_med(t,3) = median_RTs;
                    RAN_seq_med(t,4) = onset;

                end

            end

            %MEAN for Blocks

            for l= 1:10
                RAN_SEQ(l,1) = mean(RAN_seq_med(RAN_seq_med(:,2)==l,3));
            end
            clearvars seq_no block_no median RTs t k l


            %&&&&&&& SEPARATE in BLOCK TYPE &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            %&&&&&&&&&&&&&&&&&&&&&& PATTERN &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

            PAT_all = ProcLearn(strcmp(ProcLearn(:,2),'PAT'),:);
            PAT.ERR_all = sum(cell2mat(PAT_all(:,8))==1);
            PAT.MEAN_RTS = mean(cell2mat(PAT_all(:,4)));
            PAT.MEDIAN_RTS = median(cell2mat(PAT_all(:,4)));
            PAT.SD_RTS = std(cell2mat(PAT_all(:,4)));

            for f = 1: 10
                no = f;
                block_no = ['PAT' num2str(no)];

                PAT_MATRIX = PAT_all(strcmp(PAT_all(:,3),block_no),:);

                RTS = cell2mat(PAT_MATRIX(:,4:8));
                correctRTS = RTS(RTS(:,5)==0);
                filteredRTS= correctRTS(correctRTS(:,1)<RT_high_cutoff);
                incorrectRTS=RTS(RTS(:,5)==0);
                errors = RTS((RTS(:,5)==1),:);

                PAT.BLOCKS{f}.N = size(RTS,1);
                PAT.BLOCKS{f}.MRT = mean(cell2mat(PAT_MATRIX(:,4)));
                PAT.BLOCKS{f}.SD = std(cell2mat(PAT_MATRIX(:,4)));
                PAT.BLOCKS{f}.MED = median(cell2mat(PAT_MATRIX(:,4)));
                PAT.BLOCKS{f}.ONSET = min(cell2mat(PAT_MATRIX(:,5)));
                PAT.BLOCKS{f}.DURATON = max(cell2mat(PAT_MATRIX(:,5)))-min(cell2mat(PAT_MATRIX(:,5)));
                PAT.BLOCKS{f}.ERRORS = errors;
                PAT.BLOCKS{f}.RTS = RTS;
                PAT.BLOCKS{f}.BLOCK = block_no;
                PAT.BLOCKS{f}.correctRTS = correctRTS(:,1);
                PAT.BLOCKS{f}.filteredRTS = filteredRTS(:,1);
                PAT.BLOCKS{f}.errors = errors(:,1);
                PAT.BLOCKS{f}.MRT_filteredRTS = mean(filteredRTS(:,1));
                PAT.BLOCKS{f}.SD_filteredRTS = std(filteredRTS(:,1));
                PAT.BLOCKS{f}.MED_filteredRTS = median(filteredRTS(:,1));
                PAT.BLOCKS{f}.all = PAT_MATRIX;

                PAT.Onsets{f,1} = min(cell2mat(PAT_MATRIX(:,5)));
                PAT.Duration{f,1}= max(cell2mat(PAT_MATRIX(:,5)))-min(cell2mat(PAT_MATRIX(:,5)));
                PAT.MRT_filteredRTS{f,1} = mean(filteredRTS(:,1));
                PAT.SD_filteredRTS{f,1} = std(filteredRTS(:,1));
                PAT.Median_filteredRTS{f,1} = median(filteredRTS(:,1));
                PAT.MRT_correctRTS{f,1} = mean(correctRTS(:,1));
                PAT.SD_correctRTS{f,1} = std(correctRTS(:,1));
                PAT.Median_correctRTS{f,1} = median(correctRTS(:,1));
                PAT.Errors{f,1} = sum(cell2mat(PAT_MATRIX(:,8))==1);
                PAT.Errors{f,2} = size(RTS,1);
                per_error = (PAT.Errors{f,1}/PAT.Errors{f,2})*100;
                PAT.Errors{f,3} = per_error;

            end


            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            %&&&&&&&&&&&&&&&&&&&RANDOM &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            RAN_all = ProcLearn(strcmp(ProcLearn(:,2),'RAN'),:);
            RAN.ERR_all = sum(cell2mat(RAN_all(:,8))==1);
            RAN.MEAN_RTS = mean(cell2mat(RAN_all(:,4)));
            RAN.MEDIAN_RTS = median(cell2mat(RAN_all(:,4)));
            RAN.SD_RTS = std(cell2mat(PAT_all(:,4)));


            for g = 1: 10
                no = g;
                block_no = ['RAN' num2str(no)];

                RAN_MATRIX = RAN_all(strcmp(RAN_all(:,3),block_no),:);

                RTS = cell2mat(RAN_MATRIX(:,4:8));
                correctRTS = RTS(RTS(:,5)==0);
                filteredRTS= correctRTS(correctRTS(:,1)<RT_high_cutoff);
                incorrectRTS=RTS(RTS(:,5)==0);
                errors = RTS((RTS(:,5)==1),:);

                RAN.BLOCKS{g}.N = size(RTS,1);
                RAN.BLOCKS{g}.MRT = mean(cell2mat(RAN_MATRIX(:,4)));
                RAN.BLOCKS{g}.SD = std(cell2mat(RAN_MATRIX(:,4)));
                RAN.BLOCKS{g}.MED = median(cell2mat(RAN_MATRIX(:,4)));
                RAN.BLOCKS{g}.ONSET = min(cell2mat(RAN_MATRIX(:,5)));
                RAN.BLOCKS{g}.DURATON = max(cell2mat(RAN_MATRIX(:,5)))-min(cell2mat(RAN_MATRIX(:,5)));
                RAN.BLOCKS{g}.ERRORS = errors;
                RAN.BLOCKS{g}.RTS = RTS;
                RAN.BLOCKS{g}.BLOCK = block_no;
                RAN.BLOCKS{g}.correctRTS = correctRTS(:,1);
                RAN.BLOCKS{g}.filteredRTS = filteredRTS(:,1);
                RAN.BLOCKS{g}.errors = errors(:,1);
                RAN.BLOCKS{g}.MRT_filteredRTS = mean(filteredRTS(:,1));
                RAN.BLOCKS{g}.SD_filteredRTS = std(filteredRTS(:,1));
                RAN.BLOCKS{g}.MED_filteredRTS = median(filteredRTS(:,1));
                RAN.BLOCKS{g}.all = RAN_MATRIX;


                RAN.Onsets{g,1} = min(cell2mat(RAN_MATRIX(:,5)));
                RAN.Duration{g,1}= max(cell2mat(RAN_MATRIX(:,5)))-min(cell2mat(RAN_MATRIX(:,5)));
                RAN.MRT_filteredRTS{g,1} = mean(filteredRTS(:,1));
                RAN.SD_filteredRTS{g,1} = std(filteredRTS(:,1));
                RAN.Median_filteredRTS{g,1} = median(filteredRTS(:,1));
                RAN.MRT_correctRTS{g,1} = mean(correctRTS(:,1));
                RAN.SD_correctRTS{g,1} = std(correctRTS(:,1));
                RAN.Median_correctRTS{g,1} = median(correctRTS(:,1));
                RAN.Errors{g,1} = sum(cell2mat(RAN_MATRIX(:,8))==1);
                RAN.Errors{g,2} = size(RTS,1);
                per_error = (RAN.Errors{g,1}/RAN.Errors{g,2})*100;
                RAN.Errors{g,3} = per_error;

            end

            PL.RAN = RAN;
            PL.PAT = PAT;
            PL.N_trials = N_trials;
            PL.OVERALL_MEAN_RT = OVERALL_MEAN_RT;
            PL.OVERALL_SD_RT = OVERALL_SD_RT;
            PL.OVERALL_ERR = OVERALL_ERR;
            MEDIAN_PL_EFFECT =  cell2mat(RAN.Median_filteredRTS)-cell2mat(PAT.Median_filteredRTS);
            MRT_PL_EFFECT =  cell2mat(RAN.MRT_filteredRTS)-cell2mat(PAT.MRT_filteredRTS);
            PL.MEDIAN_PL_EFFECT(1:10,1) =MEDIAN_PL_EFFECT(1:10,1);
            PL.MRT_PL_EFFECT(1:10,1) = MRT_PL_EFFECT(1:10,1);
            PL.RAN.SEQ = A0_all;
            PL.PAT.SEQ = [A1_all;A2_all;A3_all;A4_all];
            PL.PAT.SEQ_type = SEQ;
            PL.PAT.SEQ_amount = SEQ_amount;
            PL.RAN.SEQ_blockMRT = transpose(RAN_SEQ);
            PL.PAT.SEQ_blockMRT = transpose(PAT_SEQ);
            %%save
            save(fullfile(beh_sbj_path, 'ProcLearn'), 'subject_name', 'PL', 'substance');
        catch
            sprintf("subject " + string(subject_name) + " could not be analysed\n");
            pl_errors(end + 1) = string(subject_name);
        end
    else
        disp("PL analysis " +subject_name+ " already complete");
        continue
    end
end
disp('READY');
clear;



