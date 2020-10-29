clear all
clc
load Sample_6.mat;
rawData=Orig_Sig;
numSamples = length(rawData);
maxValue = max(rawData);
minValue = min(rawData);
% add a buffer so graph doesn't touch the edges of preview window
limBuffer = 100;
maxYLim = maxValue + limBuffer;
minYLim = minValue - limBuffer;
% only consider peaks above the 70th percentile
peakThresholdPct = 0.65;
peakThreshold = minValue + ((maxValue - minValue) * peakThresholdPct);
% increase window for more smoothing
movMeanWindow = 10;


% use movmean to clean up spikes
meanData = movmean(rawData, movMeanWindow); % 10 is moving window
peakLocs = find(islocalmax(meanData) & meanData > peakThreshold);
dipLocs = find(islocalmin(meanData));

hold on 
plot(rawData, 'b');
plot([0, numSamples],[peakThreshold, peakThreshold], 'r--');
plot(meanData, 'r--');
plot(peakLocs, rawData(peakLocs), 'r*');
plot(dipLocs, rawData(dipLocs), 'b^');
hold off
title('Analyzed ECG')
xlim([0 numSamples]);
ylim([minYLim maxYLim]);

thresholdedData = rawData;
[peaksY, peaksX] = findpeaks(thresholdedData);

   

