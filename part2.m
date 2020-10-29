clear all
clc
load Sample_2.mat;
rawData=Orig_Sig;
numSamples = length(rawData);
maxValue = max(rawData);
minValue = min(rawData);
% add a buffer so graph doesn't touch the edges of preview window
limBuffer = 50;
maxYLim = maxValue + limBuffer;
minYLim = minValue - limBuffer;
% only consider peaks above the 70th percentile
peakThresholdPct = 0.53;
peakThreshold = minValue + ((maxValue - minValue) * peakThresholdPct);

% setting X-axis boundaries (converting to seconds)
% set(gca,'XTick',[360 720 1080 1440 1800 2160 2520 2880 3240 3600] )
% set(gca,'XTickLabel',[1 2 3 4 5 6 7 8 9 10 ] )

% use filtfilt to clean up spikes
d = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency' ,0.08, 'DesignMethod','butter');
filteredData = filtfilt(d, rawData);
% filteredData = movmean(rawData, movMeanWindow); % 10 is moving window
peakLocs = find(islocalmax(filteredData) & filteredData > peakThreshold);
valleyLocs = find(islocalmin(filteredData, 'MinProminence', 3));

P_locs = [];
Q_locs = [];
R_locs = peakLocs;
S_locs = [];
T_locs = [];

% loop through valley locations near peaks to assign P,Q,S,T
peakIdx = 1;
for valleyIdx = 2:length(valleyLocs)-2
    P_loc = valleyLocs(valleyIdx - 1);
    Q_loc = valleyLocs(valleyIdx);
    R_loc = peakLocs(peakIdx);
    S_loc = valleyLocs(valleyIdx + 1);
    T_loc = valleyLocs(valleyIdx + 2);
    
    if Q_loc < R_loc && R_loc < S_loc && peakIdx < length(peakLocs)
        peakIdx = peakIdx + 1;
        % add to locs array
        P_locs = [P_locs P_loc];
        Q_locs = [Q_locs Q_loc];
        S_locs = [S_locs S_loc];
        T_locs = [T_locs T_loc];
    end
end

hold on;
plot(P_locs, filteredData(P_locs), 'bo', 'MarkerSize', 10);
plot(Q_locs, filteredData(Q_locs), 'rs', 'MarkerSize', 10);
plot(R_locs, filteredData(R_locs), 'rv', 'MarkerSize', 10);
plot(S_locs, filteredData(S_locs), 'kx', 'MarkerSize', 10);
plot(T_locs, filteredData(T_locs), 'md', 'MarkerSize', 10);

%plot(valleyLocs, filteredData(valleyLocs), 'b^');
plot(rawData, 'g--');
plot(filteredData, 'b');
plot([0, numSamples],[peakThreshold, peakThreshold], 'r:');
hold off;
legend('P', 'Q', 'R', 'S', 'T', 'ECG Raw signal', 'Filtered Data', 'Threshold line')
title('Analyzed ECG')
axis([0 numSamples minYLim maxYLim])


% heart rate calculation and display
numPeaks = length(peakLocs);
heartRate=(numPeaks * 60) / 10.0; % 60s in a min, 10s of samples

PR_val = 0;
QT_val = 0;
QRS_dur = 0;
fprintf('Heart rate analysis\nHeart rate: %0.2f[b/m]\nP-R interval: %0.2f[s]\nQ-T interval: %0.2f[s]\nQRS duration: %0.2f[s]\n', heartRate, PR_val, QT_val, QRS_dur);
