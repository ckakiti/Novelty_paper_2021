% function Moseq_DLC_2107
clear
close all
clc

%This codes analyze Moseq data of behavior syllables using XY label with DLC
% In Korleki's dropbox Behavior folder
% MiceIndex_wLabels.mat (organized by Korleki)
% Mice has 18 mice data
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
Bout_tail_each_multi = {}; Nose_start_each_multi = {};
for group_n = [1,2,3,4] %groups to compare
groupfolder = strcat('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Behavior/novelty_paper_2021/',group{group_n});
cd(groupfolder);

Syl_all = []; Syl_each = {}; Syl9_freq_retreat = []; Syl9_freq_session = []; 
Syl9_freq_tail_behind = [];  Syl9_freq_tail_exposure = [];
Bout_tail_each = {}; Nose_start_each = {};
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

cd('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Behavior/novelty_paper_2021/MoSeq')
load ('MiceIndex_wLabels_combine3L_update','Mice')
% load ('MiceIndex_wLabels','Mice')
for i = 1:length(Mice)
    animal_Moseq{i} = Mice(i).name;
end
animal_n_Moseq = find(strcmp(animal_Moseq,animal{animal_n}))';

syllable = Mice(animal_n_Moseq).ExpDay(test_n).moseq_align;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make matrix of syllable

trigger = {nose_closest'};
% trigger = {nose_closest_tail_behind'};
% trigger = {nose_closest_tail_exposure'};

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

bout_tail = bout_tail(ind:ind2); 
Bout_tail_each{animal_index} = bout_tail;
nose_start = nose_start(ind:ind2); 
Nose_start_each{animal_index} = nose_start;


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
    
    syl9 = (Syl(bout_tail==1,31:60)==syllable_n); %tail behind
    syl9_count = sum(syl9,'all');
    trial_count = sum(bout_tail==1);
    syl9_freq_tail_behind = syl9_count/(trial_count*30); %2 second x 15 frames
    Syl9_freq_tail_behind = [Syl9_freq_tail_behind,syl9_freq_tail_behind];
    
    syl9 = (Syl(bout_tail==0,31:60)==syllable_n); %tail exposure
    syl9_count = sum(syl9,'all');
    trial_count = sum(bout_tail==0);
    syl9_freq_tail_exposure = syl9_count/(trial_count*30); %2 second x 15 frames
    Syl9_freq_tail_exposure = [Syl9_freq_tail_exposure,syl9_freq_tail_exposure];
end

end

end


Syl_multi{group_n} = Syl_all;
Syl_each_multi{group_n} = Syl_each;
Syl9_freq_session_multi{group_n} = Syl9_freq_session;
Syl9_freq_retreat_multi{group_n} = Syl9_freq_retreat;
Syl9_freq_tail_behind_multi{group_n} = Syl9_freq_tail_behind;
Syl9_freq_tail_exposure_multi{group_n} = Syl9_freq_tail_exposure;
Bout_tail_each_multi{group_n} = Bout_tail_each;
Nose_start_each_multi{group_n} = Nose_start_each;

end

% fig 5b
figure
for i = 1:4

Syl_this = Syl_multi{i};
    syl9 = (Syl_this(:,31:60)==syllable_n); 
    syl9_count = sum(syl9,2);
    [B,I] = sort(syl9_count,'descend');
    Syl9_sort = Syl_this(I,:);
    
    
subplot(3,4,i)
imagesc(Syl9_sort,[1 100]);
colormap hsv
xlabel('time - retreat (s)');
ylabel('trials')
h=gca;
h.XTick = 1:15:91;
h.XTickLabel = -3:3;
h.YTickLabel = {};
title(group{i})
hold on;

% colorbar
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

subplot(3,4,4+i)
plotWin = -45:45; %-3s to 3s
syl9long = (Syl_this==syllable_n); 
m_plot = mean(syl9long);
s_plot = std(syl9long)/sqrt(size(syl9long,1));
errorbar_patch(plotWin,m_plot,s_plot,'k');
xlabel('time - retreat (s)');
ylabel('frequency')
h=gca;
h.XTick = -45:15:45;
h.XTickLabel = -3:3;


subplot(3,4,8+i)
response = Syl_multi{i}(:,31:60); %-1to1s
response = reshape(response,1,[]);
h = histogram(response,0.5:1:100.5,'Normalization','probability');
[B,I] = sort(h.Values,'descend');
axis([0 100 0 0.15])
ylabel('frequency at retreat')
xlabel('syllable')
title(I(1:3)) %3 most frequent syllable
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

syl_histo{i} = h.Values;
syl_order{i} = I;

end

% fig 5c, frequency plots
figure
subplot(1,2,1)
plot([Syl9_freq_session_multi{1};Syl9_freq_retreat_multi{1}],'ko-')
hold on
plot((3:4)',[Syl9_freq_session_multi{2};Syl9_freq_retreat_multi{2}],'ko-')
plot((5:6)',[Syl9_freq_session_multi{3};Syl9_freq_retreat_multi{3}],'ko-')
plot((7:8)',[Syl9_freq_session_multi{4};Syl9_freq_retreat_multi{4}],'ko-')
ylabel('syllable frequency')
title('whole, retreat')
h=gca;
h.XTick = 1:8;
h.XTickLabel = {'stimulus','','contextual','','saline','','6OHDA',''};
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

subplot(1,2,2)
plot([Syl9_freq_tail_behind_multi{1};Syl9_freq_tail_exposure_multi{1}],'ko-')
hold on
plot((3:4)',[Syl9_freq_tail_behind_multi{2};Syl9_freq_tail_exposure_multi{2}],'ko-')
plot((5:6)',[Syl9_freq_tail_behind_multi{3};Syl9_freq_tail_exposure_multi{3}],'ko-')
plot((7:8)',[Syl9_freq_tail_behind_multi{4};Syl9_freq_tail_exposure_multi{4}],'ko-')
ylabel('syllable frequency')
title('tail behind, tail exposure')
h=gca;
h.XTick = 1:8;
h.XTickLabel = {'stimulus','','contextual','','saline','','6OHDA',''};
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

y = [Syl9_freq_retreat_multi{1}, Syl9_freq_session_multi{1}, Syl9_freq_retreat_multi{2}, Syl9_freq_session_multi{2},...
    Syl9_freq_retreat_multi{3}, Syl9_freq_session_multi{3}, Syl9_freq_retreat_multi{4}, Syl9_freq_session_multi{4}];
trigger_type = [ones(1,length(Syl9_freq_retreat_multi{1})),zeros(1,length(Syl9_freq_session_multi{1})),...
    ones(1,length(Syl9_freq_retreat_multi{2})),zeros(1,length(Syl9_freq_session_multi{2})),...
    ones(1,length(Syl9_freq_retreat_multi{3})),zeros(1,length(Syl9_freq_session_multi{3})),...
    ones(1,length(Syl9_freq_retreat_multi{4})),zeros(1,length(Syl9_freq_session_multi{4}))];
stim_type = [zeros(1,length(Syl9_freq_retreat_multi{1})),zeros(1,length(Syl9_freq_session_multi{1})),...
    ones(1,length(Syl9_freq_retreat_multi{2})),ones(1,length(Syl9_freq_session_multi{2})),...
    2*ones(1,length(Syl9_freq_retreat_multi{3})),2*ones(1,length(Syl9_freq_session_multi{3})),...
    3*ones(1,length(Syl9_freq_retreat_multi{4})),3*ones(1,length(Syl9_freq_session_multi{4}))];
p_anova_bout = anovan(y,{trigger_type,stim_type});

[h,p_ttest_stim_vs_context_retreat_syl9] = ttest2(Syl9_freq_retreat_multi{1},Syl9_freq_retreat_multi{2})
[h,p_ttest_retreat_vs_whole_stim_syl9] = ttest(Syl9_freq_retreat_multi{1},Syl9_freq_session_multi{1})

[h,p_ttest_saline_vs_6OHDA_retreat_syl9] = ttest2(Syl9_freq_retreat_multi{3},Syl9_freq_retreat_multi{4})
[h,p_ttest_retreat_vs_whole_saline_syl9] = ttest(Syl9_freq_retreat_multi{3},Syl9_freq_session_multi{3})
    
[h,p_ttest_stim_vs_6OHDA_retreat_syl9] = ttest2(Syl9_freq_retreat_multi{1},Syl9_freq_retreat_multi{4})   
[h,p_ttest_context_vs_6OHDA_retreat_syl9] = ttest2(Syl9_freq_retreat_multi{2},Syl9_freq_retreat_multi{4}) 

y = [Syl9_freq_tail_behind_multi{1}, Syl9_freq_tail_exposure_multi{1}, Syl9_freq_tail_behind_multi{2}, Syl9_freq_tail_exposure_multi{2},...
    Syl9_freq_tail_behind_multi{3}, Syl9_freq_tail_exposure_multi{3}, Syl9_freq_tail_behind_multi{4}, Syl9_freq_tail_exposure_multi{4}];
trigger_type = [ones(1,length(Syl9_freq_tail_behind_multi{1})),zeros(1,length(Syl9_freq_tail_exposure_multi{1})),...
    ones(1,length(Syl9_freq_tail_behind_multi{2})),zeros(1,length(Syl9_freq_tail_exposure_multi{2})),...
    ones(1,length(Syl9_freq_tail_behind_multi{3})),zeros(1,length(Syl9_freq_tail_exposure_multi{3})),...
    ones(1,length(Syl9_freq_tail_behind_multi{4})),zeros(1,length(Syl9_freq_tail_exposure_multi{4}))];
stim_type = [zeros(1,length(Syl9_freq_tail_behind_multi{1})),zeros(1,length(Syl9_freq_tail_exposure_multi{1})),...
    ones(1,length(Syl9_freq_tail_behind_multi{2})),ones(1,length(Syl9_freq_tail_exposure_multi{2})),...
    2*ones(1,length(Syl9_freq_tail_behind_multi{3})),2*ones(1,length(Syl9_freq_tail_exposure_multi{3})),...
    3*ones(1,length(Syl9_freq_tail_behind_multi{4})),3*ones(1,length(Syl9_freq_tail_exposure_multi{4}))];
p_anova_tail = anovan(y,{trigger_type,stim_type});

Approach_mouse = [];
bout_tail_each_stim = Bout_tail_each_multi{1}; %0 is exposure
for i = 1:length(bout_tail_each_stim)
    approach_mouse = (min(bout_tail_each_stim{i})==0);
    Approach_mouse = [Approach_mouse,approach_mouse];
end
ind = find(Approach_mouse);
[h,p_ttest_tail_behind_vs_exposure_stim_syl9] = ttest(Syl9_freq_tail_behind_multi{1}(ind),Syl9_freq_tail_exposure_multi{1}(ind))

%% time course

% this part is used to save time-course data
Syl79_trial_mean = []; Syl79_trial_ste =[]; Syl79_Trial ={};
Syl79_others_trial_mean = []; Syl79_others_trial_ste =[]; Syl79_others_Trial ={};
colorset = {[0 0 0],[1,0,0],[0 0 0],[1,0,0]};
% group_compare = [1 2];
% group_compare = [3 4];
group_compare = [1 2 3 4];
sylset = 79;
% sylset = [79,94,14];
% sylset = [65,30,88,91];
for iii = 1:length(sylset)
    Syl_all_multi = {{};{};{};{}}; Syl_others_all_multi = {{};{};{};{}};
    
    for i = group_compare
        Syl79_trial = []; Syl79_all = []; Syl79_others_trial = []; Syl79_others_all = [];
        for ii = 1:length(Syl_each_multi{i})
            syl79_trial = (Syl_each_multi{i}{ii}==sylset(iii));
            syl79_trial = max(syl79_trial(:,31:60),[],2); %whether it exist in the trial or not
%             syl79_trial_smooth = smooth(syl79_trial);
            syl79_time = Nose_start_each_multi{i}{ii}(syl79_trial==1);
            [N,edges] = histcounts(syl79_time,0:60*15:25*60*15);
            Syl79_trial = [Syl79_trial;N]; %frequency of bouts with this syllable in a min in a single animal
            Syl79_all = [Syl79_all,sum(syl79_trial)]; %total bouts with this syllable in a single animal
            
            syl79_others_time = Nose_start_each_multi{i}{ii}(syl79_trial==0); %all approach not include syl79
            [N,edges] = histcounts(syl79_others_time,0:60*15:25*60*15);
            Syl79_others_trial = [Syl79_others_trial;N]; %frequency of bouts with others in a min in a single animal
            Syl79_others_all = [Syl79_others_all,sum(1-syl79_trial)]; %total bouts without this syllable in a single animal
        end
        
        Syl_all_multi{i} = Syl79_all;
        Syl79_Trial{i} = Syl79_trial;
        Syl79_trial_mean = [Syl79_trial_mean;mean(Syl79_trial)];
        Syl79_trial_ste = [Syl79_trial_mean;std(Syl79_trial)/sqrt(size(Syl79_trial,1))];
        
        Syl_others_all_multi{i} = Syl79_others_all;
        Syl79_others_Trial{i} = Syl79_others_trial;
        Syl79_others_trial_mean = [Syl79_others_trial_mean;mean(Syl79_others_trial)];
        Syl79_others_trial_ste = [Syl79_others_trial_mean;std(Syl79_others_trial)/sqrt(size(Syl79_others_trial,1))];
    end
    
    [h,p] = kstest2(Syl_all_multi{group_compare(1)},Syl_all_multi{group_compare(2)});
end         

group_compare = [3 4];
% sylset = [79,94,14];
sylset = [65,30,88,91];
    Syl_all_multi = {{};{};{};{}};
    for i = group_compare
        Syl79_trial = []; Syl79_all = [];
        for ii = 1:length(Syl_each_multi{i})
            syl79_trial = (Syl_each_multi{i}{ii}==sylset(1)|Syl_each_multi{i}{ii}==sylset(2)|Syl_each_multi{i}{ii}==sylset(3)|Syl_each_multi{i}{ii}==sylset(4));
            syl79_trial = max(syl79_trial(:,31:60),[],2); %whether it exist in the trial or not
%             syl79_trial_smooth = smooth(syl79_trial);
            syl79_time = Nose_start_each_multi{i}{ii}(syl79_trial==1);
            [N,edges] = histcounts(syl79_time,0:60*15:25*60*15);
            Syl79_trial = [Syl79_trial;N]; %frequency of bouts with this syllable in a min in a single animal
            Syl79_all = [Syl79_all,sum(syl79_trial)]; %total bouts with this syllable in a single animal
        end
        Syl_all_multi{i} = Syl79_all;
    end
    [h,p] = kstest2(Syl_all_multi{group_compare(1)},Syl_all_multi{group_compare(2)});

%% time course syl79 and others
close all

cmap = colormap(hsv(100));

syl79_control = Syl79_Trial{3};
mean_syl79_control = mean(syl79_control);
syl79_others_control = Syl79_others_Trial{3};
mean_others_control = mean(syl79_others_control);

ste_syl79_control = std(syl79_control)/sqrt(size(syl79_control,1));
ste_others_control = std(syl79_others_control)/sqrt(size(syl79_others_control,1));

syl79_6OHDA = Syl79_Trial{4};
mean_syl79_6OHDA = mean(syl79_6OHDA);
syl79_others_6OHDA = Syl79_others_Trial{4};
mean_others_6OHDA = mean(syl79_others_6OHDA);

ste_syl79_6OHDA = std(syl79_6OHDA)/sqrt(size(syl79_6OHDA,1));
ste_others_6OHDA = std(syl79_others_6OHDA)/sqrt(size(syl79_others_6OHDA,1));


plotWin = 1:25;
subplot(2,2,1)
errorbar_patch(plotWin,mean_syl79_control,ste_syl79_control,cmap(79,:));
hold on
errorbar_patch(plotWin,mean_others_control,ste_others_control,'b');
axis([0 25 -1 7])
legend('syl79','others')
xlabel('time(min)')
ylabel('frequency')
title('control')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

subplot(2,2,2)
errorbar_patch(plotWin,mean_syl79_6OHDA,ste_syl79_6OHDA,cmap(79,:));
hold on
errorbar_patch(plotWin,mean_others_6OHDA,ste_others_6OHDA,'b');
axis([0 25 -1 7])
legend('syl79','others')
xlabel('time(min)')
ylabel('frequency')
title('6OHDA')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

[h,p] = ttest2(mean(syl79_control,2),mean(syl79_6OHDA,2))
[h,p] = kstest2(mean(syl79_control,2),mean(syl79_6OHDA,2));
subplot(2,2,3)
boxplot([mean(syl79_control,2),mean(syl79_6OHDA,2)])
h=gca;
h.XTick = 1:2; %every 5min
title(p)
h.XTickLabel = {'control','6OHDA'};
ylabel('syl79 frequency/session')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)       
set(gcf,'color','w')  

[h,p] = ttest2(mean(syl79_others_control,2),mean(syl79_others_6OHDA,2))
[h,p] = kstest2(mean(syl79_others_control,2),mean(syl79_others_6OHDA,2));
subplot(2,2,4)
boxplot([mean(syl79_others_control,2),mean(syl79_others_6OHDA,2)])
h=gca;
h.XTick = 1:2; %every 5min
title(p)
h.XTickLabel = {'control','6OHDA'};
ylabel('others frequency/session')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)       
set(gcf,'color','w')  

%% transition (Fig 5f)
group_compare = [3 4];
Syl_after_79_multi = {{};{};{};{}}; Syl14_After79 =[];
figure
for i = group_compare
    Syl_after_79_all = []; Syl14_after79 = [];
    for ii = 1:length(Syl_each_multi{i})
        syl_this_animal = Syl_each_multi{i}{ii};
        syl79_trial = (syl_this_animal==79);
        syl79_trial = max(syl79_trial(:,31:60),[],2); %whether it exist in the trial or not
        syl79_trial = find(syl79_trial);
        Syl_after_79 = [];
        for iii = 1:length(syl79_trial)
            syl_this = syl_this_animal(syl79_trial(iii),:);
            ind = find(syl_this(31:end)==79,1,'first'); %first syl79 at retreat
            ind2 = find(~(syl_this((30+ind+1):end)==79),1,'first'); %first after syl79
            Syl_after_79 = [Syl_after_79,syl_this(30+ind+ind2)];
        end
        Syl_after_79_all = [Syl_after_79_all,Syl_after_79];
        Syl14_after79 = [Syl14_after79,sum(Syl_after_79==14)/length(Syl_after_79)];
    end
    subplot(2,2,i-2)
    histogram(Syl_after_79_all,1:100,'Normalization','probability')
    ylabel('after syl 79')
    title(group{i})
    box off
    set(gca,'tickdir','out')
    set(gca,'TickLength',2*(get(gca,'TickLength')))
    set(gca,'FontSize',10)
    
    Syl_after_79_multi{i} = Syl_after_79_all;
    Syl14_After79 = [Syl14_After79;Syl14_after79];
end
set(gcf,'color','w')

[h,p] = ttest2(Syl14_After79(1,:),Syl14_After79(2,:));
p_ttest_syl14_after79_control_6OHDA = p
mean_transition_sham = mean(Syl14_After79(1,:))
std_transition_sham = std(Syl14_After79(1,:))

subplot(2,1,2)
boxplot(Syl14_After79')
ylabel('syl14 after syl79')
axis([0.5 2.5 0 1])
h=gca;
h.XTick = 1:2;
h.XTickLabel = {'control','6OHDA'};
title(p)
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

% cd('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior');
% save('syl79_timecourse','Syl79_trial_mean','Syl79_trial_ste','Syl79_Trial')
