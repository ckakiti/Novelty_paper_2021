function GCaMP_zscore = analyze_noise_2105(GCaMP,tdTom,trial_type_sig_all)

%similar to 2101 (monster) but for headfix/Korleki tone

% baseline is adjusted after subtracting tdTom signals during ITI

% Subtract tdTom after fitting of a whole trace (detrended) in a session 

R_Greenred = [];

% % read fiber photometry
% 
% file_ID = fopen('imaging.dat','r');
% CC_analog = fread(file_ID, inf, 'double', 0, 'b');
% 
% A = reshape(CC_analog, 2, [ ]);
% B = reshape (A, 2, 3, [ ]);
% 
% GCaMP = B (:,1,:);
% GCaMP = reshape (GCaMP,[],1);
% 
% tdTom = B (:,2,:);
% tdTom = reshape (tdTom,[],1);
% 
% if min(GCaMP)<0 % adjust strange signals <0
%     GCaMP = GCaMP - min(GCaMP);
% end
% if min(tdTom)<0
%     tdTom = tdTom - min(tdTom);
% end
% 
% truncate = 1:length(GCaMP);
% % truncate = 1:270000; %if using part of photometry trace
% GCaMP = GCaMP(truncate);
% tdTom = tdTom(truncate);

% plot the gcamp and tdtom signals for the whole day %%%%%%%%%%%%%%%

% figure()
% plot(GCaMP, 'g');
% hold on;
% plot(tdTom, 'r');
% legend('GFP','tdTom');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clean photometry signal %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load('photometry_time.mat') %'photometry_t','door_TS','enter_TS','reward_TS','monster_TS'
% 
% %detect fiber off
% GCaMP_2s = movmean(GCaMP,[9999,0]);
% GCaMP_off = movmean(GCaMP,[0,9999]);
% diff_GCaMP = GCaMP_2s(1:(end-1)) - GCaMP_off(2:end);
% ind = find(diff_GCaMP>1);
% figure
% plot(diff_GCaMP)
% t_off = [];
% if length(ind)>0
%     ind_task = find(ind>enter_TS(1));
%     for i = 1:length(ind_task)
%         t_jump = ind(ind_task(i));
%         if length(t_off)<1
%         if min(GCaMP(1:(t_jump-1000)))>max(GCaMP((t_jump+1000):end))
%             t_off = t_jump;
%            GCaMP = GCaMP(1:(t_off-1000));
%            tdTom = tdTom(1:(t_off-1000));
%            truncate = truncate(1):(truncate(1)+t_off-1000-1);
%         end
%         end
%     end
% end

 %remove 60Hz noise
d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',58,'HalfPowerFrequency2',62, ...
               'DesignMethod','butter','SampleRate',1000);
filtered_GCaMP = filtfilt(d,GCaMP);
filtered_tdTom = filtfilt(d,tdTom);


%smoothing
normG = smooth(filtered_GCaMP,50); %be careful for analyses to exclude 49ms
normR = smooth(filtered_tdTom,50);


% figure
% plot(normG, 'g');
% hold on;
% plot(normR, 'r');
% legend('filtered green','filtered red');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%remove global decay
samp_rate = 1000;

normG_median = [];
normG_start = normG(1)*ones(49999,1);
normG_end = normG(end)*ones(50000,1);
normG_startend = [normG_start;normG;normG_end];
for i = 1:samp_rate:length(normG)
    normG_median = [normG_median; median(normG_startend(i:i+99999))]; %median in 100second
end

normG_median_full = normG_median'.*ones(samp_rate,1);
normG_median_full = reshape(normG_median_full,[],1);
normG_median_full = normG_median_full(1:length(normG));
normG_median_full = smooth(normG_median_full,50);

normR_median = [];
normR_start = normR(1)*ones(49999,1);
normR_end = normR(end)*ones(50000,1);
normR_startend = [normR_start;normR;normR_end];
for i = 1:samp_rate:length(normR)
    normR_median = [normR_median; median(normR_startend(i:i+99999))]; %100second
end

normR_median_full = normR_median'.*ones(samp_rate,1);
normR_median_full = reshape(normR_median_full,[],1);
normR_median_full = normR_median_full(1:length(normG));
normR_median_full = smooth(normR_median_full,50);

normG_median_divided = normG./normG_median_full;
normR_median_divided = normR./normR_median_full;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get only ITI

ITI = repmat(-6000:0,length(trial_type_sig_all)-1,1)+trial_type_sig_all(2:end);
GCaMP_ITI = filtered_GCaMP(ITI);
median_GCaMP = median(GCaMP_ITI');
GCaMP_dFF = GCaMP_ITI./median_GCaMP';
GCaMP_dFF = reshape(GCaMP_dFF,1,[]);
tdTom_ITI = filtered_tdTom(ITI);
median_tdTom = median(tdTom_ITI');
tdTom_dFF = tdTom_ITI./median_tdTom';
tdTom_dFF = reshape(tdTom_dFF,1,[]);


% % remove before and after session
% % load('photometry_time.mat') %'photometry_t','door_TS','enter_TS','reward_TS','monster_TS'
% ts_first = round(enter_TS(1));
% ts_end = round(enter_TS(end));
% if truncate(1)>1
%     ts_first = ts_first - truncate(1);
%     ts_end = ts_end - truncate(1);
%     if ts_first<0
%         ts_first = 1;
%     end
% end
% if ts_end>truncate(end)
%     ts_end = truncate(end);
% end
% ITI = ts_first:ts_end;
% GCaMP_ITI = normG_median_divided(ITI);
% median_GCaMP = median(GCaMP_ITI');
% GCaMP_dFF = GCaMP_ITI./median_GCaMP';
% GCaMP_dFF = reshape(GCaMP_dFF,1,[]);
% tdTom_ITI = normR_median_divided(ITI);
% median_tdTom = median(tdTom_ITI');
% tdTom_dFF = tdTom_ITI./median_tdTom';
% tdTom_dFF = reshape(tdTom_dFF,1,[]);

% fit red and green
GCaMP_dFF = GCaMP_dFF(1:samp_rate:end);
tdTom_dFF = tdTom_dFF(1:samp_rate:end);
figure
plot (tdTom_dFF,GCaMP_dFF,'o')
hold on
p2 = polyfit(tdTom_dFF,GCaMP_dFF,1)
y2 = polyval(p2,tdTom_dFF);
plot(tdTom_dFF,y2,'k');
xlabel('tdTom')
ylabel('GCaMP')
[R_greenred,p_greenred] = corr(tdTom_dFF',GCaMP_dFF')
title(p_greenred);
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

% subtract tdTom
% GCaMP = signals + motion, GCaMP = p2(1)*tdTom + p2(2)

if p_greenred<0.05
% motion = p2(1)*(normR_median_divided);
motion = p2(1)*(normR_median_divided)+p2(2);
else
% motion = 0; % when fitting is not good
motion = p2(2);
end
GCaMP_dFF_full = normG_median_divided;
GCaMP_subtract = GCaMP_dFF_full - motion;

figure
plot(GCaMP_dFF_full, 'g');
hold on;
plot(GCaMP_subtract,'b');
plot(motion, 'r');
legend('GFP','GFP_subtracted','tdTom');

R_Greenred = [R_Greenred, R_greenred];

% figure
% hist(R_Greenred)
% xlabel('R')
% ylabel('session number')
% title('correlation between green and red raw signals');
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')

GCaMP_session = reshape(GCaMP_subtract(ITI),1,[]);
mean_GCaMP = mean(GCaMP_session);
std_GCaMP = std(GCaMP_session);
GCaMP_zscore = (GCaMP_subtract-mean_GCaMP)/std_GCaMP;

save('photometry_corrected','GCaMP_zscore')
end