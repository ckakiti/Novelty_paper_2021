function photometry_water_tone_Korleki_2105 

% Extract behavior parameters from water, tone, puff responses in Korleki rig
% perform motion correction using analyze_noise_1910

% animal = {'161_IK659','162_IK1630','163_IK1631','168_IK1761','170_IK633',...
%     '171_IK793','172_IK1763','173_IK1764','174_IK1765','175_IK1481'};
animal = {'Air','Avatar','Earth','Fire','Water'};

legend_name = {'water1','water3','water10','tone50','tone75','tone100'};

% max_lick_value = 1; % adjust lick threshold for each session
green_range = [-1 1]; % for raster plot


% for animal_n = 1:length(animal)  %to run multiple aninals
for animal_n = 3  %choose animal number
%     foldername = strcat('/Users/mitsukouchida/Desktop/Korleki/behavior/FL_all/',animal{animal_n});
    foldername = strcat('/Users/mitsukouchida/Desktop/Korleki/photometry/tone/',animal{animal_n});
% foldername = strcat('/Volumes/Mitsuko_Mac2019/Iku_headfix/UStasks/Anterior/',animal{animal_n});
cd(foldername);
 
% filename = dir('IK*_LS1_Analog');
filename = dir('*_data');
% filename = dir('photometry_time_tone_*');
  

for ii = 1: length(filename)
    filename(ii).name
    file_ID = fopen(filename(ii).name,'r');

% read fiber photometry

CC_analog = fread(file_ID, inf, 'double', 0, 'b');

A = reshape(CC_analog, 2, [ ]);
B = reshape (A, 2, 3, [ ]);
% B = reshape (A, 2, 11, [ ]); %for session LS or LoudTone (complex tone)

GCaMP = B (:,1,:);
GCaMP = reshape (GCaMP,[],1);

tdTom = B (:,2,:);
tdTom = reshape (tdTom,[],1);

% lick = B (:,3,:);
% lick = reshape (lick,[],1);
% 
% water = B (:,4,:);
% water = reshape (water,[],1);
% water_on = crossing(water,[],2); %threshold(mV)
% water_on_ts = (water_on(1:2:end)).';
% water_off_ts = (water_on(2:2:end)).';

trial_type_sig = B (:,3,:);
trial_type_sig = reshape (trial_type_sig,[],1);

% puff = B (:,8,:);
% puff = reshape (puff,[],1);
% puff_on = crossing(puff,[],2); %threshold(mV)
% puff_on_ts = (puff_on(1:2:end)).';
% puff_off_ts = (puff_on(2:2:end)).';

% plot the gcamp and tdtom signals for the whole day %%%%%%%%%%%%%%%

figure
plot(GCaMP, 'g');
hold on;
plot(tdTom+10, 'r');
% plot(lick+15, 'k');
% plot(water,'b');
plot(trial_type_sig,'b');
% plot(puff,'k')

title('photometry (g,r), tone(b)');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % calculate lick rate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% min_lick_value = -1; 
% lick_inhibition_width = 50;
% 
% figure
% plot(lick,'k')
% hold on
% 
% filtered_lick = lowpass_signal(lick,1000,40);
% plot(filtered_lick,'r')
% 
% [extrema_a,extrema_b,extrema_c,extrema_d] = extrema(filtered_lick);
% filtered_lick = zeros(size(filtered_lick));
% plot(extrema_d,extrema_c,'o')
% 
% for f = 1:length(extrema_d)    %extrema_d is ts for min(filtered_lick)
% if extrema_c(f) > min_lick_value && extrema_c(f) < max_lick_value
%     filtered_lick(extrema_d(f),1) = 1;
% end
% end
% 
% for f = 1:(length(filtered_lick)-100)
% for i = 1:lick_inhibition_width
%     if filtered_lick(f) == 1
%     if filtered_lick(f+i) == 1
%         filtered_lick(f+i) = 0;
%     end
%     end
% end
% end
% 
% plot(max_lick_value*filtered_lick,'b')
% title('lick raw (k), filtered1(r), filtered2(b)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % clean photometry signal %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
%  %remove 60Hz noise
% d = designfilt('bandstopiir','FilterOrder',2, ...
%                'HalfPowerFrequency1',58,'HalfPowerFrequency2',62, ...
%                'DesignMethod','butter','SampleRate',1000);
% filtered_GCaMP = filtfilt(d,GCaMP);
% GCaMP = filtered_GCaMP;
% filtered_tdTom = filtfilt(d,tdTom);
% tdTom = filtered_tdTom;
% 
% %remove sudden rise noise
% 
% diff_GCaMP = diff(GCaMP);
% std_GCaMP = std(diff_GCaMP);
% ind_noise = find(diff_GCaMP>5*std_GCaMP);
% exclude_green = size(ind_noise)
% 
% for i = 1:length(ind_noise)
% GCaMP(ind_noise(i))=GCaMP(ind_noise(i)-1);
%     for k=1:1000
%         if (ind_noise(i)+k)<length(GCaMP)
%         if GCaMP(ind_noise(i)+k)-GCaMP(ind_noise(i)+k-1)>5*std_GCaMP
%             GCaMP(ind_noise(i)+k) = GCaMP(ind_noise(i)+k-1);
%         end
%         end
%     end
% end
% 
% diff_tdTom = diff(tdTom);
% std_tdTom = std(diff_tdTom);
% ind_noise = find(diff_tdTom>5*std_tdTom);
% exclude_red = size(ind_noise)
% 
% for i = 1:length(ind_noise)
% tdTom(ind_noise(i))=tdTom(ind_noise(i)-1);
%     for k=1:1000
%         if tdTom(ind_noise(i)+k)-tdTom(ind_noise(i)+k-1)>5*std_tdTom
%             tdTom(ind_noise(i)+k) = tdTom(ind_noise(i)+k-1);
%         end
%     end
% end
% 
% %smoothing
% normG = smooth(GCaMP,50);
% GCaMP = normG;
% normR = smooth(tdTom,50);
% tdTom = normR;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the start of each trial and type %%%%%%%%%%%%%%%%%%%%%%%%%%%%

trial_type_sig_on = crossing(trial_type_sig,1:length(trial_type_sig),1);
trial_type_sig_off = (trial_type_sig_on(2:2:end)).';
trial_type_sig_on = (trial_type_sig_on(1:2:end)).';

trial_type_sig_on(:,2) = trial_type_sig_on(:,1);
trial_type_sig_on(:,2) = 0;

for i = 1:size(trial_type_sig_on,1)
    
temp_B = 1;

temp_A = trial_type_sig_on(i,1);    

for f = i+1:size(trial_type_sig_on,1)
if trial_type_sig_on(f,1) < temp_A + 1000  %identify multiple signals within 1s

temp_B = temp_B + 1;  
  
end
end

trial_type_sig_on(i,2) = temp_B;  %number of signals within 1s after trial_type_sig_on(i,1)

end

% delete duplicates of the same trial

for i = 1:size(trial_type_sig_on,1)
    
temp_B = 1;

temp_A = trial_type_sig_on(i,1);    

for f = i+1:size(trial_type_sig_on,1)
if trial_type_sig_on(f,1) < temp_A + 1000

trial_type_sig_on(f,:) = 0;
  
end
end

end

ind = find(trial_type_sig_on(:,1)>0);
trial_type_sig_on = trial_type_sig_on(ind,:);

TTL_end = [];
for i = 1:size(trial_type_sig_on,1)-1
    ind = find(trial_type_sig_off>trial_type_sig_on(i,1) & trial_type_sig_off<trial_type_sig_on(i+1,1));
    if length(ind)==0
        TTL_end = [TTL_end,0];
    else
        ind_max = max(ind);
    TTL_end = [TTL_end,trial_type_sig_off(ind_max)];
    end
end
TTL_end = [TTL_end,trial_type_sig_off(end)];
TTL_end = TTL_end';

trial_type_sig_all = [];
for iii = 1: max(trial_type_sig_on(:,2))
    trial_type = find(trial_type_sig_on(:,2)==iii);
%     trial_type_ts{iii} = trial_type_sig_on(trial_type);  % use first TTL
    trial_type_ts{iii} = TTL_end(trial_type);  % use last TTL
    trial_type_sig_all = [trial_type_sig_all;TTL_end(trial_type)];
end
trial_type_sig_all = sort(trial_type_sig_all); 

% % check trial_type_ts
% figure
% plot(trial_type_sig,'m');
% hold on
% for iii = 1: max(trial_type_sig_on(:,2))
%     if size(trial_type_ts{iii},1)>0
%     plot(trial_type_ts{iii},ones,'o')
%     end
% end

GCaMP_zscore = analyze_noise_2105(GCaMP,tdTom,trial_type_sig_all); % motion correction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make matrix of GCaMP data

% trial_number = [length(trial_type_ts{1}),length(trial_type_ts{2}),length(trial_type_ts{3}),...
%     length(trial_type_ts{4}),length(trial_type_ts{5}),length(trial_type_ts{7}),length(trial_type_ts{9})]
% trial_number = [length(trial_type_ts{1}),length(trial_type_ts{2}),length(trial_type_ts{3}),...
%     length(trial_type_ts{4}),length(trial_type_ts{5}),length(trial_type_ts{6})] %for session LS (complex tone)
% trial_number = length(trial_type_ts{2}) %for complex tone only

clear triggerB

% trigger = {trial_type_ts{1};trial_type_ts{2};trial_type_ts{3};...
%      trial_type_ts{4};trial_type_ts{5};trial_type_ts{6}}; %for session LS (complex tone)
trigger = {trial_type_ts{1}};


% trigger = {trial_type5_ts};
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
plotWin = -2000:5000;
responseWin = 2001:3000;  %choose response time, 2000 is trigger
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
        
    F = mean(rawTraceB(:,1001:2000),2);        %using this time window in plotwin for baseline
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
legend(legend_name)
xlabel('time - stimulus on (ms)')
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
xlabel('time - tone (s)');
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
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % make matrix of licking data
% 
% figure('Position',[1 scrsz(4)/1.5 scrsz(3)/1.5 scrsz(4)/1.5])
% subplot(2,2,1)
% 
% plotdata = filtered_lick; 
% 
% Lick_trace = [];
% Response_lick = [];
% ste_Response_lick = [];
% for i = 1:length(trigger)
%     ts = round(trigger{i});
% 
%     ind = find( ts+ plotWin(1)>0,1,'first');
%     ind2 = find( ts+ plotWin(end)< length(plotdata),1,'last');
%     ts = ts(ind:ind2);
%     plotind = bsxfun(@plus, repmat(plotWin,length(ts),1),ts);
%     rawTrace = plotdata(plotind);
%     
%      m_plot = mean(rawTrace);
%      m_plot = smooth(m_plot,500);
%      m_plot = m_plot';
%     s_plot = std(rawTrace)/sqrt(length(ts));
%     s_plot = smooth(s_plot,500);
%     s_plot = s_plot';
% 
% errorbar_patch(plotWin,m_plot,s_plot,plotColors{i});
% 
% Lick_trace = [Lick_trace;rawTrace];
% 
% response_lick = rawTrace(:,2000:4000); %2000 is trigger
% response_lick = mean(response_lick');
% Response_lick = [Response_lick mean(response_lick)];
% ste_Response_lick = [ste_Response_lick std(response_lick)/sqrt(length(response_lick))];
% end
% legend(legend_name)
% xlabel('time - water in (ms)')
% title('lick')
% set(gca,'FontSize',10)
% 
% subplot(2,2,3)
% bar(1000*Response_lick)
% hold on
% errorbar(1000*Response_lick, 1000*ste_Response_lick,'b.')
% hold on
% title('lick')
% ylabel('lick/s')
% h=gca;
% h.XTickLabel = legend_name;
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',10)
% set(gcf,'color','w')
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % raster plot (lick)
% 
% subplot(1,2,2)
% %1) bin the data
% trialNum = size(Lick_trace,1); binSize = 100;
% length_x = plotWin(end)-plotWin(1);
% binedF = squeeze(mean(reshape(Lick_trace(:,1:length_x),trialNum, binSize,[]),2));
% % imagesc(binedF,[-1 1]);
% imagesc(binedF,[-0.05 0.05]);
% colormap yellowblue
% xlabel('time - water (s)');
% h=gca;
% h.XTick = 0:10:(length_x/binSize);
% h.XTickLabel = {(plotWin(1)/1000):(plotWin(end)/1000)};
% title(max_lick_value)
% hold on;
% 
% % 2) plot the triggers
% % % mark triggerP
% % for k = 1:trialNum;
% % % x = [(Tmark(k)-plotWin(1))/binSize (Tmark(k)-plotWin(1))/binSize]; % odor timing
% % x = [(Tmark(k)-plotWin(1)+water_delay)/binSize (Tmark(k)-plotWin(1)+water_delay)/binSize]; %water timing
% % y = [k-0.5 k+0.5];
% % plot(x,y,'c')
% % end
% 
% % mark trigger
% % x2 = [(-plotWin(1)+1000)/binSize (-plotWin(1)+1000)/binSize];%water
% x2 = [-plotWin(1)/binSize -plotWin(1)/binSize]; % odor
% plot(x2,[0 trialNum+0.5],'r')
% 
% % divide trigger
% for j = 1:length(Trial_number)-1  
%      plot([0 length_x/binSize],[sum(Trial_number(1:j))+0.5 sum(Trial_number(1:j))+0.5],'m','Linewidth',1)   
% end
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')

% save_name = strcat(filename(ii).name,'_aligned_corrected');
% save (save_name,'DeltaF','Trial_number','Lick_trace','legend_name')

end
end
