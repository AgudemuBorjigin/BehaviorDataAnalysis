OS = 'Ubuntu';

%% ITD3down1up
% Note that different day testing needs to be added right after its previous  
subjs = {'Satya', 'SatyaDD', 'Kristen', 'Rav', 'S116', 'Anna', 'Bre', 'S117', 'S117DD', 'S128', 'S132', 'S078', 'S149', ...
    'S123', 'S143', 'S084', 'S072', 'S046', 'S043', 'S127', 'S133', 'S075'}; 
%---------------------------------------------------------------------------
%Do we need to re-test the following subjects (paradigm was chaneged after them): 'Satya', 'SatyaDD', 'Kristen', 'Rav', 'S116', 'Anna', 'Bre'
%---------------------------------------------------------------------------
numSubj = numel(subjs);

dataArrayITD = dataExtraction(subjs, OS, 'ITD3down1up', 'BothEar');
% variance, mean of the first, last half, and the whole session can be
% computed for storage and saved
% save('dataITD3down1up.mat', 'dataArray');
figure;
legendInfo = cell(1, numSubj);

for s = 1:numSubj
    dataTmp = dataArrayITD{s};
    subjName = dataTmp.subj;
    if strcmp(subjName(end-1:end), 'DD')
        LineStyle = '--';
        Color = h.Color;
        h = plot(dataTmp.thresh, 'LineStyle', LineStyle, 'Marker', 'o', 'LineWidth', 2, 'Color', Color);
    else
        LineStyle = '-';
        h = plot(dataTmp.thresh, 'LineStyle', LineStyle, 'Marker', 'o', 'LineWidth', 2);
    end
    hold on;
    legendInfo{s} = dataTmp.subj;
end
xlabel('Repetitions');
ylabel('ITDs [us]');
title('ITD detection thresholds across repetitions');
legend(legendInfo);

% Box plot
figure;
threshSet = [];
nameSet = cell(1, numSubj * numel(dataArrayITD{1}.thresh));
for s = 1:numSubj
    threshSet = [threshSet, dataArrayITD{s}.thresh];  %#ok<AGROW>
    for i = 1:numel(dataArrayITD{s}.thresh)
        nameSet{(s-1)*numel(dataArrayITD{s}.thresh) + i} = dataArrayITD{s}.subj;
    end
end
boxplot(threshSet, nameSet);
ylabel('ITD [us]');
title('ITD thresholds for all subjects');

%% FM 
subjs = {'Rav', 'S116', 'Anna', 'S117', 'S128', 'S132', 'S078', 'S149', 'S123', 'S143', 'S084', 'S072', 'S046', 'S043', 'S127',...
    'S133', 'S075'}; 

dataArrayFMLeft = dataExtraction(subjs, OS, 'FM', 'LeftEar');
dataArrayFMRight = dataExtraction(subjs, OS, 'FM', 'RightEar');
% variance, mean of the first, last half, and the whole session can be
% computed for storage
%save('dataFM.mat', 'dataArrayLeft');
%save('dataFM.mat', 'dataArrayRight');

% Box plot
figure;
boxplot_thresh(dataArrayFMLeft, subjs, 'FM');
figure;
boxplot_thresh(dataArrayFMRight, subjs, 'FM');

%% Hearing threshold
subjs = {'S117', 'S128', 'S132', 'S078', 'S149', 'S123', 'S143', 'S084', 'S072', 'S046'}; 
dataArrayHLLeft = dataExtraction(subjs, OS, 'FM', 'LeftEar');
dataArrayHLRight = dataExtraction(subjs, OS, 'FM', 'RightEar');
%% Changes in data
% means = zeros(1, numel(subjs));
% meansLast4 = zeros(1, numel(subjs));
% meansFirst4 = zeros(1, numel(subjs));
% varsLast4 = zeros(1, numel(subjs));
% varsFirst4 = zeros(1, numel(subjs));
% vars = zeros(1, numel(subjs));
% meanDiffDD = zeros(1, numel(subjs));
% varDiffDD = zeros(1, numel(subjs));

%     % some data collection
%     means(s) = dataTmp.mean;
%     meansLast4(s) = dataTmp.meanLast4;
%     meansFirst4(s) = dataTmp.meanFirst4;
%     varsLast4(s) = dataTmp.varianceLast4;
%     vars(s) = dataTmp.variance;
%     varsFirst4(s) = dataTmp.varianceFirst4;
%     if strcmp(subjName(end-1:end), 'DD')
%         meanDiffDD(s) = abs(means(s) - means(s-1));
%         varDiffDD(s) = abs(varsLast4(s) - varsLast4(s-1));
%     else
%         meanDiffDD(s) = 0;
%         varDiffDD(s) = 0;
%     end
% varAcrossSubjs = var(means); % How to calculate across-subject variance? 
% varDiffLas4vsAll = varsLast4 - vars;
% varDiffLast4vsFirst4 = varsLast4 - varsFirst4;
% meanDiffLast4vsAll = meansLast4 - means;
% meanDiffLast4vsFirst4 = meansLast4 - meansFirst4;

% save('dataITD3down1up.mat', 'means', 'meansLast4', 'meansFirst4', 'vars', 'varsLast4', 'varsFirst4', 'varDiffLas4vsAll', 'varDiffLast4vsFirst4', ...
%     'meanDiffLast4vsAll', 'meanDiffLast4vsFirst4', 'meanDiffDD', 'varDiffDD');
