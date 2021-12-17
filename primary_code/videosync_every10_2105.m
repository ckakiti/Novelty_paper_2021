function videosync_every10_2105

% this is similar to 1808 and 2010 but for Korleki
% This program is to synchronize video LED TTL with event ts.
% LED TTL is detected using a code similar to 'detect_video_LED_2010'
% Output 'video_t' is timestamp for each video frame.

% cd('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior/DLC_newplots/raw_data');
% [animal_info,text,raw] = xlsread('akiti_miceID_210318.xlsx');
% % animal = text(2:end,3);
% animal = {'Avatar'};
% condition = text(2:end,9);
% test = {'hab1','hab2','novel1','novel2','novel3','novel4'};
% group = {'stimulus','contextual','saline','6OHDA','stimulus_FP'};
% group_n = 5;
% groupfolder = strcat('/Users/mitsukouchida/Dropbox (Uchida Lab)/Korleki Akiti (1)/Behavior/DLC_newplots/raw_data/',group{group_n});
% cd(groupfolder);
% % for animal_n = find(strcmp(condition,group{group_n}))'
% %     animal_n
% animal_n = 1;
%     animal{animal_n}
%     animalfolder = strcat(groupfolder,'/',animal{animal_n});
%     cd(animalfolder);
% for test_n = 3
%         cd(animalfolder);
%       cd(test{test_n});
%       test{test_n}
      
      filename = dir('*DeepCut_*.csv');
      Labels = csvread(filename.name,3,0);
      totalFrame = size(Labels,1);
  

%% align timestamps of behavior to recording

load('LED_ts')

diff_LED = diff(LED_on);
figure
histogram(diff_LED)
title('LED interval')

%%make ts for each video frame

video_t = 1:totalFrame;

video_t(LED_on(1))=0;
    frame_interval_first = 10000/(LED_on(2)-LED_on(1));
    for k = 1: LED_on(1)-1
        video_t(k)=-(LED_on(1)-k)*frame_interval_first;
    end

for i = 2:length(LED_on)
    video_t(LED_on(i))=10000*(i-1);
    frame_interval = 10000/(LED_on(i)-LED_on(i-1));
    for k = 1: LED_on(i)-LED_on(i-1)
        video_t(LED_on(i-1)+k)=video_t(LED_on(i-1))+ k*frame_interval;
    end
end
    
  frame_interval_last = 10000/(LED_on(end)-LED_on(end-1));
    for k = 1: totalFrame(end)-LED_on(end)
        video_t(LED_on(end)+k)=video_t(LED_on(end))+ k*frame_interval_last;
    end
 
    figure
    plot(video_t)
    xlabel('LED clock')
    ylabel('video frame')

    save('video_time','video_t')
    
end
% end
    
