%function novelty_comparison_multi_days
clear
close all
clc

%Use data 'bout_multi' saved with "analy_novelty2103"

group = {'stimulus','contextual','saline','6OHDA','stimulus_saline'};
Bout_ratio_multi={[],[],[],[],[]};Bout_duration_max_multi={[],[],[],[],[]};
Ratio_nose_tail_multi={[],[],[],[],[]};Bout_tail_behind_frequency_multi={[],[],[],[],[]};
Frame_within_multi = {[],[],[],[],[]};Bout_with_tail_frequency_multi={[],[],[],[],[]};
Nose_ratio_multi = {[],[],[],[],[]};Tail_ratio_multi = {[],[],[],[],[]};Tail_closer_multi = {[],[],[],[],[]};
Body_length_bin_multi = {[],[],[],[],[]}; Bout_type_multi = {[],[],[],[],[]};

for group_n = [1,2,3,4,5] %groups to compare
groupfolder = strcat('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Behavior/novelty_paper_2021/',group{group_n});

cd(groupfolder);
group_n
load('bout_multi','Bout_ratio','Bout_duration_max','Ratio_nose_tail','Bout_tail_behind_frequency',...
    'Nose_ratio','Tail_ratio','Frame_within','Bout_with_tail_frequency','Tail_closer','Bout_body_length','Body_length_bin',...
    'Bout_start','Bout_type')

Bout_ratio_multi{group_n}=Bout_ratio;
Bout_duration_max_multi{group_n}=Bout_duration_max;
Ratio_nose_tail_multi{group_n}=Ratio_nose_tail;
Bout_tail_behind_frequency_multi{group_n}=Bout_tail_behind_frequency;
Bout_with_tail_frequency_multi{group_n}=Bout_with_tail_frequency;
Frame_within_multi{group_n}=Frame_within;
Nose_ratio_multi{group_n} = Nose_ratio;
Tail_ratio_multi{group_n} = Tail_ratio;
% Tail_closer_multi{group_n} = Tail_closer;
Body_length_bin_multi{group_n} = Body_length_bin;
Bout_type_multi{group_n} = Bout_type;

end

%% time near object (Fig 1d, 3b, 4c)
close all

Bout_ratio_stim = Bout_ratio_multi{1};
Bout_min_stim = Bout_ratio_stim(:,1:15*60:end);
Bout_zscore_stim = zscore(Bout_min_stim,0,2); %zscore
Bout_zscore_stim = Bout_zscore_stim - mean(Bout_zscore_stim(:,1:50),2); %subtract first 2 days
Bout_block_stim = movmean(Bout_zscore_stim,[0,4],2); %average over 5min
Bout_block_stim = Bout_block_stim(:,1:5:end);
Bout_5min_stim = movmean(Bout_min_stim,[0,4],2); %average over 5min
Bout_5min_stim = Bout_5min_stim(:,1:5:end);
Bout_day_stim = movmean(Bout_zscore_stim,[0,25-1],2); %average over 25min session
Bout_day_stim = Bout_day_stim(:,1:25:end);

Bout_ratio_context = Bout_ratio_multi{2};
Bout_min_context = Bout_ratio_context(:,1:15*60:end);
Bout_zscore_context = zscore(Bout_min_context,0,2); %zscore
Bout_zscore_context = Bout_zscore_context - mean(Bout_zscore_context(:,1:50),2); %subtract first 2 days
Bout_block_context = movmean(Bout_zscore_context,[0,4],2); %average over 5min
Bout_block_context = Bout_block_context(:,1:5:end);
Bout_5min_context = movmean(Bout_min_context,[0,4],2); %average over 5min
Bout_5min_context = Bout_5min_context(:,1:5:end);
Bout_day_context = movmean(Bout_zscore_context,[0,25-1],2); %average over 25min session
Bout_day_context = Bout_day_context(:,1:25:end);

Bout_ratio_control = Bout_ratio_multi{3};
Bout_min_control = Bout_ratio_control(:,1:15*60:end);
Bout_zscore_control = zscore(Bout_min_control,0,2); %zscore
Bout_zscore_control = Bout_zscore_control - mean(Bout_zscore_control(:,1:50),2); %subtract first 2 days
Bout_block_control = movmean(Bout_zscore_control,[0,4],2); %average over 5min normalized
Bout_block_control = Bout_block_control(:,1:5:end);
Bout_5min_control = movmean(Bout_min_control,[0,4],2); %average over 5min
Bout_5min_control = Bout_5min_control(:,1:5:end);
Bout_day_control = movmean(Bout_zscore_control,[0,25-1],2); %average over 25min session
Bout_day_control = Bout_day_control(:,1:25:end);

Bout_ratio_6OHDA = Bout_ratio_multi{4};
Bout_min_6OHDA = Bout_ratio_6OHDA(:,1:15*60:end);
Bout_zscore_6OHDA = zscore(Bout_min_6OHDA,0,2); %zscore
Bout_zscore_6OHDA = Bout_zscore_6OHDA - mean(Bout_zscore_6OHDA(:,1:50),2); %subtract first 2 days
Bout_block_6OHDA = movmean(Bout_zscore_6OHDA,[0,4],2); %average over 5min normalized
Bout_block_6OHDA = Bout_block_6OHDA(:,1:5:end);
Bout_5min_6OHDA = movmean(Bout_min_6OHDA,[0,4],2); %average over 5min
Bout_5min_6OHDA = Bout_5min_6OHDA(:,1:5:end);
Bout_day_6OHDA = movmean(Bout_zscore_6OHDA,[0,25-1],2); %average over 25min session
Bout_day_6OHDA = Bout_day_6OHDA(:,1:25:end);

Bout_ratio_bigcontrol = Bout_ratio_multi{5};
Bout_min_bigcontrol = Bout_ratio_bigcontrol(:,1:15*60:end);
Bout_zscore_bigcontrol = zscore(Bout_min_bigcontrol,0,2); %zscore
Bout_zscore_bigcontrol = Bout_zscore_bigcontrol - mean(Bout_zscore_bigcontrol(:,1:50),2); %subtract first 2 days
Bout_block_bigcontrol = movmean(Bout_zscore_bigcontrol,[0,4],2); %average over 5min
Bout_block_bigcontrol = Bout_block_bigcontrol(:,1:5:end);
Bout_day_bigcontrol = movmean(Bout_zscore_bigcontrol,[0,25-1],2); %average over 25min session
Bout_day_bigcontrol = Bout_day_bigcontrol(:,1:25:end);


ind = find(Bout_day_control(:,3)>0);
n_approach_control = length(ind)/size(Bout_day_control,1)
ind = find(Bout_day_6OHDA(:,3)>0);
n_approach_6OHDA = length(ind)/size(Bout_day_6OHDA,1)
% [h,p_kstest_day1_control_6OHDA] = kstest2(mean(Bout_min_control(:,51:75),2),mean(Bout_min_6OHDA(:,51:75),2))

ind = find(Bout_day_stim(:,3)>0);
n_approach_stim = length(ind)/size(Bout_day_stim,1)
ind = find(Bout_day_context(:,3)>0);
n_approach_context = length(ind)/size(Bout_day_context,1)
% [h,p_kstest_day1_stim_context] = kstest2(mean(Bout_min_stim(:,51:75),2),mean(Bout_min_context(:,51:75),2))


%% fig 4c
figure
subplot(1,3,1)
plot(Bout_5min_control'*60/5,'k')
h=gca;
h.XTick = 0:10:5*6;
h.XTickLabel = 0:50:25*6;
xlabel('min')
ylabel('s/min')
title('time spent near object')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,2)
plot(Bout_5min_6OHDA'*60/5,'k')
h=gca;
h.XTick = 0:10:5*6;
h.XTickLabel = 0:50:25*6;
xlabel('min')
ylabel('s/min')
title('time spent near object')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,3)
ecdf(mean(Bout_min_control(:,51:75),2)*60) %day1 
hold on
ecdf(mean(Bout_min_6OHDA(:,51:75),2)*60) %day1 
legend('saline','6OHDA')
xlabel('time spent near object (min/min)')
ylabel('cumulative probability')
title('day 1')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')


%% fig 3b
figure
subplot(1,3,1)
plot(Bout_5min_stim'*60/5,'k')
h=gca;
h.XTick = 0:10:5*6;
h.XTickLabel = 0:50:25*6;
xlabel('min')
ylabel('s/min')
title('time spent near object')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,2)
plot(Bout_5min_context'*60/5,'k')
h=gca;
h.XTick = 0:10:5*6;
h.XTickLabel = 0:50:25*6;
xlabel('min')
ylabel('s/min')
title('context')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,3)
ecdf(mean(Bout_min_stim(:,51:75),2)*60) %day1
hold on
ecdf(mean(Bout_min_context(:,51:75),2)*60) %day1
legend('stimulus','context')
xlabel('time spent near object (s/min)')
ylabel('cumulative probability')
title('day 1')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')


%% fig 1d
figure
subplot(1,3,1)
plot(Bout_day_bigcontrol','k-')
hold on
plot(mean(Bout_day_bigcontrol),'k-','LineWidth',2)
xlabel('day')
ylabel('zscore')
title('big control')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

bigcontrol_approach = find(Bout_day_bigcontrol(:,3)>0);
Beta_time_bigcontrol = [];P_time_bigcontrol=[];
for ani = 1:size(bigcontrol_approach)
mdl = fitlm(1:4,Bout_day_bigcontrol(bigcontrol_approach(ani),3:6)); %time near object vs novelty days
beta = mdl.Coefficients.Estimate;
p = mdl.Coefficients.pValue;
Beta_time_bigcontrol = [Beta_time_bigcontrol;beta'];
P_time_bigcontrol = [P_time_bigcontrol;p'];
end
[h,pval_time_bigcontrol_days] = ttest(Beta_time_bigcontrol(:,2));

subplot(1,3,2)
boxplot(Beta_time_bigcontrol(:,2))
hold on
plot(1,Beta_time_bigcontrol(:,2),'ko')
ind = find(P_time_bigcontrol(:,2)<0.05);
if length(ind)>0
plot(1,Beta_time_bigcontrol(ind,2),'ro')
end
h=gca;
h.XTick = [];
xlabel('bigcontrol')
ylabel('beta approach')
title(pval_time_bigcontrol_days)
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

bigcontrol_avoid = find(Bout_day_bigcontrol(:,3)<0);
Beta_time_bigcontrol = [];P_time_bigcontrol=[];
for ani = 1:size(bigcontrol_avoid)
mdl = fitlm(1:4,Bout_day_bigcontrol(bigcontrol_avoid(ani),3:6)); %time near object vs novelty days
beta = mdl.Coefficients.Estimate;
p = mdl.Coefficients.pValue;
Beta_time_bigcontrol = [Beta_time_bigcontrol;beta'];
P_time_bigcontrol = [P_time_bigcontrol;p'];
end
[h,pval_time_bigcontrol_days] = ttest(Beta_time_bigcontrol(:,2));

subplot(1,3,3)
boxplot(Beta_time_bigcontrol(:,2))
hold on
plot(1,Beta_time_bigcontrol(:,2),'ko')
ind = find(P_time_bigcontrol(:,2)<0.05);
if length(ind)>0
plot(1,Beta_time_bigcontrol(ind,2),'ro')
end
h=gca;
h.XTick = [];
xlabel('bigcontrol')
ylabel('beta avoid')
title(pval_time_bigcontrol_days)
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')


%% nose tail (Fig 3e boxplots)

Bout_tail_behind_stim = Bout_tail_behind_frequency_multi{1};
Bout_tail_behind_stim_min = Bout_tail_behind_stim(:,1:60*15:end); %1 min
Bout_tail_behind_block_stim = movmean(Bout_tail_behind_stim_min,[0,4],2); %average over 5min, per min
Bout_tail_behind_block_stim = Bout_tail_behind_block_stim(:,1:5:end);
Bout_tail_behind_context = Bout_tail_behind_frequency_multi{2};
Bout_tail_behind_context_min = Bout_tail_behind_context(:,1:60*15:end); %1 min
Bout_tail_behind_block_context = movmean(Bout_tail_behind_context_min,[0,4],2); %average over 5min, per min
Bout_tail_behind_block_context = Bout_tail_behind_block_context(:,1:5:end);

Bout_with_tail_stim = Bout_with_tail_frequency_multi{1};
Bout_with_tail_stim_min = Bout_with_tail_stim(:,1:60*15:end); %1 min
Bout_with_tail_block_stim = movmean(Bout_with_tail_stim_min,[0,4],2); %average over 5min, per min
Bout_with_tail_block_stim = Bout_with_tail_block_stim(:,1:5:end);
Bout_with_tail_context = Bout_with_tail_frequency_multi{2};
Bout_with_tail_context_min = Bout_with_tail_context(:,1:60*15:end); %1 min
Bout_with_tail_block_context = movmean(Bout_with_tail_context_min,[0,4],2); %average over 5min, per min
Bout_with_tail_block_context = Bout_with_tail_block_context(:,1:5:end);

Bout_tail_behind_control = Bout_tail_behind_frequency_multi{3};
Bout_tail_behind_control_min = Bout_tail_behind_control(:,1:60*15:end); %1 min
Bout_tail_behind_block_control = movmean(Bout_tail_behind_control_min,[0,4],2); %average over 5min, per min
Bout_tail_behind_block_control = Bout_tail_behind_block_control(:,1:5:end);
Bout_tail_behind_6OHDA = Bout_tail_behind_frequency_multi{4};
Bout_tail_behind_6OHDA_min = Bout_tail_behind_6OHDA(:,1:60*15:end); %1 min
Bout_tail_behind_block_6OHDA = movmean(Bout_tail_behind_6OHDA_min,[0,4],2); %average over 5min, per min
Bout_tail_behind_block_6OHDA = Bout_tail_behind_block_6OHDA(:,1:5:end);

Bout_with_tail_control = Bout_with_tail_frequency_multi{3};
Bout_with_tail_control_min = Bout_with_tail_control(:,1:60*15:end); %1 min
Bout_with_tail_block_control = movmean(Bout_with_tail_control_min,[0,4],2); %average over 5min, per min
Bout_with_tail_block_control = Bout_with_tail_block_control(:,1:5:end);
Bout_with_tail_6OHDA = Bout_with_tail_frequency_multi{4};
Bout_with_tail_6OHDA_min = Bout_with_tail_6OHDA(:,1:60*15:end); %1 min
Bout_with_tail_block_6OHDA = movmean(Bout_with_tail_6OHDA_min,[0,4],2); %average over 5min, per min
Bout_with_tail_block_6OHDA = Bout_with_tail_block_6OHDA(:,1:5:end);

[h,p_tail_behind_day1_control_6OHDA] = ttest2(mean(Bout_tail_behind_control_min(:,51:75),2),...
    mean(Bout_tail_behind_6OHDA_min(:,51:75),2))
[h,p_with_tail_day1_control_6OHDA] = ttest2(mean(Bout_with_tail_control_min(:,51:75),2),...
    mean(Bout_with_tail_6OHDA_min(:,51:75),2))
[h,p_tail_behind_day1_stim_context] = ttest2(mean(Bout_tail_behind_stim_min(:,51:75),2),...
    mean(Bout_tail_behind_context_min(:,51:75),2))
[h,p_with_tail_day1_stim_context] = ttest2(mean(Bout_with_tail_stim_min(:,51:75),2),...
    mean(Bout_with_tail_context_min(:,51:75),2))

[h,p_tail_behind_10min_control_6OHDA] = ttest2(mean(Bout_tail_behind_control_min(:,51:60),2),...
    mean(Bout_tail_behind_6OHDA_min(:,51:60),2))
[h,p_with_tail_day1late_control_6OHDA] = ttest2(mean(Bout_with_tail_control_min(:,61:75),2),...
    mean(Bout_with_tail_6OHDA_min(:,61:75),2))
[h,p_tail_behind_10min_stim_context] = ttest2(mean(Bout_tail_behind_stim_min(:,51:60),2),...
    mean(Bout_tail_behind_context_min(:,51:60),2))
[h,p_with_tail_day1late_stim_context] = ttest2(mean(Bout_with_tail_stim_min(:,61:75),2),...
    mean(Bout_with_tail_context_min(:,61:75),2))


plotWin = 1:25*6;
plotColors = {'k','r'};
m_plot = {mean(Bout_tail_behind_control_min(:,1:150),'omitnan');mean(Bout_tail_behind_6OHDA_min(:,1:150),'omitnan')};
s_plot = {std(Bout_tail_behind_control_min(:,1:150),'omitnan')/sqrt(size(Bout_tail_behind_control_min(:,1:150),1));...
    std(Bout_tail_behind_6OHDA_min(:,1:150),'omitnan')/sqrt(size(Bout_tail_behind_6OHDA_min,1))};

%% fig 4f
figure
subplot(2,3,1)
for i = 1:2
errorbar_patch(plotWin,m_plot{i},s_plot{i},plotColors{i});
hold on
end
h=gca;
h.XTick = 0:50:150;
h.XTickLabel = 0:50:150;
axis([0 150 0 6])
xlabel('min')
ylabel('frequency (/min)')
title('approach with tail behind')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

m_plot = {mean(Bout_with_tail_control_min(:,1:150),'omitnan');mean(Bout_with_tail_6OHDA_min(:,1:150),'omitnan')};
s_plot = {std(Bout_with_tail_control_min(:,1:150),'omitnan')/sqrt(size(Bout_with_tail_control_min(:,1:150),1));...
    std(Bout_with_tail_6OHDA_min(:,1:150),'omitnan')/sqrt(size(Bout_with_tail_6OHDA_min,1))};

subplot(2,3,2)
for i = 1:2
errorbar_patch(plotWin,m_plot{i},s_plot{i},plotColors{i});
hold on
end
h=gca;
h.XTick = 0:50:150;
h.XTickLabel = 0:50:150;
axis([0 150 0 6])
xlabel('min')
ylabel('frequency (/min)')
title('approach with tail exposure')
legend({'control','6OHDA'})
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

plotColors = {'m','b'};
m_plot = {mean(Bout_tail_behind_control_min(:,1:150),'omitnan');mean(Bout_with_tail_control_min(:,1:150),'omitnan')};
s_plot = {std(Bout_tail_behind_control_min(:,1:150),'omitnan')/sqrt(size(Bout_tail_behind_control_min(:,1:150),1));...
    std(Bout_with_tail_control_min(:,1:150),'omitnan')/sqrt(size(Bout_with_tail_control_min,1))};

subplot(2,3,3)
for i = 1:2
errorbar_patch(plotWin,m_plot{i},s_plot{i},plotColors{i});
hold on
end
h=gca;
h.XTick = 0:50:150;
h.XTickLabel = 0:50:150;
axis([0 150 0 6])
xlabel('min')
ylabel('frequency (/min)')
title('control')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

m_plot = {mean(Bout_tail_behind_6OHDA_min(:,1:150),'omitnan');mean(Bout_with_tail_6OHDA_min(:,1:150),'omitnan')};
s_plot = {std(Bout_tail_behind_6OHDA_min(:,1:150),'omitnan')/sqrt(size(Bout_tail_behind_6OHDA_min(:,1:150),1));...
    std(Bout_with_tail_6OHDA_min(:,1:150),'omitnan')/sqrt(size(Bout_with_tail_6OHDA_min,1))};

subplot(2,3,6)
for i = 1:2
errorbar_patch(plotWin,m_plot{i},s_plot{i},plotColors{i});
hold on
end
h=gca;
h.XTick = 0:50:150;
h.XTickLabel = 0:50:150;
axis([0 150 0 6])
xlabel('min')
ylabel('frequency (/min)')
title('6OHDA')
legend({'tail behind','tail exposure'})
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(2,3,4)
boxplot([mean(Bout_tail_behind_control_min(:,51:75),2),mean(Bout_tail_behind_6OHDA_min(:,51:75),2)])
hold on
plot(1, mean(Bout_tail_behind_control_min(:,51:75),2),'ko')
plot(2, mean(Bout_tail_behind_6OHDA_min(:,51:75),2),'ko')
h=gca;
h.XTick = 1:2;
h.XTickLabel = {'control','6OHDA'};
axis([0.5 2.5 0 6])
ylabel('frequency')
title('day 1')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(2,3,5)
boxplot([mean(Bout_with_tail_control_min(:,51:75),2),mean(Bout_with_tail_6OHDA_min(:,51:75),2)])
hold on
plot(1, mean(Bout_with_tail_control_min(:,51:75),2),'ko')
plot(2, mean(Bout_with_tail_6OHDA_min(:,51:75),2),'ko')
h=gca;
h.XTick = 1:2;
h.XTickLabel = {'control','6OHDA'};
axis([0.5 2.5 0 8])
ylabel('frequency')
title('day 1')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

plotColors = {'k','r'};
m_plot = {mean(Bout_tail_behind_stim_min,'omitnan');mean(Bout_tail_behind_context_min,'omitnan')};
s_plot = {std(Bout_tail_behind_stim_min,'omitnan')/sqrt(size(Bout_tail_behind_stim_min,1));...
    std(Bout_tail_behind_context_min,'omitnan')/sqrt(size(Bout_tail_behind_context_min,1))};


%% fig 3e
figure
subplot(2,3,1)
for i = 1:2
errorbar_patch(plotWin,m_plot{i},s_plot{i},plotColors{i});
hold on
end
h=gca;
h.XTick = 0:50:150;
h.XTickLabel = 0:50:150;
axis([0 150 0 6])
xlabel('min')
ylabel('frequency (/min)')
title('approach with tail behind')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

m_plot = {mean(Bout_with_tail_stim_min,'omitnan');mean(Bout_with_tail_context_min,'omitnan')};
s_plot = {std(Bout_with_tail_stim_min,'omitnan')/sqrt(size(Bout_with_tail_stim_min,1));...
    std(Bout_with_tail_context_min,'omitnan')/sqrt(size(Bout_with_tail_context_min,1))};

subplot(2,3,2)
for i = 1:2
errorbar_patch(plotWin,m_plot{i},s_plot{i},plotColors{i});
hold on
end
h=gca;
h.XTick = 0:50:150;
h.XTickLabel = 0:50:150;
axis([0 150 0 6])
xlabel('min')
ylabel('frequency (/min)')
title('approach with tail exposure')
legend({'stim','context'})
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

plotColors = {'m','b'};
m_plot = {mean(Bout_tail_behind_stim_min,'omitnan');mean(Bout_with_tail_stim_min,'omitnan')};
s_plot = {std(Bout_tail_behind_stim_min,'omitnan')/sqrt(size(Bout_tail_behind_stim_min,1));...
    std(Bout_with_tail_stim_min,'omitnan')/sqrt(size(Bout_with_tail_stim_min,1))};

subplot(2,3,3)
for i = 1:2
errorbar_patch(plotWin,m_plot{i},s_plot{i},plotColors{i});
hold on
end
h=gca;
h.XTick = 0:50:150;
h.XTickLabel = 0:50:150;
axis([0 150 0 6])
xlabel('min')
ylabel('frequency (/min)')
title('stim')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

m_plot = {mean(Bout_tail_behind_context_min,'omitnan');mean(Bout_with_tail_context_min,'omitnan')};
s_plot = {std(Bout_tail_behind_context_min,'omitnan')/sqrt(size(Bout_tail_behind_context_min,1));...
    std(Bout_with_tail_context_min,'omitnan')/sqrt(size(Bout_with_tail_context_min,1))};

subplot(2,3,6)
for i = 1:2
errorbar_patch(plotWin,m_plot{i},s_plot{i},plotColors{i});
hold on
end
h=gca;
h.XTick = 0:50:150;
h.XTickLabel = 0:50:150;
axis([0 150 0 6])
xlabel('min')
ylabel('frequency (/min)')
title('context')
legend({'tail behind','tail exposure'})
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(2,3,4)
boxplot([mean(Bout_tail_behind_stim_min(:,51:75),2),mean(Bout_tail_behind_context_min(:,51:75),2)])
hold on
plot(1, mean(Bout_tail_behind_stim_min(:,51:75),2),'ko')
plot(2, mean(Bout_tail_behind_context_min(:,51:75),2),'ko')
h=gca;
h.XTick = 1:2;
h.XTickLabel = {'stim','context'};
axis([0.5 2.5 0 6])
ylabel('frequency')
title('day 1')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(2,3,5)
boxplot([mean(Bout_with_tail_stim_min(:,51:75),2),mean(Bout_with_tail_context_min(:,51:75),2)])
hold on
plot(1, mean(Bout_with_tail_stim_min(:,51:75),2),'ko')
plot(2, mean(Bout_with_tail_context_min(:,51:75),2),'ko')
h=gca;
h.XTick = 1:2;
h.XTickLabel = {'stim','context'};
axis([0.5 2.5 0 8])
ylabel('frequency')
title('day 1')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')


[h,p_tail_behind_day1_control_stim] = ttest2(mean(Bout_tail_behind_control_min(:,51:75),2),...
    mean(Bout_tail_behind_stim_min(:,51:75),2))
[h,p_tail_behind_day1_control_context] = ttest2(mean(Bout_tail_behind_control_min(:,51:75),2),...
    mean(Bout_tail_behind_context_min(:,51:75),2))
[h,p_tail_behind_day1_6OHDA_stim] = ttest2(mean(Bout_tail_behind_6OHDA_min(:,51:75),2),...
    mean(Bout_tail_behind_stim_min(:,51:75),2))
[h,p_tail_behind_day1_6OHDA_context] = ttest2(mean(Bout_tail_behind_6OHDA_min(:,51:75),2),...
    mean(Bout_tail_behind_context_min(:,51:75),2))
[h,p_with_tail_day1_control_stim] = ttest2(mean(Bout_with_tail_control_min(:,51:75),2),...
    mean(Bout_with_tail_stim_min(:,51:75),2))
[h,p_with_tail_day1_control_context] = ttest2(mean(Bout_with_tail_control_min(:,51:75),2),...
    mean(Bout_with_tail_context_min(:,51:75),2))
[h,p_with_tail_day1_6OHDA_stim] = ttest2(mean(Bout_with_tail_6OHDA_min(:,51:75),2),...
    mean(Bout_with_tail_stim_min(:,51:75),2))
[h,p_with_tail_day1_6OHDA_context] = ttest2(mean(Bout_with_tail_6OHDA_min(:,51:75),2),...
    mean(Bout_with_tail_context_min(:,51:75),2))

[h,p_with_tail_day1late_control_stim] = ttest2(mean(Bout_with_tail_control_min(:,61:75),2),...
    mean(Bout_with_tail_stim_min(:,61:75),2))
[h,p_with_tail_day1late_control_context] = ttest2(mean(Bout_with_tail_control_min(:,61:75),2),...
    mean(Bout_with_tail_context_min(:,61:75),2))
[h,p_with_tail_day1late_6OHDA_stim] = ttest2(mean(Bout_with_tail_6OHDA_min(:,61:75),2),...
    mean(Bout_with_tail_stim_min(:,61:75),2))
[h,p_with_tail_day1late_6OHDA_context] = ttest2(mean(Bout_with_tail_6OHDA_min(:,61:75),2),...
    mean(Bout_with_tail_context_min(:,61:75),2))

%% bout duration (supp fig 2)

Bout_duration_max_stimulus = Bout_duration_max_multi{1};
Bout_duration_max_context = Bout_duration_max_multi{2};
figure
ecdf(max(Bout_duration_max_stimulus(:,51:75),[],2)) %day1
hold on
ecdf(max(Bout_duration_max_context(:,51:75),[],2)) %day1
legend('stimulus','context')
xlabel('max bout length')
ylabel('cumulative probability')
title('day 1')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')


[h,p_ttest_bout_duration_stimulus_context] = ttest2(max(Bout_duration_max_stimulus(:,51:75),[],2),...
    max(Bout_duration_max_context(:,51:75),[],2))
[h,p_kstest_bout_duration_stimulus_context] = kstest2(max(Bout_duration_max_stimulus(:,51:75),[],2),...
    max(Bout_duration_max_context(:,51:75),[],2))

Bout_duration_max_control = Bout_duration_max_multi{3};
Bout_duration_max_6OHDA = Bout_duration_max_multi{4};
figure
% boxplot([max(Bout_duration_max_control(:,51:75),[],2),max(Bout_duration_max_6OHDA(:,51:75),[],2)])
ecdf(max(Bout_duration_max_control(:,51:75),[],2)) %day1
hold on
ecdf(max(Bout_duration_max_6OHDA(:,51:75),[],2)) %day1
legend('saline','6OHDA')
xlabel('max bout length')
ylabel('cumulative probability')
title('day 1')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')


[h,p_ttest_bout_duration_control_6OHDA] = ttest2(max(Bout_duration_max_control(:,51:75),[],2),...
    max(Bout_duration_max_6OHDA(:,51:75),[],2))
[h,p_kstest_bout_duration_control_6OHDA] = kstest2(max(Bout_duration_max_control(:,51:75),[],2),...
    max(Bout_duration_max_6OHDA(:,51:75),[],2))


%% bout type (Fig 3f)

figure
plot(mean(Bout_type_multi{1}))
hold on
plot(mean(Bout_type_multi{2}))
legend('novel','familiar')
xlabel('bout')
ylabel('fraction tail behind')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')



