clear all
clc
load Sample_8.mat;
rawData=Orig_Sig;
numSamplesPerSec = 360;
numSamples = length(rawData);
maxValue = max(rawData);
minValue = min(rawData);
limBuffer = 50;
maxYLim = maxValue + limBuffer;
minYLim = minValue - limBuffer;

% use filtfilt to clean up spikes
d = designfilt('lowpassiir', 'FilterOrder', 2, 'HalfPowerFrequency' ,0.08, 'DesignMethod','butter');
filteredData = filtfilt(d, rawData);
peakLocs = find(islocalmax(filteredData));
valleyLocs = find(islocalmin(filteredData));
valleyLocs = [1;valleyLocs];

P_locs = [];
Q_locs = [];
R_locs = [];
S_locs = [];
T_locs = [];

% loop through valley locations near peaks to assign P,Q,S,T
peakValleyThreshold = (max(filteredData) - min(filteredData)) * 0.6;
peakIdx = 1;

for valleyIdx = 1:length(valleyLocs)-1
    if peakIdx > length(peakLocs)
        break
    end
    
    % sometimes P_loc doesn't exist since there isn't a dip 
    % assume the first value
    P_loc = 1;
    Q_loc = valleyLocs(valleyIdx);
    R_loc = peakLocs(peakIdx);
    S_loc = valleyLocs(valleyIdx + 1);
    % sometimes P_loc doesn't exist since there isn't a dip 
    % assume the the value
    T_loc = numSamples;
    
    % only consider a peak if valley-peak-valley is above a threshold
    if (filteredData(R_loc) * 2 - filteredData(Q_loc) - filteredData(S_loc)) < peakValleyThreshold
        peakIdx = peakIdx + 1;
        continue;
    end
    
    if valleyIdx > 1
        P_loc = valleyLocs(valleyIdx - 1);
    end
    
    if valleyIdx < length(valleyLocs)-1
        T_loc = valleyLocs(valleyIdx + 2);
    end
    
    % if Q R S is valley-peak-valley
    if Q_loc < R_loc && R_loc < S_loc
        peakIdx = peakIdx + 1;
        % add to locs array
        P_locs = [P_locs;P_loc];
        Q_locs = [Q_locs;Q_loc];
        R_locs = [R_locs;R_loc];
        S_locs = [S_locs;S_loc];
        T_locs = [T_locs;T_loc];
    end
end

hold on;
plot(P_locs, filteredData(P_locs), 'bo', 'MarkerSize', 10);
plot(Q_locs, filteredData(Q_locs), 'rs', 'MarkerSize', 10);
plot(R_locs, filteredData(R_locs), 'rv', 'MarkerSize', 10);
plot(S_locs, filteredData(S_locs), 'kx', 'MarkerSize', 10);
plot(T_locs, filteredData(T_locs), 'md', 'MarkerSize', 10);

plot(rawData, 'g--');
plot(filteredData, 'b');
% plot(valleyLocs, filteredData(valleyLocs), 'b^');

hold off;
set(gca,'XTick', [numSamplesPerSec:numSamplesPerSec:numSamples]);
set(gca,'XTickLabel', [1:10]);
legend('P', 'Q', 'R', 'S', 'T', 'ECG Raw Data', 'Filtered Data')
title('Analyzed ECG');
axis([0 numSamples minYLim maxYLim]);


% heart rate calculation and display
numPeaks = length(R_locs);
heartRate=(numPeaks * 60) / 10.0; % 60s in a min, 10s of samples
PR_dur = mean(R_locs - P_locs) / numSamplesPerSec;
QT_dur = mean(T_locs - Q_locs) / numSamplesPerSec;
QRS_dur = mean(S_locs - Q_locs) / numSamplesPerSec;

fprintf('Heart rate analysis\nHeart rate: %0.2f[b/m]\nP-R interval: %0.2f[s]\nQ-T interval: %0.2f[s]\nQRS interval: %0.2f[s]\n', heartRate, PR_dur, QT_dur, QRS_dur);

if PR_dur < 0.12 || PR_dur > 0.20
    fprintf('Your P-R interval is abnormal (0.12 to 0.20[s])\n')
end
if QT_dur >= 0.38
    fprintf('Your Q-T interval is abnormal (>= 0.38[s])\n')
end
if QRS_dur>0.1
    fprintf('Your QRS interval is abnormal (>= 0.1[s])\n')
end

