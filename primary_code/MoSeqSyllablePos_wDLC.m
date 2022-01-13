%% plot syllable position/trajectory
%  need: MiceIndex_wLabels_***.mat (from add_MoSeqLabels_tsFromH5.m)
%        DLC_label.mat for each session in MiceIndex (from analy_novelty2103.m)

clear
clc
close all

cd('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Behavior/novelty_paper_2021/MoSeq')
load('MiceIndex_wLabels_combine3L_update.mat')

sessions = {'novel1'};
IntSyllable = 91; %79; 14; 94; %65; 30; 88; 91;

disp(['Syllable of interest: ' num2str(IntSyllable)])
disp('section 1')

%%
sylNose = [];
sylTail = [];
for miceiter=1:length(Mice)
    cd('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Behavior/novelty_paper_2021')
    disp(Mice(miceiter).name)
    
    if(strcmp(Mice(miceiter).novelty,'S'))
        cd stimulus
    elseif(strcmp(Mice(miceiter).novelty,'C'))
        cd contextual
    elseif(strcmp(Mice(miceiter).novelty,'s'))
        cd saline
    elseif(strcmp(Mice(miceiter).novelty,'l'))
        cd 6OHDA
    elseif(strcmp(Mice(miceiter).novelty,'p'))
        cd FP_all
    end
    cd(Mice(miceiter).name)
    
    for dayiter = 1:length(sessions)
        cd(sessions{dayiter})
        load('DLC_label.mat')
        
        sylIdx = find(Mice(miceiter).ExpDay(dayiter).moseq_align==IntSyllable);
        idxAdjust = sylIdx-Labels(1,1)+1; % adjust idx to match Labels crop
        idxAdjust(idxAdjust>length(Labels(:,1)))=[];
        
        if(idxAdjust)
            diffAdd = [0 diff(idxAdjust)]';
        else
            diffAdd = [];
        end
        
        sylNose = [sylNose; diffAdd ...
            Labels(idxAdjust,2) Labels(idxAdjust,3)];
        sylTail = [sylTail; diffAdd ...
            Labels(idxAdjust,11) Labels(idxAdjust,12)];
    end
end

if(0)
    cd('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Novelty_paper2021/Figures_matlab/update0914')
    save(['sylPos_' num2str(IntSyllable) '.mat'],'sylNose','sylTail')
end

%% nose, tail, merge plot for single syl
close all

fig1 = figure(1);
set(fig1,'position',[1 200 1150 400])
% title(['Syllable Position Distribution: syl' ...
%     num2str(IntSyllable)],'FontSize',20)

subplot(1,3,1)
plot(sylNose(:,2), sylNose(:,3), 'r.')
xlim([-150 300])
ylim([-150 300])
axis('square')
title('nose')
set(gca,'ydir','reverse','FontSize',20,...
    'box','off','TickDir','out')

subplot(1,3,2)
plot(sylTail(:,2), sylTail(:,3), 'k.')
xlim([-150 300])
ylim([-150 300])
axis('square')
title('tail')
set(gca,'ydir','reverse','FontSize',20,...
    'box','off','TickDir','out')

subplot(1,3,3)
hold on
plot(sylNose(:,2), sylNose(:,3), 'r.')
plot(sylTail(:,2), sylTail(:,3), 'k.')
xlim([-150 300])
ylim([-150 300])
axis('square')
title('merge')
set(gca,'ydir','reverse','FontSize',20,...
    'box','off','TickDir','out')

if(0)
    cd('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Novelty_paper2021/Figures_matlab/update0914')
    saveas(fig1, ['MoSeqPos_wDLC_syl' num2str(IntSyllable) '_***.fig'])
    saveas(fig1, ['MoSeqPos_wDLC_syl' num2str(IntSyllable) '_***.tif'])
end

%% merge plot for all syls (w lines)
clear
clc
close all

cd('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Novelty_paper2021/Figures_matlab/update0914')

sylPos_files     = dir('sylPos*.mat');
sylPos_filenames = cat(1,sylPos_files.name);
syl_id           = sylPos_filenames(:,8:9);

sylNose_all = [];
sylTail_all = [];
for syl_iter = 1:size(sylPos_filenames,1)
    load(sylPos_filenames(syl_iter,:))
    
    sylNose_all = [sylNose_all; ...
        repmat(str2num(syl_id(syl_iter,:)),length(sylNose),1) ...
        sylNose];
    sylTail_all = [sylTail_all; ...
        repmat(str2num(syl_id(syl_iter,:)),length(sylTail),1) ...
        sylTail];
end


fig1 = figure(1);
set(fig1,'position',[1 85 1150 540])

syl_ordered = [79 14 94 65 30 88 91];
for fig_iter = 1:size(syl_ordered,2)
    disp(fig_iter)
    currNose_idx = sylNose_all(:,1)==syl_ordered(fig_iter);
    currTail_idx = sylTail_all(:,1)==syl_ordered(fig_iter);
    currSyl_nose = sylNose_all(currNose_idx,:);
    currSyl_tail = sylTail_all(currTail_idx,:);
    
    boutNose_idx = find(currSyl_nose(:,2)>1);
    boutTail_idx = find(currSyl_tail(:,2)>1);
    if(boutNose_idx(1)~=1)
        boutNose_idx = [1; boutNose_idx];
    end
    if(boutTail_idx(1)~=1)
        boutTail_idx = [1; boutTail_idx];
    end
    
    if(fig_iter>3)
        subplot(2,4,fig_iter+1)
    else
        subplot(2,4,fig_iter)
    end
    hold on
    % uncomment to plot without lines
    plot(currSyl_nose(:,3), currSyl_nose(:,4), 'r.')
    plot(currSyl_tail(:,3), currSyl_tail(:,4), 'k.')
    xlim([-150 300])
    ylim([-150 300])
    axis('square')
    title(num2str(syl_ordered(fig_iter)))
    set(gca,'ydir','reverse','FontSize',20,...
        'box','off','TickDir','out')
    
    xlim([-150 300])
    ylim([-150 300])
    axis('square')
    title(num2str(syl_ordered(fig_iter)))
    set(gca,'ydir','reverse','FontSize',20,...
        'box','off','TickDir','out')
end

if(0)
    cd('/Users/cakiti/Dropbox (Uchida Lab)/Korleki Akiti/Novelty_paper2021/Figures_matlab/update0914')
    saveas(fig1, 'MoSeqPos_wDLC_allSylMerge_***.fig')
    saveas(fig1, 'MoSeqPos_wDLC_allSylMerge_***.tif')
    saveas(fig1, 'MoSeqPos_wDLC_allSylMerge_connect_***.tif')
end
