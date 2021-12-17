function analy_novelty_multi_sessions_2012

%this is similar to video_Operant_multi_labels_2010, but for novelty in
%Korleki's rig
% for single animals

cd('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior');
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

for group_n = 1
groupfolder = strcat('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior/',group{group_n});
cd(groupfolder);


% for animal_n = 1:length(animal)
% for animal_n = 18 
% for animal_n = find(contains(animal,'stim'))   
% for animal_n = find(contains(animal,'cont')) 
% for animal_n = find(contains(animal,'6OHDA')) 
% for animal_n = find(contains(animal,'saline')) 
% for animal_n = find(strcmp(condition,'stimulus_FP'))'
ind = find(strcmp(condition,group{group_n}))';
for animal_n = ind(1)
    animal_n
    animal{animal_n}
    animalfolder = strcat(groupfolder,'/',animal{animal_n});
    cd(animalfolder);
    load('Arena_Obj_Pos','obj_center','arena') %xy positions of object, arena

    Labels_multi = [];
for test_n = test_chosen
        cd(animalfolder);
      cd(test{test_n});
      test{test_n}
      
load('DLC_label','Labels')
      
% filename = dir('*DeepCut_*.csv');
% 
% if length(filename)>0
%   filename.name  
%   Labels = csvread(filename.name,3,0);
%   event_frame = 1:size(Labels,1); %choose frame
%   event_frame = 250:size(Labels,1); %choose frame


%% Labels

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% velocity and accelaration

session_time = ((1:size(Labels,1))/15)/60; %min
head_speed_smooth = movmean(15*0.15*Labels(:,26),4000);
body_speed_smooth = movmean(15*0.15*Labels(:,29),4000);
% figure

% subplot(2,1,1)
% plot(session_time,head_speed_smooth)
% xlabel('min')
% ylabel('cm/s')
% title('head speed')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')
% 
% subplot(2,1,2)
% plot(session_time,body_speed_smooth)
% xlabel('min')
% ylabel('cm/s')
% title('body speed')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% noramlized with object position

% figure
% subplot(1,2,1)
% plot(0.15*Labels(1:10:end,20),0.15*Labels(1:10:end,21))
% xlabel('cm')
% ylabel('cm')
% title('head')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% 
% subplot(1,2,2)
% plot(0.15*Labels(1:10:end,11),0.15*Labels(1:10:end,12))
% xlabel('cm')
% ylabel('cm')
% title('tail')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')
% 
% figure
% subplot(1,2,1)
% plot(0.15*Labels(1:(10*60*15),20),0.15*Labels(1:(10*60*15),21)) %first 10min
% xlabel('cm')
% ylabel('cm')
% title('head first 10 min')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% 
% subplot(1,2,2)
% plot(0.15*Labels((end-10*60*15+1):end,20),0.15*Labels((end-10*60*15+1):end,21)) %last 10 min
% xlabel('cm')
% ylabel('cm')
% title('head last 10 min')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')

nose_log = -log10(0.15*Labels(:,32));
nose_log(find(nose_log>0.5))=0.5;
% figure
% subplot(3,1,1)
% plot(session_time,nose_log,'r-')
% xlabel('min')
% ylabel('log cm')
% title('nose from object')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% 
tail_log = -log10(0.15*Labels(:,34));
tail_log(find(tail_log>0.5))=0.5;
% subplot(3,1,2)
% plot(session_time,tail_log,'k-')
% xlabel('min')
% ylabel('log cm')
% title('tail from object')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% 
% subplot(3,1,3)
% plot(session_time,nose_log,'r-')
% hold on
% plot(session_time,tail_log,'k-')
% xlabel('min')
% ylabel('log cm')
% % title('distance from object')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')
% 
% nose_close = movmin(0.15*Labels(:,32),1000);
% tail_close = movmin(0.15*Labels(:,34),1000);
% nose_close_log = -log10(nose_close);
% nose_close_log(find(nose_close_log>0.5))=0.5;
% tail_close_log = -log10(tail_close);
% tail_close_log(find(tail_close_log>0.5))=0.5;
% nose_smooth = smoothdata(nose_close_log,'lowess',4000); %movemean,lowess, rlowess, loess
% tail_smooth = smoothdata(tail_close_log,'lowess',4000);
% 
% figure
% subplot(4,1,1)
% plot(session_time,nose_close_log,'r-')
% hold on
% plot(session_time,nose_smooth,'m-','Linewidth',2)
% xlabel('min')
% ylabel('log cm')
% title('nose closest from object')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% 
% subplot(4,1,2)
% plot(session_time,tail_close_log,'k-')
% hold on
% plot(session_time,tail_smooth,'g-','Linewidth',2)
% xlabel('min')
% ylabel('log cm')
% title('tail closest from object')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% 
% subplot(4,1,3)
% plot(session_time,nose_smooth,'m-','Linewidth',2)
% hold on
% plot(session_time,tail_smooth,'g-','Linewidth',2)
% xlabel('min')
% ylabel('log cm')
% title('closest from object')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')
% 
% nose_tail = smoothdata((nose_close - tail_close),'lowess',4000);
% 
% subplot(4,1,4)
% plot(session_time,nose_tail,'k-','Linewidth',2)
% xlabel('min')
% ylabel('cm')
% title('nose - tail closest')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')

%% approach-retreat bouts

object_threshold = 7;

frame_within = (0.15*Labels(:,32)<object_threshold | 0.15*Labels(:,34)<object_threshold); %nose or tail is close
bout_start = 1+find(diff(frame_within)==1);
bout_end = 1+find(diff(frame_within)==-1);
if length(bout_end)<length(bout_start)
    bout_start = bout_start(1:end-1);
end

figure(1)
subplot(2,length(test),test_n)
% for i = 1:length(bout_end)
if length(bout_end)>=20
    for i = 1:20
    nose_x = 0.15*Labels(bout_start(i):bout_end(i),2);
    nose_y = 0.15*Labels(bout_start(i):bout_end(i),3);
    tail_x = 0.15*Labels(bout_start(i):bout_end(i),8);
    tail_y = 0.15*Labels(bout_start(i):bout_end(i),9);
    plot(nose_x,nose_y,'r-')
    hold on
    plot(tail_x,tail_y,'k-')
%     legend('nose','tail')
    xlabel('cm')
    ylabel('cm')
    title('early bouts')
    end
else
    for i = 1:length(bout_end)
    nose_x = 0.15*Labels(bout_start(i):bout_end(i),2);
    nose_y = 0.15*Labels(bout_start(i):bout_end(i),3);
    tail_x = 0.15*Labels(bout_start(i):bout_end(i),8);
    tail_y = 0.15*Labels(bout_start(i):bout_end(i),9);
    plot(nose_x,nose_y,'r-')
    hold on
    plot(tail_x,tail_y,'k-')
%     legend('nose','tail')
    xlabel('cm')
    ylabel('cm')
    title('early bouts')
    end
end
axis([-15 15 -15 15])        
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(2,length(test),length(test)+test_n)
if length(bout_end)>=20
for i = (length(bout_end)-19):length(bout_end)
    nose_x = 0.15*Labels(bout_start(i):bout_end(i),2);
    nose_y = 0.15*Labels(bout_start(i):bout_end(i),3);
    tail_x = 0.15*Labels(bout_start(i):bout_end(i),11);
    tail_y = 0.15*Labels(bout_start(i):bout_end(i),12);
    plot(nose_x,nose_y,'r-')
    hold on
    plot(tail_x,tail_y,'k-')
    xlabel('cm')
    ylabel('cm')
    title('late bouts')
end
end
% legend('nose','tail')
axis([-15 15 -15 15])  
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

bout_length = (bout_end - bout_start)/15;
bout_frequency = zeros(1,size(Labels,1));
bout_frequency(bout_start) = 1;
bout_start_frequency = movsum(bout_frequency,900); %900 frame, 60s, 1min
bout_start_frequency_smooth = smoothdata(bout_start_frequency,'lowess',4000);
% bout_ratio = movmean(frame_within,4000);
bout_ratio = smoothdata(frame_within,'lowess',4000);
Bout_tail = [];Bout_nose = [];t_bout_tail_behind = [];Bout_tail_all = [];Bout_nose_all = [];
for i = 1:length(bout_end)
    bout_tail = min(0.15*Labels(bout_start(i):bout_end(i),34));
    Bout_tail = [Bout_tail,bout_tail];
    bout_nose = min(0.15*Labels(bout_start(i):bout_end(i),32));
    Bout_nose = [Bout_nose,bout_nose];
    bout_nose_tail = 0.15*Labels(bout_start(i):bout_end(i),32) - 0.15*Labels(bout_start(i):bout_end(i),34);
    if max(bout_nose_tail)<0
    t_bout_tail_behind = [t_bout_tail_behind,bout_start(i)];
    end
    if bout_start(i)+200<size(Labels,1)
    Bout_tail_all = [Bout_tail_all;0.15*Labels(bout_start(i):bout_start(i)+200,34)'];
    Bout_nose_all = [Bout_nose_all;0.15*Labels(bout_start(i):bout_start(i)+200,32)'];
    end
end
bout_nose_tail = 0.15*(Labels(find(frame_within),32) - Labels(find(frame_within),34));
bout_nose_tail_closest = Bout_nose - Bout_tail;
bout_tail_behind = zeros(1,size(Labels,1));
bout_tail_behind(t_bout_tail_behind) = 1;
bout_tail_behind_frequency = movsum(bout_tail_behind,900); %900 frame, 60s, 1min
bout_tail_behind_frequency_smooth = smoothdata(bout_tail_behind_frequency,'lowess',4000);

figure(2)
subplot(4,length(test),3*length(test)+test_n)
% subplot(4,1,4)
plot(session_time, bout_tail_behind_frequency)
hold on
plot(session_time,bout_tail_behind_frequency_smooth,'k-','Linewidth',2)
axis([0 30 0 12])
title('bout with tail behind')
xlabel('min')
ylabel('/min')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

subplot(4,length(test),test_n)
% subplot(4,1,1)
% plot(session_time,frame_within,'o')
% hold on
plot(session_time,bout_ratio,'k-','Linewidth',2)
axis([0 30 0 0.7])
title('time close to object')
xlabel('min')
ylabel('fraction')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

subplot(4,length(test),length(test)+test_n)
% subplot(4,1,2)
plot(session_time,bout_start_frequency)
hold on
plot(session_time,bout_start_frequency_smooth,'k-','Linewidth',2)
axis([0 30 0 15])
title('approach bout frequency')
xlabel('min')
ylabel('/min')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

bout_length_smooth = smoothdata(movmax(bout_length,10),'lowess',40);
subplot(4,length(test),2*length(test)+test_n)
% subplot(4,1,3)
plot(bout_length)
hold on
plot(bout_length_smooth,'k-','Linewidth',2)
axis([0 length(bout_length) 0 25])
title('approach bout length')
xlabel('bout')
ylabel('s')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

t_bout = find(frame_within);
figure(3)
subplot(4,length(test),test_n)
plot(session_time,nose_log,'r-')
hold on
plot(session_time,tail_log,'k-')
axis([0 30 -2 0.5])
xlabel('min')
ylabel('log cm')
% legend('nose','tail')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

subplot(4,length(test),length(test)+test_n)
plot(t_bout/(15*60), bout_nose_tail)
axis([0 30 -10 10])
title('nose - tail')
xlabel('min')
ylabel('cm')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

bout_nose_smooth = smoothdata(Bout_nose,'lowess',40);
bout_tail_smooth = smoothdata(Bout_tail,'lowess',40);
subplot(4,length(test),2*length(test)+test_n)
% subplot(4,1,3)
plot(-Bout_nose,'m')
hold on
p1=plot(-bout_nose_smooth,'r-','Linewidth',2);
plot(-Bout_tail,'c')
hold on
p2=plot(-bout_tail_smooth,'b-','Linewidth',2);
axis([0 length(Bout_nose) -15 0])
% legend([p1,p2],{'nose','tail'});
title('closest from object')
xlabel('bout')
ylabel('cm')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')


bin = 15*60; %1 min
binN = floor(size(Labels,1)/bin);
ratio_nose_tail = [];p_nose_tail = [];
for i = 1:binN
    frame_within_bin = (0.15*Labels((bin*(i-1)+1):bin*i,32)<object_threshold |...
        0.15*Labels((bin*(i-1)+1):bin*i,34)<object_threshold); %nose or tail is close
    nose_bin = 0.15*(Labels(bin*(i-1)+find(frame_within_bin),32));
    tail_bin = 0.15*(Labels(bin*(i-1)+find(frame_within_bin),34));
    ind = find(nose_bin>tail_bin); %tail is closer
    ratio_nose_tail = [ratio_nose_tail,length(ind)/length(frame_within_bin)];    
end

subplot(4,length(test),3*length(test)+test_n)
% subplot(4,1,4)
plot(ratio_nose_tail,'k-','Linewidth',2)
axis([0 30 0 0.5])
title('tail exposure')
xlabel('min')
ylabel('fraction tail closer')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

% figure
% subplot(1,2,1)
% imagesc(-Bout_nose_all,[-20 0])
% colormap yellowblue
% xlabel('time - water (ms)');
% h=gca;
% h.XTick = 0:100:200;
% h.XTickLabel = 0:0.1:0.2;
% ylabel('bout')
% h.YTick = [];
% h.YTickLabel = {};
% title('nose')
% colorbar
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')
% 
% subplot(1,2,2)
% imagesc(-Bout_tail_all,[-20 0])
% colormap yellowblue
% xlabel('time - water (s)');
% h=gca;
% h.XTick = 0:100:200;
% h.XTickLabel = 0:0.1:0.2;
% h.YTick = [];
% h.YTickLabel = {};
% title('tail')
% colorbar
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')

%% body stretch

% Bout_body_length = [];
% for i = 1:length(bout_end)
% %     bout_body_length = max(0.15*Labels(bout_start(i):bout_end(i),35));
%     bout_body_length = mean(0.15*Labels(bout_start(i):bout_end(i),35));
%     Bout_body_length = [Bout_body_length,bout_body_length];
% end
% 
% body_length_smooth = smoothdata(Bout_body_length,'lowess',4000,'SamplePoints',bout_start);
% figure
% plot(t_bout/(15*60),0.15*Labels(frame_within,35))
% hold on
% plot(bout_start/(15*60),body_length_smooth,'k-','Linewidth',2);
% title('body length in bouts')
% xlabel('min')
% ylabel('cm')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')
% 
% %% speed related to object
% 
% head_speed_object_smooth = movmean(15*0.15*Labels(:,36),4000);
% head_speed_lateral_smooth = movmean(15*0.15*Labels(:,37),4000);
% figure
% plot(session_time,head_speed_object_smooth,'r-')
% hold on
% plot(session_time,head_speed_lateral_smooth,'k-')
% legend('toward/away from','lateral')
% title('head speed related to object')
% xlabel('min')
% ylabel('cm/s')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')
% 
% %% distance from wall
% 
% tail_wall_smooth = smoothdata(0.15*Labels(:,38),'lowess',4000);
% figure
% plot(session_time,0.15*Labels(:,38))
% hold on
% plot(session_time,tail_wall_smooth,'k-','Linewidth',2)
% title('tail from wall')
% xlabel('min')
% ylabel('cm')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')

end
end


end
