% function analy_novelty2103

%this code is similar to 2011 but use multiple session multiple animals

% Labels(:,2) Nose x (pixel)
% Labels(:,3) Nose y (pixel)
% Labels(:,5) Leftear x (pixel)
% Labels(:,6) Leftear y (pixel)
% Labels(:,8) Rightear x (pixel)
% Labels(:,9) Rightear y (pixel)
% Labels(:,11) Tailbase x (pixel)
% Labels(:,12) Tailbase y (pixel)
% Labels(:,14) Tailmidpoint x (pixel)
% Labels(:,15) Tailmidpoint y (pixel)
% Labels(:,17) Tailtip x (pixel)
% Labels(:,18) Tailtip y (pixel)
% Labels(:,20) Head x (pixel) 'average of nose, leftear and rightear'
% Labels(:,21) Head y (pixel)
% Labels(:,22) Body x (pixel) 'average of head and tail base'
% Labels(:,23) Body y (pixel)
% Labels(:,24) Tail x (pixel) 'average of tailtip, midpoint and base'
% Labels(:,25) Tail y (pixel)
% Labels(:,26) head speed (pixel)
% Labels(:,27) head accerelation (pixel)
% Labels(:,28) head jerk (pixel)
% Labels(:,29) body speed (pixel)
% Labels(:,30) body accerelation (pixel)
% Labels(:,31) body jerk (pixel)
% Labels(:,32) nose distance from object (pixel)
% Labels(:,33) head distance from object (pixel)
% Labels(:,34) tailbase distance from object (pixel)
% Labels(:,35) body length (pixel)
% Labels(:,36) head speed related to object (pixel)
% Labels(:,37) head speed unrelated to object (pixel)
% Labels(:,38) tail-base from wall (pixel)
%image (480x640 pixels operant box)
% arena (24 x 19 cm, 200x180 pixel operant box)
% 6.3/42=0.15 cm/pixel
% 15 frame per second

cd('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Behavior/novelty_paper_2021')
[animal_info,text,raw] = xlsread('akiti_miceID_210318.xlsx');
animal = text(2:end,3);
condition = text(2:end,9);

% group = {'Capoeira','Planets'};
% animal = {'Jupiter_6OHDA','Mars_6OHDA','Neptune_6OHDA','Pluto_6OHDA','Uranus_6OHDA','Venus_6OHDA',...
%     'Earth_saline','Mercury_saline','Saturn_saline'};
% % animal = {'Au_stim','Ginga_stim','Negativa_stim','Esquiva_cont','MeiaLua_cont','Queixada_cont'};
% test = {'hab1','hab2','novel1','novel2','novel3','novel4','novel5','novel6'};
test = {'hab1','hab2','novel1','novel2','novel3','novel4'};
session_length = 25; %min
test_chosen = 1:length(test);
% test_chosen = 3;
test_length = length(test_chosen);
% group_n = 2;
% groupfolder = strcat('/Users/mitsukouchida/Desktop/Korleki/',group{group_n});
% cd(groupfolder);
group = {'stimulus','contextual','saline','6OHDA','FP_all'};

Bout_ratio = []; Ratio_nose_tail = [];mean_nose_tail = [];std_nose_tail = [];Bout_tail_behind_frequency = [];
Bout_duration_max =[];Distance_nose=[];Tail_ratio = [];Nose_ratio = [];Frame_within=[];Bout_with_tail_frequency = [];
Tail_closer = [];
Bout_body_length=[];Body_length_bin = [];Body_length_min = [];Bout_body_length_novelty = [];Body_length_closest=[];
Bout_start = []; Bout_type = [];

% for group_n = [1,3] %when combine groups, change save folder at the end
for group_n = 2
groupfolder = strcat('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/',...
    'Behavior/novelty_paper_2021/',group{group_n});
cd(groupfolder);


% for animal_n = 1:length(animal)
% for animal_n = 18 
% for animal_n = find(contains(animal,'stim'))   
% for animal_n = find(contains(animal,'cont')) 
% for animal_n = find(contains(animal,'6OHDA')) 
% for animal_n = find(contains(animal,'saline')) 
% for animal_n = find(strcmp(condition,'stimulus_FP'))'
for animal_n = find(strcmp(condition,group{group_n}))'
    animal_n
    animal{animal_n}
    animalfolder = strcat(groupfolder,'/',animal{animal_n});
    cd(animalfolder);
%     load('Arena_Obj_Pos','obj_center','arena') %xy positions of object, arena

    Labels_multi = [];
for test_n = test_chosen
        cd(animalfolder);
      cd(test{test_n});
      test{test_n}
      
load('DLC_label','Labels')

Labels_multi = [Labels_multi;Labels(1:session_length*60*15,:)];
end
Labels = Labels_multi;

%% approach-retreat bouts

object_threshold = 7; % cm
% session_time = ((1:size(Labels,1))/15)/60; %min

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

% figure
% subplot(1,2,1)
% % for i = 1:length(bout_end)
% for i = 1:20
%     nose_x = 0.15*Labels(bout_start(i):bout_end(i),2);
%     nose_y = 0.15*Labels(bout_start(i):bout_end(i),3);
%     tail_x = 0.15*Labels(bout_start(i):bout_end(i),8);
%     tail_y = 0.15*Labels(bout_start(i):bout_end(i),9);
%     plot(nose_x,nose_y,'r-')
%     hold on
%     plot(tail_x,tail_y,'k-')
%     xlabel('cm')
%     ylabel('cm')
%     title('early bouts')
% end
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% 
% subplot(1,2,2)
% for i = (length(bout_end)-19):length(bout_end)
%     nose_x = 0.15*Labels(bout_start(i):bout_end(i),2);
%     nose_y = 0.15*Labels(bout_start(i):bout_end(i),3);
%     tail_x = 0.15*Labels(bout_start(i):bout_end(i),11);
%     tail_y = 0.15*Labels(bout_start(i):bout_end(i),12);
%     plot(nose_x,nose_y,'r-')
%     hold on
%     plot(tail_x,tail_y,'k-')
%     legend('nose','tail')
%     xlabel('cm')
%     ylabel('cm')
%     title('late bouts')
% end
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')

bout_length = (bout_end - bout_start)/15;
% bout_frequency = zeros(1,size(Labels,1));
% bout_frequency(bout_start) = 1;
% bout_start_frequency = movsum(bout_frequency,900); %900 frame, 60s, 1min
% bout_start_frequency_smooth = smoothdata(bout_start_frequency,'lowess',4000);
bout_ratio = movmean(frame_within,[0 15*60-1]); %900 frame, 60s, 1min
% bout_ratio = smoothdata(frame_within,'lowess',4000);
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
% bout_tail_behind_frequency_smooth = smoothdata(bout_tail_behind_frequency,'lowess',4000);
bout_with_tail = zeros(1,size(Labels,1));
bout_with_tail(t_bout_with_tail) = 1;
bout_with_tail_frequency = movsum(bout_with_tail,[0 899]); %900 frame, 60s, 1min

bout_duration = zeros(1,size(Labels,1));
bout_duration(bout_start) = bout_length;
bout_duration = reshape(bout_duration,900,[]); %900 frame, 60s, 1min
bout_duration_max = max(bout_duration,[],1); 
% bout_duration_max_smooth = smoothdata(bout_duration_max,'lowess',4000);


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
% tail_closer = smoothdata(tail_closer,'lowess',4000);

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

%% body stretch

bout_body_length_all = [];
ind = find(0.15*Labels(:,35)>9); %remove >9cm
Labels(ind,35)=NaN;
for i = 1:length(bout_end)
    bout_body_length = max(0.15*Labels(bout_start(i):bout_end(i),35),[],'omitnan');
%     bout_body_length = mean(0.15*Labels(bout_start(i):bout_end(i),35));
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
%         body_length_this_bin = max(bout_body_length_all(ind));
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


%% Fig 1e: time spent near object
Bout_ratio_min = Bout_ratio(:,1:15*60:end);
Total_bout_ratio = sum(Bout_ratio_min');
[Total_bout_ratio_sort, sort_index] = sort(Total_bout_ratio);
% sort_index
Bout_ratio_sort = Bout_ratio_min(sort_index,:);

% mean_bout_ratio = mean(reshape(bout_ratio,1,[]));
% std_bout_ratio = std(reshape(bout_ratio,1,[]));
% thresh1 = 0.114-0.046;
% thresh2 = 0.114+3*0.046;
% approach_start = []; exploration_start = [];
% for i=1:size(Bout_ratio_sort,1)
%     ind = find(Bout_ratio_sort(i,:)>thresh1,1,'first');
%     if length(ind)>0
%     approach_start = [approach_start,ceil(ind/(15*60))];
%     else
%         approach_start = [approach_start,31];
%     end
%     ind = find(Bout_ratio_sort(i,:)>thresh2,1,'first');
%     if length(ind)>0
%     exploration_start = [exploration_start,ceil(ind/(15*60))];
%     else
%         exploration_start = [exploration_start,31];
%     end
% end
% approach_start
% exploration_start

figure
subplot(2,1,1)
imagesc(Bout_ratio_sort,[0,0.4])
% colormap yellowblue
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

Bout_ratio_sort_5min = movmean(Bout_ratio_sort,[0,4],2);
Bout_ratio_sort_5min = Bout_ratio_sort_5min(:,1:5:end); 
plotWin = 1:150;
m_plot = mean(Bout_ratio_sort);
s_plot = std(Bout_ratio_sort)/sqrt(size(Bout_ratio_sort,1));
subplot(2,1,2)
% plot(Bout_ratio_sort','Color',[0.5 0.5 0.5])
% plot(1:5:150,Bout_ratio_sort_5min','Color',[0.5 0.5 0.5])
% hold on
% plot(mean(Bout_ratio_sort),'k-','Linewidth',2)
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

Bout_ratio_sort_baseline = mean(Bout_ratio_sort_5min(:,1:10),2);
% Bout_ratio_normalized = log10(Bout_ratio_sort_5min./Bout_ratio_sort_baseline);
Bout_ratio_normalized = Bout_ratio_sort_5min - Bout_ratio_sort_baseline;

%% violin plots
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
% histogram(mean(Bout_ratio_normalized(:,16:end),2),-0.6:0.2:0.8) %day2-4
% histogram(mean(Bout_ratio_normalized(:,11:15),2)) %day1
violinplot(mean(Bout_ratio_normalized(:,11:15),2))
% hold on
% plot(1, mean(Bout_ratio_normalized(:,11:15),2),'ko')
xlabel('normalized time')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')


% Bout_ratio_zscore = zscore(Bout_ratio,0,2); %zscore
% Bout_ratio_zscore = Bout_ratio_zscore - mean(Bout_ratio_zscore(:,1:50*60*15),2); %subtract first 2 days

% figure
% subplot(1,2,1)
% plot(Bout_ratio_zscore')
% % hold on
% % plot(mean(Bout_ratio_zscore),'k-','Linewidth',2) 
% h=gca;
% h.XTick = 0:50*60*15:size(Bout_ratio_zscore,2); %every 50min
% h.XTickLabel = 0:50:size(Bout_ratio_zscore,2);
% axis([0 size(Bout_ratio_zscore,2) -3 5])
% xlabel('min')
% ylabel('zscore')
% title('time spent near object')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')
% 
% subplot(1,2,2)
% histogram(mean(Bout_ratio_zscore(:,(50*60*15+1):75*60*15),2),10)
% xlabel('zscore')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')

%% Fig 1g: approch bout duration
Total_bout_duration_max = sum(Bout_duration_max');
[Total_bout_duration_sort, sort_index] = sort(Total_bout_duration_max);
Bout_duration_max_sort = Bout_duration_max(sort_index,:);

figure
subplot(2,1,1)
imagesc(Bout_duration_max_sort,[0,10])
% colormap yellowblue
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

%% violin plots
Bout_duration_max_5min = movmean(Bout_duration_max,[0,4],2);
Bout_duration_max_5min = Bout_duration_max_5min(:,1:5:end); 
Bout_duration_max_baseline = mean(Bout_duration_max_5min(:,1:10),2);
Bout_duration_max_normalized = Bout_duration_max_5min - Bout_duration_max_baseline;
figure
violinplot(mean(Bout_duration_max_normalized(:,11:15),2))
xlabel('normalized duration')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')


%% nose-tail
Total_ratio_nose_tail = sum(Ratio_nose_tail','omitnan');
[Total_ratio_nose_tail_sort, sort_index] = sort(Total_ratio_nose_tail);
Ratio_nose_tail_sort = Ratio_nose_tail(sort_index,:);

% % mean_nose_tail
% % std_nose_tail
% thresh = 0.6-0.2;
% tail_start = []; tail_first = [];
% for i=1:size(Ratio_nose_tail_sort,1)
%     ind = find(Ratio_nose_tail_sort(i,:)>thresh,1,'first');
%     if length(ind)>0
%     tail_start = [tail_start,ind];
%     else
%         tail_start = [tail_start,31];
%     end
%     ind = find(Ratio_nose_tail_sort(i,:)>0,1,'first');
%     if length(ind)>0
%     tail_first = [tail_first,ind];
%     else
%         tail_first = [tail_first,31];
%     end
% end
% % tail_start
% % tail_first

figure
subplot(2,1,1)
imagesc(Ratio_nose_tail_sort,[0,1])
% colormap yellowblue
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

m_plot = mean(Ratio_nose_tail_sort,'omitnan');
s_plot = std(Ratio_nose_tail_sort,'omitnan')/sqrt(size(Ratio_nose_tail_sort,1));
subplot(2,1,2)
% plot(Ratio_nose_tail_sort')
% hold on
% plot(mean(Ratio_nose_tail_sort,'omitnan'),'k-','Linewidth',2) 
errorbar_patch(plotWin,m_plot,s_plot,'k');
% plot([0 30],[thresh thresh],'--') %mean in habituation
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

%% Fig 1f, 3c/d colorplots
% approch with tail behind
Bout_tail_behind_min = Bout_tail_behind_frequency(:,1:15*60:end);
Total_bout_tail_behind = sum(Bout_tail_behind_min');
[Total_bout_tail_behind_sort, sort_index_tail_behind] = sort(Total_bout_tail_behind);
% Bout_tail_behind_frequency_sort = Bout_tail_behind_min(sort_index_tail_behind,:);

%approch with tail exposure
Bout_with_tail_min = Bout_with_tail_frequency(:,1:15*60:end);
Total_bout_with_tail = sum(Bout_with_tail_min');
[Total_bout_with_tail_sort, sort_index_with_tail] = sort(Total_bout_with_tail);
% Bout_with_tail_frequency_sort = Bout_with_tail_min(sort_index,:);
% Bout_with_tail_frequency_sort = Bout_with_tail_min(sort_index_tail_behind,:);
Bout_with_tail_frequency_sort = Bout_with_tail_min(sort_index_with_tail,:);
Bout_tail_behind_frequency_sort = Bout_tail_behind_min(sort_index_with_tail,:);

figure
subplot(2,3,2)
imagesc(Bout_tail_behind_frequency_sort,[0,8])
% colormap yellowblue
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

% Bout_tail_behind_frequency_smooth = smoothdata(Bout_tail_behind_frequency_sort,2,'lowess',4000);

plotWin = 1:25*test_length;
plotColors = {'k','r'};
m_plot = mean(Bout_tail_behind_min,'omitnan');
s_plot = std(Bout_tail_behind_min,'omitnan')/sqrt(size(Bout_tail_behind_min,1));
subplot(2,3,5)
errorbar_patch(plotWin,m_plot,s_plot,plotColors{1});
% plot(Bout_tail_behind_min')
% hold on
% plot(mean(Bout_tail_behind_min),'k-','Linewidth',2) 
% plot(Bout_tail_behind_frequency_smooth')
% hold on
% plot(mean(Bout_tail_behind_frequency_smooth),'k-','Linewidth',2) 
% plot([0 30],[thresh thresh],'--') %mean in habituation
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
% colormap yellowblue
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

% Bout_with_tail_frequency_smooth = smoothdata(Bout_with_tail_frequency_sort,2,'lowess',4000);
m_plot = mean(Bout_with_tail_min,'omitnan');
s_plot = std(Bout_with_tail_min,'omitnan')/sqrt(size(Bout_tail_behind_min,1));
subplot(2,3,6)
errorbar_patch(plotWin,m_plot,s_plot,plotColors{1});
% plot(Bout_with_tail_min')
% hold on
% plot(mean(Bout_with_tail_min),'k-','Linewidth',2) 
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

%all approch frequency
% Bout_frequency = Bout_tail_behind_frequency + Bout_with_tail_frequency;
Bout_min = Bout_tail_behind_min + Bout_with_tail_min;
Total_bout_freq = sum(Bout_min');
[Total_bout_with_tail_sort, sort_index] = sort(Total_bout_freq);
Bout_frequency_sort = Bout_min(sort_index,:);
% Bout_frequency_sort = Bout_frequency(sort_index_tail_behind,:);


subplot(2,3,1)
imagesc(Bout_frequency_sort,[0,8])
% colormap yellowblue
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

% Bout_frequency_smooth = smoothdata(Bout_frequency_sort,2,'lowess',4000);
m_plot = mean(Bout_min,'omitnan');
s_plot = std(Bout_min,'omitnan')/sqrt(size(Bout_tail_behind_min,1));
subplot(2,3,4)
errorbar_patch(plotWin,m_plot,s_plot,plotColors{1});
% plot(Bout_min')
% hold on
% plot(mean(Bout_min),'k-','Linewidth',2) 
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

%% violin plots
Bout_5min = movmean(Bout_min,[0,4],2);
Bout_5min = Bout_5min(:,1:5:end); 
Bout_5min_baseline = mean(Bout_5min(:,1:10),2);
Bout_5min_normalized = Bout_5min - Bout_5min_baseline;
figure
violinplot(mean(Bout_5min_normalized(:,11:15),2))
title('normalized frequency')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')


Bout_tail_behind_5min = movmean(Bout_tail_behind_min,[0,4],2);
Bout_tail_behind_5min = Bout_tail_behind_5min(:,1:5:end); 
Bout_tail_behind_5min_baseline = mean(Bout_tail_behind_5min(:,1:10),2);
Bout_tail_behind_5min_normalized = Bout_tail_behind_5min - Bout_tail_behind_5min_baseline;
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

Bout_with_tail_5min = movmean(Bout_with_tail_min,[0,4],2);
Bout_with_tail_5min = Bout_with_tail_5min(:,1:5:end); 
Bout_with_tail_5min_baseline = mean(Bout_with_tail_5min(:,1:10),2);
Bout_with_tail_5min_normalized = Bout_with_tail_5min - Bout_with_tail_5min_baseline;
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


figure
subplot(1,2,1)
violinplot([mean(Bout_tail_behind_5min_normalized(:,11:12),2),...
    mean(Bout_tail_behind_5min_normalized(:,13:15),2),...
    mean(Bout_tail_behind_5min_normalized(:,16:end),2)])
hold on
plot([mean(Bout_tail_behind_5min_normalized(:,11:12),2),...
    mean(Bout_tail_behind_5min_normalized(:,13:15),2),...
    mean(Bout_tail_behind_5min_normalized(:,16:end),2)]','k-')
h=gca;
h.XTick = 1:3; %every 50min
h.XTickLabel = {'1-10min','11-25min','day2-4'};
% plot(Bout_tail_behind_5min_normalized','k-')
% h=gca;
% h.XTick = 0:50:25*test_length; %every 50min
% h.XTickLabel = 0:50:25*test_length;
title('tail behind')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

Beta_tail_behind_time = [];P_tail_behind_time=[];
for ani = 1:size(Bout_tail_behind_min,1)
mdl = fitlm(1:100,Bout_tail_behind_min(ani,51:end)); %tail behind frequency vs novelty min
beta = mdl.Coefficients.Estimate;
p = mdl.Coefficients.pValue;
Beta_tail_behind_time = [Beta_tail_behind_time;beta'];
P_tail_behind_time = [P_tail_behind_time;p'];
end
[h,pval_tail_behind_time] = ttest(Beta_tail_behind_time(:,2))

subplot(1,2,2)
boxplot(Beta_tail_behind_time(:,2))
hold on
plot(1,Beta_tail_behind_time(:,2),'ko')
ind = find(P_tail_behind_time(:,2)<0.05);
if length(ind)>0
plot(1,Beta_tail_behind_time(ind,2),'ro')
end
h=gca;
h.XTick = [];
xlabel('tail behind vs time')
ylabel('beta')
title(pval_tail_behind_time)
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')


figure
subplot(1,2,1)
violinplot([mean(Bout_with_tail_5min_normalized(:,11:12),2),...
    mean(Bout_with_tail_5min_normalized(:,13:15),2),...
    mean(Bout_with_tail_5min_normalized(:,16:end),2)])
hold on
plot([mean(Bout_with_tail_5min_normalized(:,11:12),2),...
    mean(Bout_with_tail_5min_normalized(:,13:15),2),...
    mean(Bout_with_tail_5min_normalized(:,16:end),2)]','k-')
h=gca;
h.XTick = 1:3; %every 50min
h.XTickLabel = {'1-10min','11-25min','day2-4'};
% plot(Bout_tail_behind_5min_normalized','k-')
% h=gca;
% h.XTick = 0:50:25*test_length; %every 50min
% h.XTickLabel = 0:50:25*test_length;
title('tail exposure')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

Beta_tail_exposure_time = [];P_tail_exposure_time=[];
for ani = 1:size(Bout_with_tail_min,1)
mdl = fitlm(1:100,Bout_with_tail_min(ani,51:end)); %tail behind frequency vs novelty min
beta = mdl.Coefficients.Estimate;
p = mdl.Coefficients.pValue;
Beta_tail_exposure_time = [Beta_tail_exposure_time;beta'];
P_tail_exposure_time = [P_tail_exposure_time;p'];
end
[h,pval_tail_exposure_time] = ttest(Beta_tail_exposure_time(:,2))


[R, P] = corrcoef(mean(Bout_tail_behind_5min_normalized(:,11:12),2),mean(Bout_with_tail_5min_normalized(:,13:15),2)) %tail behind vs tail exposure
subplot(1,2,2)
scatter(mean(Bout_tail_behind_5min_normalized(:,11:12),2),mean(Bout_with_tail_5min_normalized(:,13:15),2))
xlabel('tail behind 1-10min')
ylabel('tail exposure 11-25min')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

%% Fig 1d (betas)
% mean_with_tail = mean(Bout_with_tail_min(:,76:end),2);
mean_with_tail = mean(Bout_with_tail_min(:,61:75),2); %11-25min
mean_tail_before = mean(Bout_with_tail_min(:,1:50),2);
approach_animal = (mean_with_tail>=mean_tail_before);
other_animal = (mean_with_tail<mean_tail_before);

mean_tail_behind_10min = mean(Bout_tail_behind_min(:,51:60),2); %10min after novelty
mean_tail_behind_d24 = mean(Bout_tail_behind_min(:,76:end),2); %day2-4

Beta_with_tail_time = [];P_with_tail_time=[];
for ani = 1:size(Bout_with_tail_min,1)
mdl = fitlm(1:90,Bout_with_tail_min(ani,61:end)); %with tail frequency vs time 11min-
beta = mdl.Coefficients.Estimate;
p = mdl.Coefficients.pValue;
Beta_with_tail_time = [Beta_with_tail_time;beta'];
P_with_tail_time = [P_with_tail_time;p'];
end
[h,pval_with_tail_time_approach] = ttest(Beta_with_tail_time(approach_animal,2));
[h,pval_with_tail_time_avoid] = ttest(Beta_with_tail_time(other_animal,2));

figure
subplot(1,2,1)
boxplot(Beta_with_tail_time(approach_animal,2))
hold on
plot(1,Beta_with_tail_time(approach_animal,2),'ko')
ind = find(P_with_tail_time(approach_animal,2)<0.05);
if length(ind)>0
    ind2 = find(approach_animal);
plot(1,Beta_with_tail_time(ind2(ind),2),'ro')
end
h=gca;
h.XTick = [];
xlabel('approach animals')
ylabel('beta')
title(pval_with_tail_time_approach)
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,2,2)
boxplot(Beta_with_tail_time(other_animal,2))
hold on
plot(1,Beta_with_tail_time(other_animal,2),'ko')
ind = find(P_with_tail_time(other_animal,2)<0.05);
if length(ind)>0
    ind2 = find(other_animal);
plot(1,Beta_with_tail_time(ind2(ind),2),'ro')
end
h=gca;
h.XTick = [];
xlabel('avoid animals')
ylabel('beta')
title(pval_with_tail_time_avoid)
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

%%
figure
subplot(1,3,1)
plot(mean(Bout_tail_behind_min),'r-','Linewidth',2) 
hold on
plot(mean(Bout_with_tail_min),'k-','Linewidth',2) 
h=gca;
h.XTick = 0:50:25*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
axis([0 25*test_length 0 6])
xlabel('min')
ylabel('/min')
% legend('tail behind','tail exposure')
title('all animals')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(1,3,2)
plot(mean(Bout_tail_behind_min(approach_animal,:)),'r-','Linewidth',2) 
hold on
plot(mean(Bout_with_tail_min(approach_animal,:)),'k-','Linewidth',2) 
h=gca;
h.XTick = 0:50:25*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
axis([0 25*test_length 0 6])
xlabel('min')
ylabel('/min')
% legend('tail behind','tail exposure')
title('approach animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(1,3,3)
plot(mean(Bout_tail_behind_min(other_animal,:)),'r-','Linewidth',2) 
hold on
plot(mean(Bout_with_tail_min(other_animal,:)),'k-','Linewidth',2) 
h=gca;
h.XTick = 0:50:25*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
axis([0 25*test_length 0 6])
xlabel('min')
ylabel('/min')
legend('tail behind','tail exposure')
title('avoid animals')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

%% nose or tail time spent near object (not used)
figure

Total_bout_ratio = sum(Nose_ratio');
[Total_bout_ratio_sort, sort_index] = sort(Total_bout_ratio);
sort_index;
Nose_ratio_sort = Nose_ratio(sort_index,:);

subplot(2,3,1)
imagesc(Nose_ratio_sort,[0,0.3])
% colormap yellowblue
colormap summer
colorbar
h=gca;
h.XTick = 0:50*60*15:25*60*15*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
title('nose time spent near object')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(2,3,4)
plot(Nose_ratio_sort')
hold on
plot(mean(Nose_ratio_sort),'k-','Linewidth',2) 
h=gca;
h.XTick = 0:50*60*15:25*60*15*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
axis([0 25*60*15*test_length 0 0.3])
xlabel('min')
ylabel('fraction')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

Total_bout_ratio = sum(Tail_ratio');
[Total_bout_ratio_sort, sort_index] = sort(Total_bout_ratio);
sort_index;
Tail_ratio_sort = Tail_ratio(sort_index,:);

subplot(2,3,2)
imagesc(Tail_ratio_sort,[0,0.3])
% colormap yellowblue
colormap summer
colorbar
h=gca;
h.XTick = 0:50*60*15:25*60*15*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
title('tail time spent near object')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(2,3,5)
plot(Tail_ratio_sort')
hold on
plot(mean(Tail_ratio_sort),'k-','Linewidth',2) 
h=gca;
h.XTick = 0:50*60*15:25*60*15*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
axis([0 25*60*15*test_length 0 0.3])
xlabel('min')
ylabel('fraction')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

Nose_tail_ratio = Nose_ratio-Tail_ratio;
Total_bout_ratio = sum(Nose_tail_ratio');
[Total_bout_ratio_sort, sort_index] = sort(Total_bout_ratio);
sort_index;
Nose_tail_ratio_sort = Nose_tail_ratio(sort_index,:);

subplot(2,3,3)
imagesc(Nose_tail_ratio_sort,[0,0.3])
% colormap yellowblue
colormap summer
colorbar
h=gca;
h.XTick = 0:50*60*15:25*60*15*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
title('nose-tail time spent near object')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(2,3,6)
plot(Nose_tail_ratio_sort')
hold on
plot(mean(Nose_tail_ratio_sort),'k-','Linewidth',2) 
h=gca;
h.XTick = 0:50*60*15:25*60*15*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
axis([0 25*60*15*test_length -0.1 0.3])
xlabel('min')
ylabel('fraction')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

Total_bout_ratio = sum(Tail_closer');
[Total_bout_ratio_sort, sort_index] = sort(Total_bout_ratio);
Tail_closer_sort = Tail_closer(sort_index,:);
Tail_closer_sort = smoothdata(Tail_closer_sort,2,'lowess',4000);

mean_tail_closer = mean(Tail_closer(:,51*1000:end),2);
mean_tail_closer_baseline = mean(Tail_closer(:,1:50*1000),2);
figure
subplot(1,2,1)
histogram(mean_tail_closer,0:0.05:0.2)
xlabel('fraction')
ylabel('animal number')
title('time with tail closer')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(1,2,2)
histogram(mean_tail_closer - mean_tail_closer_baseline,-0.1:0.05:0.1)
xlabel('fraction')
ylabel('animal number')
title('time with tail closer')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')


figure
subplot(2,1,1)
imagesc(Tail_closer_sort,[0,0.3])
% colormap yellowblue
colormap summer
colorbar
h=gca;
h.XTick = 0:50*60*15:25*60*15*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
title('time tail closer near object')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(2,1,2)
plot(Tail_closer_sort')
hold on
plot(mean(Tail_closer_sort),'k-','Linewidth',2) 
h=gca;
h.XTick = 0:50*60*15:25*60*15*test_length; %every 50min
h.XTickLabel = 0:50:25*test_length;
axis([0 25*60*15*test_length 0 0.3])
xlabel('min')
ylabel('fraction')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

%% body length

figure
subplot(3,1,1)
plot(Body_length_bin')
hold on
% plot(mean(Body_length_bin),'k-','Linewidth',2) 
plot(mean(Body_length_bin,'omitnan'),'k-','Linewidth',2) 
h=gca;
h.XTick = 0:5:5*test_length;
h.XTickLabel = 0:25:25*test_length;
axis([0 5*test_length 6 9])
title('max body length in bouts')
xlabel('min')
ylabel('cm')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

% mean_Body_length_bin = mean(Body_length_bin,2,'omitnan'); %'zsocre' cannot handle NaN
% std_Body_length_bin = std(Body_length_bin,[],2,'omitnan');
% Body_length_bin_zscore = (Body_length_bin - mean_Body_length_bin)./std_Body_length_bin; %zscore
% Body_length_bin_zscore = Body_length_bin_zscore - mean(Body_length_bin_zscore(:,1:10),2,'omitnan'); %subtract first 2 days
% 
% subplot(3,1,2)
% plot(Body_length_bin_zscore')
% hold on
% plot(mean(Body_length_bin_zscore,'omitnan'),'k-','Linewidth',2) 
% h=gca;
% h.XTick = 0:5:5*test_length;
% h.XTickLabel = 0:25:25*test_length;
% axis([0 5*test_length -2 4])
% title('max body length in bouts')
% xlabel('min')
% ylabel('zscore')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')

mean_Body_length_baseline = mean(Body_length_bin(:,1:10),2,'omitnan'); 
Body_length_bin_normalized = Body_length_bin./mean_Body_length_baseline;

subplot(3,1,2)
plot(Body_length_bin_normalized')
hold on
plot(mean(Body_length_bin_normalized,'omitnan'),'k-','Linewidth',2) 
h=gca;
h.XTick = 0:5:5*test_length;
h.XTickLabel = 0:25:25*test_length;
axis([0 5*test_length 0.9 1.2])
title('max body length in bouts')
xlabel('min')
ylabel('normalized length')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')


Total_body_length = sum(Body_length_bin_normalized','omitnan');
[Total_body_length_sort, sort_index] = sort(Total_body_length,'descend');
Body_length_bin_sort = Body_length_bin_normalized(sort_index,:);

% Total_body_length = sum(Body_length_bin_zscore','omitnan');
% [Total_body_length_sort, sort_index] = sort(Total_body_length,'descend');
% Body_length_bin_sort = Body_length_bin_zscore(sort_index,:);

subplot(3,1,3)
imagesc(Body_length_bin_sort,[0.9 1.2]) %5 min bin
% colormap yellowblue
colormap summer
colorbar
h=gca;
h.XTick = 0:5:5*test_length;
h.XTickLabel = 0:25:25*test_length;
title('body length')
xlabel('min')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

% figure
% subplot(3,1,1)
% plot(Body_length_min')
% hold on
% plot(mean(Body_length_min,'omitnan'),'k-','Linewidth',2) 
% h=gca;
% h.XTick = 0:25:25*test_length;
% h.XTickLabel = 0:25:25*test_length;
% axis([0 25*test_length 6 9])
% title('max body length in bouts')
% xlabel('min')
% ylabel('cm')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')
% 
% mean_Body_length_min = mean(Body_length_min,2,'omitnan'); %'zsocre' cannot handle NaN
% std_Body_length_min = std(Body_length_min,[],2,'omitnan');
% Body_length_min_zscore = (Body_length_min - mean_Body_length_min)./std_Body_length_min; %zscore
% Body_length_min_zscore = Body_length_min_zscore - mean(Body_length_min_zscore(:,1:50),2,'omitnan'); %subtract first 2 days
% 
% subplot(3,1,2)
% plot(Body_length_min_zscore')
% hold on
% plot(mean(Body_length_min_zscore,'omitnan'),'k-','Linewidth',2) 
% h=gca;
% h.XTick = 0:25:25*test_length;
% h.XTickLabel = 0:25:25*test_length;
% axis([0 25*test_length -2 4])
% title('max body length in bouts')
% xlabel('min')
% ylabel('zscore')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')
% 
% Total_body_length = sum(Body_length_min','omitnan');
% [Total_body_length_sort, sort_index] = sort(Total_body_length,'descend');
% Body_length_min_sort = Body_length_min_zscore(sort_index,:);
% 
% subplot(3,1,3)
% imagesc(Body_length_min_sort,[-2,4]) %5 min bin
% % colormap yellowblue
% colormap summer
% colorbar
% h.XTick = 0:25:25*test_length;
% h.XTickLabel = 0:25:25*test_length;
% title('body length')
% xlabel('min')
% ylabel('zscore')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')

mean_Body_length_baseline = mean(Body_length_bin(:,1:10),2,'omitnan'); 
Bout_body_length_normalized = Bout_body_length_novelty./mean_Body_length_baseline;
m_plot = mean(Bout_body_length_normalized,'omitnan');
s_plot = std(Bout_body_length_normalized,'omitnan')/sqrt(size(Bout_body_length_normalized,1));
plotWin = 1:size(Bout_body_length_novelty,2);
figure
% plot(Bout_body_length_normalized')
% hold on
% plot(mean(Bout_body_length_normalized,'omitnan'),'k-','Linewidth',2)
errorbar_patch(plotWin,m_plot,s_plot,'k');
h=gca;
h.XTick = 0:10:100;
axis([0 100 0.9 1.2])
title('body length')
xlabel('bout')
ylabel('normalized length')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

% mean_body_length_closest_baseline = mean(Body_length_closest(:,1:20),2,'omitnan');
% Body_length_closest_normalized = Body_length_closest./mean_body_length_closest_baseline;
% figure
% plot(Body_length_closest_normalized')
% hold on
% plot(mean(Body_length_closest_normalized,'omitnan'),'k-','LineWidth',2)
% h=gca;
% h.XTick = 0:10:100;
% axis([0 100 0.9 1.3])
% title('body length')
% xlabel('bout')
% ylabel('normalized length')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')

% cd('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior/stimulus_saline');
% cd(groupfolder);
% save('bout_multi','Bout_ratio','Bout_duration_max','Ratio_nose_tail','Bout_tail_behind_frequency',...
%     'Nose_ratio','Tail_ratio','Frame_within','Bout_with_tail_frequency','Tail_closer','Bout_body_length','Body_length_bin',...
%     'Bout_start','Bout_type')

