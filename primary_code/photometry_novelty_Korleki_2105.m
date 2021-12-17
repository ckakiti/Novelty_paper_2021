function photometry_novelty_Korleki_2105 

% photometry novelty exploration in Korleki rig using
% 'analyze_noise_2105_novelty' for motion correction
% 'photometry_sync_every10_2105' for sync photometry and every10
% 'videosync_every10_2105' for sync video and every10
% before running this code, run 'video_novelty_multi_labels_2011' for DeepLabCut


cd('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior');
[animal_info,text,raw] = xlsread('akiti_miceID_210318.xlsx');
animal = text(2:end,3);
% animal = {'Air','Avatar','Earth','Fire','Water'};
% animal = {'Aconcagua','Denali'};
condition = text(2:end,9);
test = {'hab1','hab2','novel1','novel2','novel3','novel4'};
group = {'stimulus','contextual','saline','6OHDA','stimulus_FP','contextual_FP','GFP'};
group_n = 5;
% groupfolder = strcat('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior/',group{group_n});
groupfolder = strcat('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior/FP_all');
cd(groupfolder);
legend_name = {'retreat'};
green_range = [-5 5]; % for raster plot

% for animal_n = 1:length(animal)
% for animal_n = 55
for animal_n = find(strcmp(condition,group{group_n}))'
    animal_n
    animal{animal_n}
    animalfolder = strcat(groupfolder,'/',animal{animal_n});
    cd(animalfolder);
for test_n = 3
        cd(animalfolder);
      cd(test{test_n});
      test{test_n}

%       analyze_noise_2105_novelty; %this needs only once
%       photometry_sync_every10_2105; %this needs only once
%       videosync_every10_2105; %this needs only once
      
load('video_time.mat','video_t')
load('photometry_time_FP_data','photometry_t')
load('photometry_corrected_novelty','GCaMP_zscore')
load('DLC_label','Labels','session_start')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find events %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% approach-retreat bouts

Labels = Labels(1:30*60*15,:); %use 30 min
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
t_nose_closest_bout = video_t(nose_closest_bout); %time in event clock
for i = 1:length(t_nose_closest_bout)
    if t_nose_closest_bout(i)<photometry_t(length(GCaMP_zscore))
        nose_closest_bout_TS1 = find(photometry_t < t_nose_closest_bout(i),1,'last');
        nose_closest_bout_TS = [nose_closest_bout_TS, nose_closest_bout_TS1]; %time in photometry clock
    end
end

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
nose_closest = []; nose_closest_TS = []; nose_start_TS = []; nose_closest_tail_behind_TS =[]; nose_closest_tail_exposure_TS =[];
bout_tail = []; approach_start = []; retreat_end = []; approach_start_TS = []; retreat_end_TS = [];
for nosei = 1:length(nose_start)
    [M,I] = min(Labels(nose_start(nosei):nose_end(nosei),32));
    nose_closest_this = nose_start(nosei) + I - 1;
    nose_closest = [nose_closest,nose_closest_this];
    approach_start_this = find(diff(Labels(1:nose_closest_this,32))>0,1,'last');
    retreat_end_this = find(diff(Labels(nose_closest_this:end,32))<0,1,'first');
    retreat_end_this = nose_closest_this + retreat_end_this;
    approach_start = [approach_start,approach_start_this];
    retreat_end  = [retreat_end,retreat_end_this];
end

nose_closest = nose_closest + session_start - 1; %time in video clock
t_nose_closest = video_t(nose_closest); %time in event clock
for i = 1:length(t_nose_closest)
    if t_nose_closest(i)<photometry_t(length(GCaMP_zscore))
        nose_closest_TS1 = find(photometry_t < t_nose_closest(i),1,'last');
        nose_closest_TS = [nose_closest_TS, nose_closest_TS1]; %time in photometry clock
    end
end

approach_start = approach_start + session_start - 1; %time in video clock
t_approach_start = video_t(approach_start); %time in event clock
for i = 1:length(t_approach_start)
    if t_approach_start(i)<photometry_t(length(GCaMP_zscore))
        approach_start_TS1 = find(photometry_t < t_approach_start(i),1,'last');
        approach_start_TS = [approach_start_TS, approach_start_TS1]; %time in photometry clock
    end
end

retreat_end = retreat_end + session_start - 1; %time in video clock
t_retreat_end = video_t(retreat_end); %time in event clock
for i = 1:length(t_retreat_end)
    if t_retreat_end(i)<photometry_t(length(GCaMP_zscore))
        retreat_end_TS1 = find(photometry_t < t_retreat_end(i),1,'last');
        retreat_end_TS = [retreat_end_TS, retreat_end_TS1]; %time in photometry clock
    end
end

t_nose_start = video_t(nose_start); %time in event clock
for i = 1:length(t_nose_start)
    if t_nose_start(i)<photometry_t(length(GCaMP_zscore))
        nose_start_TS1 = find(photometry_t < t_nose_start(i),1,'last');
        nose_start_TS = [nose_start_TS, nose_start_TS1]; %time in photometry clock
    end
end

for nosei = 1:length(nose_closest_TS)
bout_nose_tail = 0.15*Labels(nose_start(nosei):nose_end(nosei),32) - 0.15*Labels(nose_start(nosei):nose_end(nosei),34);
    if max(bout_nose_tail)<0
    nose_closest_tail_behind_TS = [nose_closest_tail_behind_TS,nose_closest_TS(nosei)];
    bout_tail = [bout_tail,1];
    else
       nose_closest_tail_exposure_TS = [nose_closest_tail_exposure_TS,nose_closest_TS(nosei)]; 
       bout_tail = [bout_tail,0];
    end
end
length_tail_behind = length(nose_closest_tail_behind_TS)
length_tail_exposure = length(nose_closest_tail_exposure_TS)
length_frame_within = sum(frame_within);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make matrix of GCaMP data

clear triggerB triggerP

trigger = {nose_closest_TS'};
% trigger = {approach_start_TS'};
% trigger = {retreat_end_TS'};
% trigger = {nose_start_TS'};
% trigger = {nose_closest_tail_behind_TS'};
% trigger = {nose_closest_tail_exposure_TS'};
% trigger = {nose_closest_bout_TS'};

scrsz = get(groot,'ScreenSize');    
figure('Position',[1 scrsz(4)/1.5 scrsz(3)/1.5 scrsz(4)/1.5])
subplot(2,2,1)
% plotColors = color_select(4);
% plotColors = {'r','m','y','g','c','k'};
% plotColors = colormap(parula(7));
% plotColors = {plotColors(7,:),plotColors(6,:),plotColors(5,:),plotColors(4,:),plotColors(3,:),plotColors(2,:),plotColors(1,:)};
% plotColors = {[0,0,0.2],[0,0,0.5],[0,0,1],[1,0,0],[0,0.2,0],[0,0.5,0],[0,1,0]};
plotColors = {[0,0,0.2],[0,0,0.5],[0,0,1],[0,0.2,0],[0,0.5,0],[0,1,0]};
% plotdata = tdTom;
% plotdata = GCaMP;
plotdata = GCaMP_zscore;
plotWin = -3000:3000;
responseWin = 3001:4000;  %choose response time, 2000 is trigger
M_plot = [];
DeltaF = [];
Trial_number = [];
Response = [];
for i = 1:length(trigger)
    ts = round(trigger{i});
    if ~exist('triggerB')
        triggerB = trigger;
    end
    tsB = round(triggerB{i});

    ind = find( tsB+ plotWin(1)>0,1,'first');
    ind2 = find( ts+ plotWin(end)< length(plotdata),1,'last');
    ts = ts(ind:ind2);
    plotind = bsxfun(@plus, repmat(plotWin,length(ts),1),ts);
    rawTrace = plotdata(plotind);
    
    tsB = tsB(ind:ind2);
    plotind = bsxfun(@plus, repmat(plotWin,length(ts),1),tsB);
    rawTraceB = plotdata(plotind);  
        
    F = mean(rawTraceB(:,1:2000),2);        %using this time window in plotwin for baseline
     deltaF = bsxfun(@minus,rawTrace,F);
%     deltaF = bsxfun(@minus,rawTrace,F)/2.5;
%     deltaF = bsxfun(@rdivide,rawTrace,F);
% deltaF = 100*deltaF/F_mean;
% deltaF = 100*deltaF;

%remove outlier  %do not use to save data
% mean_intensity = mean(deltaF(:,:)');
% mean_mean_intensity = mean(mean_intensity);
% std_intensity = std(mean_intensity);
% remove_outlier = find(mean_intensity<mean_mean_intensity+3*std_intensity & ...
%     mean_intensity>mean_mean_intensity-3*std_intensity);
% % remove_outlier = find(mean_intensity>-0.06);  
% if size(deltaF,1)>length(remove_outlier)
% outlier_green = size(deltaF,1)-length(remove_outlier)
% deltaF = deltaF(remove_outlier,:);
% end

      m_plot = mean(deltaF);
%      m_plot = mean(deltaF(end-20:end,:));
%      m_plot = deltaF(6,:);
    s_plot = std(deltaF)/sqrt(length(ts));
%     errorbar_patch(plotWin,m_plot,s_plot,plotColors(i,:));
errorbar_patch(plotWin,m_plot,s_plot,plotColors{i});
M_plot = [M_plot; m_plot];

DeltaF = [DeltaF;deltaF];
Trial_number = [Trial_number size(deltaF,1)];
response = deltaF(:,responseWin);
Response{i} =  mean(response');
end
axis([-3000 3000 -1 4])
% legend(legend_name)
xlabel('time - retreat start (ms)')
% ylabel('dF/F (%)')
ylabel('zscore')
title('DA sensor')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')


subplot(2,2,3)
% boxplot([Response{1},Response{2},Response{3},Response{4},Response{5},Response{6}],...
%     [ones(1,length(Response{1})), 2*ones(1,length(Response{2})),3*ones(1,length(Response{3})),...
%     4*ones(1,length(Response{4})),5*ones(1,length(Response{5})),6*ones(1,length(Response{6}))])
boxplot(Response{1})
% title(animal{animal_n})
ylabel('response (0-1s)')
h=gca;
h.XTickLabel = legend_name;
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% raster plot green

subplot(1,2,2)
%1) bin the data
trialNum = size(DeltaF,1); binSize = 100;
length_x = plotWin(end)-plotWin(1);
binedF = squeeze(mean(reshape(DeltaF(:,1:length_x),trialNum, binSize,[]),2));
imagesc(binedF,green_range);
% imagesc(binedF);
colormap yellowblue
xlabel('time - retreat (s)');
ylabel('trials')
h=gca;
h.XTick = 0:10:(length_x/binSize);
h.XTickLabel = {(plotWin(1)/1000):(plotWin(end)/1000)};
h.YTickLabel = {};
title(animal{animal_n})
hold on;

% 2) plot the triggers
% % mark triggerP
% for k = 1:trialNum;
% % x = [(Tmark(k)-plotWin(1))/binSize (Tmark(k)-plotWin(1))/binSize]; % odor timing
% x = [(Tmark(k)-plotWin(1)+water_delay)/binSize (Tmark(k)-plotWin(1)+water_delay)/binSize]; %water timing
% y = [k-0.5 k+0.5];
% plot(x,y,'c')
% end

% mark trigger
% x2 = [(-plotWin(1)+1000)/binSize (-plotWin(1)+1000)/binSize];%water
x2 = [-plotWin(1)/binSize -plotWin(1)/binSize]; % odor
plot(x2,[0 trialNum+0.5],'r','Linewidth',1.5)

% divide trigger
for j = 1:length(Trial_number)-1  
     plot([0 length_x/binSize],[sum(Trial_number(1:j))+0.5 sum(Trial_number(1:j))+0.5],'m','Linewidth',1.5)   
end
colorbar
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

% cd(animalfolder);
% save_name = strcat(animal{animal_n},'_',test{test_n},'_tail_behind');
% save (save_name,'DeltaF','length_tail_exposure','length_frame_within')

bout_tail = bout_tail(ind:ind2);
nose_closest = nose_closest(ind:ind2);
cd(animalfolder);
% save_name = strcat(animal{animal_n},'_',test{test_n},'_retreat_end');
% save (save_name,'DeltaF')
% save_name = strcat(animal{animal_n},'_',test{test_n},'_approach_start');
% save (save_name,'DeltaF')
save_name = strcat(animal{animal_n},'_',test{test_n},'_retreat');
save (save_name,'DeltaF','bout_tail','length_tail_exposure','length_frame_within','bout_start','nose_closest')

end
end
