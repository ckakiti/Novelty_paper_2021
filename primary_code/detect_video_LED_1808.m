function detect_video_LED_1808

%This program detect LED TTL in video. Output 'LED-on' is the frame number
%with TTL signals

c{1} = '/Users/mitsukouchida/Desktop/photometry/Diego';
cd(c{1});
foldername = dir('*-12-26_*');
cd(foldername.name);

filename = dir('*-0000.mp4');
videoObject = VideoReader(filename.name);
% videoObject = VideoReader('MY3_2018-09-12-143936-0000.mp4');

totalFrame = videoObject.NumberOfFrames
frame = 10000;  %choose frame number for background
LED_threashold = 1.4;
LED_max_threashold = 150;

thisFrame1 = read(videoObject, frame);
thisFrame1 = rgb2gray(thisFrame1);

figure
imshow(thisFrame1)

size(thisFrame1)
% %arena 464x420
% LED_location1 = thisFrame1(:,314:486);  %cut out left and right sides
% LED_location1 = LED_location1(232:450,:);  %cut out top and bottom
%%LED
LED_location1 = thisFrame1(:,151:300);  %cut out left and right sides
LED_location1 = LED_location1(1:60,:);  %cut out top and bottom

figure
imshow(LED_location1)

%check LED threashold and interval
LED = [];
LED_Max = [];
for i = 10000:totalFrame % choose frame number to analyze
% for i = 30000:35000 % choose frame number to analyze
    thisFrame = read(videoObject,i);
    thisFrame1 = rgb2gray(thisFrame);
    LED_location = thisFrame1(1:60,151:300);
    LED_intensity = mean(mean(LED_location-LED_location1));  %method using average of the area
    LED_max = max(max(LED_location-LED_location1));  %method using max, this works better than average
    LED = [LED LED_intensity];
    LED_Max = [LED_Max LED_max];
end

figure
plot(LED)

figure
plot(LED_Max)

% ind = find(LED>LED_threashold)
% diff_ind = diff(ind);
% LED_on = find(diff_ind>1);
% LED_on = ind([1,LED_on+1])
% diff(LED_on)

ind = find(LED_Max>LED_max_threashold);
diff_ind = diff(ind);
LED_on = find(diff_ind>1);  %remove occasional 2nd frame with 1 TTL
LED_on = ind([1,LED_on+1]);
diff(LED_on(1:10))
LED_on(1:10)

figure
hist(diff(LED_on))

ind = find(diff(LED_on)>800)
LED_on(ind)
LED_on(ind+1)

save('LED_ts','LED_on','totalFrame')
end

