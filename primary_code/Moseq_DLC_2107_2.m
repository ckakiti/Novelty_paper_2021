%% Moseq_DLC_2107_2.m
%  this code creates a portion of the color plots for Figure 5

%  input: akiti_miceID_210318.xlsx, DLC_label.mat file for each session,
%         MiceIndex_wLabels_combine3L_update.mat

%% preprocessing
clear
close all
clc

%This codes analyze Moseq data of behavior syllables using XY label with DLC
% Within MiceIndex_wLabels.mat:
% In 'Mice', ExpDay has moseq_align data, same length as DLC

cd('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Behavior/novelty_paper_2021')
[animal_info,text,raw] = xlsread('akiti_miceID_210318.xlsx');
animal = text(2:end,3);
condition = text(2:end,9);
syllable_n = 79; % choose syllable

% test = {'hab1','hab2','novel1','novel2','novel3','novel4'};
test = {'novel1'};

group = {'stimulus','contextual','saline','6OHDA','stimulus_saline','FP_all'};

Syl_multi = {}; Syl_each_multi = {}; Syl9_freq_retreat_multi = {}; Syl9_freq_session_multi = {}; 
Syl9_freq_tail_behind_multi = {}; Syl9_freq_tail_exposure_multi = {};
Bout_tail_each_multi = {};
for group_n = [1,2,3,4] %groups to compare
groupfolder = strcat('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Behavior/novelty_paper_2021/',group{group_n});
cd(groupfolder);

Syl_all = []; Syl_each = {}; Syl9_freq_retreat = []; Syl9_freq_session = []; 
Syl9_freq_tail_behind = [];  Syl9_freq_tail_exposure = [];
Bout_tail_each = {};
animal_index = 0;
for animal_n = find(strcmp(condition,group{group_n}))'
    animal_index = animal_index + 1;
    animalfolder = strcat(groupfolder,'/',animal{animal_n});
    cd(animalfolder);
    
for test_n = 1
        cd(animalfolder);
      cd(test{test_n});

load ('DLC_label','Labels','session_start')

% approach-retreat bouts

Labels = Labels(1:25*60*15,:); %use 30 min
object_threshold = 7; % cm

frame_within = (0.15*Labels(:,32)<object_threshold | 0.15*Labels(:,34)<object_threshold); %nose or tail is close
bout_start = 1+find(diff(frame_within)==1);
bout_end = 1+find(diff(frame_within)==-1);
if frame_within(1)==1
    bout_end = bout_end(2:end);
end    
if length(bout_end)<length(bout_start)
    bout_start = bout_start(1:end-1);
end

nose_closest_bout = []; nose_closest_bout_TS = [];
for nosei = 1:length(bout_start)
    [M,I] = min(Labels(bout_start(nosei):bout_end(nosei),32));
    nose_closest_bout = [nose_closest_bout,bout_start(nosei) + I - 1];
end

nose_closest_bout = nose_closest_bout + session_start - 1; %time in video clock

nose_within = (0.15*Labels(:,32)<object_threshold); %nose is close
% nose_ratio = smoothdata(nose_within,'lowess',4000);
nose_start = 1+find(diff(nose_within)==1);
nose_end = 1+find(diff(nose_within)==-1);
if nose_within(1)==1
    nose_end = nose_end(2:end);
end    
if length(nose_end)<length(nose_start)
    nose_start = nose_start(1:end-1);
end
nose_closest = []; nose_closest_TS = []; nose_start_TS = []; nose_closest_tail_behind =[]; nose_closest_tail_exposure =[];
bout_tail = [];
for nosei = 1:length(nose_start)
    [M,I] = min(Labels(nose_start(nosei):nose_end(nosei),32));
    nose_closest = [nose_closest,nose_start(nosei) + I - 1];
end

nose_closest = nose_closest + session_start - 1; %time in video clock

for nosei = 1:length(nose_closest)
bout_nose_tail = 0.15*Labels(nose_start(nosei):nose_end(nosei),32) - 0.15*Labels(nose_start(nosei):nose_end(nosei),34);
    if max(bout_nose_tail)<0
    nose_closest_tail_behind = [nose_closest_tail_behind,nose_closest(nosei)];
    bout_tail = [bout_tail,1];
    else
       nose_closest_tail_exposure = [nose_closest_tail_exposure,nose_closest(nosei)]; 
       bout_tail = [bout_tail,0];
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Behavior/novelty_paper_2021/Moseq');
load ('MiceIndex_wLabels_combine3L_update','Mice')
for i = 1:length(Mice)
    animal_Moseq{i} = Mice(i).name;
end
animal_n_Moseq = find(strcmp(animal_Moseq,animal{animal_n}))';

syllable = Mice(animal_n_Moseq).ExpDay(test_n).moseq_align;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make matrix of syllable

% trigger = {nose_closest'};
% trigger = {nose_closest_tail_behind'};
trigger = {nose_closest_tail_exposure'};

plotdata = syllable;
plotWin = -45:45; %3s*15frames
Syl = [];
Trial_number = [];
for i = 1:length(trigger)
    ts = round(trigger{i});
    
    if length(trigger{i})>0

    ind = find( ts+ plotWin(1)>0,1,'first');
    ind2 = find( ts+ plotWin(end)< length(plotdata),1,'last');
    ts = ts(ind:ind2);
    plotind = bsxfun(@plus, repmat(plotWin,length(ts),1),ts);
    rawTrace = plotdata(plotind); 
    Syl = [Syl;rawTrace];
    Trial_number = [Trial_number size(rawTrace,1)];
    end
end

Syl_all = [Syl_all;Syl];
Syl_each{animal_index} = Syl;

% syllable 9
if size(Syl,1)>0
    syl9 = (Syl(:,31:60)==syllable_n); 
    syl9_count = sum(syl9,'all');
    trial_count = size(Syl,1);
    syl9_freq_retreat = syl9_count/(trial_count*30); %2 second x 15 frames
    Syl9_freq_retreat = [Syl9_freq_retreat,syl9_freq_retreat];
    
    syl9 = (syllable==9); % whole trace
    syl9_count = sum(syl9);
    session_length = length(syllable);
    syl9_freq_session = syl9_count/session_length; 
    Syl9_freq_session = [Syl9_freq_session,syl9_freq_session];
    
end

end

end


Syl_multi{group_n} = Syl_all;
Syl_each_multi{group_n} = Syl_each;
Syl9_freq_session_multi{group_n} = Syl9_freq_session;
Syl9_freq_retreat_multi{group_n} = Syl9_freq_retreat;

end

%% enriched in stimulus novelty
% fig 5c, tail behind 
figure
for i = 1:4
group{i}

% sort with multiple syllables
    Syl_this = Syl_multi{i};   
    syl2 = (Syl_this(:,31:60)==14); 
    syl2_count = sum(syl2,2);
    [B,I] = sort(syl2_count,'descend');
    Syl9_sort2 = Syl_this(I,:);
    
    syl2 = (Syl9_sort2(:,31:60)==94); 
    syl2_count = sum(syl2,2);
    [B,I] = sort(syl2_count,'descend');
    Syl9_sort2 = Syl9_sort2(I,:);
    
    syl2 = (Syl9_sort2(:,31:60)==79); 
    syl2_count = sum(syl2,2);
    [B,I] = sort(syl2_count,'descend');
    Syl9_sort = Syl9_sort2(I,:);
    
    
subplot(2,5,i)
% imagesc(Syl9_sort,[1 100]);
% colormap hsv

%for only selected syllables
cmap = colormap(hsv(100));
C = zeros(size(Syl9_sort,1),size(Syl9_sort,2),3);
C(:,:,1) = cmap(79,1)*(Syl9_sort==79) + cmap(94,1)*(Syl9_sort==94) + cmap(14,1)*(Syl9_sort==14);
C(:,:,2) = cmap(79,2)*(Syl9_sort==79) + cmap(94,2)*(Syl9_sort==94) + cmap(14,2)*(Syl9_sort==14);
C(:,:,3) = cmap(79,3)*(Syl9_sort==79) + cmap(94,3)*(Syl9_sort==94) + cmap(14,3)*(Syl9_sort==14);
image(C)

xlabel('time - retreat (s)');
ylabel('trials')
h=gca;
h.XTick = 1:15:91;
h.XTickLabel = -3:3;
h.YTickLabel = {};
title(group{i})
% hold on;
% colorbar
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

subplot(2,5,5+i)
plotWin = -45:45; %-3s to 3s

syl9long = (Syl_this==79); 
m_plot = mean(syl9long);
s_plot = std(syl9long)/sqrt(size(syl9long,1));
errorbar_patch(plotWin,m_plot,s_plot,cmap(79,:));
trial_n = size(syl9long,1)
max_syl79_usage = max(m_plot)

%for multiple plot
hold on
syl9long = (Syl_this==94); 
m_plot = mean(syl9long);
s_plot = std(syl9long)/sqrt(size(syl9long,1));
errorbar_patch(plotWin,m_plot,s_plot,cmap(94,:));

syl9long = (Syl_this==14); 
m_plot = mean(syl9long);
s_plot = std(syl9long)/sqrt(size(syl9long,1));
errorbar_patch(plotWin,m_plot,s_plot,cmap(14,:));
max_syl14_usage = max(m_plot)
legend('syllable 79','syllable 94','syllable 14')

xlabel('time - retreat (s)');
ylabel('frequency')
h=gca;
h.XTick = -45:15:45;
h.XTickLabel = -3:3;

end

subplot(2,5,5)
colorbar

