function analyzeOLA(beh_data_path, subjects, MedList)
% analyzeOLA analyses encoding and retrieval sessions, respectively, of the
% Object Location Association (OLA) task;
% analyzeOLA(beh_data_path, subjects, MedList) takes as first argument
% a directory in form of a string leading to the behavioral data folder 
% containing all subjects, e.g. "D:\DATA\Behavioral"; 
% the second argument should be a cell of size 1xn number of subjects 
% where each cell contains a string or character array with a subject 
% number, e.g. "001"; 
% the third argument should be a cell of size n number of subjecty x 2 
% where one row contains the subject number and the second contains a 
% string indicating the substance group the subject was assigned to.
% $Author: A. Kasparbauer, A. Vorreuther $Date: 2022/04/28
ola_errors = [];
for i = 1 : numel(subjects)
    OLA_E = [];
    OLA_R = [];

    subject_name = subjects{1,i};
    subject_name = subject_name{1};

    % fMRI_sbj_path = fullfile (fMRI_data_path, subjects{i});
    beh_sbj_path = fullfile(beh_data_path,subject_name);

    if ~isfile(fullfile(beh_sbj_path, 'OLA.mat'))
        try
            % create column vector output
            OLA = convertTextToColumnVectors(beh_sbj_path, ['OLA.*final']);

            % find the countdown starting OLA_E and OLA_R
            countdown = find(strcmp(OLA(:,3),'CD_5'));

            colHeadings = {'t','Nr', 'Picture' ,'Kat', 'Picture_Number', 'Onset', 'Duration', 'RT' ,'BT' ,'correct' ,'BFT_PT', 'Pause', 'FB_PT' ,'FB_Dur', 'Ref', 'IVal' ,'UVal' ,'XPos', 'YPos', 'Values'};
            OLA_Data = cell2struct(OLA(2:end,:), colHeadings, 2);

            %% OLA encoding
            OlA_E=[];
            for s = 1:max(countdown)

                picture = OLA_Data(s,1).Picture;
                picture_number = OLA_Data(s,1).Picture_Number;


                str = strsplit(picture,'_');
                category = str{1,1};

                if strcmp(category,'A')==1 || strcmp(category,'B')


                    if strcmp(category, 'A')==1
                        category_type = 'artificial';
                    elseif strcmp(category,'B') ==1
                        category_type = 'natural';
                    end



                    onset = OLA_Data(s,1).Onset;
                    duration = OLA_Data(s,1).Duration;

                    xpos = sign(OLA_Data(s,1).XPos); % 1 if greater than zero, 0 when smaller than 0
                    ypos = sign(OLA_Data(s,1).YPos);


                    %     Stimuli Position
                    if xpos == 1 && ypos == 1; direction = 'right_up'; quadrant = 2;
                    elseif xpos == -1 && ypos == 1; direction = 'left_up';  quadrant = 1;
                    elseif xpos == -1 && ypos == -1; direction = 'left_down'; quadrant = 3;
                    elseif xpos == 1 && ypos == -1; direction = 'right_down'; quadrant = 4;
                    end

                    % Response

                    button_press = OLA_Data(s,1).BT; RT = OLA_Data(s,1).RT;
                    if button_press ==-1 && OLA_Data(s+1,1).BT~=-1
                        button_press = OLA_Data(s+1,1).BT; RT = OLA_Data(s+1,1).RT+ duration;
                    end

                    Buttons = {'artificial','natural'};

                    if button_press == 1 || button_press ==2
                        button_type = Buttons{:,button_press};
                    else
                        button_type = 'miss';
                    end

                    % Judgement

                    if strcmp(category_type,button_type) ==1
                        Judgement = 'correct_J';
                    elseif strcmp (category_type,button_type) ==0 && strcmp(button_type,'miss') ==1
                        Judgement = 'miss_J';
                    elseif strcmp(category_type,button_type) ==0 && strcmp(button_type,'miss')==0
                        Judgement = 'false_J';
                    end

                    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    %&&&&&&&&&&&&&&&&&&&CORRECT 10034 Button Switch &&&&&&&&&&&&&&&&&&&
                    if strcmp(subject_name, '10034')==1
                        if strcmp(Judgement, 'correct_J') ==1
                            Judgement= 'false_J';
                        elseif strcmp (Judgement,'false_J')==1
                            Judgement = 'correct_J';
                        end
                    end
                    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


                    OLA_E{s,1} = picture;
                    OLA_E{s,2} =  picture_number;
                    OLA_E{s,3} =category_type;
                    OLA_E{s,4} =  duration;
                    OLA_E{s,5} =  onset;
                    OLA_E{s,6} =  button_press;
                    OLA_E{s,7} =  button_type;
                    OLA_E{s,8} = RT ;
                    OLA_E{s,9} =  Judgement;
                    OLA_E{s,10} =   quadrant;
                    OLA_E{s,11} =   direction;
                end
            end
            clearvars picture pictue_number category_type duration onset button_press button_type RT Judgement quadrant direction
            header = {'Pic','Number', 'Pic_Cat','Duration', 'Onset', 'Button', 'Button_Type', 'RT','Judgement','Quadrant','StimuliPos'};

            OLA_E = [header; OLA_E];
            OLA_E(any(cellfun(@isempty,OLA_E),2),:) = []; % delete empty cells

            %% OLA retrieval
            OLA_R=[];

            for t = max(countdown):size(OLA_Data,1)

                picture = OLA_Data(t,1).Picture;
                picture_number = OLA_Data(t,1).Picture_Number;


                str = strsplit(picture,'_');
                category = str{1,1};

                if strcmp(category,'A')==1 || strcmp(category,'B')


                    if strcmp(category, 'A')==1
                        category_type = 'artificial';
                    elseif strcmp(category,'B') ==1
                        category_type = 'natural';
                    end

                    onset = OLA_Data(t,1).Onset;
                    duration = OLA_Data(t,1).Duration;

                    button_press = OLA_Data(t,1).BT; RT = OLA_Data(t,1).RT;

                    if button_press ==-1 && OLA_Data(t+1,1).BT~=-1
                        button_press = OLA_Data(t+1,1).BT; RT = OLA_Data(t+1,1).RT+ duration;
                    end

                    Buttons = {'left_up','right_up','left_down','right_down','new'};

                    if button_press <=5 && button_press>0
                        button_type = Buttons{:,button_press};
                    else
                        button_type = 'miss';
                    end


                    OLA_R{t,1} = picture;
                    OLA_R{t,2} =  picture_number;
                    OLA_R{t,3} = category_type;
                    OLA_R{t,4} =  duration;
                    OLA_R{t,5} =  onset;
                    OLA_R{t,6} =  button_press;
                    OLA_R{t,7} =  button_type;
                    OLA_R{t,8} =   RT;

                end


            end

            header = {'Pic','Number', 'Pic_Cat','Duration', 'Onset', 'Button', 'Button_Type','RT'};

            OLA_R = [header; OLA_R];
            OLA_R(any(cellfun(@isempty,OLA_R),2),:) = []; % delete empty cells
            clearvars picture pictue_number category_type duration onset button_press button_type RT Judgement quadrant direction

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %%% Merge OLA_R and OLA_E
            OLA_all = [];

            for u = 2 :size(OLA_R,1)

                picture = OLA_R{u,1};
                row_encoding = OLA_E(strcmp(OLA_E(:,1),picture),:);
                if isempty(row_encoding)==1
                    row_encoding = {picture 'new' 'new' 'new' 'new', 'new','new','new', 'new', 'new',...
                        'new' };
                end
                row_retrieval = OLA_R(u,:);
                old_trial = [row_encoding row_retrieval(1,4:end)];

                OLA_all = [OLA_all; old_trial];

            end
            clearvars picture row_encoding row_retrieval old_trial u


            N_OLA_all = size(OLA_all,1);

            %% correct or incorrect retrieval %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            for n = 1: N_OLA_all
                if strcmp(OLA_all(n,11),OLA_all(n,15))==1
                    if strcmp(OLA_all(n,11),'new')== 0
                        OLA_all{n,17} = 'CORSCE';
                        OLA_all{n,18} = 'CORSCR';
                    elseif strcmp(OLA_all(n,11),'new')== 1
                        OLA_all{n,17} = 'COR_NEW';
                        OLA_all{n,18} = 'COR_NEW';
                    end
                elseif strcmp(OLA_all(n,11),OLA_all(n,15))== 0
                    if strcmp(OLA_all(n,15),'miss') == 0
                        if strcmp(OLA_all(n,15),'new')== 0 && strcmp(OLA_all(n,11),'new')==0
                            OLA_all{n,17} = 'FALSCE';
                            OLA_all{n,18} = 'FALSCR';
                        elseif  strcmp(OLA_all(n,15),'new')== 1 && strcmp(OLA_all(n,11),'new')==0
                            OLA_all{n,17} = 'FORGSCE';
                            OLA_all{n,18} = 'FORGSCR';
                        elseif  strcmp(OLA_all(n,15),'new')== 0 && strcmp(OLA_all(n,11),'new')==1
                            OLA_all{n,17} = 'FAL_NEW';
                            OLA_all{n,18} = 'FAL_NEW';
                        end
                    elseif strcmp(OLA_all(n,15),'miss') == 1
                        if strcmp(OLA_all(n,11),'new')== 1
                            OLA_all{n,17} = 'MISS_NEW';
                            OLA_all{n,18} = 'MISS_NEW';
                        elseif strcmp(OLA_all(n,11),'new')== 0
                            OLA_all{n,17} = 'MISS_OLD';
                            OLA_all{n,18} = 'MISS_OLD';
                        end
                    end
                end
            end

            header = {'Pic','Number', 'Pic_Cat','OLA_E_Duration','OLA_E_Onset',...
                'OLA_E_Button', 'OLA_E_Button_Type', 'OLA_E_RT','Judgement',...
                'OLA_E_Quadrant','StimuliPos','OLA_R_Duration','OLA_R_Onset', ...
                'OLA_R_Button','OLA_R_Button_Type','OLA_R_RT','Encoding','Retrieval'};

            OLA_all = [header; OLA_all];


            textfile_name= [subject_name, '^' 'OLA','.csv'];
            textfile_path = fullfile(beh_sbj_path,textfile_name);
            dlmcell(textfile_path, OLA_all,',');


            %%% 48 NEW TRIALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            NEW_all = OLA_all(strcmp(OLA_all(:,11),'new'),:); N_NEW = size(NEW_all,1);
            COR_NEW = OLA_all(strcmp(OLA_all(:,17),'COR_NEW'),:);
            N_COR_NEW = size(COR_NEW,1); Per_COR_NEW = N_COR_NEW/N_NEW*100;
            RTS_COR_NEW =cell2mat(COR_NEW(:,16)); MRT_RTS_COR_NEW = mean(RTS_COR_NEW); SD_RTS_COR_NEW = std(RTS_COR_NEW);
            Onset_COR_NEW = cell2mat(COR_NEW(:,13));

            FAL_NEW = OLA_all(strcmp(OLA_all(:,17),'FAL_NEW'),:);
            N_FAL_NEW = size(FAL_NEW,1); Per_FAL_NEW = N_FAL_NEW/N_NEW*100;
            RTS_FAL_NEW =cell2mat(FAL_NEW(:,16)); MRT_RTS_FAL_NEW = mean(RTS_FAL_NEW); SD_RTS_FAL_NEW = std(RTS_FAL_NEW);
            Onset_FAL_NEW = cell2mat(FAL_NEW(:,13));

            MISS_NEW = OLA_all(strcmp(OLA_all(:,17),'MISS_NEW'),:); MISS_NEW = MISS_NEW(strcmp(MISS_NEW(:,11),'new'),:);
            N_MISS_NEW = size(MISS_NEW,1); Per_MISS_NEW = N_MISS_NEW/N_NEW*100;
            Onset_MISS_NEW = cell2mat(MISS_NEW(:,13));

            NEW.COR.N = N_COR_NEW; NEW.COR.PER = Per_COR_NEW;NEW.COR.RTS = RTS_COR_NEW;
            NEW.COR.Onsets = Onset_COR_NEW/1000;NEW.COR.MRT = MRT_RTS_COR_NEW;NEW.COR.SD = SD_RTS_COR_NEW;

            NEW.FAL.N = N_FAL_NEW;NEW.FAL.PER = Per_FAL_NEW;NEW.FAL.RTS = RTS_FAL_NEW;
            NEW.FAL.Onsets = Onset_FAL_NEW/1000;NEW.FAL.MRT = MRT_RTS_FAL_NEW; NEW.FAL.SD = SD_RTS_FAL_NEW;

            NEW.MISS.N = N_MISS_NEW;NEW.MISS.PER = Per_MISS_NEW;
            NEW.MISS.Onsets = Onset_MISS_NEW/1000;

            clearvars Onset_COR_NEW Onset_FAL_NEW Onset_MISS_NEW Per_COR_NEW Per_FAL_NEW  Per_MISS_NEW  N_FAL_NEW N_MISS_NEW RTS_COR_NEW RTS_FAL_NEW SD_RTS_COR_NEW SD_RTS_FAL_NEW MRT_RTS_COR_NEW MRT_RTS_FAL_NEW

            %%% OLD TRIALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            OLA_all(strcmp(OLA_all(:,3),'new'),:)=[]; OLD_all = OLA_all(2:end,:);
            N_OLD = size(OLD_all,1); % 96 Trials


            %%% Judgement %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            OLD_all = sortrows(OLD_all,5);% sort according to time in Encoding

            OLD_correctJ =OLD_all(strcmp(OLD_all(:,9),'correct_J'),:);
            OLD.correctJ.all = OLD_correctJ;
            OLD.correctJ.N = size(OLD_correctJ,1);
            OLD.correctJ.Per = OLD.correctJ.N/N_OLD*100;
            OLD.correctJ.RTS = cell2mat(OLD_correctJ(:,8));
            OLD.correctJ.MRT = mean(OLD.correctJ.RTS);
            OLD.correctJ.SD = std(OLD.correctJ.RTS);
            OLD_falseJ =OLD_all(strcmp(OLD_all(:,9),'false_J'),:);
            OLD.falseJ.all = OLD_falseJ;
            OLD.falseJ.N = size(OLD_falseJ,1);
            OLD.falseJ.Per = OLD.falseJ.N/N_OLD*100;
            if OLD.falseJ.N  > 1
                OLD.falseJ.RTS = cell2mat(OLD_falseJ(:,8));
                OLD.falseJ.MRT = mean(OLD.falseJ.RTS);
                OLD.falseJ.SD = std(OLD.falseJ.RTS);
            else OLD.falseJ.RTS = nan; OLD.falseJ.MRT = nan;
                OLD.falseJ.SD = nan;
            end
            OLD_missJ =OLD_all(strcmp(OLD_all(:,9),'miss'),:);
            OLD.missJ.all = OLD_missJ;
            OLD.missJ.N= size(OLD_missJ,1);
            OLD.missJ.Per = OLD.missJ.N/N_OLD*100;


            %%% Retrieval (only of correctJ Trials) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %%% CORSCE: correct spatial context encoding

            CORSCE = OLD_correctJ(strcmp(OLD_correctJ(:,17),'CORSCE'),:);
            OLD.CORSCE.N = size(CORSCE,1);
            OLD.CORSCE.Per = OLD.CORSCE.N/N_OLD *100;
            OLD.CORSCE.Onsets = cell2mat(CORSCE(:,5))/1000;


            FALSCE = OLD_correctJ(strcmp(OLD_correctJ(:,17),'FALSCE'),:);
            OLD.FALSCE.N = size(FALSCE,1);
            OLD.FALSCE.Per = OLD.FALSCE.N/N_OLD*100;
            OLD.FALSCE.Onsets = cell2mat(FALSCE(:,5))/1000;


            FORGSCE = OLD_correctJ(strcmp(OLD_correctJ(:,17),'FORGSCE'),:);
            OLD.FORGSCE.N = size(FORGSCE,1);
            OLD.FORGSCE.Per = OLD.FORGSCE.N/N_OLD*100;
            OLD.FORGSCE.Onsets= cell2mat(FORGSCE(:,5))/1000;


            MISS_SCE = OLD_correctJ(strcmp(OLD_correctJ(:,17),'MISS_OLD'),:);
            OLD.MISSSCE.N= size(MISS_SCE,1);
            OLD.MISSSCE.Per = OLD.MISSSCE.N/N_OLD*100;
            OLD.MISSSCE.Onsets = cell2mat(MISS_SCE(:,5))/1000;



            %%% CORSCR: correct spatial context encoding

            CORSCR = OLD_correctJ(strcmp(OLD_correctJ(:,18),'CORSCR'),:);
            OLD.CORSCR.N= size(CORSCR,1);
            OLD.CORSCR.Per = OLD.CORSCR.N/N_OLD*100;
            OLD.CORSCR.RTS = cell2mat(CORSCR(:,16)); OLD.CORSCR.MRT_CORSCR = mean(OLD.CORSCR.RTS); OLD.CORSCR.SD_CORSCR = std(OLD.CORSCR.RTS);
            OLD.CORSCR.Onsets= cell2mat(CORSCR(:,13))/1000;


            FALSCR = OLD_correctJ(strcmp(OLD_correctJ(:,18),'FALSCR'),:);
            OLD.FALSCR.N = size(FALSCR,1);
            OLD.FALSCR.Per = OLD.FALSCR.N/N_OLD*100;
            OLD.FALSCR.RTS = cell2mat(FALSCR(:,16)); OLD.FALSCR.MRT_FALSCR = mean(OLD.FALSCR.RTS); OLD.FALSCR.SD_FALSCR= std(OLD.FALSCR.RTS);
            OLD.FALSCR.Onsets = cell2mat(FALSCR(:,13))/1000;


            FORGSCR= OLD_correctJ(strcmp(OLD_correctJ(:,18),'FORGSCR'),:);
            OLD.FORGSCR.N = size(FORGSCR,1);
            OLD.FORGSCR.Per= OLD.FORGSCR.N/N_OLD*100;
            OLD.FORGSCR.RTS = cell2mat(FORGSCR(:,16)); OLD.FORGSCR.MRT_FORGSCR = mean(OLD.FORGSCR.RTS); OLD.FORGSCR.SD_FORGSCR = std(OLD.FORGSCR.RTS);
            OLD.FORGSCR.Onsets= cell2mat(FORGSCR(:,5))/1000;


            MISSSCR = OLD_correctJ(strcmp(OLD_correctJ(:,18),'MISS_OLD'),:);
            OLD.MISSSCR.N = size(MISSSCR,1);
            OLD.MISSSCR.Per = OLD.MISSSCR.N/N_OLD*100;
            OLD.MISSSCR.Onsets = cell2mat(MISSSCR(:,13))/1000;


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%DPRIME%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            h= OLD.CORSCE.N+OLD.FALSCE.N;%remembered items
            m= OLD.FORGSCE.N;
            f = 48-N_COR_NEW;
            cr=N_COR_NEW;

            H=(h+0.5)/(h+m+1);
            F=(f+0.5)/(f+cr+1);

            Hprime = (-sqrt(2)*erfcinv(2*H)); %same as norminv(p):
            Fprime = (-sqrt(2)*erfcinv(2*F));

            dprime = Hprime-Fprime;
            response_crit_c = -0.5*(Hprime+Fprime);
            response_crit_beta= exp(0.5*((Fprime*Fprime)-(Hprime*Hprime)));

            %CHI SQUARE
            %critical value that the participants did not guess for chisquare value is
            %3.841, df= 1; alpha=0.05;
            % Observed data

            all_remembered = h;
            CORSCE = OLD.CORSCE.N;
            FALSCE =OLD.FALSCE.N;
            expected_CORSCE= 1/3*all_remembered;
            expected_FALSCE= 2/3*all_remembered;

            O_E= CORSCE-expected_CORSCE;
            O_E2 = FALSCE-expected_FALSCE;
            sq_O_E= O_E*O_E;
            sq_O_E2 = O_E2*O_E2;

            observed1 = sq_O_E/expected_CORSCE;
            observed2 = sq_O_E2/expected_FALSCE;

            chisquare_value= observed1 + observed2;

            if chisquare_value > 3.841
                chisquare_p = 'significant';
            else chisquare_p = 'non-significant';
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            subject_ID = str2num(subject_name);
            substance =cell2mat( MedList(([MedList{:,1}]==subject_ID),2));
            %%%%%%%%%%%%%%%%%%DISPLAY%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            fprintf ('Processing subject "%s" OLA Trials %d  %s\n ',subject_name, N_OLA_all, substance);
            %     fprintf('Percentage CORSCE %.1f%%\n',Per_CORSCR)
            %     fprintf('Percentage FALSCE %.1f%%\n ',Per_FALSCR)
            %     fprintf('Percentage MISSSCE %.1f%%\n ',Per_MISSSCR)
            %     fprintf('Percentage FORGSCE %.1f%%\n ',Per_FORGSCR)
            %     fprintf('Percentage Correct New %.1f%%\n\n',Per_CORR_NEW)
            %     fprintf('Number of False Judgement %d\n ',N_OLD_falseJ)
            %     fprintf('Number of Missed Judgement %d\n ',N_OLD_missJ)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %% find substance from txt file
            clearvars OLA
            OLA.NEW = NEW;
            OLA.OLD = OLD;
            OLA.dprime= dprime;
            OLA.response_criterion.c = response_crit_c;
            OLA.response_criterion.beta = response_crit_beta;
            OLA.chisquare_value = chisquare_value;
            OLA.chisquare_p = chisquare_p;

            save(fullfile(beh_sbj_path, 'OLA'), 'OLA', 'subject_name', 'substance');
        catch
            sprintf("subject " + string(subject_name) +  " could not be analysed\n");
            ola_errors(end + 1) = string(subject_name);
        end
    else
        sprintf("OLA analysis " + string(subject_name) + " already complete");
        continue
    end
end

save('..\results\ola_errors.mat', 'ola_errors');
disp('READY');
% clear;







