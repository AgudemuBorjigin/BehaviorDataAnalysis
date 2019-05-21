OS = 'Ubuntu';
rootDir = '/media/agudemu/Storage/Data/Behavior/';
subjs_ITD = subjNames(strcat(rootDir, 'ITD'));
rootDir = '/media/agudemu/Storage/Data/Behavior/';
subjs_FM = subjNames(strcat(rootDir, 'FM'));
rootDir = '/media/agudemu/Storage/Data/Behavior/';
subjs_Audiogram = subjNames(strcat(rootDir, 'Audiogram'));
rootDir = '/media/agudemu/Storage/Data/EEG/';
subjs_ITD_EEG = subjNames(strcat(rootDir, 'ITD'));
rootDir = '/media/agudemu/Storage/Data/EEG/';
subjs_FFR = subjNames(strcat(rootDir, 'FFR'));
rootDir = '/media/agudemu/Storage/Data/Behavior/';
subjs_HI = audiogramPop(rootDir, OS);
subjs_OD = {'S216', 'S218'};

subjs_Audiogram_FM = intersect(subjs_Audiogram, subjs_FM);
subjs_behavior = intersect(subjs_Audiogram_FM, subjs_ITD);
subjs_EEG_ITD_behavior = intersect(subjs_behavior, subjs_ITD_EEG); 
subjs_EEG_ITD_behavior_HI = intersect(subjs_EEG_ITD_behavior, subjs_HI);
subjs_EEG_ITD_behavior_NH = setdiff(subjs_EEG_ITD_behavior, subjs_EEG_ITD_behavior_HI);
subjs_All = intersect(subjs_EEG_ITD_behavior_NH, subjs_FFR);   

%% Behavior & EEG (ITD) dataset
fid = fopen('dataSetBehaviorEEG_ITD.csv', 'w');
fprintf(fid, 'Subject, ITD, FMleft, FMright, mistakeITD, mistakeFMLeft, mistakeFMRight, ERPn1lat180, ERPp2lat180\n');
numSubj = numel(subjs_EEG_ITD_behavior_NH);
load('ERP_n1lat180_NH_EEG_ITD');% variable: erp_n1lat180
load('ERP_p2lat180_NH_EEG_ITD');% variable: erp_p2lat180
for s = 1:numSubj
    subj{1} = subjs_EEG_ITD_behavior_NH{s};
    % ITD
    ITDs_tmp = dataExtraction(subj, OS, 'ITD3down1up', 'BothEar');
    ITDs = ITDs_tmp{1}.thresh;
    ITD_mean = mean(ITDs, 2);
    percentITD = obvsMistkCntr(ITDs_tmp{1}, 'ITD');
    % FM left
    FMs_Left_tmp = dataExtraction(subj, OS, 'FM', 'LeftEar');
    FMleft_tmp = FMs_Left_tmp{1}.thresh;
    FMleftMean = mean(FMleft_tmp);
    percentFM_left = obvsMistkCntr(FMs_Left_tmp{1}, 'FM');
    % FM right
    FMs_Right_tmp = dataExtraction(subj, OS, 'FM', 'RightEar');
    FMright_tmp = FMs_Right_tmp{1}.thresh;
    FMrightMean = mean(FMright_tmp);
    percentFM_right = obvsMistkCntr(FMs_Right_tmp{1}, 'FM');
    for b = 1
        fprintf(fid, '%s, %f, %f, %f, %f, %f, %f, %f, %f', ...
            subj{1}, ITD_mean, FMleftMean, FMrightMean, percentITD, percentFM_left, percentFM_right, ...
            erp_n1lat180(s), erp_p2lat180(s));
        fprintf(fid, '\n');
    end
    fprintf(fid, '\n');
end

%% Behavior & EEG (ITD&FFR) dataset
fid = fopen('dataSetBehaviorEEG_All.csv', 'w');
fprintf(fid, 'Subject, ITDmean, FMleft, FMright, mistakeITD, mistakeFMLeft, mistakeFMRight, FFRmag1K, n1lat180, p2lat180\n');
%mistakeITD, mistakeFMleft, mistakeFMright
%mag20us, mag60us, mag180us, mag540us, magAvg, magAvgExcld20us, n1lat20us, n1lat60us, n1lat180us, n1lat540us, n1latAvg, n1latAvgExcld20, p2lat20us, p2lat60us, p2lat180us, p2lat540us, p2latAvg, p2latAvgExcld20, itc20, itc60, itc180, itc540, itcAvg, itcAvgExd20, itclat20, itclat60, itclat180, itclat540, itclatAvg, itclatAvgExd20, itc20left, itc60left, itc180left, itc540left, itcAvgleft, itcAvgExd20left, itclat20left, itclat60left, itclat180left, itclat540left, itclatAvgleft, itclatAvgExd20left, itc20right, itc60right, itc180right, itc540right, itcAvgright, itcAvgExd20right, itclat20right, itclat60right, itclat180right, itclat540right, itclatAvgright, itclatAvgExd20right
numSubj = numel(subjs_All);
subj = cell(1, 1);
load('FFR_mag1K_NH'); % variable: FFR_mag1K_NH
load('ERP_n1lat180_NH.mat')
load('ERP_p2lat180_NH.mat')
for s = 1:numSubj
    subj{1} = subjs_All{s};
    % ITD
    ITDs_tmp = dataExtraction(subj, OS, 'ITD3down1up', 'BothEar');
    ITDs = ITDs_tmp{1}.thresh;
    ITD_mean = mean(ITDs, 2);
    percentITD = obvsMistkCntr(ITDs_tmp{1}, 'ITD');
    % FM left
    FMs_Left_tmp = dataExtraction(subj, OS, 'FM', 'LeftEar');
    FMleft_tmp = FMs_Left_tmp{1}.thresh;
    FMleft = mean(FMleft_tmp);
    percentFM_left = obvsMistkCntr(FMs_Left_tmp{1}, 'FM');
    % FM right
    FMs_Right_tmp = dataExtraction(subj, OS, 'FM', 'RightEar');
    FMright_tmp = FMs_Right_tmp{1}.thresh;
    FMright = mean(FMright_tmp);
    percentFM_right = obvsMistkCntr(FMs_Right_tmp{1}, 'FM');
    for b = 1
        fprintf(fid, '%s, %f, %f, %f, %f, %f, %f, %f, %f, %f', ...
            subjs_All{s}, ITD_mean, FMleft, FMright, percentITD, percentFM_left, percentFM_right, ...
            FFR_mag1K_NH(s), ...
            erp_n1lat180(s), erp_p2lat180(s));
        fprintf(fid, '\n');
    end
    fprintf(fid, '\n');
end

%% Behavior FM and ITD
fid = fopen('dataSetBehavior.csv', 'w');
fprintf(fid, 'Subject, ITDmean, ITDmedian, ITDmin, ITDmax, FMleftMean, FMleftMedian, FMleftMin, FMleftMax, FMrightMean, FMrightMedian, FMrightMin, FMrightMax, mistakeITD, mistakeFMLeft, mistakeFMRight, HL500left, HL500right\n');
numSubj = numel(subjs_behavior);

for s = 1:numSubj
    subj{1} = subjs_behavior{s};
    % ITD
    ITDs_tmp = dataExtraction(subj, OS, 'ITD3down1up', 'BothEar');
    ITDs = ITDs_tmp{1}.thresh;
    ITD_mean = mean(ITDs, 2);
    ITD_median = median(ITDs);
    ITD_max = max(ITDs);
    ITD_min = min(ITDs);
    percentITD = obvsMistkCntr(ITDs_tmp{1}, 'ITD');
    % FM left
    FMs_Left_tmp = dataExtraction(subj, OS, 'FM', 'LeftEar');
    FMleft_tmp = FMs_Left_tmp{1}.thresh;
    FMleftMedian = median(FMleft_tmp);
    FMleftMean = mean(FMleft_tmp);
    FMleftMin = min(FMleft_tmp);
    FMleftMax = max(FMleft_tmp);
    percentFM_left = obvsMistkCntr(FMs_Left_tmp{1}, 'FM');
    % FM right
    FMs_Right_tmp = dataExtraction(subj, OS, 'FM', 'RightEar');
    FMright_tmp = FMs_Right_tmp{1}.thresh;
    FMrightMedian = median(FMright_tmp);
    FMrightMean = mean(FMright_tmp);
    FMrightMin = min(FMright_tmp);
    FMrightMax = max(FMright_tmp);
    percentFM_right = obvsMistkCntr(FMs_Right_tmp{1}, 'FM');
    % Audiogram
    HLright = dataExtraction(subj, OS, 'Audiogram', 'RightEar');
    HLleft = dataExtraction(subj, OS, 'Audiogram', 'LeftEar');
    for b = 1
        fprintf(fid, '%s, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f', ...
            subjs_behavior{s}, ITD_mean, ITD_median, ITD_min, ITD_max, FMleftMean, FMleftMedian, FMleftMin, FMleftMax, FMrightMean, FMrightMedian, FMrightMin, FMrightMax,...
            percentITD, percentFM_left, percentFM_right, ...
            HLleft{1}.thresh(1), HLright{1}.thresh(1));
        fprintf(fid, '\n');
    end
    fprintf(fid, '\n');
end

%% ploting individual EEG response (itc) across conditions
% plot([20, 60, 180, 540], [mean(itc_20us), mean(itc_60us), mean(itc_180us), mean(itc_540us)]...
%    ,'-ro', 'LineWidth', 12, 'MarkerSize', 20);
% hold on;
% for i = 1:numel(itc_20us)
%     h = plot([20, 60, 180, 540], [itc_20us(i), itc_60us(i), itc_180us(i), itc_540us(i)], '--ko', ...
%         'LineWidth', 3, 'MarkerSize', 20);
%     hold on;
% end
% [~, hobj2, ~, ~] = legend('Average', 'Individual subject', 'location', 'best');
% hLine = findobj(hobj2, 'type', 'line');
% set(hLine, 'LineWidth', 4);
% title('ITD-evoked response across ITDs');
% htext = findobj(hobj2, 'type', 'text');
% set(htext, 'FontSize', 30);
% 
% xticklabels({'20', '60', '180', '540'});
% xticks([20, 60, 180, 540]);
% % set(gca,'xtick',[])
% % set(gca,'xticklabel',[])
% ylabel('Normalized magnitude');
% xlabel('ITD [us]');
% set(gca, 'FontSize', 45);