%% analy_novelty2103.m
%  this code creates bout_multi.m file (needed for further analysis)
%  and plots the following figures: 1e-g, 2d-e, 3c-d, 4d-e

%  input: akiti_miceID_210318.xlsx, DLC_label.mat file for each session
%  output: bout_multi.mat

%% preprocessing (TAKES A WHILE TO RUN THIS SECTION)
clear
close all
clc

cd('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Behavior/novelty_paper_2021')
[animal_info,text,raw] = xlsread('akiti_miceID_210318.xlsx');
animal = text(2:end,3);
condition = text(2:end,9);

% test = {'hab1','hab2','novel1','novel2','novel3','novel4','novel5','novel6'}; % for lesion
test = {'hab1','hab2','novel1','novel2','novel3','novel4'}; % for stim/cont
session_length = 25; %min
test_chosen = 1:length(test); % 3=novelty day 1
test_length = length(test_chosen);
group = {'stimulus','contextual','saline','6OHDA','FP_all'};

Bout_ratio = []; Ratio_nose_tail = [];mean_nose_tail = [];std_nose_tail = [];
Bout_tail_behind_frequency = [];Bout_duration_max =[];Distance_nose=[];Tail_ratio = [];
Nose_ratio = [];Frame_within=[];Bout_with_tail_frequency = [];Tail_closer = [];
Bout_body_length=[];Body_length_bin = [];Body_length_min = [];Bout_body_length_novelty = [];
Body_length_closest=[];Bout_start = []; Bout_type = [];

for group_n = [1,3] %when combining groups, change save file at the end (bout_multi)
% for group_n = 4
groupfolder = strcat('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/',...
    'Behavior/novelty_paper_2021/',group{group_n});
cd(groupfolder);

for animal_n = find(strcmp(condition,group{group_n}))'
    animal_n
    animal{animal_n}
    animalfolder = strcat(groupfolder,'/',animal{animal_n});
    cd(animalfolder);

    Labels_multi = [];
for test_n = test_chosen
      cd(animalfolder);
      cd(test{test_n});
      test{test_n}
      
load('DLC_label','Labels')

Labels_multi = [Labels_multi;Labels(1:session_length*60*15,:)];
end
Labels = Labels_multi;

% approach-retreat bouts

object_threshold = 7; % cm

tail_within = (0.15*Labels(:,34)<object_threshold); %tail is close
tail_ratio = smoothdata(tail_within,'lowess',4000);

nose_within = (0.15*Labels(:,32)<object_threshold); %nose is close
nose_ratio = smoothdata(nose_within,'lowess',4000);

frame_within = (0.15*Labels(:,32)<object_threshold | 0.15*Labels(:,34)<object_threshold); %nose or tail is close
bout_start = 1+find(diff(frame_within)==1);
bout_end = 1+find(diff(frame_within)==-1);
if frame_within(1)==1
    bout_end = bout_end(2:end);
end    
if length(bout_end)<length(bout_start)
    bout_start = bout_start(1:end-1);
end

bout_length = (bout_end - bout_start)/15;
bout_ratio = movmean(frame_within,[0 15*60-1]); %900 frame, 60s, 1min
Bout_tail = [];Bout_nose = [];t_bout_tail_behind = [];t_bout_with_tail=[]; bout_type =[];
for i = 1:length(bout_end)
    bout_tail = min(0.15*Labels(bout_start(i):bout_end(i),34));
    Bout_tail = [Bout_tail,bout_tail];
    bout_nose = min(0.15*Labels(bout_start(i):bout_end(i),32));
    Bout_nose = [Bout_nose,bout_nose];
    bout_nose_tail = 0.15*Labels(bout_start(i):bout_end(i),32) - 0.15*Labels(bout_start(i):bout_end(i),34);
    if max(bout_nose_tail)<0
    t_bout_tail_behind = [t_bout_tail_behind,bout_start(i)];
    if bout_start(i)>2*25*15*60 %novelty days
        bout_type = [bout_type, 1];
    end
    else
        t_bout_with_tail = [t_bout_with_tail,bout_start(i)];
        if bout_start(i)>2*25*15*60 %novelty days
        bout_type = [bout_type, 0];
        end
    end
end
bout_nose_tail = 0.15*(Labels(find(frame_within),32) - Labels(find(frame_within),34));
bout_nose_tail_closest = Bout_nose - Bout_tail;
bout_tail_behind = zeros(1,size(Labels,1));
bout_tail_behind(t_bout_tail_behind) = 1;
bout_tail_behind_frequency = movsum(bout_tail_behind,[0 899]); %900 frame, 60s, 1min
bout_with_tail = zeros(1,size(Labels,1));
bout_with_tail(t_bout_with_tail) = 1;
bout_with_tail_frequency = movsum(bout_with_tail,[0 899]); %900 frame, 60s, 1min

bout_duration = zeros(1,size(Labels,1));
bout_duration(bout_start) = bout_length;
bout_duration = reshape(bout_duration,900,[]); %900 frame, 60s, 1min
bout_duration_max = max(bout_duration,[],1); 


bin = 15*60; %1 min
binN = floor(size(Labels,1)/bin);
ratio_nose_tail = [];ratio_nose_tail_bout = [];
for i = 1:binN
    frame_within_bin = find(0.15*Labels((bin*(i-1)+1):bin*i,32)<object_threshold |...
        0.15*Labels((bin*(i-1)+1):bin*i,34)<object_threshold); %nose or tail is close
    nose_bin = 0.15*(Labels(bin*(i-1)+frame_within_bin,32));
    tail_bin = 0.15*(Labels(bin*(i-1)+frame_within_bin,34));
    ind = find(nose_bin>tail_bin); %tail is closer
    if length(frame_within_bin)>0
    ratio_nose_tail = [ratio_nose_tail,length(ind)/length(frame_within_bin)];
    ratio_nose_tail_bout = [ratio_nose_tail_bout,length(ind)/length(frame_within_bin)];  
    else
        ratio_nose_tail = [ratio_nose_tail,NaN];
    end
end

tail_closer = (Labels(:,34)<Labels(:,32) & 0.15*Labels(:,34)<object_threshold); %tail is closer and near object

bout_start_novel1 = (bout_start>2*25*15*60);
bout_start_novel1 = bout_start(bout_start_novel1);

Bout_duration_max = [Bout_duration_max;bout_duration_max];
Bout_tail_behind_frequency = [Bout_tail_behind_frequency;bout_tail_behind_frequency];
Bout_with_tail_frequency = [Bout_with_tail_frequency;bout_with_tail_frequency];
Bout_ratio = [Bout_ratio;bout_ratio']; 
Tail_ratio = [Tail_ratio;tail_ratio']; 
Nose_ratio = [Nose_ratio;nose_ratio']; 
Ratio_nose_tail = [Ratio_nose_tail;ratio_nose_tail];
mean_nose_tail = [mean_nose_tail,mean(ratio_nose_tail_bout)];
std_nose_tail = [std_nose_tail,std(ratio_nose_tail_bout)];
Tail_closer = [Tail_closer;tail_closer']; 
Bout_type = [Bout_type;bout_type(1:40)];
Bout_start = [Bout_start;bout_start_novel1];

% body stretch

bout_body_length_all = [];
ind = find(0.15*Labels(:,35)>9); %remove >9cm
Labels(ind,35)=NaN;
for i = 1:length(bout_end)
    bout_body_length = max(0.15*Labels(bout_start(i):bout_end(i),35),[],'omitnan');
    bout_body_length_all = [bout_body_length_all,bout_body_length];
end


bout_body_length_novelty = [];
ind = find(bout_end>2*25*15*60); %novelty days
bout_end_novelty = bout_end(ind);
bout_start_novelty = bout_start(ind);
for i = 1:length(bout_end_novelty)
    [bout_body_length,I] = max(0.15*Labels(bout_start_novelty(i):bout_end_novelty(i),35),[],'omitnan');
    bout_body_length_novelty = [bout_body_length_novelty,bout_body_length];
end


body_length_closest = [];
ind = find(bout_end<2*25*15*60); %baseline days
bout_end_novelty = bout_end(ind);
for i = 1:length(bout_end_novelty)
    [M,I] = min(Labels(bout_start(i):bout_end(i),32)); %nose is closest         
    body_length_closest = [body_length_closest,0.15*Labels(bout_start(i)+I-1,35)];
end
body_length_closest = body_length_closest((end-19):end); %last 20 bouts for baseline %%%
ind = find(bout_end>2*25*15*60); %novelty days
bout_end_novelty = bout_end(ind);
for i = 1:length(bout_end_novelty)
    [M,I] = min(Labels(bout_start(i):bout_end(i),32)); %nose is closest
    body_length_closest = [body_length_closest,0.15*Labels(bout_start(i)+I-1,35)];
end


bin = 1*60*15; % 1 min
body_length_min =[];
for binN = 1:(test_length*session_length*15*60/bin)
    ind = find(bout_start(1:length(bout_end)) > bin*(binN-1) & bout_start(1:length(bout_end)) <= bin*binN);
    if length(ind)>0
        body_length_this_bin = mean(bout_body_length_all(ind));
        else
            body_length_this_bin = NaN;
    end
    body_length_min = [body_length_min,body_length_this_bin];
end

bin = 5*60*15; % 5 min
body_length_bin =[];
for binN = 1:(test_length*session_length*15*60/bin)
    ind = find(bout_start(1:length(bout_end)) > bin*(binN-1) & bout_start(1:length(bout_end)) <= bin*binN);
    if length(ind)>0
        body_length_this_bin = mean(bout_body_length_all(ind));
        else
            body_length_this_bin = NaN;
    end
    body_length_bin = [body_length_bin,body_length_this_bin];
end

Body_length_min = [Body_length_min;body_length_min];
Body_length_bin = [Body_length_bin;body_length_bin];
Bout_body_length{animal_n} = [bout_start(1:length(bout_end))';bout_end';bout_body_length_all];
Bout_body_length_novelty = [Bout_body_length_novelty;bout_body_length_novelty(1:100)];
Body_length_closest = [Body_length_closest;body_length_closest(1:120)];

end


end

Bout_ratio_min = Bout_ratio(:,1:15*60:end);
Total_bout_ratio = sum(Bout_ratio_min');
[Total_bout_ratio_sort, sort_index] = sort(Total_bout_ratio);
Bout_ratio_sort = Bout_ratio_min(sort_index,:);

Bout_ratio_sort_5min = movmean(Bout_ratio_sort,[0,4],2);
Bout_ratio_sort_5min = Bout_ratio_sort_5min(:,1:5:end); 

Bout_ratio_sort_baseline = mean(Bout_ratio_sort_5min(:,1:10),2);
Bout_ratio_normalized = Bout_ratio_sort_5min - Bout_ratio_sort_baseline;

Total_bout_duration_max = sum(Bout_duration_max');
[Total_bout_duration_sort, sort_index] = sort(Total_bout_duration_max);
Bout_duration_max_sort = Bout_duration_max(sort_index,:);

Bout_duration_max_5min = movmean(Bout_duration_max,[0,4],2);
Bout_duration_max_5min = Bout_duration_max_5min(:,1:5:end); 
Bout_duration_max_baseline = mean(Bout_duration_max_5min(:,1:10),2);
Bout_duration_max_normalized = Bout_duration_max_5min - Bout_duration_max_baseline;

Total_ratio_nose_tail = sum(Ratio_nose_tail','omitnan');
[Total_ratio_nose_tail_sort, sort_index] = sort(Total_ratio_nose_tail);
Ratio_nose_tail_sort = Ratio_nose_tail(sort_index,:);

% approch with tail behind
Bout_tail_behind_min = Bout_tail_behind_frequency(:,1:15*60:end);
Total_bout_tail_behind = sum(Bout_tail_behind_min');
[Total_bout_tail_behind_sort, sort_index_tail_behind] = sort(Total_bout_tail_behind);

%approch with tail exposure
Bout_with_tail_min = Bout_with_tail_frequency(:,1:15*60:end);
Total_bout_with_tail = sum(Bout_with_tail_min');
[Total_bout_with_tail_sort, sort_index_with_tail] = sort(Total_bout_with_tail);
Bout_with_tail_frequency_sort = Bout_with_tail_min(sort_index_with_tail,:);
Bout_tail_behind_frequency_sort = Bout_tail_behind_min(sort_index_with_tail,:);

%all approch frequency
% Bout_frequency = Bout_tail_behind_frequency + Bout_with_tail_frequency;
Bout_min = Bout_tail_behind_min + Bout_with_tail_min;
Total_bout_freq = sum(Bout_min');
[Total_bout_with_tail_sort, sort_index] = sort(Total_bout_freq);
Bout_frequency_sort = Bout_min(sort_index,:);
% Bout_frequency_sort = Bout_frequency(sort_index_tail_behind,:);
Bout_5min = movmean(Bout_min,[0,4],2);
Bout_5min = Bout_5min(:,1:5:end); 
Bout_5min_baseline = mean(Bout_5min(:,1:10),2);
Bout_5min_normalized = Bout_5min - Bout_5min_baseline;

Bout_tail_behind_5min = movmean(Bout_tail_behind_min,[0,4],2);
Bout_tail_behind_5min = Bout_tail_behind_5min(:,1:5:end); 
Bout_tail_behind_5min_baseline = mean(Bout_tail_behind_5min(:,1:10),2);
Bout_tail_behind_5min_normalized = Bout_tail_behind_5min - Bout_tail_behind_5min_baseline;

Bout_with_tail_5min = movmean(Bout_with_tail_min,[0,4],2);
Bout_with_tail_5min = Bout_with_tail_5min(:,1:5:end); 
Bout_with_tail_5min_baseline = mean(Bout_with_tail_5min(:,1:10),2);
Bout_with_tail_5min_normalized = Bout_with_tail_5min - Bout_with_tail_5min_baseline;

% %% Fig 1d: boxplots
% mean_with_tail = mean(Bout_with_tail_min(:,61:75),2); %11-25min
% mean_tail_before = mean(Bout_with_tail_min(:,1:50),2);
% approach_animal = (mean_with_tail>=mean_tail_before);
% other_animal = (mean_with_tail<mean_tail_before);
% 
% mean_tail_behind_10min = mean(Bout_tail_behind_min(:,51:60),2); %10min after novelty
% mean_tail_behind_d24 = mean(Bout_tail_behind_min(:,76:end),2); %day2-4
% 
% Beta_with_tail_time = [];P_with_tail_time=[];
% for ani = 1:size(Bout_with_tail_min,1)
% mdl = fitlm(1:90,Bout_with_tail_min(ani,61:end)); %with tail frequency vs time 11min-
% beta = mdl.Coefficients.Estimate;
% p = mdl.Coefficients.pValue;
% Beta_with_tail_time = [Beta_with_tail_time;beta'];
% P_with_tail_time = [P_with_tail_time;p'];
% end
% [h,pval_with_tail_time_approach] = ttest(Beta_with_tail_time(approach_animal,2));
% [h,pval_with_tail_time_avoid] = ttest(Beta_with_tail_time(other_animal,2));
% 
% figure
% subplot(1,2,1)
% boxplot(Beta_with_tail_time(approach_animal,2))
% hold on
% plot(1,Beta_with_tail_time(approach_animal,2),'ko')
% ind = find(P_with_tail_time(approach_animal,2)<0.05);
% if length(ind)>0
%     ind2 = find(approach_animal);
% plot(1,Beta_with_tail_time(ind2(ind),2),'ro')
% end
% h=gca;
% h.XTick = [];
% xlabel('approach animals')
% ylabel('beta')
% title(pval_with_tail_time_approach)
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')
% 
% subplot(1,2,2)
% boxplot(Beta_with_tail_time(other_animal,2))
% hold on
% plot(1,Beta_with_tail_time(other_animal,2),'ko')
% ind = find(P_with_tail_time(other_animal,2)<0.05);
% if length(ind)>0
%     ind2 = find(other_animal);
% plot(1,Beta_with_tail_time(ind2(ind),2),'ro')
% end
% h=gca;
% h.XTick = [];
% xlabel('avoid animals')
% ylabel('beta')
% title(pval_with_tail_time_avoid)
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')

%% Fig 1e
% colorplot, time spent near object
figure
subplot(2,1,1)
imagesc(Bout_ratio_sort,[0,0.4])
colormap summer
colorbar
h=gca;
h.XTick = 0:50:size(Bout_ratio_sort,2); %every 50min
h.XTickLabel = 0:50:size(Bout_ratio_sort,2);
title('time spent near object')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')


plotWin = 1:150;
m_plot = mean(Bout_ratio_sort);
s_plot = std(Bout_ratio_sort)/sqrt(size(Bout_ratio_sort,1));
subplot(2,1,2)
errorbar_patch(plotWin,m_plot,s_plot,'k');
h=gca;
h.XTick = 0:50:size(Bout_ratio_sort,2); %every 50min
h.XTickLabel = 0:50:size(Bout_ratio_sort,2);
axis([0 size(Bout_ratio_sort,2) 0 0.4])
xlabel('min')
ylabel('fraction')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

% violinplot
figure
subplot(1,2,1)
plot(Bout_ratio_normalized','k-')
% hold on
% plot(mean(Bout_ratio_zscore),'k-','Linewidth',2) 
h=gca;
h.XTick = 0:10:5*6; %every 50min
h.XTickLabel = 0:50:25*6;
% axis([0 5*6 -3 5])
xlabel('min')
ylabel('normalized time')
title('time spent near object')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(1,2,2)
violinplot(mean(Bout_ratio_normalized(:,11:15),2))
% hold on
% plot(1, mean(Bout_ratio_normalized(:,11:15),2),'ko')
xlabel('normalized time')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

%% fig 1f 
% violin plots
figure
violinplot(mean(Bout_5min_normalized(:,11:15),2))
title('normalized frequency')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

%% Fig 1g
% colorplot, approch bout duration
figure
subplot(2,1,1)
imagesc(Bout_duration_max_sort,[0,10])
colormap summer
colorbar
h=gca;
h.XTick = 0:50:25*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
title('approach bout duration')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

m_plot = mean(Bout_duration_max);
s_plot = std(Bout_duration_max)/sqrt(size(Bout_duration_max,1));
subplot(2,1,2)
% plot(Bout_duration_max')
% hold on
% plot(mean(Bout_duration_max),'k-','Linewidth',2) 
errorbar_patch(plotWin,m_plot,s_plot,'k');
% plot([0 30],[thresh thresh],'--') %mean in habituation
h=gca;
h.XTick = 0:50:25*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
axis([0 25*test_length 0 10])
xlabel('min')
ylabel('s')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

% violinplot
figure
violinplot(mean(Bout_duration_max_normalized(:,11:15),2))
xlabel('normalized duration')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

%% Fig 2d/e violinplots
figure
subplot(1,2,1)
violinplot([mean(Bout_tail_behind_5min_normalized(:,11:12),2),...
    mean(Bout_tail_behind_5min_normalized(:,13:15),2),...
    mean(Bout_tail_behind_5min_normalized(:,16:end),2)])
h=gca;
h.XTick = 1:3; %every 50min
h.XTickLabel = {'first 10min','11-25min','day2-4'};
title('tail behind')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')


subplot(1,2,2)
violinplot([mean(Bout_with_tail_5min_normalized(:,11:12),2),...
    mean(Bout_with_tail_5min_normalized(:,13:15),2),...
    mean(Bout_with_tail_5min_normalized(:,16:end),2)])
h=gca;
h.XTick = 1:3; %every 50min
h.XTickLabel = {'1-10min','11-25min','day2-4'};
title('tail exposure')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

%% Fig 2e colorplot
figure
subplot(2,1,1)
imagesc(Ratio_nose_tail_sort,[0,1])
colormap summer
colorbar
h=gca;
h.XTick = 0:50:25*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
title('tail exposure')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

plotWin = 1:150;
m_plot = mean(Ratio_nose_tail_sort,'omitnan');
s_plot = std(Ratio_nose_tail_sort,'omitnan')/sqrt(size(Ratio_nose_tail_sort,1));
subplot(2,1,2)
errorbar_patch(plotWin,m_plot,s_plot,'k');
h=gca;
h.XTick = 0:50:25*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
axis([0 25*test_length 0 1])
xlabel('min')
ylabel('fraction')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')


%% assorted colorplots (1f, 3c/d, 4d/e)
%  change 'test' and 'group_n' variables to plot different figures 

figure
subplot(2,3,2)
imagesc(Bout_tail_behind_frequency_sort,[0,8])
colormap summer
colorbar
h=gca;
h.XTick = 0:50:25*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
title('approach with tail behind')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')


plotWin = 1:25*test_length;
plotColors = {'k','r'};
m_plot = mean(Bout_tail_behind_min,'omitnan');
s_plot = std(Bout_tail_behind_min,'omitnan')/sqrt(size(Bout_tail_behind_min,1));
subplot(2,3,5)
errorbar_patch(plotWin,m_plot,s_plot,plotColors{1});
h=gca;
h.XTick = 0:50:25*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
axis([0 25*test_length 0 8])
xlabel('min')
ylabel('/min')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')


subplot(2,3,3)
imagesc(Bout_with_tail_frequency_sort,[0,8])
colormap summer
colorbar
h=gca;
h.XTick = 0:50:25*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
title('approach with tail exposure')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

m_plot = mean(Bout_with_tail_min,'omitnan');
s_plot = std(Bout_with_tail_min,'omitnan')/sqrt(size(Bout_tail_behind_min,1));
subplot(2,3,6)
errorbar_patch(plotWin,m_plot,s_plot,plotColors{1});
h=gca;
h.XTick = 0:50:25*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
axis([0 25*test_length 0 8])
xlabel('min')
ylabel('/min')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')


subplot(2,3,1)
imagesc(Bout_frequency_sort,[0,8])
colormap summer
colorbar
h=gca;
h.XTick = 0:50:25*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
title('approach frequency')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

m_plot = mean(Bout_min,'omitnan');
s_plot = std(Bout_min,'omitnan')/sqrt(size(Bout_tail_behind_min,1));
subplot(2,3,4)
errorbar_patch(plotWin,m_plot,s_plot,plotColors{1});
h=gca;
h.XTick = 0:50:25*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
axis([0 25*test_length 0 8])
xlabel('min')
ylabel('/min')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

%% save file (bout_multi.mat)
cd(groupfolder);
savePrompt = input('Save bout_multi? y/n:', 's');

if(strcmp(savePrompt,'y'))
    save('bout_multi','Bout_ratio','Bout_duration_max','Ratio_nose_tail',...
        'Bout_tail_behind_frequency','Nose_ratio','Tail_ratio','Frame_within',...
        'Bout_with_tail_frequency','Tail_closer','Bout_body_length','Body_length_bin',...
        'Bout_start','Bout_type')
end
