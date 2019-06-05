OS = 'Ubuntu';

rootDir = '/media/agudemu/Storage/Data/Behavior/';
subjs_Audiogram = subjNames(strcat(rootDir, 'Audiogram'));
rootDir = '/media/agudemu/Storage/Data/Behavior/';
subjs_HI = audiogramPop(rootDir, OS);
subjs_NH = setdiff(subjs_Audiogram, subjs_HI);
subjs_OD = {'S216', 'S218'};

rootDir = '/media/agudemu/Storage/Data/Behavior/';
subjs_FM = subjNames(strcat(rootDir, 'FM'));
subjs_FM = intersect(subjs_FM, subjs_NH);

rootDir = '/media/agudemu/Storage/Data/Behavior/';
subjs_ITD = subjNames(strcat(rootDir, 'ITD'));
subjs_ITD = intersect(subjs_ITD, subjs_NH);

subjs_behavior = intersect(subjs_FM, subjs_ITD);

rootDir = '/media/agudemu/Storage/Data/EEG/';
subjs_ITD_EEG = subjNames(strcat(rootDir, 'ITD'));

rootDir = '/media/agudemu/Storage/Data/EEG/';
subjs_FFR = subjNames(strcat(rootDir, 'FFR'));


subjs_EEG_ITD_behavior = intersect(subjs_ITD_EEG, subjs_ITD);

subjs_All = intersect(subjs_EEG_ITD_behavior, subjs_FFR);   

%% Behavior & EEG (ITD) dataset
fid = fopen('dataSetBehaviorEEG_ITD.csv', 'w');
fprintf(fid, 'Subject, ITD, FMleft, FMright, mistakeITD, mistakeFMLeft, mistakeFMRight, ERPn1lat180, ERPp2lat180\n');
numSubj = numel(subjs_EEG_ITD_behavior);
load('ERP_n1lat180_NH_EEG_ITD');% variable: erp_n1lat180
load('ERP_p2lat180_NH_EEG_ITD');% variable: erp_p2lat180
for s = 1:numSubj
    subj{1} = subjs_EEG_ITD_behavior{s};
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
fprintf(fid, 'Subject, ITDmean, FMleft, FMright, mistakeITD, mistakeFMLeft, mistakeFMRight, FFRmag1K, FFRmag500, FFRplv500, FFRplv1K, n1lat180, p2lat180\n');

load('FFR_mag1K_NH'); load('FFR_mag1K_good');
load('FFR_mag1K_NH_Cz'); load('FFR_mag1K_good_Cz');
load('FFR_mag500_NH_Cz'); load('FFR_mag500_good_Cz');
load('FFR_plv500_NH_Cz'); load('FFR_plv500_good_Cz');
load('FFR_plv1K_NH_Cz'); load('FFR_plv1K_good_Cz');
load('ERP_n1lat180_NH.mat'); load('ERP_n1lat180_good');
load('ERP_p2lat180_NH.mat'); load('ERP_p2lat180_good');
load('goodSubjs');
numSubj = numel(subjs_All);
subj = cell(1, 1);

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
        fprintf(fid, '%s, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f', ...
            subjs_All{s}, ITD_mean, FMleft, FMright, percentITD, percentFM_left, percentFM_right, ...
            FFR_mag1K_NH_Cz(s), FFR_mag500_NH_Cz(s),...
            FFR_plv500_NH_Cz(s), FFR_plv1K_NH_Cz(s),...
            erp_n1lat180(s), erp_p2lat180(s));
        fprintf(fid, '\n');
    end
    fprintf(fid, '\n');
end

%% Behavior FM and ITD
fid = fopen('dataSetBehavior.csv', 'w');
fprintf(fid, 'Subject, ITDmean, ITDmedian, ITDmin, ITDmax, FMleftMean, FMleftMedian, FMleftMin, FMleftMax, FMrightMean, FMrightMedian, FMrightMin, FMrightMax, mistakeITD, mistakeFMLeft, mistakeFMRight, HL500left, HL500right, HL4Kleft, HL4Kright\n');
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
        fprintf(fid, '%s, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f', ...
            subjs_behavior{s}, ITD_mean, ITD_median, ITD_min, ITD_max, FMleftMean, FMleftMedian, FMleftMin, FMleftMax, FMrightMean, FMrightMedian, FMrightMin, FMrightMax,...
            percentITD, percentFM_left, percentFM_right, ...
            HLleft{1}.thresh(1), HLright{1}.thresh(1), HLleft{1}.thresh(4), HLright{1}.thresh(4));
        fprintf(fid, '\n');
    end
    fprintf(fid, '\n');
end

%% ploting individual EEG response (itc) across conditions
load('ITC_mag_both.mat');
itc_mag_both = 20*log10(itc_mag_both);
h_avg = plot([20, 60, 180, 540], [meanWithNan(itc_mag_both(:, 1)), meanWithNan(itc_mag_both(:, 2)), ... 
    meanWithNan(itc_mag_both(:, 3)), meanWithNan(itc_mag_both(:, 4))],'-rs', 'LineWidth', 4, 'MarkerSize', 10);
set(h_avg, 'markerfacecolor', get(h_avg, 'color'));

itc_size = size(itc_mag_both);
hold on;
for i = 1:itc_size(1)
    h = plotWithNan([20 60 180 540], itc_mag_both(i, 1:4));
    hold on;
end
[~, hobj, ~, ~] = legend('Average', 'Individual subject', 'location', 'best');
hLine = findobj(hobj, 'type', 'line');
set(hLine, 'LineWidth', 2);
htext = findobj(hobj, 'type', 'text');
set(htext, 'FontSize', 8);
% title('ITD-evoked response across ITDs');

xticklabels({'20', '60', '180', '540'});
xticks([20, 60, 180, 540]);
% set(gca,'xtick',[])
% set(gca,'xticklabel',[])
ylabel('Normalized magnitude [dB]');
xlabel('ITD [us]');
set(gca, 'FontSize', 10);