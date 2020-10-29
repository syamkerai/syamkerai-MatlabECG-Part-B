clear all
clc
load Sample_1.mat;
rawData=Orig_Sig;
numSamples = length(rawData);
maxValue = max(rawData);
minValue = min(rawData);
% add a buffer so graph doesn't touch the edges of preview window
limBuffer = 50;
maxYLim = maxValue + limBuffer;
minYLim = minValue - limBuffer;
% only consider peaks above the 70th percentile
peakThresholdPct = 0.65;
peakThreshold = minValue + ((maxValue - minValue) * peakThresholdPct);
% increase window for more smoothing
movMeanWindow = 10;


% use movmean to clean up spikes
d = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency' ,0.15, 'DesignMethod','butter');
filteredData = filtfilt(d, rawData);
% filteredData = movmean(rawData, movMeanWindow); % 10 is moving window
peakLocs = find(islocalmax(filteredData) & filteredData > peakThreshold);
dipLocs = find(islocalmin(filteredData));

hold on 
plot(rawData, 'g--');
plot([0, numSamples],[peakThreshold, peakThreshold], 'r:');
plot(filteredData, 'b');
plot(peakLocs, filteredData(peakLocs), 'rv');
plot(dipLocs, filteredData(dipLocs), 'b^');
hold off
title('Analyzed ECG')
axis([0 numSamples minYLim maxYLim])

