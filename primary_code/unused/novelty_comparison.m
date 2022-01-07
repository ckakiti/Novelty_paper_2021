% function novelty_comparison

%Use data saved with "analy_novelty2011"

% cd('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior/DLC_newplots/raw_data');
% [animal_info,text,raw] = xlsread('akiti_miceID_210318.xlsx');
% animal = text(2:end,3);
% condition = text(2:end,7);
% 
% test = {'hab1','hab2','novel1','novel2','novel3','novel4'};
% session_length = 26; %min
% 
group = {'stimulus','contextual','saline','6OHDA'};
Bout_ratio_multi={[],[],[],[]};Bout_duration_max_multi={[],[],[],[]};
Ratio_nose_tail_multi={[],[],[],[]};Bout_tail_behind_frequency_multi={[],[],[],[]};
Frame_within_multi = {[],[],[],[]};Bout_with_tail_frequency_multi={[],[],[],[]};
Nose_ratio_multi = {[],[],[],[]};Tail_ratio_multi = {[],[],[],[]};Tail_closer_multi = {[],[],[],[]};
Body_length_bin = {[],[],[],[]};

% for group_n = [3,4] %groups to compare
for group_n = [1,2] %groups to compare
groupfolder = strcat('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Behavior/novelty_paper_2021/',group{group_n});
cd(groupfolder);

load('bout','Bout_ratio_sort','Bout_duration_max_sort','Ratio_nose_tail_sort','Bout_tail_behind_frequency',...
    'Nose_ratio','Tail_ratio','Frame_within','Bout_with_tail_frequency','Tail_closer','Bout_body_length','Body_length_bin')

Bout_ratio_multi{group_n}=Bout_ratio_sort;
Bout_duration_max_multi{group_n}=Bout_duration_max_sort;
Ratio_nose_tail_multi{group_n}=Ratio_nose_tail_sort;
Bout_tail_behind_frequency_multi{group_n}=Bout_tail_behind_frequency;
Bout_with_tail_frequency_multi{group_n}=Bout_with_tail_frequency;
Frame_within_multi{group_n}=Frame_within;
Nose_ratio_multi{group_n} = Nose_ratio;
Tail_ratio_multi{group_n} = Tail_ratio;
Tail_closer_multi{group_n} = Tail_closer;
Body_length_bin{group_n} = Body_length_bin;

% comparison

plotColors = {'b','c','k','r'};
% figure(1)
% 
% plotWin = 1:size(Bout_ratio_sort,2);
% m_plot = mean(Bout_ratio_sort);
% s_plot = std(Bout_ratio_sort)/sqrt(size(Bout_ratio_sort,1));
% % m_plot = median(Bout_ratio_sort);
% % s_plot = diff(prctile(Bout_ratio_sort,[25,75],1),1)/2;
% 
% subplot(1,5,1)
% errorbar_patch(plotWin,m_plot,s_plot,plotColors{group_n});
% hold on
% h=gca;
% h.XTick = 0:10*60*15:30*60*15; %every 10min
% h.XTickLabel = 0:10:30;
% axis([0 30*60*15 0 0.3])
% xlabel('min')
% ylabel('fraction')
% title('time spent near object')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')
% 
% 
% plotWin = 1:size(Bout_duration_max_sort,2);
% m_plot = mean(Bout_duration_max_sort);
% s_plot = std(Bout_duration_max_sort)/sqrt(size(Bout_duration_max_sort,1));
% 
% subplot(1,5,2)
% errorbar_patch(plotWin,m_plot,s_plot,plotColors{group_n});
% hold on
% h=gca;
% h.XTick = 0:10:30; %every 10min
% h.XTickLabel = 0:10:30;
% axis([0 30 0 10])
% xlabel('min')
% ylabel('s')
% title('approach bout duration')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')
% 
% 
% plotWin = 1:size(Ratio_nose_tail_sort,2);
% m_plot = mean(Ratio_nose_tail_sort);
% s_plot = std(Ratio_nose_tail_sort)/sqrt(size(Ratio_nose_tail_sort,1));
% 
% subplot(1,5,3)
% errorbar_patch(plotWin,m_plot,s_plot,plotColors{group_n});
% hold on
% h=gca;
% h.XTick = 0:10:30; %every 10min
% h.XTickLabel = 0:10:30;
% axis([0 30 0 0.5])
% xlabel('min')
% ylabel('fraction')
% title('tail exposure')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')
% 
% 
% Bout_tail_behind_frequency_smooth = smoothdata(Bout_tail_behind_frequency,2,'lowess',4000);
% plotWin = 1:size(Bout_tail_behind_frequency_smooth,2);
% m_plot = mean(Bout_tail_behind_frequency_smooth);
% s_plot = std(Bout_tail_behind_frequency_smooth)/sqrt(size(Bout_tail_behind_frequency_smooth,1));
% 
% subplot(1,5,4)
% errorbar_patch(plotWin,m_plot,s_plot,plotColors{group_n});
% hold on
% h=gca;
% h.XTick = 0:10*60*15:30*60*15; %every 10min
% h.XTickLabel = 0:10:30;
% axis([0 30*60*15 0 5])
% xlabel('min')
% ylabel('/min')
% title('approach with tail behind')
% legend('stim+saline','6OHDA')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')
% 
% 
% Bout_with_tail_frequency_smooth = smoothdata(Bout_with_tail_frequency,2,'lowess',4000);
% plotWin = 1:size(Bout_with_tail_frequency_smooth,2);
% m_plot = mean(Bout_with_tail_frequency_smooth);
% s_plot = std(Bout_with_tail_frequency_smooth)/sqrt(size(Bout_with_tail_frequency_smooth,1));
% 
% subplot(1,5,5)
% errorbar_patch(plotWin,m_plot,s_plot,plotColors{group_n});
% hold on
% h=gca;
% h.XTick = 0:10*60*15:30*60*15; %every 10min
% h.XTickLabel = 0:10:30;
% axis([0 30*60*15 0 5])
% xlabel('min')
% ylabel('/min')
% title('approach with tail exposure')
% legend('stim+saline','6OHDA')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')

end

Bout_ratio_control = Bout_ratio_multi{3};
Bout_block_control = movmean(Bout_ratio_control,[0,5*60*15-1],2); %average over 5min
Bout_block_control = Bout_block_control(:,1:5*60*15:(20*60*15+1));
Bout_ratio_6OHDA = Bout_ratio_multi{4};
Bout_block_6OHDA = movmean(Bout_ratio_6OHDA,[0,5*60*15-1],2); %average over 5min, per min
Bout_block_6OHDA = Bout_block_6OHDA(:,1:5*60*15:(20*60*15+1));

Bout_duration_max_block_control=[];
Bout_duration_max_block_6OHDA=[];
Bout_duration_max_control = Bout_duration_max_multi{3};
for i=1:size(Bout_duration_max_control,1)
    bout_duration_max_block_control=reshape(Bout_duration_max_control(i,1:25),5,[]);
    bout_duration_max_block_control=max(bout_duration_max_block_control,[],1);
    Bout_duration_max_block_control(i,:)=bout_duration_max_block_control;
end
Bout_duration_max_6OHDA = Bout_duration_max_multi{4};
for i=1:size(Bout_duration_max_6OHDA,1)
    bout_duration_max_block_6OHDA=reshape(Bout_duration_max_6OHDA(i,1:25),5,[]);
    bout_duration_max_block_6OHDA=max(bout_duration_max_block_6OHDA,[],1);
    Bout_duration_max_block_6OHDA(i,:)=bout_duration_max_block_6OHDA;
end

Ratio_nose_tail_control = Ratio_nose_tail_multi{3};
Ratio_nose_tail_block_control = movmean(Ratio_nose_tail_control,[0,5],2); %average over 5min, per min
Ratio_nose_tail_block_control = Ratio_nose_tail_block_control(:,1:5:21);
Ratio_nose_tail_6OHDA = Ratio_nose_tail_multi{4};
Ratio_nose_tail_block_6OHDA = movmean(Ratio_nose_tail_6OHDA,[0,5],2); %average over 5min, per min
Ratio_nose_tail_block_6OHDA = Ratio_nose_tail_block_6OHDA(:,1:5:21);

Bout_tail_behind_frequency_control = Bout_tail_behind_frequency_multi{3};
Bout_tail_behind_frequency_control_min = Bout_tail_behind_frequency_control(:,1:60*15:(25*60*15+1)); %1 min
Bout_tail_behind_frequency_block_control = movmean(Bout_tail_behind_frequency_control_min,[0,4],2); %average over 5min, per min
Bout_tail_behind_frequency_block_control = Bout_tail_behind_frequency_block_control(:,1:5:21);
Bout_tail_behind_frequency_6OHDA = Bout_tail_behind_frequency_multi{4};
Bout_tail_behind_frequency_6OHDA_min = Bout_tail_behind_frequency_6OHDA(:,1:60*15:(25*60*15+1)); %1 min
Bout_tail_behind_frequency_block_6OHDA = movmean(Bout_tail_behind_frequency_6OHDA_min,[0,4],2); %average over 5min, per min
Bout_tail_behind_frequency_block_6OHDA = Bout_tail_behind_frequency_block_6OHDA(:,1:5:21);

Bout_with_tail_frequency_control = Bout_with_tail_frequency_multi{3};
Bout_with_tail_frequency_control_min = Bout_with_tail_frequency_control(:,1:60*15:(25*60*15+1)); %1 min
Bout_with_tail_frequency_block_control = movmean(Bout_with_tail_frequency_control_min,[0,4],2); %average over 5min, per min
Bout_with_tail_frequency_block_control = Bout_with_tail_frequency_block_control(:,1:5:21);
Bout_with_tail_frequency_6OHDA = Bout_with_tail_frequency_multi{4};
Bout_with_tail_frequency_6OHDA_min = Bout_with_tail_frequency_6OHDA(:,1:60*15:(25*60*15+1)); %1 min
Bout_with_tail_frequency_block_6OHDA = movmean(Bout_with_tail_frequency_6OHDA_min,[0,4],2); %average over 5min, per min
Bout_with_tail_frequency_block_6OHDA = Bout_with_tail_frequency_block_6OHDA(:,1:5:21);

figure
subplot(1,5,1)
plot(Bout_block_control','k')
hold on
plot(Bout_block_6OHDA','r')
h=gca;
h.XTick = 0:2:6;
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('fraction')
title('time spent near object')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,5,2)
plot(Bout_duration_max_block_control','k')
hold on
plot(Bout_duration_max_block_6OHDA','r')
h=gca;
h.XTick = 0:2:6;
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('s')
title('approach bout duration')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,5,3)
plot(Ratio_nose_tail_block_control','k')
hold on
plot(Ratio_nose_tail_block_6OHDA','r')
h=gca;
h.XTick = 0:2:6;
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('fraction')
title('tail exposure')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,5,4)
plot(Bout_tail_behind_frequency_block_control','k')
hold on
plot(Bout_tail_behind_frequency_block_6OHDA','r')
h=gca;
h.XTick = 0:2:6;
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('frequency (/min)')
title('approach with tail behind')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,5,5)
plot(Bout_with_tail_frequency_block_control','k')
hold on
plot(Bout_with_tail_frequency_block_6OHDA','r')
h=gca;
h.XTick = 0:2:6;
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('frequency (/min)')
title('approach with tail exposure')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')


figure
subplot(1,3,2)
plotWin = 1:5;
m_plot = mean(Bout_tail_behind_frequency_block_control);
s_plot = std(Bout_tail_behind_frequency_block_control)/sqrt(size(Bout_tail_behind_frequency_block_control,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{3});
hold on
m_plot = mean(Bout_tail_behind_frequency_block_6OHDA);
s_plot = std(Bout_tail_behind_frequency_block_6OHDA)/sqrt(size(Bout_tail_behind_frequency_block_6OHDA,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{4});
h=gca;
h.XTick = 0:2:6;
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('frequency (/min)')
title('approach with tail behind')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,3)
plotWin = 1:5;
m_plot = mean(Bout_with_tail_frequency_block_control);
s_plot = std(Bout_with_tail_frequency_block_control)/sqrt(size(Bout_with_tail_frequency_block_control,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{3});
hold on
m_plot = mean(Bout_with_tail_frequency_block_6OHDA);
s_plot = std(Bout_with_tail_frequency_block_6OHDA)/sqrt(size(Bout_with_tail_frequency_block_6OHDA,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{4});
h=gca;
h.XTick = 0:2:6;
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('frequency (/min)')
title('approach with tail exposure')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

Bout_frequency_block_control = Bout_tail_behind_frequency_block_control + Bout_with_tail_frequency_block_control;
Bout_frequency_block_6OHDA = Bout_tail_behind_frequency_block_6OHDA + Bout_with_tail_frequency_block_6OHDA;
subplot(1,3,1)
plotWin = 1:5;
m_plot = mean(Bout_frequency_block_control);
s_plot = std(Bout_frequency_block_control)/sqrt(size(Bout_frequency_block_control,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{3});
hold on
m_plot = mean(Bout_frequency_block_6OHDA);
s_plot = std(Bout_frequency_block_6OHDA)/sqrt(size(Bout_frequency_block_6OHDA,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{4});
h=gca;
h.XTick = 0:2:6;
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('frequency (/min)')
title('approach frequency')
legend('control','6OHDA')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

figure
subplot(1,4,1)
plotWin = 1:5;
m_plot = mean(Bout_block_control);
s_plot = std(Bout_block_control)/sqrt(size(Bout_block_control,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{3});
hold on
m_plot = mean(Bout_block_6OHDA);
s_plot = std(Bout_block_6OHDA)/sqrt(size(Bout_block_6OHDA,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{4});
h=gca;
h.XTick = 0:2:6;
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('fraction')
title('time spent near object')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')


subplot(1,4,2)
plotWin = 1:5;
m_plot = mean(Bout_duration_max_block_control);
s_plot = std(Bout_duration_max_block_control)/sqrt(size(Bout_duration_max_block_control,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{3});
hold on
m_plot = mean(Bout_duration_max_block_6OHDA);
s_plot = std(Bout_duration_max_block_6OHDA)/sqrt(size(Bout_duration_max_block_6OHDA,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{4});
h=gca;
h.XTick = 0:2:6;
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('s')
title('approach bout duration')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,4,3)
plotWin = 1:5;
m_plot = mean(Ratio_nose_tail_block_control);
s_plot = std(Ratio_nose_tail_block_control)/sqrt(size(Ratio_nose_tail_block_control,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{3});
hold on
m_plot = mean(Ratio_nose_tail_block_6OHDA);
s_plot = std(Ratio_nose_tail_block_6OHDA)/sqrt(size(Ratio_nose_tail_block_6OHDA,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{4});
h=gca;
h.XTick = 0:2:6;
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('fraction')
title('tail exposure')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,4,4)
plotWin = 1:5;
m_plot = mean(Bout_tail_behind_frequency_block_control);
s_plot = std(Bout_tail_behind_frequency_block_control)/sqrt(size(Bout_tail_behind_frequency_block_control,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{3});
hold on
m_plot = mean(Bout_tail_behind_frequency_block_6OHDA);
s_plot = std(Bout_tail_behind_frequency_block_6OHDA)/sqrt(size(Bout_tail_behind_frequency_block_6OHDA,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{4});
h=gca;
h.XTick = 0:2:6;
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('frequency (/min)')
title('approach with tail behind')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

figure
ecdf(Bout_block_control(:,2))
hold on
ecdf(Bout_block_6OHDA(:,2))
legend('control','6OHDA')
xlabel('fraction')
title('time spent around object')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

Bout_cumsum_control = cumsum(Frame_within_multi{3},2)/900;
Bout_cumsum_6OHDA = cumsum(Frame_within_multi{4},2)/900;
figure
plot(Bout_cumsum_control','k')
hold on
plot(median(Bout_cumsum_control),'k','LineWidth',2)
plot(Bout_cumsum_6OHDA','r')
plot(median(Bout_cumsum_6OHDA),'r','LineWidth',2)
h=gca;
h.XTick = 0:10*60*15:30*60*15; %every 10min
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('min')
title('time spent near object')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

figure
ecdf(Bout_duration_max_block_control(:,2))
hold on
ecdf(Bout_duration_max_block_6OHDA(:,2))
legend('control','6OHDA')
xlabel('s')
title('approach bout duration')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

Bout_duration_cummax_control = cummax(Bout_duration_max_multi{3},2);
Bout_duration_cummax_6OHDA = cummax(Bout_duration_max_multi{4},2);
figure
plot(Bout_duration_cummax_control','k')
hold on
plot(median(Bout_duration_cummax_control),'k','LineWidth',2)
plot(Bout_duration_cummax_6OHDA','r')
plot(median(Bout_duration_cummax_6OHDA),'r','LineWidth',2)
h=gca;
h.XTick = 0:10:30; %every 10min
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('s')
title('approach bout duration')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

Bout_tail_cumsum_control = cumsum(Bout_with_tail_frequency_control_min,2);
Bout_tail_cumsum_6OHDA = cumsum(Bout_with_tail_frequency_6OHDA_min,2);
figure
plot(Bout_tail_cumsum_control','k')
hold on
plot(median(Bout_tail_cumsum_control),'k','LineWidth',2)
plot(Bout_tail_cumsum_6OHDA','r')
plot(median(Bout_tail_cumsum_6OHDA),'r','LineWidth',2)
h=gca;
h.XTick = 0:10:30; %every 10min
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('/min')
title('approach with tail exposure')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

[h,p_ttest_time2]=ttest2(Bout_block_control(:,2),Bout_block_6OHDA(:,2))
[h,p_ttest_time3]=ttest2(Bout_block_control(:,3),Bout_block_6OHDA(:,3))
[h,p_ks_time2]=kstest2(Bout_block_control(:,2),Bout_block_6OHDA(:,2))
[h,p_ks_time3]=kstest2(Bout_block_control(:,3),Bout_block_6OHDA(:,3))
[p_ranksum_time2,h]=ranksum(Bout_block_control(:,2),Bout_block_6OHDA(:,2))
[p_ranksum_time2,h]=ranksum(Bout_block_control(:,3),Bout_block_6OHDA(:,3))
y=[reshape(Bout_block_control(:,1:5),1,[]),reshape(Bout_block_6OHDA(:,1:5),1,[])];
time1=repmat([1:5],size(Bout_block_control(:,2),1),1);
time2=repmat([1:5],size(Bout_block_6OHDA(:,2),1),1);
time=[reshape(time1,1,[]),reshape(time2,1,[])];
drug=[zeros(1,size(Bout_block_control,1)*5),ones(1,size(Bout_block_6OHDA,1)*5)];
% p_anova_time=anovan(y,{time,drug})

[h,p_ttest_duration2]=ttest2(Bout_duration_max_block_control(:,2),Bout_duration_max_block_6OHDA(:,2))
[h,p_ttest_duration3]=ttest2(Bout_duration_max_block_control(:,3),Bout_duration_max_block_6OHDA(:,3))
[h,p]=kstest2(Bout_duration_max_block_control(:,2),Bout_duration_max_block_6OHDA(:,2))
[h,p]=kstest2(Bout_duration_max_block_control(:,3),Bout_duration_max_block_6OHDA(:,3))
[p_ranksum_duration2,h]=ranksum(Bout_duration_max_block_control(:,2),Bout_duration_max_block_6OHDA(:,2))
[p_ranksum_duration3,h]=ranksum(Bout_duration_max_block_control(:,3),Bout_duration_max_block_6OHDA(:,3))
y=[reshape(Bout_duration_max_block_control(:,1:5),1,[]),reshape(Bout_duration_max_block_6OHDA(:,1:5),1,[])];
% p_anova_duration=anovan(y,{time,drug})

[h,p_ttest_tail3]=ttest2(Ratio_nose_tail_block_control(:,3),Ratio_nose_tail_block_6OHDA(:,3))
[h,p_ttest_tail4]=ttest2(Ratio_nose_tail_block_control(:,4),Ratio_nose_tail_block_6OHDA(:,4))
[h,p]=kstest2(Ratio_nose_tail_block_control(:,3),Ratio_nose_tail_block_6OHDA(:,3))
[h,p]=kstest2(Ratio_nose_tail_block_control(:,4),Ratio_nose_tail_block_6OHDA(:,4))
[p_ranksum_tail3,h]=ranksum(Ratio_nose_tail_block_control(:,3),Ratio_nose_tail_block_6OHDA(:,3))
[p_ranksum_tail4,h]=ranksum(Ratio_nose_tail_block_control(:,4),Ratio_nose_tail_block_6OHDA(:,4))
y=[reshape(Ratio_nose_tail_block_control(:,1:5),1,[]),reshape(Ratio_nose_tail_block_6OHDA(:,1:5),1,[])];
% p_anova_tail=anovan(y,{time,drug})
% mean_tail3_control=mean(Ratio_nose_tail_block_control(:,3))
% std_tail3_control=std(Ratio_nose_tail_block_control(:,3))
% mean_tail3_6OHDA=mean(Ratio_nose_tail_block_6OHDA(:,3))
% std_tail3_6OHDA=std(Ratio_nose_tail_block_6OHDA(:,3))
% n=sampsizepwr('t2',[mean_tail3_control std_tail3_control],mean_tail3_6OHDA,0.8,[])

[h,p_ttest_bout_tail2]=ttest2(Bout_with_tail_frequency_block_control(:,2),Bout_with_tail_frequency_block_6OHDA(:,2))
[h,p_ttest_bout_tail3]=ttest2(Bout_with_tail_frequency_block_control(:,3),Bout_with_tail_frequency_block_6OHDA(:,3))
[h,p]=kstest2(Bout_with_tail_frequency_block_control(:,2),Bout_with_tail_frequency_block_6OHDA(:,2))
[h,p]=kstest2(Bout_with_tail_frequency_block_control(:,3),Bout_with_tail_frequency_block_6OHDA(:,3))
[p_ranksum_bout_tail2,h]=ranksum(Bout_with_tail_frequency_block_control(:,2),Bout_with_tail_frequency_block_6OHDA(:,2))
[p_ranksum_bout_tail3,h]=ranksum(Bout_with_tail_frequency_block_control(:,3),Bout_with_tail_frequency_block_6OHDA(:,3))
y=[reshape(Bout_with_tail_frequency_block_control(:,1:5),1,[]),reshape(Bout_with_tail_frequency_block_6OHDA(:,1:5),1,[])];
% p_anova_tail=anovan(y,{time,drug})
% mean_bout_tail3_control=mean(Bout_with_tail_frequency_block_control(:,3))
% std_bout_tail3_control=std(Bout_with_tail_frequency_block_control(:,3))
% mean_bout_tail3_6OHDA=mean(Bout_with_tail_frequency_block_6OHDA(:,3))
% std_bout_tail3_6OHDA=std(Bout_with_tail_frequency_block_6OHDA(:,3))
% n=sampsizepwr('t2',[mean_bout_tail3_control std_bout_tail3_control],mean_bout_tail3_6OHDA,0.8,[])

Y = [Bout_with_tail_frequency_block_control;Bout_with_tail_frequency_block_6OHDA];
treatment = [zeros(17,1);ones(17,1)];
t = table(treatment,Y(:,1),Y(:,2),Y(:,3),Y(:,4),Y(:,5),...
    'VariableNames',{'treatment','t5','t10','t15','t20','t25'});
Time = [5 10 15 20 25]';
% rm = fitrm(t,'t5-t25 ~ treatment','WithinDesign',Time,'WithinModel','orthogonalcontrasts');
% ranovatbl = ranova(rm)
rm = fitrm(t,'t5-t25 ~ treatment','WithinDesign',Time);
anovatbl = anova(rm,'WithinModel','orthogonalcontrasts')

figure
subplot(1,3,1)
boxplot([sum(Bout_frequency_block_control,2),sum(Bout_frequency_block_6OHDA,2)])
axis([0.5 2.5 0 45])
h=gca;
h.XTick = 1:2; 
h.XTickLabel = {'control','6OHDA'};
ylabel('frequency')
title('approach bout')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,2)
boxplot([sum(Bout_tail_behind_frequency_block_control,2),sum(Bout_tail_behind_frequency_block_6OHDA,2)])
axis([0.5 2.5 0 35])
h=gca;
h.XTick = 1:2; 
h.XTickLabel = {'control','6OHDA'};
ylabel('frequency')
title('approach with tail behind')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,3)
boxplot([sum(Bout_with_tail_frequency_block_control,2),sum(Bout_with_tail_frequency_block_6OHDA,2)])
axis([0.5 2.5 0 35])
h=gca;
h.XTick = 1:2; 
h.XTickLabel = {'control','6OHDA'};
ylabel('frequency')
title('approach with tail exposure')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

figure
subplot(1,3,1)
boxplot([sum(Bout_frequency_block_control(:,3:end),2),sum(Bout_frequency_block_6OHDA(:,3:end),2)])
axis([0.5 2.5 0 30])
h=gca;
h.XTick = 1:2; 
h.XTickLabel = {'control','6OHDA'};
ylabel('frequency')
title('approach bout')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,2)
boxplot([sum(Bout_tail_behind_frequency_block_control(:,3:end),2),sum(Bout_tail_behind_frequency_block_6OHDA(:,3:end),2)])
axis([0.5 2.5 0 30])
h=gca;
h.XTick = 1:2; 
h.XTickLabel = {'control','6OHDA'};
ylabel('frequency')
title('approach with tail behind')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,3)
boxplot([sum(Bout_with_tail_frequency_block_control(:,3:end),2),sum(Bout_with_tail_frequency_block_6OHDA(:,3:end),2)])
axis([0.5 2.5 0 30])
h=gca;
h.XTick = 1:2; 
h.XTickLabel = {'control','6OHDA'};
ylabel('frequency')
title('approach with tail exposure')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')


[h,p_bout_freq] = ttest2(sum(Bout_frequency_block_control,2),sum(Bout_frequency_block_6OHDA,2))
[h,p_bout_freq_tail_behind] = ttest2(sum(Bout_tail_behind_frequency_block_control,2),sum(Bout_tail_behind_frequency_block_6OHDA,2))
[h,p_bout_freq_tail_exposure] = ttest2(sum(Bout_with_tail_frequency_block_control,2),sum(Bout_with_tail_frequency_block_6OHDA,2))
[h,p_bout_freq_ks] = kstest2(sum(Bout_frequency_block_control,2),sum(Bout_frequency_block_6OHDA,2))
[h,p_bout_freq_tail_behind_ks] = kstest2(sum(Bout_tail_behind_frequency_block_control,2),sum(Bout_tail_behind_frequency_block_6OHDA,2))
[h,p_bout_freq_tail_exposure_ks] = kstest2(sum(Bout_with_tail_frequency_block_control,2),sum(Bout_with_tail_frequency_block_6OHDA,2))
[p_bout_freq,h] = ranksum(sum(Bout_frequency_block_control,2),sum(Bout_frequency_block_6OHDA,2))
[p_bout_freq_tail_behind,h] = ranksum(sum(Bout_tail_behind_frequency_block_control,2),sum(Bout_tail_behind_frequency_block_6OHDA,2))
[p_bout_freq_tail_exposure,h] = ranksum(sum(Bout_with_tail_frequency_block_control,2),sum(Bout_with_tail_frequency_block_6OHDA,2))

[h,p_bout_freq] = ttest2(sum(Bout_frequency_block_control(:,3:end),2),sum(Bout_frequency_block_6OHDA(:,3:end),2))
[h,p_bout_freq_tail_behind] = ttest2(sum(Bout_tail_behind_frequency_block_control(:,3:end),2),sum(Bout_tail_behind_frequency_block_6OHDA(:,3:end),2))
[h,p_bout_freq_tail_exposure] = ttest2(sum(Bout_with_tail_frequency_block_control(:,3:end),2),sum(Bout_with_tail_frequency_block_6OHDA(:,3:end),2))
[h,p_bout_freq_ks] = kstest2(sum(Bout_frequency_block_control(:,3:end),2),sum(Bout_frequency_block_6OHDA(:,3:end),2))
[h,p_bout_freq_tail_behind_ks] = kstest2(sum(Bout_tail_behind_frequency_block_control(:,3:end),2),sum(Bout_tail_behind_frequency_block_6OHDA(:,3:end),2))
[h,p_bout_freq_tail_exposure_ks] = kstest2(sum(Bout_with_tail_frequency_block_control(:,3:end),2),sum(Bout_with_tail_frequency_block_6OHDA(:,3:end),2))
[p_bout_freq,h] = ranksum(sum(Bout_frequency_block_control(:,3:end),2),sum(Bout_frequency_block_6OHDA(:,3:end),2))
[p_bout_freq_tail_behind,h] = ranksum(sum(Bout_tail_behind_frequency_block_control(:,3:end),2),sum(Bout_tail_behind_frequency_block_6OHDA(:,3:end),2))
[p_bout_freq_tail_exposure,h] = ranksum(sum(Bout_with_tail_frequency_block_control(:,3:end),2),sum(Bout_with_tail_frequency_block_6OHDA(:,3:end),2))

%% nose or tail time spent near object

Nose_ratio_control = Nose_ratio_multi{3};
Nose_block_control = movmean(Nose_ratio_control,[0,5*60*15],2); %average over 5min
Nose_block_control = Nose_block_control(:,1:5*60*15:(20*60*15+1));
Nose_ratio_6OHDA = Nose_ratio_multi{4};
Nose_block_6OHDA = movmean(Nose_ratio_6OHDA,[0,5*60*15],2); %average over 5min, per min
Nose_block_6OHDA = Nose_block_6OHDA(:,1:5*60*15:(20*60*15+1));

Tail_ratio_control = Tail_ratio_multi{3};
Tail_block_control = movmean(Tail_ratio_control,[0,5*60*15],2); %average over 5min
Tail_block_control = Tail_block_control(:,1:5*60*15:(20*60*15+1));
Tail_ratio_6OHDA = Tail_ratio_multi{4};
Tail_block_6OHDA = movmean(Tail_ratio_6OHDA,[0,5*60*15],2); %average over 5min, per min
Tail_block_6OHDA = Tail_block_6OHDA(:,1:5*60*15:(20*60*15+1));

Tail_closer_control = Tail_closer_multi{3};
Tail_closer_block_control = movmean(Tail_closer_control,[0,5*60*15],2); %average over 5min
Tail_closer_block_control = Tail_closer_block_control(:,1:5*60*15:(20*60*15+1));
Tail_closer_6OHDA = Tail_closer_multi{4};
Tail_closer_block_6OHDA = movmean(Tail_closer_6OHDA,[0,5*60*15],2); %average over 5min, per min
Tail_closer_block_6OHDA = Tail_closer_block_6OHDA(:,1:5*60*15:(20*60*15+1));

figure
subplot(1,2,1)
plotWin = 1:5;
m_plot = mean(Bout_block_control);
s_plot = std(Bout_block_control)/sqrt(size(Bout_block_control,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{3});
hold on
m_plot = mean(Bout_block_6OHDA);
s_plot = std(Bout_block_6OHDA)/sqrt(size(Bout_block_6OHDA,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{4});
h=gca;
h.XTick = 0:2:6;
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('fraction')
title('time spent near object')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,2,2)
plotWin = 1:5;
m_plot = mean(Tail_closer_block_control);
s_plot = std(Tail_closer_block_control)/sqrt(size(Tail_closer_block_control,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{3});
hold on
m_plot = mean(Tail_closer_block_6OHDA);
s_plot = std(Tail_closer_block_6OHDA)/sqrt(size(Tail_closer_block_6OHDA,1));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{4});
h=gca;
h.XTick = 0:2:6;
h.XTickLabel = 0:10:30;
% axis([0 6 0 0.3])
xlabel('min')
ylabel('fraction')
title('time tail closer near object')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

% subplot(1,3,2)
% plotWin = 1:5;
% m_plot = mean(Nose_block_control);
% s_plot = std(Nose_block_control)/sqrt(size(Nose_block_control,1));
% errorbar_patch(plotWin,m_plot,s_plot,plotColors{3});
% hold on
% m_plot = mean(Nose_block_6OHDA);
% s_plot = std(Nose_block_6OHDA)/sqrt(size(Nose_block_6OHDA,1));
% errorbar_patch(plotWin,m_plot,s_plot,plotColors{4});
% h=gca;
% h.XTick = 0:2:6;
% h.XTickLabel = 0:10:30;
% % axis([0 6 0 0.3])
% xlabel('min')
% ylabel('fraction')
% title('nose')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')
% 
% subplot(1,3,3)
% plotWin = 1:5;
% m_plot = mean(Tail_block_control);
% s_plot = std(Tail_block_control)/sqrt(size(Tail_block_control,1));
% errorbar_patch(plotWin,m_plot,s_plot,plotColors{3});
% hold on
% m_plot = mean(Tail_block_6OHDA);
% s_plot = std(Tail_block_6OHDA)/sqrt(size(Tail_block_6OHDA,1));
% errorbar_patch(plotWin,m_plot,s_plot,plotColors{4});
% h=gca;
% h.XTick = 0:2:6;
% h.XTickLabel = 0:10:30;
% % axis([0 6 0 0.3])
% xlabel('min')
% ylabel('fraction')
% title('tail')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')


[h,p_ttest_time_near]=ttest2(sum(Bout_block_control(:,3:end),2),sum(Bout_block_6OHDA(:,3:end),2))
[h,p_ks_time_near]=kstest2(sum(Bout_block_control(:,3:end),2),sum(Bout_block_6OHDA(:,3:end),2))
[p_ranksum_time_near,h]=ranksum(sum(Bout_block_control(:,3:end),2),sum(Bout_block_6OHDA(:,3:end),2))
[h,p_ttest_tail_closer]=ttest2(sum(Tail_closer_block_control(:,3:end),2),sum(Tail_closer_block_6OHDA(:,3:end),2))
[h,p_ks_tail_closer]=kstest2(sum(Tail_closer_block_control(:,3:end),2),sum(Tail_closer_block_6OHDA(:,3:end),2))
[p_ranksum_tail_closer,h]=ranksum(sum(Tail_closer_block_control(:,3:end),2),sum(Tail_closer_block_6OHDA(:,3:end),2))
% [h,p_ttest_nose]=ttest2(sum(Nose_block_control(:,3:end),2),sum(Nose_block_6OHDA(:,3:end),2))
% [h,p_ks_nose]=kstest2(sum(Nose_block_control(:,3:end),2),sum(Nose_block_6OHDA(:,3:end),2))
% [p_ranksum_nose,h]=ranksum(sum(Nose_block_control(:,3:end),2),sum(Nose_block_6OHDA(:,3:end),2))
% [h,p_ttest_tail]=ttest2(sum(Tail_block_control(:,3:end),2),sum(Tail_block_6OHDA(:,3:end),2))
% [h,p_ks_tail]=kstest2(sum(Tail_block_control(:,3:end),2),sum(Tail_block_6OHDA(:,3:end),2))
% [p_ranksum_tail,h]=ranksum(sum(Tail_block_control(:,3:end),2),sum(Tail_block_6OHDA(:,3:end),2))