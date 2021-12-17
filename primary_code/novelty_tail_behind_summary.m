function novelty_tail_behind_summary

cd('/Users/mitsuko/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior');
% cd('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior');
[animal_info,text,raw] = xlsread('akiti_miceID_210318.xlsx');
animal = text(2:end,3);
% animal = {'Air','Avatar','Earth','Fire','Water'};
% animal = {'Aconcagua','Denali'};
condition = text(2:end,9);
group = {'stimulus','contextual','saline','6OHDA','FP_all'};
group_n = 5;
groupfolder = strcat('/Users/mitsuko/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior/',group{group_n});
% groupfolder = strcat('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior/',group{group_n});
cd(groupfolder);
green_range = [-2 2]; % for raster plot
session_length = 40; %50 for stimulus, 40 for contextual

Mean_DeltaF = []; Length_tail_exposure = []; Length_frame_within = []; DeltaF_all = [];
Bout_tail = []; First_tail_exposure = []; First_tail_exposure_time = [];
Response = []; Response_history = []; Response_all = {}; Response_history_all = {}; 
Bout_tail_all = {}; Mean_DeltaF_phase1 = []; Mean_DeltaF_phase2 = []; Mean_DeltaF_phase1_only = [];
animal_index = 0; Mean_DeltaF_phase2_tail_behind = []; Mean_DeltaF_phase2_tail_exposure = [];
% for animal_n = 1:length(animal)
% for animal_n = 61 
% for animal_n = find(strcmp(condition,group{group_n}))'
% for animal_n = find(strcmp(condition,'contextual_FP'))'
for animal_n = find(strcmp(condition,'stimulus_FP'))'
    animal_index = animal_index + 1;
    animal_n
    animal{animal_n}
    animalfolder = strcat(groupfolder,'/',animal{animal_n});
    cd(animalfolder);
%     filename = dir('*_tail_behind*');
%     load(filename.name,'DeltaF','length_tail_exposure','length_frame_within');
    filename = dir('*_retreat.*');
    load(filename.name,'DeltaF','bout_tail','length_tail_exposure','length_frame_within','bout_start');
    mean_deltaF = mean(DeltaF);
%     mean_deltaF = mean(DeltaF(bout_tail==1,:)); %tail behind
%     mean_deltaF = mean(DeltaF(1:50,:));
    DeltaF_all = cat(3,DeltaF_all,DeltaF(1:session_length,:));
    Mean_DeltaF = [Mean_DeltaF;mean_deltaF];
    Length_tail_exposure = [Length_tail_exposure,length_tail_exposure];
%     Length_tail_exposure = [Length_tail_exposure,sum(1-bout_tail(11:end))];
    Length_frame_within = [Length_frame_within,length_frame_within/(60*15)]; %min
    Bout_tail = [Bout_tail;bout_tail(1:session_length)]; 
    Bout_tail_all{animal_index} = bout_tail;
    
    diff_bout_tail = diff(bout_tail);
    first_tail_exposure = find(diff_bout_tail==-1,1,'first');
    if length(first_tail_exposure)>0
    First_tail_exposure = [First_tail_exposure, first_tail_exposure+1];
    First_tail_exposure_time = [First_tail_exposure_time, bout_start(first_tail_exposure+1)/(60*15)]; %min
    DeltaF_phase1 = DeltaF(1:(first_tail_exposure-1),:);
    Mean_DeltaF_phase1 = [Mean_DeltaF_phase1;mean(DeltaF_phase1)];
    DeltaF_phase2 = DeltaF(first_tail_exposure:end,:);
    Mean_DeltaF_phase2 = [Mean_DeltaF_phase2;mean(DeltaF_phase2)];
    ind = (bout_tail(first_tail_exposure:end)==1);
    Mean_DeltaF_phase2_tail_behind = [Mean_DeltaF_phase2_tail_behind;mean(DeltaF_phase2(ind,:))];
    ind = find(bout_tail(first_tail_exposure:end)==0);
    if length(ind)>1
    Mean_DeltaF_phase2_tail_exposure = [Mean_DeltaF_phase2_tail_exposure;mean(DeltaF_phase2(ind,:))];
    else
        Mean_DeltaF_phase2_tail_exposure = [Mean_DeltaF_phase2_tail_exposure;DeltaF_phase2(ind,:)];
    end
    else
    First_tail_exposure = [First_tail_exposure, NaN];
    First_tail_exposure_time = [First_tail_exposure_time, 26]; %one session plus 1 min
    Mean_DeltaF_phase1_only = [Mean_DeltaF_phase1_only;mean(DeltaF)];
    end
    
    response = DeltaF(:,3001:4000);
    response = mean(response,2);
    response_cumsum = cumsum(response);
    response_history = response_cumsum./(1:length(response_cumsum))';
    Response = [Response; response(1:session_length)'];
    Response_all{animal_index} = response;
    Response_history = [Response_history; response_history(1:session_length)'];
    Response_history_all{animal_index} = response_history;
    
end
mean_response = mean(Response,2)'

figure
subplot(1,4,1)
m_plot = mean(Mean_DeltaF);
s_plot = std(Mean_DeltaF)/sqrt(size(Mean_DeltaF,1));
plotWin = -3000:3000;
errorbar_patch(plotWin,m_plot,s_plot,'b');
h=gca;
h.XTick = -3000:1000:3000;
h.XTickLabel = -3:3;
xlabel('time - retreat start (s)')
ylabel('zscore')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

% raster plot

subplot(1,4,2)
mean_Mean_DeltaF = mean(Mean_DeltaF(:,3001:4000),2);
[B,I] = sort(mean_Mean_DeltaF,'descend');
sort_index_DA = I
Mean_DeltaF_sort = Mean_DeltaF(I,:);
%1) bin the data
trialNum = size(Mean_DeltaF,1); binSize = 100;
length_x = plotWin(end)-plotWin(1);
binedF = squeeze(mean(reshape(Mean_DeltaF_sort(:,1:length_x),trialNum, binSize,[]),2));
imagesc(binedF,green_range);
% imagesc(binedF);
colormap yellowblue
colorbar
xlabel('time - retreat (s)');
ylabel('animals')
h=gca;
h.XTick = 0:10:(length_x/binSize);
h.XTickLabel = {(plotWin(1)/1000):(plotWin(end)/1000)};
h.YTickLabel = {};
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

% raster plot

subplot(1,4,3)
%1) bin the data
trialNum = size(DeltaF_all,1); binSize = 100;
length_x = plotWin(end)-plotWin(1);
Mean_DeltaF_all = mean(DeltaF_all,3);
binedF = squeeze(mean(reshape(Mean_DeltaF_all(:,1:length_x),trialNum, binSize,[]),2));
imagesc(binedF,green_range);
% imagesc(binedF);
colormap yellowblue
colorbar
xlabel('time - retreat (s)');
ylabel('trials')
h=gca;
h.XTick = 0:10:(length_x/binSize);
h.XTickLabel = {(plotWin(1)/1000):(plotWin(end)/1000)};
h.YTickLabel = {};
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(1,4,4)
plot(Response','k-')
hold on
plot(mean(Response),'k-','LineWidth',2)
xlabel('trials');
ylabel('DA response')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

figure
subplot(2,1,1)
for i = 1:animal_index
        response_smooth = smooth(Response_all{i});
%         if First_tail_exposure(i)>0
        plot(response_smooth,'k-')
%         end
    hold on
end
axis([0 200 -1 7])
xlabel('trials');
ylabel('DA response')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(2,1,2)
for i = 1:animal_index
    response_smooth = smooth(Response_all{i});
    if First_tail_exposure(i)>0
    plot(((1-First_tail_exposure(i)):(length(response_smooth)-First_tail_exposure(i)))',response_smooth,'k-')
    else
        plot((-length(response_smooth):(-1))',response_smooth,'k-')
    end
    hold on
end
axis([-100 100 -1 7])
xlabel('trials - first tail exposure');
ylabel('DA response')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

figure
subplot(1,3,1)
m_plot = mean(Mean_DeltaF_phase1_only);
s_plot = std(Mean_DeltaF_phase1_only)/sqrt(size(Mean_DeltaF_phase1_only,1));
plotWin = -3000:3000;
errorbar_patch(plotWin,m_plot,s_plot,'b');
h=gca;
h.XTick = -3000:1000:3000;
h.XTickLabel = -3:3;
axis([-3000 3000 -0.5 3.5])
xlabel('time - retreat start (s)')
ylabel('zscore')
title('avoidance mouse')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

subplot(1,3,2)
m_plot = mean(Mean_DeltaF_phase1);
s_plot = std(Mean_DeltaF_phase1)/sqrt(size(Mean_DeltaF_phase1,1));
plotWin = -3000:3000;
errorbar_patch(plotWin,m_plot,s_plot,'b');
h=gca;
h.XTick = -3000:1000:3000;
h.XTickLabel = -3:3;
axis([-3000 3000 -0.5 3.5])
xlabel('time - retreat start (s)')
ylabel('zscore')
title('phase1')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')
    
    
subplot(1,3,3)
m_plot = mean(Mean_DeltaF_phase2);
s_plot = std(Mean_DeltaF_phase2)/sqrt(size(Mean_DeltaF_phase2,1));
plotWin = -3000:3000;
errorbar_patch(plotWin,m_plot,s_plot,'b');
h=gca;
h.XTick = -3000:1000:3000;
h.XTickLabel = -3:3;
axis([-3000 3000 -0.5 3.5])
xlabel('time - retreat start (s)')
ylabel('zscore')
title('phase2')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

[h,p_phase1_phase2] = ttest(mean(Mean_DeltaF_phase1,2),mean(Mean_DeltaF_phase2,2))
n_phase12 = size(Mean_DeltaF_phase1,1)

[h,p_phase2_tail_behind_exposure] = ttest(mean(Mean_DeltaF_phase2_tail_behind,2),mean(Mean_DeltaF_phase2_tail_exposure,2))

figure
subplot(1,2,1)
m_plot = mean(Mean_DeltaF_phase2_tail_behind);
s_plot = std(Mean_DeltaF_phase2_tail_behind)/sqrt(size(Mean_DeltaF_phase2_tail_behind,1));
plotWin = -3000:3000;
errorbar_patch(plotWin,m_plot,s_plot,'b');
h=gca;
h.XTick = -3000:1000:3000;
h.XTickLabel = -3:3;
axis([-3000 3000 -0.3 0.5])
xlabel('time - retreat start (s)')
ylabel('zscore')
title('phase2 tail behind')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

subplot(1,2,2)
m_plot = mean(Mean_DeltaF_phase2_tail_exposure);
s_plot = std(Mean_DeltaF_phase2_tail_exposure)/sqrt(size(Mean_DeltaF_phase2_tail_exposure,1));
plotWin = -3000:3000;
errorbar_patch(plotWin,m_plot,s_plot,'b');
h=gca;
h.XTick = -3000:1000:3000;
h.XTickLabel = -3:3;
axis([-3000 3000 -0.3 0.5])
xlabel('time - retreat start (s)')
ylabel('zscore')
title('phase2 tail exposure')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')


% subplot(3,1,3)
% for i = 1:animal_index
%     response_smooth = Response_history_all{i}; %no smooth
%     if First_tail_exposure(i)>0
%     plot(((1-First_tail_exposure(i)):(length(response_smooth)-First_tail_exposure(i)))',response_smooth,'k-')
% %     else
% %         plot((-length(response_smooth):(-1))',response_smooth,'k-')
%     end
%     hold on
% end
% xlabel('trials - first tail exposure');
% ylabel('DA response history')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')

% figure
% plot(Response_history','k-')
% hold on
% plot(mean(Response_history),'k-','LineWidth',2)
% xlabel('trials');
% ylabel('DA response history')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')


figure
subplot(1,2,1)
plot(Length_tail_exposure,mean_Mean_DeltaF,'o','MarkerSize',15,'MarkerFaceColor','b')
xlabel('frequency of tail exposure (/session)');
ylabel('TS dopamine (zscore)')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(1,2,2)
plot(Length_frame_within,mean_Mean_DeltaF,'o','MarkerSize',15,'MarkerFaceColor','b')
xlabel('time spent near object (min)');
ylabel('TS dopamine (zscore)')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

[rho,pval_dopamine_tail_exposure_Spearman] = corr(Length_tail_exposure',mean_Mean_DeltaF,'Type','Spearman')
[rho,pval_dopamine_time_near_object_Spearman] = corr(Length_frame_within',mean_Mean_DeltaF,'Type','Spearman')
[rho,pval_dopamine_tail_exposure_Pearson] = corr(Length_tail_exposure',mean_Mean_DeltaF,'Type','Pearson')
[rho,pval_dopamine_time_near_object_Pearson] = corr(Length_frame_within',mean_Mean_DeltaF,'Type','Pearson')

figure
subplot(1,2,1)
plot(First_tail_exposure,mean_Mean_DeltaF,'o','MarkerSize',15,'MarkerFaceColor','b')
xlabel('first tail exposure (trial)');
ylabel('TS dopamine (zscore)')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(1,2,2)
plot(First_tail_exposure_time,mean_Mean_DeltaF,'o','MarkerSize',15,'MarkerFaceColor','b')
xlabel('first tail exposure (min)');
ylabel('TS dopamine (zscore)')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

[rho,pval_dopamine_first_tail_exposure_Spearman] = ...
    corr(First_tail_exposure(First_tail_exposure>0)',mean_Mean_DeltaF(First_tail_exposure>0),'Type','Spearman')
[rho,pval_dopamine_first_tail_exposure_time_Spearman] = corr(First_tail_exposure_time',mean_Mean_DeltaF,'Type','Spearman')
[rho,pval_dopamine_first_tail_exposure_Pearson] = ...
    corr(First_tail_exposure(First_tail_exposure>0)',mean_Mean_DeltaF(First_tail_exposure>0),'Type','Pearson')
[rho,pval_dopamine_first_tail_exposure_time_Pearson] = corr(First_tail_exposure_time',mean_Mean_DeltaF,'Type','Pearson')

%% DA activity correlates behavior?
%regress DA response to all approach bouts, past average DA responses, current retreat (tail behind),
%next retreat (tail behind)

Rsq = []; Beta = []; P_value = [];
Rsq2 = []; Beta2 = []; P_value2 = [];
DA_Retreat = []; DA_Retreat2 = [];  Phase = []; DA_Retreat_history = []; Bout_tail1 = []; Bout_tail2 = []; Trial = [];

for i = 1:animal_index
    DA_retreat = Response_all{i};
    DA_Retreat = [DA_Retreat;DA_retreat(1:end-1)]; %to test effects on next trial
    DA_Retreat2 = [DA_Retreat2;DA_retreat(2:end)]; %to test effects on current trial
    bout_tail1 = Bout_tail_all{i};
    Bout_tail2 = [Bout_tail2;bout_tail1(2:end)'];
    Trial = [Trial;(1:length(DA_retreat)-1)'];
    DA_retreat_history = Response_history_all{i};
    if First_tail_exposure(i)>0
    phase = [ones(1,First_tail_exposure(i)-1),zeros(1,length(DA_retreat)-First_tail_exposure(i)+1)];

    mdl2 = fitglm(DA_retreat(1:(end-1)),phase(2:end)','Distribution','binomial','Link','logit'); %phase with previous DA

    rsq2 = mdl2.Rsquared.Ordinary;
    b2 = mdl2.Coefficients.Estimate;
    p2 = mdl2.Coefficients.pValue;
    Rsq2 = [Rsq2;rsq2'];
    Beta2 = [Beta2;b2'];
    P_value2 = [P_value2;p2'];
    
    Phase = [Phase; phase(2:end)'];
    else
        Phase = [Phase; ones(length(DA_retreat)-1,1)];
    end

end

p_beta_phase = signrank(Beta2(:,2))

figure
subplot(1,2,1)
boxplot(Beta2(:,2))
hold on
plot(1,Beta2(:,2),'ko')
ind = find(P_value2(:,2)<0.05);
if length(ind)>0
    plot(1,Beta2(ind,2),'ro')
end
h=gca;
h.XTick = [];
h.XTickLabel = {};
title('regression behavior phase with dopamine')
ylabel('slope')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

subplot(1,2,2)
boxplot(-Beta2(:,1)./Beta2(:,2))
hold on
plot(1,-Beta2(:,1)./Beta2(:,2),'ko')
h=gca;
h.XTick = [];
h.XTickLabel = {};
ylabel('boundary')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')


Rsq = []; Beta = []; P_value = [];
Rsq2 = []; Beta2 = []; P_value2 = [];
for i = 1:animal_index
    DA_retreat = Response_all{i};
    bout_tail1 = Bout_tail_all{i};
    DA_retreat_history = Response_history_all{i};
    if First_tail_exposure(i)>0
    phase = [zeros(1,First_tail_exposure(i)-1),ones(1,length(DA_retreat)-First_tail_exposure(i)+1)];
    mdl2 = fitglm(DA_retreat,bout_tail1','Distribution','binomial','Link','logit'); %current choice with DA
    

%     rsq = mdl.Rsquared.Ordinary;    
% b = mdl.Coefficients.Estimate;
% p = mdl.Coefficients.pValue;
% Rsq = [Rsq;rsq'];
% Beta = [Beta;b'];
% P_value = [P_value;p'];

rsq2 = mdl2.Rsquared.Ordinary;
b2 = mdl2.Coefficients.Estimate;
p2 = mdl2.Coefficients.pValue;
Rsq2 = [Rsq2;rsq2'];
Beta2 = [Beta2;b2'];
P_value2 = [P_value2;p2'];

% x = min(DA_retreat):0.1:max(DA_retreat);
% y = glmval(b2,x,'logit');
% figure
% plot(x,y,'k-')
% hold on
% plot(DA_retreat, phase','ko')
% xlabel('dopamine')
% ylabel('phase')
% plot((1:length(bout_tail))',bout_tail','ko')
% plot(DA_retreat_history/3,'bo')
% axis([0 length(bout_tail) -0.5 2.5])
% legend('fit','tail behind','dopamine')

    end
end

% p_beta2 = signrank(Beta(:,2))
% p_beta3 = signrank(Beta(:,3))
% % p_beta4 = signrank(Beta(:,4))

p_beta_current_choice = signrank(Beta2(:,2))

figure
% subplot(1,2,1)
% boxplot(Beta(:,2:3))
% hold on
% plot(1,Beta(:,2),'ko')
% plot(2,Beta(:,3),'ko')
% ind = find(P_value(:,2)<0.05);
% if length(ind)>0
%     plot(1,Beta(ind,2),'ro')
% end
% ind = find(P_value(:,3)<0.05);
% if length(ind)>0
%     plot(2,Beta(ind,3),'ro')
% end
% % plot(2,Beta(:,4),'ko')
% % ind = find(P_value(:,4)<0.05);
% % if length(ind)>0
% %     plot(3,Beta(ind,4),'ro')
% % end
% h=gca;
% h.XTick = 1:2;
% h.XTickLabel = {'current','next'};
% title('regression DA with current and next retreat type')
% ylabel('beta')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',10)
% set(gcf,'color','w')
% 
% subplot(1,2,2)
subplot(1,2,1)
boxplot(Beta2(:,2))
hold on
plot(1,Beta2(:,2),'ko')
ind = find(P_value2(:,2)<0.05);
if length(ind)>0
    plot(1,Beta2(ind,2),'ro')
end
h=gca;
h.XTick = [];
h.XTickLabel = {};
title('regression approach types with dopamine')
ylabel('slope')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

subplot(1,2,2)
boxplot(-Beta2(:,1)./Beta2(:,2))
hold on
plot(1,-Beta2(:,1)./Beta2(:,2),'ko')
h=gca;
h.XTick = [];
h.XTickLabel = {};
ylabel('boundary')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')




% mdl_all = fitlm([Bout_tail1',Bout_tail2'],DA_Retreat) %DA and current and next retreat
% % mdl2_all = fitlm(Bout_tail2',DA_Retreat_history) %DA history and next retreat 
% 
% Bout_tail_smooth = smoothdata(Bout_tail,2,'movmean',10);
% figure
% plot(Bout_tail_smooth','k-')
% hold on
% plot(mean(Bout_tail),'k-','LineWidth',2)
% xlabel('trial')
% ylabel('approach type tail behind')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',10)
% set(gcf,'color','w')

% % dopamine decay predict early first tail exposure?
% Rsq2 = []; Beta2 = []; P_value2 = [];
% for i = 1:animal_index
%     DA_retreat = Response_all{i};
%     bout_tail1 = Bout_tail_all{i};
%     trial = 1:length(DA_retreat);
%     if First_tail_exposure(i)>0
%     phase = [zeros(1,First_tail_exposure(i)-1),ones(1,length(DA_retreat)-First_tail_exposure(i)+1)];
%     ind = find(phase==0);
%     mdl2 = fitlm(trial(ind),DA_retreat(ind)'); %choice with trial
% 
% rsq2 = mdl2.Rsquared.Ordinary;
% b2 = mdl2.Coefficients.Estimate;
% p2 = mdl2.Coefficients.pValue;
% Rsq2 = [Rsq2;rsq2'];
% Beta2 = [Beta2;b2'];
% P_value2 = [P_value2;p2'];
% 
%     else
%         Beta2 = [Beta2;[NaN,NaN]];
% 
%     end
% 
% end
% 
% p_beta = signrank(Beta2(:,2))
% 
% figure
% subplot(1,3,1)
% plot(Length_tail_exposure,Beta2(:,2),'o','MarkerSize',15,'MarkerFaceColor','b')
% xlabel('frequency of tail exposure (/session)');
% ylabel('TS dopamine decay in phase1 (beta)')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')
% 
% subplot(1,3,2)
% plot(Length_frame_within,Beta2(:,2),'o','MarkerSize',15,'MarkerFaceColor','b')
% xlabel('time spent near object (min)');
% ylabel('TS dopamine decay in phase1 (beta)')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')
% 
% ind = (First_tail_exposure>0);
% subplot(1,3,3)
% plot(First_tail_exposure(ind),Beta2(ind,2),'o','MarkerSize',15,'MarkerFaceColor','b')
% xlabel('first tail exposure');
% ylabel('TS dopamine decay in phase1 (beta)')
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')
% 
% [rho,pval_dopamine_decay_tail_exposure_Spearman] = corr(Length_tail_exposure',Beta2(:,2),'Type','Pearson')
% [rho,pval_dopamine_decay_time_near_object_Spearman] = corr(Length_frame_within',Beta2(:,2),'Type','Pearson')

%% ROC analysis

% test phase coding
% mdl = fitglm(Trial(ind),Phase(ind),'Distribution','binomial','Link','logit') %Fit a logistic regression model, phase
mdl = fitglm(DA_Retreat,Phase,'Distribution','binomial','Link','logit') %Fit a logistic regression model, phase
% mdl = fitglm([Trial(ind),DA_Retreat(ind)],Phase(ind),'Distribution','binomial','Link','logit') %Fit a logistic regression model, phase
% mdl = fitglm([Trial,DA_Retreat],Phase,'Distribution','binomial','Link','logit') %Fit a logistic regression model, phase

scores = mdl.Fitted.Probability;
[X,Y,T,AUC_value] = perfcurve(Phase,scores,1);

figure
subplot(1,3,1)
plot(X,Y)
xlabel('False positive rate')
ylabel('True positive rate')
title({'AUC phase',AUC_value})
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

% test next retreat type coding
% ind = find(Trial>18);
ind = find(Phase(1:(end-1))==0); % after first tail exposure
mdl = fitglm(DA_Retreat(ind+1),Bout_tail2(ind),'Distribution','binomial','Link','logit') %Fit a logistic regression model, phase
scores = mdl.Fitted.Probability;
[X,Y,T,AUC_value] = perfcurve(Bout_tail2(ind),scores,1);

subplot(1,3,2)
plot(X,Y)
xlabel('False positive rate')
ylabel('True positive rate')
title({'AUC current approach type',AUC_value})
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')



% test next retreat type coding
% ind = find(Trial>18);
ind = find(Phase==0); % after first tail exposure
mdl = fitglm(DA_Retreat2(ind),Bout_tail2(ind),'Distribution','binomial','Link','logit') %Fit a logistic regression model, phase
scores = mdl.Fitted.Probability;
[X,Y,T,AUC_value] = perfcurve(Bout_tail2(ind),scores,1);

subplot(1,3,3)
plot(X,Y)
xlabel('False positive rate')
ylabel('True positive rate')
title({'AUC next approach type',AUC_value})
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
set(gcf,'color','w')

% test phase coding, trial number vs dopamine
mdl_dopamine = fitlm(DA_Retreat,Phase) %Fit a linear regression model, phase
mdl_trialnumber = fitlm(Trial,Phase) 
mdl_both = fitlm([Trial,DA_Retreat],Phase)

% ind = find(Phase(1:(end-1))==0); % after first tail exposure
% mdl_trialnumber_after_tail_exposure = fitlm(Trial(ind),DA_Retreat(ind)) 
% ind = find(Phase(1:(end-1))==1); % before first tail exposure
% mdl_trialnumber_before_tail_exposure = fitlm(Trial(ind),DA_Retreat(ind)) 





First_tail_exposure

