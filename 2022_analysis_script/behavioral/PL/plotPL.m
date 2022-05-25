function plotPL
% PLOTPL generates a bar graph of random vs. patterned trials of the PL
% task
% $Author: A. Kasparbauer, A. Vorreuther $Date: 2022/04/28
addpath("..\utils");

Figure_name='PL_BarChart_RTs';

load('..\results\behavioral\NEUTRAL.mat', 'NEUTRAL');

subject_list_filename = '..\data\MRT_Subjectliste.csv';
% Import the file
[~, ~, Subject_info] = xlsread(subject_list_filename,'MRT_Subjectliste');
Subject_info(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),Subject_info)) = {''};
MRTSubjectliste=cell2mat( Subject_info(2:end,1:2));


% loop through NEUTRAL all Subjects
t=0;
for p = 1: size (NEUTRAL,2)

    sb_name = NEUTRAL{1,p}.subject_name;
    substance = NEUTRAL{1,p}.substance;

    fprintf ('Processing subject "%s"\t Substance %s\n' , string(sb_name),string(substance));

    %compare whether subject is included from csv file
    [~, index]= ismember(str2num(string(sb_name)), MRTSubjectliste(:,1));

    if    MRTSubjectliste(index, 2) == 0
        fprintf ('subject "%s" excluded\n\n', string(sb_name));
    else
        t=t+1;

        % create matrix with included subjects and mean RTs of blocks
        % get mean RTs from each participant for 10 blocks
        RAN(t,:) =transpose( cell2mat(NEUTRAL{1, p}.PL.RAN.MRT_filteredRTS));
        PAT(t,:) =transpose( cell2mat(NEUTRAL{1, p}.PL.PAT.MRT_filteredRTS));
        % get mean SDs from each participant for 10 blocks
        RAN_SDs(t,:) =transpose( cell2mat(NEUTRAL{1, p}.PL.RAN.SD_filteredRTS));
        PAT_SDTs(t,:) =transpose( cell2mat(NEUTRAL{1, p}.PL.PAT.SD_filteredRTS))        ;

    end
end
% random blocks
mean_R1 = mean(RAN(:,1));sem_R1 = std(RAN(:,1))/sqrt(length(RAN(:,1)));
mean_R2 =mean(RAN(:,2));sem_R2 = std(RAN(:,2))/sqrt(length(RAN(:,2)));
mean_R3 =mean(RAN(:,3));sem_R3 = std(RAN(:,3))/sqrt(length(RAN(:,3)));
mean_R4 = mean(RAN(:,4));sem_R4 = std(RAN(:,4))/sqrt(length(RAN(:,4)));
mean_R5 = mean(RAN(:,5));sem_R5 = std(RAN(:,5))/sqrt(length(RAN(:,5)));
mean_R6 = mean(RAN(:,6));sem_R6 = std(RAN(:,6))/sqrt(length(RAN(:,6)));
mean_R7 = mean(RAN(:,7));sem_R7 = std(RAN(:,7))/sqrt(length(RAN(:,7)));
mean_R8 =mean(RAN(:,8));sem_R8 =std(RAN(:,8))/sqrt(length(RAN(:,8)));
mean_R9 = mean(RAN(:,9));sem_R9 = std(RAN(:,9))/sqrt(length(RAN(:,9)));
mean_R10 = mean(RAN(:,10));sem_R10 = std(RAN(:,10))/sqrt(length(RAN(:,10)));

% pattern blocks
mean_P1 = mean(PAT(:,1));sem_P1 = std(PAT(:,1))/sqrt(length(PAT(:,1)));
mean_P2 =mean(PAT(:,2));sem_P2 = std(PAT(:,2))/sqrt(length(PAT(:,2)));
mean_P3 =mean(PAT(:,3));sem_P3 = std(PAT(:,3))/sqrt(length(PAT(:,3)));
mean_P4 = mean(PAT(:,4));sem_P4 = std(PAT(:,4))/sqrt(length(PAT(:,4)));
mean_P5 = mean(PAT(:,5));sem_P5 = std(PAT(:,5))/sqrt(length(PAT(:,5)));
mean_P6 = mean(PAT(:,6));sem_P6 = std(PAT(:,6))/sqrt(length(PAT(:,6)));
mean_P7 = mean(PAT(:,7));sem_P7 = std(PAT(:,7))/sqrt(length(PAT(:,7)));
mean_P8 =mean(PAT(:,8));sem_P8 =std(PAT(:,8))/sqrt(length(PAT(:,8)));
mean_P9 = mean(PAT(:,9));sem_P9 = std(PAT(:,9))/sqrt(length(PAT(:,9)));
mean_P10 = mean(PAT(:,10));sem_P10 = std(PAT(:,10))/sqrt(length(PAT(:,10)));



% data for barcharts
y =[mean_R1 mean_P1 mean_R2 mean_P2 mean_R3  mean_P3 mean_R4 mean_P4,...
    mean_R5 mean_P5 mean_R6 mean_P6 mean_R7 mean_P7 mean_R8 mean_P8,...
    mean_R9 mean_P9  mean_R10 mean_P10;...
    sem_R1 sem_P1 sem_R2 sem_P2 sem_R3  sem_P3 sem_R4 sem_P4,...
    sem_R5 sem_P5 sem_R6 sem_P6 sem_R7 sem_P7 sem_R8 sem_P8,...
    sem_R9 sem_P9  sem_R10 sem_P10];

clearvars mean* sem*

% Defaults for this blog post
width =4.5;     % Width in inches
height = 2.5;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 8;      % Fontsize
lw = 2;      % LineWidth
msz = 8;       % MarkerSize
grey = [0.4 , 0.4 , 0.4] ;
fig1 = figure(1);

% The properties we've been using in the figures
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
set(0,'defaultLineLineWidth',lw);   % set the default line width to lw
set(0,'defaultLineMarkerSize',msz); % set the default line marker size to msz
set(0,'defaultLineLineWidth',lw);   % set the default line width to lw
set(0,'defaultLineMarkerSize',msz); % set the default line marker size to msz

% Set the default size for display
defpos = get(0,'defaultFigurePosition');
set(0,'defaultFigurePosition', [defpos(1) defpos(2) width*100, height*100]);

% Set the defaults for saving/printing to a file
set(0,'defaultFigureInvertHardcopy','on'); % This is the default anyway
set(0,'defaultFigurePaperUnits','inches'); % This is the default anyway
defsize = get(gcf, 'PaperSize');
left = (defsize(1)- width)/2;
bottom = (defsize(2)- height)/2;
defsize = [left, bottom, width, height];
set(0, 'defaultFigurePaperPosition', defsize);

clf;
[hBar, hErrorbar] = barwitherr...
    ([ y(2,1:2); y(2,3:4);y(2,5:6);y(2,7:8);y(2,9:10);y(2,11:12);...
    y(2,13:14);y(2,15:16); y(2,17:18); y(2,19:20)],...
    [ y(1,1:2); y(1,3:4);y(1,5:6);y(1,7:8);y(1,9:10);y(1,11:12);...
    y(1,13:14);y(1,15:16); y(1,17:18); y(1,19:20)], 'k');
set(hBar, 'FaceColor',grey,...
    'BarWidth', 1)
set(gca,...
    'Box','off')%,...
set(gca, 'YTick', 50 :50: 600);
ylim([0 550])
xlim([0 11])


set(hBar(1),'FaceColor', 'red','DisplayName','RANDOM')
set(hBar(2),'FaceColor', 'green','DisplayName','PATTERN')

legend('Random','Pattern','Location','NorthEastOutside')
% legend(gca, 'show', 'Location')
% legend(gca,'Location','Best')

xlabel('Block'),...
    ylabel('mean reaction time in ms');

set(hErrorbar, 'Linewidth',1)

% applyhatch_plusC(gcf,'-w',[],[],[],600,2,2)

% ylabel('% percent local signal change')

ax = gca;
fig2 = figure(2);
ax1 = subplot(1,2,1, 'parent', fig2);
% set(gca,'YTickLabel',[], 'XTickLabel', []);
% set(gca,'YTickLabel',[], 'XTickLabel', []);
axcp = copyobj(ax, fig2);
set(axcp,'Position',get(ax1,'position'));
delete(ax1)
set(gca, 'YTick', 50 :50: 600);
ylim([0 550])
xlim([0 11])
legend('Random','Pattern','Location','NorthEast')

set(ax, 'YTick', 475 :10: 575)
set(ax, 'YLim', [475 575]);
% ylim([475 575])
ax2 = subplot(1,2,2, 'parent', fig2);
axcp = copyobj(ax, fig2);
set(axcp,'Position',get(ax2,'position'));
delete(ax2)
legend('Random','Pattern','Location','NorthEast')

Graph_name = ['..\results\behavioral\',Figure_name];
exportgraphics(gcf,[Graph_name '.pdf'],'ContentType','vector')
% print(gca,Graph_name,'-dpng','-r300');

figure();
[h,L,MX,MED]=violin(RAN);

close all;
clear;
end