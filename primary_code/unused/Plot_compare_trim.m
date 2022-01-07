%% Code to create Fig 1d 
%  (last edited 211227 by ka)
%  Input:
%  Output:

clear
close all
clc

path_to_your_files = ['/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/' ...
    'Novelty_paper2021/data_deposit'];
cd(path_to_your_files)

% structure with name of each mouse and corresponding novelty condition
% (order matters - should be the same as your .csv files)
run('MiceIndex_combine3')
% run('MiceIndex_combine3')

% load cumulative orientation file (created from combine_orientCumul.m)
load('Dataset_20190723_orientCumul.mat')

% name of novelty conditions
cond2name = 'cont';
cond1name = 'stim';

% get indices of mice in each novelty condition
detectCond = cat(1, Mice.novelty);
cond2 = find(detectCond=='C');
cond1 = find(detectCond=='S');
disp(['cond1: ' num2str(cond1')])
disp(['cond2: ' num2str(cond2')])

% .csv files containing avg time near obj, orientation, SAP #, SAP time near
stat_timeAng = readtable('TimeStatistic_combine3_tail.csv');
stat_SAP = readtable('TimeStatistic_SAP_combine3_8cm_norm_incl.csv');
% stat_SAP     = readtable('TimeStatistic_SAP_combine3_8cm_head_norm.csv');

% separate statistics within .csv files (makes it easier to plot)
stat_timeAng2 = stat_timeAng{:,3:end};
stat_SAP2     = stat_SAP{:,3:end};

Y_dis = stat_timeAng2(1:height(stat_timeAng)/2, :);
Y_ang = stat_timeAng2(height(stat_timeAng)/2+1:height(stat_timeAng),:);
Y_SAPnum  = stat_SAP2(1:height(stat_SAP)/2, :);
Y_SAPnear = stat_SAP2(height(stat_SAP)/2+1:height(stat_SAP),:);

% calculate average and std dev for each statistic
dis_cont_avg=mean(Y_dis(cond2,:));
dis_stim_avg=mean(Y_dis(cond1,:));
dis_cont_std=std(Y_dis(cond2,:));
dis_stim_std=std(Y_dis(cond1,:));

ang_cont_avg=mean(Y_ang(cond2,:));
ang_stim_avg=mean(Y_ang(cond1,:));
ang_cont_std=std(Y_ang(cond2,:));
ang_stim_std=std(Y_ang(cond1,:));

SAPnum_cont_avg=mean(Y_SAPnum(cond2,:));
SAPnum_stim_avg=mean(Y_SAPnum(cond1,:));
SAPnum_cont_std=std(Y_SAPnum(cond2,:));
SAPnum_stim_std=std(Y_SAPnum(cond1,:));

SAPnear_cont_avg=mean(Y_SAPnear(cond2,:));
SAPnear_stim_avg=mean(Y_SAPnear(cond1,:));
SAPnear_cont_std=std(Y_SAPnear(cond2,:));
SAPnear_stim_std=std(Y_SAPnear(cond1,:));

orientCumul_cont = orientCumul_all(cond2,:);
orientCumul_stim = orientCumul_all(cond1,:);
orientCumul_contCumul = cumsum(any(orientCumul_cont))/(15*60*25);
orientCumul_stimCumul = cumsum(any(orientCumul_stim))/(15*60*25);

% duration/frames spanned by statistics in .csv files (default first 10 min of session)
totalTime = 10;
fps = 15; % frame rate
Dis_te_frame = fps*60*totalTime+500; % includes 500 frame shift 
                                     % (account for delay in putting mouse in arena)
disp(['Total time: ' num2str(round(Dis_te_frame/fps/60)) 'min'])

% radius of analysis for time spent near object (8 for nose, 12 for tail)
radius_cm_disAng = 8;
radius_cm_SAP = 8;
angle_radius = 15;
disp(['Dis/ang radius: ' num2str(radius_cm_disAng) 'cm'])
disp(['SAP radius: ' num2str(radius_cm_SAP) 'cm'])

%% variables for plotting
Y_dis_title = ['Time spent at obj (', num2str(round(Dis_te_frame/fps/60))  ...
    'min); Rad = ' num2str(radius_cm_disAng) 'cm'];
Y_ang_title = ['Orientation to obj (', num2str(round(Dis_te_frame/fps/60)) ...
    'min); Deg = +-' num2str(angle_radius) char(176)];
Y_SAPnum_title = ['Total number of SAPs (' num2str(round(Dis_te_frame/fps/60)) 'min)'];
Y_SAPnear_title = ['SAPs near obj (' num2str(round(Dis_te_frame/fps/60)) 'min; '... %%%% (norm;
    'Rad = ' num2str(radius_cm_SAP) 'cm)'];

Y_dis_ylabel     = 'Time near object (frac)';
Y_ang_ylabel     = 'Orientation to object (frac)';
Y_SAPnum_ylabel  = 'Number of SAPs';
Y_SAPnear_ylabel = 'SAPs within radius';
% Y_SAPnear_ylabel = 'SAPs within radius / time near';

x_label = 'Session';

cond2Color = [0.5 0.0 0.5];
cond1Color = [1.0 0.5 0.0];
XTick = {'H1' 'H2' 'N1' 'N2' 'N3' 'N4' 'N5' 'N6' 'N7' 'N8' 'N9' 'N10'};
XTick = XTick(1:length(Y_dis(1,:)));
X     = 1:length(Y_dis(1,:));
names = stat_timeAng{1:height(stat_timeAng)/2,1}';
%     names = cat(1, Mice.name);

%% plot time spent near object and orientation to object across days
close all 

% Time near obj %%%
%   file: timeNearObj_10min_combine3_tail.tif
disfig=figure(1);
set(disfig, 'Position', [600 600 1200 450])

subplot(1, 2, 2)
hold on
d1 = plot(repmat(X, length(cond2), 1)', Y_dis(cond2,:)', ...
    'Color', cond2Color, 'Marker', '*', 'LineWidth',2);
d2 = plot(repmat(X, length(cond1), 1)', Y_dis(cond1,:)', ...
    'Color', cond1Color, 'Marker', '*', 'LineWidth',2);
title(Y_dis_title)
set(gca, 'FontSize', 14)
xlabel(x_label)
ylabel(Y_dis_ylabel)
legend([d1(1) d2(1)], [cond2name ' (n=' num2str(length(cond2)) ')'], ...
   [cond1name ' (n=' num2str(length(cond1)) ')']) %{'cont', 'stim'})
xlim([0 X(end)+1])
ylim([0 0.6])
ylimDis = disfig.CurrentAxes.YLim;
xticks(X);
xticklabels(XTick);
% set(gca,'YTick',[0 0.2 0.4])

subplot(1, 2, 1)
hold on
errorbar(X,dis_cont_avg,dis_cont_std, 'Color', cond2Color, 'LineWidth',2)
errorbar(X,dis_stim_avg,dis_stim_std, 'Color', cond1Color, 'LineWidth',2)
title(Y_dis_title)
set(gca, 'FontSize', 14)
xlabel(x_label)
ylabel(Y_dis_ylabel)
legend([cond2name ' (n=' num2str(length(cond2)) ')'], ...
   [cond1name ' (n=' num2str(length(cond1)) ')'])
xlim([0 X(end)+1])
ylim(ylimDis)
xticks(X);
xticklabels(XTick);
% set(gca,'YTick',[0 0.2 0.4])


% Orientation %%%
%   file: orientToObj_10min_combine3.tif
angfig=figure(2);
set(angfig, 'Position', [400 50 1200 450])

subplot(1, 2, 2)
hold on
a1 = plot(repmat(X, length(cond2), 1)', Y_ang(cond2,:)', ...
    'Color', cond2Color, 'Marker', '*', 'LineWidth',2);
a2 = plot(repmat(X, length(cond1), 1)', Y_ang(cond1,:)', ...
    'Color', cond1Color, 'Marker', '*', 'LineWidth',2);
title(Y_ang_title)
set(gca, 'FontSize', 14)
xlabel(x_label)
ylabel(Y_ang_ylabel)
legend([a1(1) a2(1)], [cond2name ' (n=' num2str(length(cond2)) ')'], ...
   [cond1name ' (n=' num2str(length(cond1)) ')']) %{'cont', 'stim'})
xlim([0 X(end)+1])
ylim([0 0.25])
ylimAng = angfig.CurrentAxes.YLim;
xticks(X);
xticklabels(XTick);
% set(gca,'YTick',[0 0.1 0.2])

subplot(1, 2, 1)
hold on
errorbar(X,ang_cont_avg,ang_cont_std, 'Color', cond2Color, 'LineWidth',2)
errorbar(X,ang_stim_avg,ang_stim_std, 'Color', cond1Color, 'LineWidth',2)
title(Y_ang_title)
set(gca, 'FontSize', 14)
xlabel(x_label)
ylabel(Y_ang_ylabel)
legend([cond2name ' (n=' num2str(length(cond2)) ')'], ...
   [cond1name ' (n=' num2str(length(cond1)) ')'])
xlim([0 X(end)+1])
ylim(ylimAng)
xticks(X);
xticklabels(XTick);
% set(gca,'YTick',[0 0.1 0.2])

if(0)
    saveas(disfig,'timeNearObj_10min_combine3_tail.tif')
    saveas(angfig,'orientToObj_10min_combine3.tif')
    %ranksum(Y_dis(cond1,3), Y_dis(cond2,3))
    %signrank(Y_dis(cond1,2), Y_dis(cond1,3))
end

%% plot orientation to object (dissertation format)
mean_y_ang = mean(Y_ang,2,'omitnan'); %'zscore' cannot handle NaN
std_y_ang = std(Y_ang,[],2,'omitnan');
% Y_ang_zscore = (Y_ang - mean_y_ang)./std_y_ang; %zscore
% Y_ang_zscore = (Y_ang - mean(Y_ang(:)))./std(Y_ang(:));
Y_ang_plot = Y_ang;

close all

angfig=figure(2);
set(angfig, 'Position', [-115 1133 1200 450])

subplot(1, 2, 1)
hold on
a1 = plot(repmat(X, length(cond2), 1)', Y_ang(cond2,:)', ...
    'Color', cond2Color, 'LineWidth',2);
a2 = plot(repmat(X, length(cond1), 1)', Y_ang(cond1,:)', ...
    'Color', cond1Color, 'LineWidth',2);
title('Individual traces')
set(gca, 'FontSize', 22)
xlabel(x_label)
ylabel(Y_ang_ylabel)
legend([a1(1) a2(1)], ['contextual (n=' num2str(length(cond2)) ')'], ...
   ['stimulus (n=' num2str(length(cond1)) ')']) %{'cont', 'stim'})
xlim([0 X(end)+1])
ylim([0 0.2])
ylimAng = angfig.CurrentAxes.YLim;
xticks(X);
xticklabels(XTick);
set(gca,'YTick',[0 0.1 0.2])
axis('square')

subplot(1, 2, 2)
hold on
errorbar(X,ang_cont_avg,ang_cont_std, 'Color', cond2Color, 'LineWidth',2)
errorbar(X,ang_stim_avg,ang_stim_std, 'Color', cond1Color, 'LineWidth',2)
title('Group average')
set(gca, 'FontSize', 22)
xlabel(x_label)
ylabel(Y_ang_ylabel)
legend(['contextual (n=' num2str(length(cond2)) ')'], ...
   ['stimulus (n=' num2str(length(cond1)) ')'])
xlim([0 X(end)+1])
ylim(ylimAng)
xticks(X);
xticklabels(XTick);
set(gca,'YTick',[0 0.1 0.2])
axis('square')

% subplot(1, 3, 2)
% a1 = plot(repmat(X, length(cond2), 1)', Y_ang_plot(cond2,:)', ...
%     'Color', cond2Color, 'LineWidth',2);
% title('Contextual')
% set(gca, 'FontSize', 14)
% xlabel(x_label)
% ylabel('Orientation to object (fraction)')
% legend(a1(1), ['contextual (n=' num2str(length(cond2)) ')']) %{'cont', 'stim'})
% xlim([0 X(end)+1])
% ylim([0 0.2])
% ylimAng = angfig.CurrentAxes.YLim;
% xticks(X);
% xticklabels(XTick);
% set(gca, 'FontSize', 16)
% axis('square')
% 
% subplot(1, 3, 1)
% a2 = plot(repmat(X, length(cond1), 1)', Y_ang_plot(cond1,:)', ...
%     'Color', cond1Color, 'LineWidth',2);
% % title(Y_ang_title)
% set(gca, 'FontSize', 14)
% title('Stimulus')
% xlabel(x_label)
% ylabel('Orientation to object (fraction)')
% legend(a2(1), ['stimulus (n=' num2str(length(cond1)) ')']) %{'cont', 'stim'})
% xlim([0 X(end)+1])
% ylim([0 0.2])
% ylimAng = angfig.CurrentAxes.YLim;
% xticks(X);
% xticklabels(XTick);
% set(gca, 'FontSize', 16)
% axis('square')
% 
% subplot(1,3,3)
% xlim([0 30])
% ylim([0 1])
% xlabel('Orientation to object (/min)')
% ylabel('Cumulative probability')
% title('N1')
% set(gca, 'FontSize', 16)
% axis('square')

% subplot(1, 2, 2)
% boxplot([(Y_ang(cond1,3)-Y_ang(cond1,2)), ...
%          (Y_ang(cond2,3)-Y_ang(cond2,2))])
% % ylim([0 0.2])
% xticklabels({'stim','cont'})
% set(gca, 'FontSize', 16)
% axis('square')

if(0)
    saveas(angfig,'orientToObj_10min_combine3.tif')
end
