%% photometry_novelty_summary.m
%  this code creates plots of photometry response aligned to different time
%  points (Figure 6c); for rest of Figure 6 plots, see novelty_tail_behind_summary.m

%  input: akiti_miceID_210318.xlsx, ANIMALNAME_novel1_approach_start.mat,
%         ANIMALNAME_novel1_retreat.mat, ANIMALNAME_novel1_retreat_end.mat

%% preprocessing
clear
close all
clc 

cd('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Behavior/novelty_paper_2021')
[animal_info,text,raw] = xlsread('akiti_miceID_210318.xlsx');
animal = text(2:end,3);
% animal = {'Air','Avatar','Earth','Fire','Water'};
% animal = {'Aconcagua','Denali'};
condition = text(2:end,9);
group = {'stimulus','contextual','saline','6OHDA','FP_all'};
group_n = 5;
groupfolder = strcat('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Behavior/novelty_paper_2021/',group{group_n});
cd(groupfolder);
green_range = [-2 2]; % for raster plot
session_length = 40; %50 for stimulus, 40 for contextual

Mean_DeltaF = []; Length_tail_exposure = []; Length_frame_within = []; DeltaF_all = [];
Bout_tail = []; First_tail_exposure = []; First_tail_exposure_time = [];
Response = []; Response_history = []; Response_all = {}; Response_history_all = {}; 
Bout_tail_all = {}; Mean_DeltaF_phase1 = []; Mean_DeltaF_phase2 = []; Mean_DeltaF_phase1_only = [];
animal_index = 0; Mean_DeltaF_phase2_tail_behind = []; Mean_DeltaF_phase2_tail_exposure = [];
Mean_DeltaF_retreat_end = []; Mean_DeltaF_approach_start = [];
% for animal_n = 1:length(animal)
% for animal_n = 61 
% for animal_n = find(strcmp(condition,group{group_n}))'
% for animal_n = find(strcmp(condition,'contextual_FP'))'
for animal_n = find(strcmp(condition,'stimulus_FP'))'
    animal_index = animal_index + 1;
    animal_n
    animal{animal_n}
    animalfolder = strcat(groupfolder,'/',animal{animal_n});
    cd(animalfolder);
%     filename = dir('*_tail_behind*');
%     load(filename.name,'DeltaF','length_tail_exposure','length_frame_within');
    filename = dir('*_retreat.*');
    load(filename.name,'DeltaF','bout_tail','length_tail_exposure','length_frame_within','bout_start');
    mean_deltaF = mean(DeltaF);
%     mean_deltaF = mean(DeltaF(bout_tail==1,:)); %tail behind
%     mean_deltaF = mean(DeltaF(1:50,:));
    DeltaF_all = cat(3,DeltaF_all,DeltaF(1:session_length,:));
    Mean_DeltaF = [Mean_DeltaF;mean_deltaF];
    Length_tail_exposure = [Length_tail_exposure,length_tail_exposure];
%     Length_tail_exposure = [Length_tail_exposure,sum(1-bout_tail(11:end))];
    Length_frame_within = [Length_frame_within,length_frame_within/(60*15)]; %min
    Bout_tail = [Bout_tail;bout_tail(1:session_length)]; 
    Bout_tail_all{animal_index} = bout_tail;
    
    diff_bout_tail = diff(bout_tail);
    first_tail_exposure = find(diff_bout_tail==-1,1,'first');
    if length(first_tail_exposure)>0
    First_tail_exposure = [First_tail_exposure, first_tail_exposure+1];
    First_tail_exposure_time = [First_tail_exposure_time, bout_start(first_tail_exposure+1)/(60*15)]; %min
    DeltaF_phase1 = DeltaF(1:(first_tail_exposure-1),:);
    Mean_DeltaF_phase1 = [Mean_DeltaF_phase1;mean(DeltaF_phase1)];
    DeltaF_phase2 = DeltaF(first_tail_exposure:end,:);
    Mean_DeltaF_phase2 = [Mean_DeltaF_phase2;mean(DeltaF_phase2)];
    ind = (bout_tail(first_tail_exposure:end)==1);
    Mean_DeltaF_phase2_tail_behind = [Mean_DeltaF_phase2_tail_behind;mean(DeltaF_phase2(ind,:))];
    ind = find(bout_tail(first_tail_exposure:end)==0);
    if length(ind)>1
    Mean_DeltaF_phase2_tail_exposure = [Mean_DeltaF_phase2_tail_exposure;mean(DeltaF_phase2(ind,:))];
    else
        Mean_DeltaF_phase2_tail_exposure = [Mean_DeltaF_phase2_tail_exposure;DeltaF_phase2(ind,:)];
    end
    else
    First_tail_exposure = [First_tail_exposure, NaN];
    First_tail_exposure_time = [First_tail_exposure_time, 26]; %one session plus 1 min
    Mean_DeltaF_phase1_only = [Mean_DeltaF_phase1_only;mean(DeltaF)];
    end
    
    response = DeltaF(:,3001:4000);
    response = mean(response,2);
    response_cumsum = cumsum(response);
    response_history = response_cumsum./(1:length(response_cumsum))';
    Response = [Response; response(1:session_length)'];
    Response_all{animal_index} = response;
    Response_history = [Response_history; response_history(1:session_length)'];
    Response_history_all{animal_index} = response_history;
    
    filename = dir('*_retreat_end*');
    load(filename.name,'DeltaF');
    mean_deltaF_retreat_end = mean(DeltaF);
    Mean_DeltaF_retreat_end = [Mean_DeltaF_retreat_end;mean_deltaF_retreat_end];
    
    filename = dir('*_approach_start*');
    load(filename.name,'DeltaF');
    mean_deltaF_approach_start = mean(DeltaF);
    Mean_DeltaF_approach_start = [Mean_DeltaF_approach_start;mean_deltaF_approach_start];
    
end

% fig 6c
figure
subplot(1,3,1)
m_plot = mean(Mean_DeltaF_approach_start);
s_plot = std(Mean_DeltaF_approach_start)/sqrt(size(Mean_DeltaF_approach_start,1));
plotWin = -3000:3000;
errorbar_patch(plotWin,m_plot,s_plot,'b');
axis([-1000 2000 -0.4 1.4])
h=gca;
h.XTick = -3000:1000:3000;
h.XTickLabel = -3:3;
xlabel('time - approach start (s)')
ylabel('zscore')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

subplot(1,3,2)
m_plot = mean(Mean_DeltaF);
s_plot = std(Mean_DeltaF)/sqrt(size(Mean_DeltaF,1));
plotWin = -3000:3000;
errorbar_patch(plotWin,m_plot,s_plot,'b');
axis([-1000 2000 -0.4 1.4])
h=gca;
h.XTick = -3000:1000:3000;
h.XTickLabel = -3:3;
xlabel('time - retreat start (s)')
ylabel('zscore')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

subplot(1,3,3)
m_plot = mean(Mean_DeltaF_retreat_end);
s_plot = std(Mean_DeltaF_retreat_end)/sqrt(size(Mean_DeltaF_retreat_end,1));
plotWin = -3000:3000;
errorbar_patch(plotWin,m_plot,s_plot,'b');
axis([-1000 2000 -0.4 1.4])
h=gca;
h.XTick = -3000:1000:3000;
h.XTickLabel = -3:3;
xlabel('time - retreat end (s)')
ylabel('zscore')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')


