function video_novelty_multi_labels_2011

%this is similar to video_Operant_multi_labels_2010, but for novelty in
%Korleki's rig
%to save 'Labels'
%uncomment line119 'close all' when run many

cd('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior');
[animal_info,text,raw] = xlsread('akiti_miceID_210318.xlsx');
animal = text(2:end,3);
condition = text(2:end,9);
% ind = (find(animal_info(:,2)>0)); %2 for all
% animal_info = animal_info(ind,:); %skip blank
% animal_info = sortrows(animal_info,2,'descend'); %animal is ordered by Bregma
% animal = animal(animal_info(:,1));
% condition = condition(animal_info(:,1));

% animal_stim = find(strcmp(condition,'stimulus'));
% animal_contex = find(strcmp(condition,'contextual'));
% animal_saline = find(strcmp(condition,'saline'));
% animal_6OHDA = find(strcmp(condition,'6OHDA'));

test = {'hab1','hab2','novel1','novel2','novel3','novel4','novel5','novel6'};

group = {'stimulus','contextual','saline','6OHDA','FP_all'};
% group = {'Capoeira','Planets'};
% animal = {'Air','Avatar','Earth','Fire','Water'};
% % animal = {'Jupiter_6OHDA','Mars_6OHDA','Neptune_6OHDA','Pluto_6OHDA','Uranus_6OHDA','Venus_6OHDA',...
% %     'Earth_saline','Mercury_saline','Saturn_saline'};
% animal = {'Au_stim','Ginga_stim','Negativa_stim','Esquiva_cont','MeiaLua_cont','Queixada_cont'};
group_n = 4;
groupfolder = strcat('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior/',group{group_n});
% groupfolder = strcat('/Users/mitsukouchida/Desktop/Korleki/',group{group_n});
cd(groupfolder);

Ratio_skip_nose = [];Ratio_skip_tailB = [];

% for animal_n = 1:length(animal)
% for animal_n = 5
% for animal_n = find(contains(animal,'DAsensor'))  
% for animal_n = find(contains(animal,'GFP'))
% for animal_n = find(strcmp(condition,stimulus_FP))'
for animal_n = find(strcmp(condition,group{group_n}))'
%     animal_n
    animal{animal_n}
    animalfolder = strcat(groupfolder,'/',animal{animal_n});
    cd(animalfolder);
    load('Arena_Obj_Pos','obj_center','arena') %xy positions of object, arena

for test_n = 3
% for test_n = 1:5
% for test_n = 1:length(test)
        cd(animalfolder);
      cd(test{test_n});
      test{test_n}

filename = dir('*DeepCut_*.csv');

if length(filename)>0
  filename.name  
  Labels = csvread(filename.name,3,0);
  
  ind = find(Labels(:,4)>0.1,1,'first'); %likelihood is >10%
  Labels = Labels(ind:end,:);
  session_start = ind;

%% check quality of labeling

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

diff_nose = sqrt(diff(Labels(:,2)').^2 + diff(Labels(:,3)').^2);
diff_earL = sqrt(diff(Labels(:,5)').^2 + diff(Labels(:,6)').^2);
diff_earR = sqrt(diff(Labels(:,8)').^2 + diff(Labels(:,9)').^2);
diff_tailB = sqrt(diff(Labels(:,11)').^2 + diff(Labels(:,12)').^2);

figure
subplot(2,2,1)
plot(diff_nose)
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)

subplot(2,2,3)
histogram(diff_nose)
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)

subplot(1,2,2)
plot(Labels(1:10:end,2),Labels(1:10:end,3))
title('nose position')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

% figure
% subplot(2,2,1)
% plot(diff_earL)
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% 
% subplot(2,2,3)
% histogram(diff_earL)
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% 
% subplot(1,2,2)
% plot(Labels(1:10:end,5),Labels(1:10:end,6))
% title('left ear position')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')

% figure
% subplot(2,2,1)
% plot(diff_earR)
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% 
% subplot(2,2,3)
% histogram(diff_earR)
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% 
% subplot(1,2,2)
% plot(Labels(1:10:end,8),Labels(1:10:end,9))
% title('right ear position')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')

figure
subplot(2,2,1)
plot(diff_tailB)
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)

subplot(2,2,3)
histogram(diff_tailB)
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)

subplot(1,2,2)
plot(Labels(1:10:end,11),Labels(1:10:end,12))
title('tail base position')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

%% fill jump of tracking

cut=100; %100 is 15cm/frame,225cm/s for operant box still big
like=0.1; %cut for likelihood

ind = find(diff_nose>cut|Labels(2:end,4)'<=like);
% ind = find(Labels(2:end,4)'<=like); 
length_skip_nose = length(ind)
ratio_skip_nose = length(ind)/size(Labels,1);
Ratio_skip_nose = [Ratio_skip_nose,ratio_skip_nose];
OKtrial=0;
for i = 1:length(ind)
    if ind(i)>=OKtrial %Labels(ind(i),:)is good, Labels(ind(i)+1,:)is bad
    distance_this = sqrt((Labels(:,2)-Labels(ind(i),2)).^2 + (Labels(:,3)-Labels(ind(i),3)).^2);
    nextOK = find(distance_this((ind(i)+1):end)<cut&Labels((ind(i)+1):end,4)>like,1,'first'); 
    if nextOK>50 %Labels(ind(i),:)is bad
        if i>1 
        Labels(ind(i),2) = mean([Labels(ind(i)-1,2),Labels(ind(i)+1,2)]);
        Labels(ind(i),3) = mean([Labels(ind(i)-1,3),Labels(ind(i)+1,3)]);
        else
           Labels(ind(i),2) = Labels(ind(i)+1,2);
           Labels(ind(i),3) = Labels(ind(i)+1,3);
        end
           OKtrial = ind(i)+1;
    else
    Labels(ind(i)+(1:(nextOK-1)),2) = mean([Labels(ind(i),2),Labels(ind(i)+nextOK,2)]);
    Labels(ind(i)+(1:(nextOK-1)),3) = mean([Labels(ind(i),3),Labels(ind(i)+nextOK,3)]);
    OKtrial = ind(i)+nextOK; 
    end
    diff_nose = sqrt(diff(Labels(:,2)').^2 + diff(Labels(:,3)').^2);   
    end
end

ind_nose_error = find(diff_nose>cut)

ind = find(diff_earL>cut|Labels(2:end,7)'<=like);
% ind = find(Labels(2:end,7)'<=like); 
% length_skip_earL = length(ind)
% ratio_skip_earL = length(ind)/size(Labels,1);
% Ratio_skip_earL = [Ratio_skip_earL,ratio_skip_earL];
OKtrial=0;
for i = 1:length(ind)
    if ind(i)>=OKtrial %Labels(ind(i),:)is good, Labels(ind(i)+1,:)is bad
    distance_this = sqrt((Labels(:,5)-Labels(ind(i),5)).^2 + (Labels(:,6)-Labels(ind(i),6)).^2);
    nextOK = find(distance_this((ind(i)+1):end)<cut&Labels((ind(i)+1):end,7)>like,1,'first'); 
    if nextOK>50 %Labels(ind(i),:)is bad
        if i>1 
        Labels(ind(i),5) = mean([Labels(ind(i)-1,5),Labels(ind(i)+1,5)]);
        Labels(ind(i),6) = mean([Labels(ind(i)-1,6),Labels(ind(i)+1,6)]);
        else
           Labels(ind(i),5) = Labels(ind(i)+1,5);
           Labels(ind(i),6) = Labels(ind(i)+1,6);
        end
           OKtrial = ind(i)+1;
    else
    Labels(ind(i)+(1:(nextOK-1)),5) = mean([Labels(ind(i),5),Labels(ind(i)+nextOK,5)]);
    Labels(ind(i)+(1:(nextOK-1)),6) = mean([Labels(ind(i),6),Labels(ind(i)+nextOK,6)]);
    OKtrial = ind(i)+nextOK; 
    end
    diff_earL = sqrt(diff(Labels(:,5)').^2 + diff(Labels(:,6)').^2);   
    end
end
ind_earL_error = find(diff_earL>cut)

ind = find(diff_earR>cut|Labels(2:end,10)'<=like);
% ind = find(Labels(2:end,10)'<=like); 
% length_skip_earR = length(ind)
% ratio_skip_earR = length(ind)/size(Labels,1);
% Ratio_skip_earR = [Ratio_skip_earR,ratio_skip_earR];
OKtrial=0;
for i = 1:length(ind)
    if ind(i)>=OKtrial %Labels(ind(i),:)is good, Labels(ind(i)+1,:)is bad
    distance_this = sqrt((Labels(:,8)-Labels(ind(i),8)).^2 + (Labels(:,9)-Labels(ind(i),9)).^2);
    nextOK = find(distance_this((ind(i)+1):end)<cut&Labels((ind(i)+1):end,10)>like,1,'first'); 
    if nextOK>50 %Labels(ind(i),:)is bad
        if i>1 
        Labels(ind(i),8) = mean([Labels(ind(i)-1,8),Labels(ind(i)+1,8)]);
        Labels(ind(i),9) = mean([Labels(ind(i)-1,9),Labels(ind(i)+1,9)]);
        else
           Labels(ind(i),8) = Labels(ind(i)+1,8);
           Labels(ind(i),9) = Labels(ind(i)+1,9);
        end
           OKtrial = ind(i)+1;
    else
    Labels(ind(i)+(1:(nextOK-1)),8) = mean([Labels(ind(i),8),Labels(ind(i)+nextOK,8)]);
    Labels(ind(i)+(1:(nextOK-1)),9) = mean([Labels(ind(i),9),Labels(ind(i)+nextOK,9)]);
    OKtrial = ind(i)+nextOK; 
    end
    diff_earR = sqrt(diff(Labels(:,8)').^2 + diff(Labels(:,9)').^2);   
    end
end
ind_earR_error = find(diff_earR>cut)

ind = find(diff_tailB>cut|Labels(2:end,13)'<=like);
% ind = find(Labels(2:end,13)'<=like); 
length_skip_tailB = length(ind)
ratio_skip_tailB = length(ind)/size(Labels,1);
Ratio_skip_tailB = [Ratio_skip_tailB,ratio_skip_tailB];
OKtrial=0;
for i = 1:length(ind)
    if ind(i)>=OKtrial %Labels(ind(i),:)is good, Labels(ind(i)+1,:)is bad
    distance_this = sqrt((Labels(:,11)-Labels(ind(i),11)).^2 + (Labels(:,3)-Labels(ind(i),12)).^2);
    nextOK = find(distance_this((ind(i)+1):end)<cut&Labels((ind(i)+1):end,13)>like,1,'first'); 
    if nextOK>50 %Labels(ind(i),:)is bad
        if i>1 
        Labels(ind(i),11) = mean([Labels(ind(i)-1,11),Labels(ind(i)+1,11)]);
        Labels(ind(i),12) = mean([Labels(ind(i)-1,12),Labels(ind(i)+1,12)]);
        else
           Labels(ind(i),11) = Labels(ind(i)+1,11);
           Labels(ind(i),12) = Labels(ind(i)+1,12);
        end
           OKtrial = ind(i)+1;
    else
    Labels(ind(i)+(1:(nextOK-1)),11) = mean([Labels(ind(i),11),Labels(ind(i)+nextOK,11)]);
    Labels(ind(i)+(1:(nextOK-1)),12) = mean([Labels(ind(i),12),Labels(ind(i)+nextOK,12)]);
    OKtrial = ind(i)+nextOK; 
    end
    diff_tailB = sqrt(diff(Labels(:,11)').^2 + diff(Labels(:,12)').^2);   
    end
end
ind_tailB_error = find(diff_tailB>cut)


%% smooth

for i = [2,3,5,6,8,9,11,12]
Labels(:,i) = smooth(Labels(:,i)')';
end

Labels(:,14:19) = 0; %fill the blank

Labels(:,20) = mean(Labels(:,[2,5,8]),2); %head
Labels(:,21) = mean(Labels(:,[3,6,9]),2);
Labels(:,22) = mean(Labels(:,[20,11]),2); %body
Labels(:,23) = mean(Labels(:,[21,12]),2);

Labels(:,24:25) = 0;

figure
subplot(1,2,1)
plot(Labels(1:10:end,2),Labels(1:10:end,3))
title('nose')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)

subplot(1,2,2)
plot(Labels(1:10:end,11),Labels(1:10:end,12))
title('tail')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')


% subplot(1,5,2)
% plot(Labels(1:10:end,5),Labels(1:10:end,6))
% title('ear')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% 
% subplot(1,5,3)
% plot(Labels(1:10:end,8),Labels(1:10:end,9))
% title('ear')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% 
% subplot(1,5,4)
% plot(Labels(1:10:end,20),Labels(1:10:end,21))
% title('head')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% 
% subplot(1,5,5)
% plot(Labels(1:10:end,22),Labels(1:10:end,23))
% title('body')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% velocity and accelaration

%head
velocityX = diff(Labels(:,20)); 
velocityX = [smooth(velocityX);0]; %x velocity
velocityY = diff(Labels(:,21)); 
velocityY = [smooth(velocityY);0]; %y velocity
% velocityX = [diff(Labels(:,20));0]; %x velocity
% velocityY = [diff(Labels(:,21));0]; %Y velocity
Labels(:,26) = sqrt(velocityX.^2 + velocityY.^2); %speed
accelX = [diff(velocityX);0]; %x acceleration
accelY = [diff(velocityY);0]; %y acceleration
Labels(:,27) = sqrt(accelX.^2 + accelY.^2); %acceleration
jerkX = [diff(accelX);0]; %x jerk
jerkY = [diff(accelY);0]; %y jerk
Labels(:,28) = sqrt(jerkX.^2 + jerkY.^2); %jerk

%body
velocityX = diff(Labels(:,22)); 
velocityX = [smooth(velocityX);0]; %x velocity
velocityY = diff(Labels(:,23)); 
velocityY = [smooth(velocityY);0]; %y velocity
% velocityX = [diff(Labels(:,20));0]; %x velocity
% velocityY = [diff(Labels(:,21));0]; %Y velocity
Labels(:,29) = sqrt(velocityX.^2 + velocityY.^2); %speed
accelX = [diff(velocityX);0]; %x acceleration
accelY = [diff(velocityY);0]; %y acceleration
Labels(:,30) = sqrt(accelX.^2 + accelY.^2); %acceleration
jerkX = [diff(accelX);0]; %x jerk
jerkY = [diff(accelY);0]; %y jerk
Labels(:,31) = sqrt(jerkX.^2 + jerkY.^2); %jerk

for i = 26:31
Labels(:,i) = smooth(Labels(:,i)')';
end

session_time = ((1:size(Labels,1))/15)/60; %min
head_speed_smooth = movmean(15*0.15*Labels(:,26),4000);
body_speed_smooth = movmean(15*0.15*Labels(:,29),4000);
figure
% subplot(2,2,1)
% plot(15*0.15*Labels(:,26))
% xlabel('time')
% ylabel('cm/s')
% title('head speed')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)

subplot(2,1,1)
plot(session_time,head_speed_smooth)
xlabel('min')
ylabel('cm/s')
title('head speed')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

% subplot(2,2,3)
% plot(15*0.15*Labels(:,29))
% xlabel('time')
% ylabel('cm/s')
% title('body speed')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)

subplot(2,1,2)
plot(session_time,body_speed_smooth)
xlabel('min')
ylabel('cm/s')
title('body speed')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

% subplot(2,3,2)
% plot(Labels(:,27))
% title('head acceleration')
% subplot(2,3,3)
% plot(Labels(:,28))
% title('head jerk')
% subplot(2,3,4)
% histogram(Labels(:,26))
% subplot(2,3,5)
% histogram(Labels(:,27))
% subplot(2,3,6)
% histogram(Labels(:,28))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% noramlized with object position

nose_baselineX = obj_center(test_n,1);
nose_baselineY = obj_center(test_n,2);

i = [2,5,8,11,14,17,20,22,24];
Labels(:,i) = Labels(:,i)-nose_baselineX;
i = [3,6,9,12,15,19,21,23,25];
Labels(:,i) = Labels(:,i)-nose_baselineY;

figure
subplot(1,2,1)
plot(0.15*Labels(1:10:end,20),0.15*Labels(1:10:end,21))
xlabel('cm')
ylabel('cm')
title('head')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)

subplot(1,2,2)
plot(0.15*Labels(1:10:end,11),0.15*Labels(1:10:end,12))
xlabel('cm')
ylabel('cm')
title('tail')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

figure
subplot(1,2,1)
plot(0.15*Labels(1:(10*60*15),20),0.15*Labels(1:(10*60*15),21)) %first 10min
xlabel('cm')
ylabel('cm')
title('head first 10 min')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)

subplot(1,2,2)
plot(0.15*Labels((end-10*60*15+1):end,20),0.15*Labels((end-10*60*15+1):end,21)) %last 10 min
xlabel('cm')
ylabel('cm')
title('head last 10 min')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

noseX = Labels(:,2);
noseY = Labels(:,3);
Labels(:,32) = sqrt(noseX.^2 + noseY.^2); %nose position from object
headX = Labels(:,20);
headY = Labels(:,21);
Labels(:,33) = sqrt(headX.^2 + headY.^2); %head position from object
bodyX = Labels(:,11);
bodyY = Labels(:,12);
Labels(:,34) = sqrt(bodyX.^2 + bodyY.^2); %tailstem position from object

nose_log = -log10(0.15*Labels(:,32));
nose_log(find(nose_log>0.5))=0.5;
figure
subplot(3,1,1)
plot(session_time,nose_log,'r-')
xlabel('min')
ylabel('log cm')
title('nose from object')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)

tail_log = -log10(0.15*Labels(:,34));
tail_log(find(tail_log>0.5))=0.5;
subplot(3,1,2)
plot(session_time,tail_log,'k-')
xlabel('min')
ylabel('log cm')
title('tail from object')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)

subplot(3,1,3)
plot(session_time,nose_log,'r-')
hold on
plot(session_time,tail_log,'k-')
xlabel('min')
ylabel('log cm')
% title('distance from object')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

nose_close = movmin(0.15*Labels(:,32),1000);
tail_close = movmin(0.15*Labels(:,34),1000);
nose_close_log = -log10(nose_close);
nose_close_log(find(nose_close_log>0.5))=0.5;
tail_close_log = -log10(tail_close);
tail_close_log(find(tail_close_log>0.5))=0.5;
nose_smooth = smoothdata(nose_close_log,'lowess',4000); %movemean,lowess, rlowess, loess
tail_smooth = smoothdata(tail_close_log,'lowess',4000);

figure
subplot(4,1,1)
plot(session_time,nose_close_log,'r-')
hold on
plot(session_time,nose_smooth,'m-','Linewidth',2)
xlabel('min')
ylabel('log cm')
title('nose closest from object')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)

subplot(4,1,2)
plot(session_time,tail_close_log,'k-')
hold on
plot(session_time,tail_smooth,'g-','Linewidth',2)
xlabel('min')
ylabel('log cm')
title('tail closest from object')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)

subplot(4,1,3)
plot(session_time,nose_smooth,'m-','Linewidth',2)
hold on
plot(session_time,tail_smooth,'g-','Linewidth',2)
xlabel('min')
ylabel('log cm')
title('closest from object')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

nose_tail = smoothdata((nose_close - tail_close),'lowess',4000);
% figure
% subplot(2,1,1)
% plot(session_time,0.15*Labels(:,32)-0.15*Labels(:,34),'b-')
% xlabel('min')
% ylabel('cm')
% title('nose - tail')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)

subplot(4,1,4)
plot(session_time,nose_tail,'k-','Linewidth',2)
xlabel('min')
ylabel('cm')
title('nose - tail closest')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

%% approach-retreat bouts

object_threshold = 7;

frame_within = (0.15*Labels(:,32)<object_threshold | 0.15*Labels(:,34)<object_threshold); %nose or tail is close
bout_start = 1+find(diff(frame_within)==1);
bout_end = 1+find(diff(frame_within)==-1);
if frame_within(1)==1
    bout_end = bout_end(2:end);
end    
if length(bout_end)<length(bout_start)
    bout_start = bout_start(1:end-1);
end


figure
subplot(1,2,1)
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
        
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)

subplot(1,2,2)
if length(bout_end)>=20
for i = (length(bout_end)-19):length(bout_end)
    nose_x = 0.15*Labels(bout_start(i):bout_end(i),2);
    nose_y = 0.15*Labels(bout_start(i):bout_end(i),3);
    tail_x = 0.15*Labels(bout_start(i):bout_end(i),11);
    tail_y = 0.15*Labels(bout_start(i):bout_end(i),12);
    plot(nose_x,nose_y,'r-')
    hold on
    plot(tail_x,tail_y,'k-')
    legend('nose','tail')
    xlabel('cm')
    ylabel('cm')
    title('late bouts')
end
end
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

bout_length = (bout_end - bout_start)/15;
bout_frequency = zeros(1,size(Labels,1));
bout_frequency(bout_start) = 1;
bout_start_frequency = movsum(bout_frequency,900); %900 frame, 60s, 1min
bout_start_frequency_smooth = smoothdata(bout_start_frequency,'lowess',4000);
% bout_ratio = movmean(frame_within,4000);
bout_ratio = smoothdata(frame_within,'lowess',4000);
Bout_tail = [];Bout_nose = [];t_bout_tail_behind = [];
for i = 1:length(bout_end)
    bout_tail = min(0.15*Labels(bout_start(i):bout_end(i),34));
    Bout_tail = [Bout_tail,bout_tail];
    bout_nose = min(0.15*Labels(bout_start(i):bout_end(i),32));
    Bout_nose = [Bout_nose,bout_nose];
    bout_nose_tail = 0.15*Labels(bout_start(i):bout_end(i),32) - 0.15*Labels(bout_start(i):bout_end(i),34);
    if max(bout_nose_tail)<0
    t_bout_tail_behind = [t_bout_tail_behind,bout_start(i)];
    end
end
bout_nose_tail = 0.15*(Labels(find(frame_within),32) - Labels(find(frame_within),34));
bout_nose_tail_closest = Bout_nose - Bout_tail;
bout_tail_behind = zeros(1,size(Labels,1));
bout_tail_behind(t_bout_tail_behind) = 1;
bout_tail_behind_frequency = movsum(bout_tail_behind,900); %900 frame, 60s, 1min
bout_tail_behind_frequency_smooth = smoothdata(bout_tail_behind_frequency,'lowess',4000);

figure
plot(session_time, bout_tail_behind_frequency)
hold on
plot(session_time,bout_tail_behind_frequency_smooth,'k-','Linewidth',2)
title('bout with tail behind')
xlabel('min')
ylabel('/min')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')


figure
subplot(1,3,1)
% plot(session_time,frame_within,'o')
% hold on
plot(session_time,bout_ratio,'k-','Linewidth',2)
title('time close to object')
xlabel('min')
ylabel('fraction')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,2)
plot(session_time,bout_start_frequency)
hold on
plot(session_time,bout_start_frequency_smooth,'k-','Linewidth',2)
title('approach bout frequency')
xlabel('min')
ylabel('/min')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)

bout_length_smooth = smoothdata(movmax(bout_length,10),'lowess',40);
subplot(1,3,3)
plot(bout_length)
hold on
plot(bout_length_smooth,'k-','Linewidth',2)
title('approach bout length')
xlabel('bout')
ylabel('s')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

t_bout = find(frame_within);
figure
subplot(3,1,1)
plot(t_bout/(15*60), bout_nose_tail)
title('nose - tail')
xlabel('min')
ylabel('cm')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)

% bout_nose_tail_max = movmax(bout_nose_tail,500);
% bout_nose_tail_smooth = smoothdata(bout_nose_tail_max,'lowess',2000,'SamplePoints',t_bout);
% subplot(3,1,2)
% plot(t_bout/(15*60), bout_nose_tail)
% hold on
% plot(t_bout/(15*60), bout_nose_tail_smooth,'k-','Linewidth',2)
% title('nose - tail')
% xlabel('min')
% ylabel('cm')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)

bout_nose_smooth = smoothdata(Bout_nose,'lowess',40);
subplot(3,1,2)
plot(-Bout_nose,'m')
hold on
p1=plot(-bout_nose_smooth,'r-','Linewidth',2);
% title('nose from object')
xlabel('bout')
ylabel('cm')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)

bout_tail_smooth = smoothdata(Bout_tail,'lowess',40);
% subplot(4,1,3)
plot(-Bout_tail,'c')
hold on
p2=plot(-bout_tail_smooth,'b-','Linewidth',2);
legend([p1,p2],{'nose','tail'});
title('closest from object')
xlabel('bout')
ylabel('cm')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

% bout_nose_tail_closest_smooth = smoothdata(bout_nose_tail_closest,'lowess',40);
% subplot(4,1,4)
% plot(bout_nose_tail_closest)
% hold on
% plot(bout_nose_tail_closest_smooth,'k-','Linewidth',2)
% title('nose - tail closest')
% xlabel('bout')
% ylabel('cm')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')

%bout_nose_tail = 0.15*(Labels(find(frame_within),32) - Labels(find(frame_within),34));
% nose_within = 0.15*(Labels(frame_within,32));
% tail_within = 0.15*(Labels(frame_within,34));
% bin = 500;
% binN = floor(length(find(frame_within))/bin);
% bout_nose_bin = reshape(nose_within(1:(bin*binN)),binN,bin);
% bout_tail_bin = reshape(tail_within(1:(bin*binN)),binN,bin);
% p_nose_tail = [];
% for i = 1:binN
%     [h,p]=ttest(bout_nose_bin(i,:),bout_tail_bin(i,:));
%     p_nose_tail = [p_nose_tail,p];
% end

% bin = 20;
% binN = floor(length(Bout_nose)/bin);
% bout_nose_bin = reshape(Bout_nose(1:(bin*binN)),binN,bin);
% bout_tail_bin = reshape(Bout_tail(1:(bin*binN)),binN,bin);
% p_nose_tail = [];
% for i = 1:binN
%     [h,p]=ttest(bout_nose_bin(i,:),bout_tail_bin(i,:));
%     p_nose_tail = [p_nose_tail,p];
% end


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

subplot(3,1,3)
plot(ratio_nose_tail,'k-','Linewidth',2)
title('tail exposure')
xlabel('min')
ylabel('fraction tail closer')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

%% body stretch

Labels(:,35) = sqrt((Labels(:,2) - Labels(:,11)).^2 + (Labels(:,3) - Labels(:,12)).^2);
Labels(:,35) = smooth(Labels(:,35)')';

Bout_body_length = [];
for i = 1:length(bout_end)
    bout_body_length = max(0.15*Labels(bout_start(i):bout_end(i),35));
    Bout_body_length = [Bout_body_length,bout_body_length];
end

% figure
% plot(t_bout/(15*60),0.15*Labels(frame_within,35))
% title('body length in bouts')
% xlabel('min')
% ylabel('cm')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')
% 
% figure
% plot(bout_start,Bout_body_length)
% title('max body length in bouts')
% xlabel('min')
% ylabel('cm')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')

%% speed related to object

Labels(:,36) = [sqrt(diff(Labels(:,33)).^2);0]; %movement toward or away from object
Labels(:,36) = smooth(Labels(:,36)')';
Labels(:,37) = sqrt(Labels(:,26).^2 - Labels(:,36).^2); %lateral movement related to object
Labels(:,37) = smooth(Labels(:,37)')';

head_speed_object_smooth = movmean(15*0.15*Labels(:,36),4000);
head_speed_lateral_smooth = movmean(15*0.15*Labels(:,37),4000);
figure
plot(session_time,head_speed_object_smooth,'r-')
hold on
plot(session_time,head_speed_lateral_smooth,'k-')
legend('toward/away from','lateral')
title('head speed related to object')
xlabel('min')
ylabel('cm/s')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

%% distance from wall

wall_x1 = arena(test_n,1) - nose_baselineX;
wall_y1 = arena(test_n,2) - nose_baselineY;
wall_x2 = arena(test_n,3) - nose_baselineX;
wall_y2 = arena(test_n,4) - nose_baselineY;

Labels(:,38) = min([abs(Labels(:,11) - wall_x1),abs(Labels(:,11) - wall_x2),...
    abs(Labels(:,12) - wall_y1),abs(Labels(:,12) - wall_y2)],[],2); %tail base from wall
Labels(:,38) = smooth(Labels(:,38)')';

tail_wall_smooth = smoothdata(0.15*Labels(:,38),'lowess',4000);
figure
plot(session_time,0.15*Labels(:,38))
hold on
plot(session_time,tail_wall_smooth,'k-','Linewidth',2)
title('tail from wall')
xlabel('min')
ylabel('cm')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

close all

% save ('DLC_label','Labels','session_start')
end
end


end

mean_skip = 100*mean(Ratio_skip_nose);
std_skip = 100*std(Ratio_skip_nose)/sqrt(length(Ratio_skip_nose));
figure
subplot(1,2,1)
boxplot(100*Ratio_skip_nose)
h=gca;
h.XTick = 1;
h.XTickLabel = {'% filled frame nose'};
title({mean_skip,std_skip})
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

mean_skip = 100*mean(Ratio_skip_tailB);
std_skip = 100*std(Ratio_skip_tailB)/sqrt(length(Ratio_skip_tailB));
subplot(1,2,2)
boxplot(100*Ratio_skip_tailB)
h=gca;
h.XTick = 1;
h.XTickLabel = {'% filled frame tailB'};
title({mean_skip,std_skip})
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

