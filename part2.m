clear all
clc
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

%  fvtool(b,a);

subplot(2,2,1);  
 hold on
   plot(t,filted)  
   hold off 
   title('zero-phase Filtered Data Butter')
 xlim([0 numSamples]);
ylim([minValue maxValue]);
 



%%all peaks labled and plotted wave

subplot(2,2,2);
plot(filted) 
xlim([0 numSamples]);
ylim([minValue maxValue]);
 [peaks, locs] = findpeaks(filted);
  hold on;
   current = locs(1);
next = 1;
while filted(current) >= filted(next)
current = next
next = next + 1;
%plot(t(current),filted(current),'ro','MarkerSize',10)
[peaks, locs] = findpeaks(filted);

hold on; 
plot(t(locs(1)),peaks(1),'s','MarkerSize',10)
xlim([0 numSamples]);
ylim([minValue maxValue]);
end
hold off
   
   

