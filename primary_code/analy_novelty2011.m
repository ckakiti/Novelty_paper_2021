function analy_novelty2011

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

cd('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior/DLC_newplots/raw_data');
[animal_info,text,raw] = xlsread('akiti_miceID_210318.xlsx');
animal = text(2:end,3);
condition = text(2:end,9);

% group = {'Capoeira','Planets'};
% animal = {'Jupiter_6OHDA','Mars_6OHDA','Neptune_6OHDA','Pluto_6OHDA','Uranus_6OHDA','Venus_6OHDA',...
%     'Earth_saline','Mercury_saline','Saturn_saline'};
% % animal = {'Au_stim','Ginga_stim','Negativa_stim','Esquiva_cont','MeiaLua_cont','Queixada_cont'};
test = {'hab1','hab2','novel1','novel2','novel3','novel4'};
session_length = 27; %min
% group_n = 2;
% groupfolder = strcat('/Users/mitsukouchida/Desktop/Korleki/',group{group_n});
% cd(groupfolder);

group = {'stimulus','contextual','saline','6OHDA'};
% animal = {'Applachian'};
Bout_ratio = []; Ratio_nose_tail = [];mean_nose_tail = [];std_nose_tail = [];Bout_tail_behind_frequency = [];
Bout_duration_max =[];Distance_nose=[];Tail_ratio = [];Nose_ratio = [];Frame_within=[];Bout_with_tail_frequency = [];
Tail_closer = []; Bout_body_length =[];

for group_n = [1,3] %when combine groups, change save folder at the end
% for group_n = 3
groupfolder = strcat('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior/DLC_newplots/raw_data/',group{group_n});
cd(groupfolder);


% for animal_n = 1:length(animal)
% for animal_n = 1
% for animal_n = find(contains(animal,'stim'))   
% for animal_n = find(contains(animal,'cont')) 
% for animal_n = find(contains(animal,'6OHDA')) 
% for animal_n = find(contains(animal,'saline')) 
for animal_n = find(strcmp(condition,group{group_n}))'
    animal_n
    animal{animal_n}
    animalfolder = strcat(groupfolder,'/',animal{animal_n});
    cd(animalfolder);
    load('Arena_Obj_Pos','obj_center','arena') %xy positions of object, arena
    
for test_n = 3
        cd(animalfolder);
      cd(test{test_n});
      test{test_n}
      
load('DLC_label','Labels')


%% approach-retreat bouts

object_threshold = 7; % cm
session_time = ((1:size(Labels,1))/15)/60; %min

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
bout_frequency = zeros(1,size(Labels,1));
bout_frequency(bout_start) = 1;
bout_start_frequency = movsum(bout_frequency,900); %900 frame, 60s, 1min
bout_start_frequency_smooth = smoothdata(bout_start_frequency,'lowess',4000);
% bout_ratio = movmean(frame_within,4000);
bout_ratio = smoothdata(frame_within,'lowess',4000);
Bout_tail = [];Bout_nose = [];t_bout_tail_behind = [];t_bout_with_tail=[];
for i = 1:length(bout_end)
    bout_tail = min(0.15*Labels(bout_start(i):bout_end(i),34));
    Bout_tail = [Bout_tail,bout_tail];
    bout_nose = min(0.15*Labels(bout_start(i):bout_end(i),32));
    Bout_nose = [Bout_nose,bout_nose];
    bout_nose_tail = 0.15*Labels(bout_start(i):bout_end(i),32) - 0.15*Labels(bout_start(i):bout_end(i),34);
    if max(bout_nose_tail)<0
    t_bout_tail_behind = [t_bout_tail_behind,bout_start(i)];
    else
        t_bout_with_tail = [t_bout_with_tail,bout_start(i)];
    end
end
bout_nose_tail = 0.15*(Labels(find(frame_within),32) - Labels(find(frame_within),34));
bout_nose_tail_closest = Bout_nose - Bout_tail;
bout_tail_behind = zeros(1,size(Labels,1));
bout_tail_behind(t_bout_tail_behind) = 1;
bout_tail_behind_frequency = movsum(bout_tail_behind,900); %900 frame, 60s, 1min
bout_tail_behind_frequency_smooth = smoothdata(bout_tail_behind_frequency,'lowess',4000);
bout_with_tail = zeros(1,size(Labels,1));
bout_with_tail(t_bout_with_tail) = 1;
bout_with_tail_frequency = movsum(bout_with_tail,900); %900 frame, 60s, 1min

bout_duration = zeros(1,size(Labels,1));
bout_duration(bout_start) = bout_length;
bout_duration = reshape(bout_duration(1:session_length*60*15),900,[]); %900 frame, 60s, 1min
bout_duration_max = max(bout_duration,[],1); 
bout_duration_max_smooth = smoothdata(bout_duration_max,'lowess',4000);


bin = 15*60; %1 min
binN = floor(size(Labels,1)/bin);
tail_closer_within = [];
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
tail_closer = smoothdata(tail_closer,'lowess',4000);

Frame_within = [Frame_within;frame_within(1:session_length*60*15)'];
Bout_duration_max = [Bout_duration_max;bout_duration_max];
Bout_tail_behind_frequency = [Bout_tail_behind_frequency;bout_tail_behind_frequency(1:session_length*60*15)];
Bout_with_tail_frequency = [Bout_with_tail_frequency;bout_with_tail_frequency(1:session_length*60*15)];
Bout_ratio = [Bout_ratio;bout_ratio(1:session_length*60*15)']; 
Tail_ratio = [Tail_ratio;tail_ratio(1:session_length*60*15)']; 
Nose_ratio = [Nose_ratio;nose_ratio(1:session_length*60*15)']; 
Ratio_nose_tail = [Ratio_nose_tail;ratio_nose_tail(1:session_length)]; %fraction tail is closer when near object
mean_nose_tail = [mean_nose_tail,mean(ratio_nose_tail_bout)];
std_nose_tail = [std_nose_tail,std(ratio_nose_tail_bout)];
Distance_nose = [Distance_nose;0.15*Labels(1:session_length*60*15,32)]; %cm
Tail_closer = [Tail_closer;tail_closer(1:session_length*60*15)']; %fraction of time tail is closer and near object

%% body stretch

bout_body_length_all = [];
ind = find(0.15*Labels(:,35)>9); %remove >9cm
Labels(ind,35)=NaN;
for i = 1:length(bout_end)
    bout_body_length = max(0.15*Labels(bout_start(i):bout_end(i),35),[],'omitnan');
%     bout_body_length = mean(0.15*Labels(bout_start(i):bout_end(i),35));
    bout_body_length_all = [bout_body_length_all,bout_body_length];
end

Bout_body_length{animal_n} = [bout_start(1:length(bout_end))';bout_end';bout_body_length_all];


end


end

end



%% plot multi animal data

% % distance from object
% figure
% plot(log10(Distance_nose'))

% time spent near object
Total_bout_ratio = sum(Bout_ratio');
[Total_bout_ratio_sort, sort_index] = sort(Total_bout_ratio);
sort_index
Bout_ratio_sort = Bout_ratio(sort_index,:);

mean_bout_ratio = mean(reshape(bout_ratio,1,[]))
% std_bout_ratio = std(reshape(bout_ratio,1,[]))
thresh1 = 0.114-0.046;
thresh2 = 0.114+3*0.046;
approach_start = []; exploration_start = [];
for i=1:size(Bout_ratio_sort,1)
    ind = find(Bout_ratio_sort(i,:)>thresh1,1,'first');
    if length(ind)>0
    approach_start = [approach_start,ceil(ind/(15*60))];
    else
        approach_start = [approach_start,31];
    end
    ind = find(Bout_ratio_sort(i,:)>thresh2,1,'first');
    if length(ind)>0
    exploration_start = [exploration_start,ceil(ind/(15*60))];
    else
        exploration_start = [exploration_start,31];
    end
end
approach_start
exploration_start

figure
subplot(1,2,1)
imagesc(Bout_ratio_sort,[0,0.5])
% colormap yellowblue
colormap summer
colorbar
h=gca;
h.XTick = 0:10*60*15:30*60*15; %every 10min
h.XTickLabel = 0:10:30;
title('time spent near object')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(1,2,2)
plot(Bout_ratio_sort')
hold on
plot(mean(Bout_ratio_sort),'k-','Linewidth',2) 
h=gca;
h.XTick = 0:10*60*15:30*60*15; %every 10min
h.XTickLabel = 0:10:30;
axis([0 30*60*15 0 0.8])
xlabel('min')
ylabel('fraction')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

%approch bout duration
Total_bout_duration_max = sum(Bout_duration_max');
[Total_bout_duration_sort, sort_index] = sort(Total_bout_duration_max);
Bout_duration_max_sort = Bout_duration_max(sort_index,:);

figure
subplot(1,2,1)
imagesc(Bout_duration_max_sort)
% colormap yellowblue
colormap summer
colorbar
h=gca;
h.XTick = 0:10:30; %every 10min
h.XTickLabel = 0:10:30;
title('approach bout duration')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(1,2,2)
plot(Bout_duration_max')
hold on
plot(mean(Bout_duration_max),'k-','Linewidth',2) 
% plot([0 30],[thresh thresh],'--') %mean in habituation
h=gca;
h.XTick = 0:10:30; %every 10min
h.XTickLabel = 0:10:30;
axis([0 30 0 20])
xlabel('min')
ylabel('s')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')


%nose-tail
Total_ratio_nose_tail = sum(Ratio_nose_tail');
[Total_ratio_nose_tail_sort, sort_index] = sort(Total_ratio_nose_tail);
Ratio_nose_tail_sort = Ratio_nose_tail(sort_index,:);

mean_nose_tail
std_nose_tail
thresh = 0.6-0.2;
tail_start = []; tail_first = [];
for i=1:size(Ratio_nose_tail_sort,1)
    ind = find(Ratio_nose_tail_sort(i,:)>thresh,1,'first');
    if length(ind)>0
    tail_start = [tail_start,ind];
    else
        tail_start = [tail_start,31];
    end
    ind = find(Ratio_nose_tail_sort(i,:)>0,1,'first');
    if length(ind)>0
    tail_first = [tail_first,ind];
    else
        tail_first = [tail_first,31];
    end
end
tail_start
tail_first

figure
subplot(1,2,1)
imagesc(Ratio_nose_tail_sort,[0,1])
% colormap yellowblue
colormap summer
colorbar
h=gca;
h.XTick = 0:10:30; %every 10min
h.XTickLabel = 0:10:30;
title('tail exposure')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(1,2,2)
plot(Ratio_nose_tail_sort')
hold on
plot(mean(Ratio_nose_tail_sort),'k-','Linewidth',2) 
plot([0 30],[thresh thresh],'--') %mean in habituation
h=gca;
h.XTick = 0:10:30; %every 10min
h.XTickLabel = 0:10:30;
axis([0 30 0 1])
xlabel('min')
ylabel('fraction')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

%approch with tail behind
Total_bout_tail_behind = sum(Bout_tail_behind_frequency');
[Total_bout_tail_behind_sort, sort_index] = sort(Total_bout_tail_behind);
Bout_tail_behind_frequency_sort = Bout_tail_behind_frequency(sort_index,:);

figure
subplot(1,2,1)
imagesc(Bout_tail_behind_frequency_sort,[0 12])
% colormap yellowblue
colormap summer
colorbar
h=gca;
h.XTick = 0:10*60*15:30*60*15; %every 10min
h.XTickLabel = 0:10:30;
title('approach with tail behind')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

Bout_tail_behind_frequency_smooth = smoothdata(Bout_tail_behind_frequency_sort,2,'lowess',4000);
subplot(1,2,2)
plot(Bout_tail_behind_frequency_smooth')
hold on
plot(mean(Bout_tail_behind_frequency_smooth),'k-','Linewidth',2) 
% plot([0 30],[thresh thresh],'--') %mean in habituation
h=gca;
h.XTick = 0:10*60*15:30*60*15; %every 10min
h.XTickLabel = 0:10:30;
axis([0 30*60*15 0 8])
xlabel('min')
ylabel('/min')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

%approch with tail exposure
Total_bout_with_tail = sum(Bout_with_tail_frequency');
[Total_bout_with_tail_sort, sort_index] = sort(Total_bout_with_tail);
Bout_with_tail_frequency_sort = Bout_with_tail_frequency(sort_index,:);

figure
subplot(1,2,1)
imagesc(Bout_with_tail_frequency_sort,[0 12])
% colormap yellowblue
colormap summer
colorbar
h=gca;
h.XTick = 0:10*60*15:30*60*15; %every 10min
h.XTickLabel = 0:10:30;
title('approach with tail exposure')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

Bout_with_tail_frequency_smooth = smoothdata(Bout_with_tail_frequency_sort,2,'lowess',4000);
subplot(1,2,2)
plot(Bout_with_tail_frequency_smooth')
hold on
plot(mean(Bout_with_tail_frequency_smooth),'k-','Linewidth',2) 
% plot([0 30],[thresh thresh],'--') %mean in habituation
h=gca;
h.XTick = 0:10*60*15:30*60*15; %every 10min
h.XTickLabel = 0:10:30;
axis([0 30*60*15 0 8])
xlabel('min')
ylabel('/min')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

% nose or tail time spent near object
figure

Total_bout_ratio = sum(Nose_ratio');
[Total_bout_ratio_sort, sort_index] = sort(Total_bout_ratio);
sort_index
Nose_ratio_sort = Nose_ratio(sort_index,:);

subplot(3,2,1)
imagesc(Nose_ratio_sort,[0,0.5])
% colormap yellowblue
colormap summer
colorbar
h=gca;
h.XTick = 0:10*60*15:30*60*15; %every 10min
h.XTickLabel = 0:10:30;
title('nose time spent near object')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(3,2,2)
plot(Nose_ratio_sort')
hold on
plot(mean(Nose_ratio_sort),'k-','Linewidth',2) 
h=gca;
h.XTick = 0:10*60*15:30*60*15; %every 10min
h.XTickLabel = 0:10:30;
axis([0 30*60*15 0 0.5])
xlabel('min')
ylabel('fraction')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

Total_bout_ratio = sum(Tail_ratio');
[Total_bout_ratio_sort, sort_index] = sort(Total_bout_ratio);
sort_index
Tail_ratio_sort = Tail_ratio(sort_index,:);

subplot(3,2,3)
imagesc(Tail_ratio_sort,[0,0.5])
% colormap yellowblue
colormap summer
colorbar
h=gca;
h.XTick = 0:10*60*15:30*60*15; %every 10min
h.XTickLabel = 0:10:30;
title('tail time spent near object')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(3,2,4)
plot(Tail_ratio_sort')
hold on
plot(mean(Tail_ratio_sort),'k-','Linewidth',2) 
h=gca;
h.XTick = 0:10*60*15:30*60*15; %every 10min
h.XTickLabel = 0:10:30;
axis([0 30*60*15 0 0.5])
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
sort_index
Nose_tail_ratio_sort = Nose_tail_ratio(sort_index,:);

subplot(3,2,5)
imagesc(Nose_tail_ratio_sort,[0,0.3])
% colormap yellowblue
colormap summer
colorbar
h=gca;
h.XTick = 0:10*60*15:30*60*15; %every 10min
h.XTickLabel = 0:10:30;
title('nose-tail time spent near object')
xlabel('min')
ylabel('animal')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(3,2,6)
plot(Nose_tail_ratio_sort')
hold on
plot(mean(Nose_tail_ratio_sort),'k-','Linewidth',2) 
h=gca;
h.XTick = 0:10*60*15:30*60*15; %every 10min
h.XTickLabel = 0:10:30;
axis([0 30*60*15 -0.1 0.3])
xlabel('min')
ylabel('fraction')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

%time tail closer
Total_bout_ratio = sum(Tail_closer');
[Total_bout_ratio_sort, sort_index] = sort(Total_bout_ratio);
% sort_index
Tail_closer_sort = Tail_closer(sort_index,:);

figure
subplot(2,1,1)
imagesc(Tail_closer_sort,[0 0.4])
% colormap yellowblue
colormap summer
colorbar
h=gca;
h.XTick = 0:10*60*15:30*60*15; %every 10min
h.XTickLabel = 0:10:30;
title('tail closer near object')
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
h.XTick = 0:10*60*15:30*60*15; %every 10min
h.XTickLabel = 0:10:30;
axis([0 30*60*15 0 0.4])
xlabel('min')
ylabel('fraction')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

% body length

figure
for animal_n = find(strcmp(condition,group{group_n}))'
    bout_body_legnth_animal = Bout_body_length{animal_n};
    bout_start_animal = bout_body_legnth_animal(1,:);
    body_length_animal = bout_body_legnth_animal(3,:);
%     body_length_smooth = smoothdata(body_length_animal,'lowess',4000,'SamplePoints',bout_start_animal);

%     plot(body_length_animal,'-')
plot(bout_start_animal/(15*60),body_length_animal,'-')
hold on

end

title('max body length in bouts')
xlabel('min')
ylabel('cm')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

%% comparison

% Bout_cumsum = cumsum(Frame_within,2);
% figure(8)
% plot(Bout_cumsum'/900,'r')
% hold on
% plot(median(Bout_cumsum)/900,'r','LineWidth',2)
% h=gca;
% h.XTick = 0:10*60*15:30*60*15; %every 10min
% h.XTickLabel = 0:10:30;
% % axis([0 6 0 0.3])
% xlabel('min')
% ylabel('min')
% title('time spent near object')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')

% figure(8)
% errorbar_patch(1:size(Bout_ratio_sort,2),median(Bout_ratio_sort),std(Bout_ratio_sort)/sqrt(size(Bout_ratio_sort,1)),'k');
% hold on
% h=gca;
% h.XTick = 0:10*60*15:30*60*15; %every 10min
% h.XTickLabel = 0:10:30;
% axis([0 30*60*15 0 0.25])
% xlabel('min')
% ylabel('fraction')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')

cd('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior/DLC_newplots/raw_data/stimulus_saline');
% cd(groupfolder);
save('bout','Bout_ratio_sort','Bout_duration_max_sort','Ratio_nose_tail_sort','Bout_tail_behind_frequency',...
    'Nose_ratio','Tail_ratio','Frame_within','Bout_with_tail_frequency','Tail_closer')
