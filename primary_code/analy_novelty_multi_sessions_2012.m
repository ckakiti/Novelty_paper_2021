%% analy_novelty_multi_sessions_2012.m
%  this code creates line plots for Figure 2 (a-c) 

%  input: akiti_miceID_210318.xlsx, DLC_label.mat file for each session

%% preprocessing
clear
close all
clc

cd('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Behavior/novelty_paper_2021')
[animal_info,text,raw] = xlsread('akiti_miceID_210318.xlsx');
animal = text(2:end,3);
condition = text(2:end,9);

% test = {'hab1','hab2','novel1','novel2','novel3','novel4','novel5','novel6'};
test = {'hab1','hab2','novel1','novel2','novel3','novel4'};
session_length = 25; %min
test_chosen = 1:length(test);
test_length = length(test_chosen);
group = {'stimulus','contextual','saline','6OHDA','FP_all'};

Bout_ratio = []; Ratio_nose_tail = [];mean_nose_tail = [];std_nose_tail = [];Bout_tail_behind_frequency = [];
Bout_duration_max =[];Distance_nose=[];Tail_ratio = [];Nose_ratio = [];Frame_within=[];Bout_with_tail_frequency = [];
Tail_closer = [];
Bout_body_length=[];Body_length_bin = [];Body_length_min = [];Bout_body_length_novelty = [];Body_length_closest=[];

for group_n = 1
groupfolder = strcat('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Behavior/novelty_paper_2021/',group{group_n});
cd(groupfolder);


ind = find(strcmp(condition,group{group_n}))';
for animal_n = ind(1)
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

session_time = ((1:size(Labels,1))/15)/60; %min

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% normalized with object position

nose_log = -log10(0.15*Labels(:,32));
nose_log(find(nose_log>0.5))=0.5;

tail_log = -log10(0.15*Labels(:,34));
tail_log(find(tail_log>0.5))=0.5;


% approach-retreat bouts

object_threshold = 7;

frame_within = (0.15*Labels(:,32)<object_threshold | 0.15*Labels(:,34)<object_threshold); %nose or tail is close
bout_start = 1+find(diff(frame_within)==1);
bout_end = 1+find(diff(frame_within)==-1);
if length(bout_end)<length(bout_start)
    bout_start = bout_start(1:end-1);
end

% fig 2a
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

% fig 2b-c
t_bout = find(frame_within);
figure(2)
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

end
end


end
