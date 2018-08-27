function [threshArray, meanThresh, closestPerCorr] = BehaviorDataAnalysis(subjID, StimulusType, LeftOrRight)
if strcmp(StimulusType, 'ITD')
    filePath = strcat('/media/agudemu/Storage/Data/Behavior/', subjID, '_behavior/', subjID);
elseif strcmp(StimulusType, 'FM')
    filePath = strcat('/media/agudemu/Storage/Data/Behavior/', subjID, '_behavior/', subjID, '_', LeftOrRight);
elseif strcmp(StimulusType, 'ITD3down1up')
    if strcmp(subjID(end-1:end), 'DD')
        subjIDOriginal = subjID(1:end-2);
    else
        subjIDOriginal = subjID;
    end
    filePath = strcat('/media/agudemu/Storage/Data/Behavior/', subjIDOriginal, '_behavior/', subjID, '_3down1up');
end
files = dir(strcat(filePath,'/*.mat'));
threshArray = zeros(1,numel(files));
ListPmtr = cell(1, numel(files));
ListResp = cell(1, numel(files));
trialTotal = zeros(1, numel(files));
for i = 1:numel(files)
    fileName = files(i).name;
    load(strcat(filePath, '/', fileName));
    if strcmp(StimulusType, 'FM')
        ListPmtr{i} = fdevList;
        ListResp{i} = respList;
        threshArray(i) = thresh;
        trialTotal(i) = numel(fdevList);
        for j = 1:numel(respList)
            respList(j) = respList(j) - 0.01*j; % to separate the responses (at the same parameters) for the sake of visualization 
        end
        figure(1);
        plot(fdevList, respList-0.02*(i-1), 'o'); 
    else
        ListPmtr{i} = ITDList*1e6;
        ListResp{i} = respList;
        threshArray(i) = thresh*1e6;
        trialTotal(i) = numel(ITDList);
        for j = 1:numel(respList)
            respList(j) = respList(j) - 0.01*j; % to separate the responses (at the same parameters) for the sake of visualization 
        end
        figure(1);
        plot(ITDList*1e6, respList-0.02*(i-1), 'o');
    end
    hold on;
end
meanThresh = mean(threshArray); % average of means from different repetitions
PmtrAllWithZero = [];
for i = 1:numel(files)
    PmtrAllWithZero = [PmtrAllWithZero,  ListPmtr{i}];
end
if strcmp(StimulusType, 'ITD')
    PmtrAllWithZero = int16(PmtrAllWithZero); % the first zero ITD or frequency deviation is not technically zero, rather it's a very small number
end
PmtrAll = PmtrAllWithZero(PmtrAllWithZero ~= 0); % excluding 0 ITDs or frequency deviation
RespAllWithZero = [];
for i = 1:numel(files)
   RespAllWithZero = [RespAllWithZero, ListResp{i}]; 
end
RespAll = RespAllWithZero(PmtrAllWithZero ~= 0);

% the number of responses excluding responses to zero ITDs or frequency
% deviation 
NumGuess = sum(RespAll(PmtrAll<meanThresh));
NumWrong = numel(RespAll(PmtrAll<meanThresh))-NumGuess;
NumCorrect = sum(RespAll(PmtrAll>meanThresh));
NumMistakes = numel(RespAll(PmtrAll>meanThresh))-NumCorrect;

% the number of responses including responses to zero ITDs or frequency
% deviation
NumGuessWithZero = sum(RespAllWithZero(PmtrAllWithZero<meanThresh));
NumWrongWithZero = numel(RespAllWithZero(PmtrAllWithZero<meanThresh))-NumGuessWithZero;
NumCorrectWithZero = sum(RespAllWithZero(PmtrAllWithZero>meanThresh));
NumMistakesWithZero = numel(RespAllWithZero(PmtrAllWithZero>meanThresh))-NumCorrectWithZero;

% percent correct calculation below each ITD that is in the range of ITD
% measured
ITDFdevs = unique(PmtrAll);
numOnes = zeros(1, numel(ITDFdevs));
numZeros = zeros(1, numel(ITDFdevs));
ITDFdevs = double(min(ITDFdevs)): 0.01 : double(max(ITDFdevs));
perCorr = zeros(1, numel(ITDFdevs));
ITDFdevsWithZeros = unique(PmtrAllWithZero);
for i = 1:numel(ITDFdevs)
    numResp = numel(RespAll(PmtrAll <= ITDFdevs(i)));
    corrs = sum(RespAll(PmtrAll <= ITDFdevs(i)));
    perCorr(i) = corrs/numResp;
end
[~, indexITDFdev] = min(abs(perCorr - 0.75));
Thresh = ITDFdevs(indexITDFdev);
closestPerCorr = perCorr(indexITDFdev)*100;

% plotting the reference line for two thresholds
plot([Thresh, Thresh], [-1.5, 1], 'g');
plot([meanThresh, meanThresh], [-1.5,1], 'r'); 
if strcmp(StimulusType, 'ITD3down1up')
    plot([0, 400], [0, 0], 'r');
end

annotation('textbox', [.2 .5 .3 .3], 'String', strcat('Num of guesses: ', num2str(NumGuessWithZero)), 'FitBoxToText', 'on');
annotation('textbox', [.2 .2 .3 .3], 'String', strcat('Num of wrong answers: ', num2str(NumWrongWithZero)), 'FitBoxToText', 'on');
annotation('textbox', [.5 .5 .3 .3], 'String', strcat('Num of correct answers: ', num2str(NumCorrectWithZero)), 'FitBoxToText', 'on');
annotation('textbox', [.5 .2 .3 .3], 'String', strcat('Num of mistakes: ', num2str(NumMistakesWithZero)), 'FitBoxToText', 'on');

if strcmp(StimulusType, 'FM')
    title(strcat('Subject response: ', subjID, LeftOrRight));
else
    title(strcat('Subject response: ', subjID));
end

if strcmp(StimulusType, 'FM')
    xlabel('Fdev [Hz]');
    unit = 'Hz';
else
    xlabel('ITD [us]');
    unit = 'us';
end
ylabel('Correct or wrong');
legend(strcat('Adjusted threshold---', num2str(Thresh), unit, ',at', num2str(closestPerCorr),'%'), strcat('meanThreshold---', num2str(meanThresh), unit, ', at', ...
    num2str(NumGuessWithZero/(NumGuessWithZero + NumWrongWithZero)*100), '%'));

% ones and zeros as a function of ITDs
for i = 1:numel(ITDFdevsWithZeros)
    % number of responses with responses to the zero ITDs included
    respITDFdev = RespAllWithZero(PmtrAllWithZero == ITDFdevsWithZeros(i));
    numOnes(i) = sum(respITDFdev);
    numZeros(i) = numel(respITDFdev) - numOnes(i);
end
figure(2);
plot(ITDFdevsWithZeros, numOnes, '-.ko');
hold on;
plot(ITDFdevsWithZeros, numZeros, '--b*');
hold on;
plot([meanThresh, meanThresh], [0,80], 'r');
plot([Thresh, Thresh], [0, 80], 'g');
if strcmp(StimulusType, 'FM')
    xlabel('Fdev [Hz]');
    title(strcat('Number of ones and zeros vs Fdevs: ', subjID, LeftOrRight));
    
else
    xlabel('ITD [us]');
    title(strcat('Number of ones and zeros vs ITDs: ', subjID));
end
ylabel('Number of responses');
legend('Correct', 'Wrong', strcat('meanThreshold---', num2str(meanThresh), unit, ',at', num2str(NumGuessWithZero/(NumGuessWithZero + NumWrongWithZero)*100), '%'), ...
    strcat('Adjusted threshold---', num2str(Thresh), unit, ', at', num2str(closestPerCorr), '%'));
str = {strcat('Num of corrects below threshold: ', num2str(NumGuessWithZero)), ...
    strcat('Num of total responses below threshold: ', num2str(NumGuessWithZero+NumWrongWithZero)), ...
    strcat('Percent correct: ', num2str(NumGuessWithZero/(NumGuessWithZero + NumWrongWithZero)*100), '%')};
annotation('textbox', [.2 .5 .3 .3], 'String', str, 'FitBoxToText', 'on');
% Percent correct
% figure(3);
% PmtrUnique = unique(PmtrAll);
% PmtrReps = histc(PmtrAll, PmtrUnique); % repetitions of an ITD
% percentCorrt = zeros(1, numel(PmtrUnique));
% for i = 1:numel(PmtrUnique)
%     correct = sum(RespAll(PmtrAll == PmtrUnique(i)));
%     percentCorrt(i) = correct/PmtrReps(i)*100;
% end
% plot(PmtrUnique, percentCorrt, 'o');
% xlabel('ITD [us]');
% ylabel('Percent correct [%]');
% title('Percent corrects vs ITDs');
% Parameter trace plot
figure(4);
for i = 1:numel(files)
    if i == 1
        trialNumTtl = trialTotal(i);
        plot(1:trialNumTtl, ListPmtr{i},'-o');
    else
        plot((trialNumTtl + 1):(trialNumTtl + trialTotal(i)), ListPmtr{i},'-o');
        trialNumTtl = trialNumTtl + trialTotal(i);
    end
    hold on;
end
if strcmp(ITDOrFM, 'ITD')
    ylabel('ITD [us]');
else
    ylabel('Frequency deviation [Hz]');
end
title(strcat('Parameter trace: ', subjID));
xlabel('Number of trials');
end
