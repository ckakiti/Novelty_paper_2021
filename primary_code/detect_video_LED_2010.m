function detect_video_LED_2010

%This program detect LED TTL in video. Output 'LED-on' is the frame number
%with TTL signals
%This is similar to 1808, but added a function to fill skipped LED

%1.choose a folder at line16-19
%2.choose a file at line22-24
%2.chooce frame_number to analyze at line31-32
%3.run
%4.adjust LED location at line 46-47
%5.adjust LED_max_threshold at line 29-30
%6.run
%7.adjust skip detection at line 105
%8.run

c{1} = '/Users/mitsukouchida/Desktop/photometry/video/Nashville/';
cd(c{1});
foldername = dir('*-04-07*');
cd(foldername.name);

filename = dir('*-0000.mp4');
videoObject = VideoReader(filename.name);
% videoObject = VideoReader('MY3_2018-09-12-143936-0000.mp4');

totalFrame = videoObject.NumberOfFrames
frame = 10000;  %choose frame number for background
LED_threashold = 1.4;
% LED_max_threashold = 150;
% LED_max_threashold = 25;
LED_max_threashold = 50;
frame_number = 1:totalFrame;
% frame_number = 1:194500;
% frame_number = 30000:35000; % choose frame number to analyze

thisFrame1 = read(videoObject, frame);
thisFrame1 = rgb2gray(thisFrame1);
size(thisFrame1)

figure
subplot(1,2,1)
imshow(thisFrame1)

% %arena 464x420
% LED_location1 = thisFrame1(:,314:486);  %cut out left and right sides
% LED_location1 = LED_location1(232:450,:);  %cut out top and bottom
%%LED operant box 480x400,480x640
% LED_win1 = 1:110; %cut out top and bottom
LED_win2 = 151:300; %cut out left and right sides
LED_win1 = 1:80; %cut out top and bottom
% LED_win2 = 350:450; %cut out left and right sides
LED_location1 = thisFrame1(LED_win1,LED_win2);

subplot(1,2,2)
imshow(LED_location1)
title('background frame')

%check LED threashold and interval
LED = [];
LED_Max = [];
for i = frame_number
    thisFrame = read(videoObject,i);
    thisFrame1 = rgb2gray(thisFrame);
    LED_location = thisFrame1(LED_win1,LED_win2);
    LED_intensity = mean(mean(LED_location-LED_location1));  %method using average of the area
    LED_max = max(max(LED_location-LED_location1));  %method using max, this works better than average
    LED = [LED LED_intensity];
    LED_Max = [LED_Max LED_max];
end

figure
subplot(1,2,1)
plot(LED)
title('LED mean')

subplot(1,2,2)
plot(LED_Max)
title('LED max')

% ind = find(LED>LED_threashold)
% diff_ind = diff(ind);
% LED_on = find(diff_ind>1);
% LED_on = ind([1,LED_on+1])
% diff(LED_on)

ind = find(LED_Max>LED_max_threashold);
diff_ind = diff(ind);
LED_on = find(diff_ind>1);  %remove occasional 2nd frame with 1 TTL
LED_on = ind([1,LED_on+1]);
% diff(LED_on(1:10))
% LED_on(1:10)

%fix start time
LED_on = frame_number(1)+LED_on-1;

%check LED location
LED1 = read(videoObject, LED_on(1));
LED1 = rgb2gray(LED1);
figure
subplot(1,2,1)
imshow(LED1)
subplot(1,2,2)
imshow(LED1(LED_win1,LED_win2))
title('LED on')

figure
subplot(1,2,1)
histogram(diff(LED_on))
title('original histogram')

% %To fill skipped LED
% ind = find(diff(LED_on)>1000); %adjust threshold to detect skip
% LED_on_fixed = LED_on;
% for i = 1:length(ind)
%     LED_on_fixed = [LED_on_fixed(1:(ind(i)+i-1)),round((LED_on(ind(i))+LED_on(ind(i)+1))/2),LED_on((ind(i)+1):end)];
% end
% LED_on = LED_on_fixed;

% %To skip extra detection
% ind = find(diff(LED_on)<400); %adjust threshold to detect extra
% diff_ind = find(diff(ind)>1);
% ind = ind([1,diff_ind]);
% LED_on_fixed = LED_on;
% for i = 1:length(ind)
%     LED_on_fixed = [LED_on_fixed(1:(ind(i)-i+1)),LED_on((ind(i)+2):end)];
% end
% LED_on = LED_on_fixed;

subplot(1,2,2)
histogram(diff(LED_on))
title('after filling')

save('LED_ts','LED_on','totalFrame')
end

