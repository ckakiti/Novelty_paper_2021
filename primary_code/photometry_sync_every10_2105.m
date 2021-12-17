function photometry_sync_every10_2105

% this code is similar to 1809 but for Korleki
% This program is to synchronize photometry TTL with event ts.
% Output 'photometry_t' is timestamp for each video frame.
% output 'event_frame' is photometry time for each event timestamp.

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

filename = dir('*_data');
  
for ii = 1: length(filename)
    filename(ii).name
    file_ID = fopen(filename(ii).name,'r');

%% read fiber photometry

CC_analog = fread(file_ID, inf, 'double', 0, 'b');

A = reshape(CC_analog, 2, [ ]);
B = reshape (A, 2, 3, [ ]);

GCaMP = B (:,1,:);
GCaMP = reshape (GCaMP,[],1);

tdTom = B (:,2,:);
tdTom = reshape (tdTom,[],1);

TTL = B (:,3,:);
TTL = reshape (TTL,[],1);

TTL_on = crossing(TTL,[],1);
TTL_on = (TTL_on(1:2:end)).';
TTL_ts = TTL_on;
% TTL_ts = TTL_on(7:end);

figure
plot(TTL)
title('TTL in photometry')

%% make ts for each photometry frame

photometry_t = 1:length(GCaMP);
photometry_t(TTL_ts(1))=0;
    frame_interval_first = 10000/(TTL_ts(2)-TTL_ts(1));
    for k = 1: (TTL_ts(1)-1)
        photometry_t(k)=-(TTL_ts(1)-k)*frame_interval_first;
    end

for i = 2:length(TTL_ts)
    photometry_t(TTL_ts(i))=10000*(i-1);
    frame_interval = 10000/(TTL_ts(i)-TTL_ts(i-1));
    for k = 1: (TTL_ts(i)-TTL_ts(i-1))
        photometry_t(TTL_ts(i-1)+k)=photometry_t(TTL_ts(i-1))+ k*frame_interval;
    end
end
    
  frame_interval_last = 10000/(TTL_ts(end)-TTL_ts(end-1));
    for k = 1: (length(GCaMP)-TTL_ts(end))
        photometry_t(TTL_ts(end)+k)=photometry_t(TTL_ts(end))+ k*frame_interval_last;
    end
 
    figure
    plot(photometry_t)
    xlabel('photometry frame')
    ylabel('time (ms)')


save_name = strcat('photometry_time_',filename(ii).name);
    save(save_name,'photometry_t')
end
end