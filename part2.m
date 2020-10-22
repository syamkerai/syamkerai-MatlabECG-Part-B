clear all;
clc;
load Sample_1;
rawData=Orig_Sig;
numSamples = 1000;
maxValue = max(rawData)*1.10;
minValue = min(rawData)*0.90;

 x = Orig_Sig;
 t = 1:3600;
 [b, a] = butter(11,0.15,'low');
 filted = filtfilt(b,a,x);
 
 thresholdedData = rawData;
 [peaksY, peaksX] = findpeaks(filted);

subplot(3,2,1);
figure(1);
plot(filted);
title('Cleaned Data Butter')
xlim([0 numSamples]);
ylim([minValue maxValue]);






%  fvtool(b,a);

subplot(3,2,2);  
 hold on
   plot(t,filted)  
   hold off 
   title('zero-phase Filtered Data')
 xlim([0 numSamples]);
ylim([minValue maxValue]);
 


subplot(3,2,3);



%%all peaks labled and plotted wave
 plot(filted) 
xlim([0 numSamples]);
ylim([minValue maxValue]);
 [peaks, locs] = findpeaks(filted);
  hold on;
     plot(t(locs(1)),peaks(1),'s','MarkerSize',10)
   xlim([0 numSamples]);
ylim([minValue maxValue]);
   title('All peaks labled');

   
   
  %%anayze wave
subplot(3,2,4);
   t = 0 : 0.01 : 4*pi;
b = linspace(1,0.5, length(t));
y = b.* sin(t);
plot(t,y);
[peaks, locs] = findpeaks(y);
hold on;   
plot(t(locs(1)),peaks(1),'s','MarkerSize',10)
current = locs(1);
next = current + 1;
while y(current) >= y(next)
    current = next;
    next = next + 1;
end
plot(t(current),y(current),'ro','MarkerSize',10)
        hold off;

