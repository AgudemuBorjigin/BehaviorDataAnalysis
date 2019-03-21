OS = 'Ubuntu';

subjs_EEG = {'S025', 'S031', 'S046', 'S117', 'S123', 'S127', 'S128', 'S132', 'S133', ...
    'S149', 'S051', 'S183', 'S187', 'S189', 'S193', 'S195', 'S196', 'S043', 'S072', 'S075', 'S078', ...
    'S135', 'S194', 'S197', 'S199', 'S191', 'S084'}; 
subjs = {'S025', 'S031', 'S046', 'S117', 'S123', 'S127', 'S128', 'S132', 'S133', 'S135', 'S143', ...
    'S149', 'S051', 'S183', 'S185', 'S187', 'S189', 'S192', 'S193', 'S194', 'S195', 'S196', 'S197', 'S199',...
    'S043', 'S072', 'S075', 'S078', 'S084', 'S191'};  
% removed 'S173' since it doesn't have audiogram
%% EEG data in the order of subjects listed in subjs_EEG
% ITC, average of auditory channels
load('ITC20'); load('ITC60'); load('ITC180'); load('ITC540'); load('ITCavg'); load('ITCavgExd20');
load('ITClat20'); load('ITClat60'); load('ITClat180'); load('ITClat540'); load('ITClatAvg'); load('ITClatAvgExd20');
load('ITC20left'); load('ITC60left'); load('ITC180left'); load('ITC540left'); load('ITCavgleft'); load('ITCavgExd20left');
load('ITClat20left'); load('ITClat60left'); load('ITClat180left'); load('ITClat540left'); load('ITClatAvgleft'); load('ITClatAvgExd20left');
load('ITC20right'); load('ITC60right'); load('ITC180right'); load('ITC540right'); load('ITCavgright'); load('ITCavgExd20right');
load('ITClat20right'); load('ITClat60right'); load('ITClat180right'); load('ITClat540right'); load('ITClatAvgright'); load('ITClatAvgExd20right');
% normalized magnitude relative to the onset erp (N1-P2), Cz channel
load('ERP20'); load('ERP60'); load('ERP180'); load('ERP540'); load('ERPavg'); load('ERPavgExd20');
% n100 latency
load('ERP_N1Lat_20'); load('ERP_N1Lat_60'); load('ERP_N1Lat_180'); load('ERP_N1Lat_540'); load('ERP_N1Lat_Avg'); load('ERP_N1Lat_AvgExd20');
% p200 latency
load('ERP_P2Lat_20'); load('ERP_P2Lat_60'); load('ERP_P2Lat_180'); load('ERP_P2Lat_540'); load('ERP_P2Lat_Avg'); load('ERP_P2Lat_AvgExd20');
% percent of easy mistakes
load('PercentMistakesFMleft'); load('PercentMistakesFMright'); load('PercentMistakesITD');
%% Behavior & EEG dataset
fid = fopen('dataSetBhvrEEG.csv', 'w');
fprintf(fid, 'Subject, ITD, FMleft, FMright, 500Hzleft, 500Hzright, 4000Hzleft, 4000Hzright, block, prctMstkITD, prctMstkFMleft, prctMstkFMright, mag20us, mag60us, mag180us, mag540us, magAvg, magAvgExcld20us, n1lat20us, n1lat60us, n1lat180us, n1lat540us, n1latAvg, n1latAvgExcld20, p2lat20us, p2lat60us, p2lat180us, p2lat540us, p2latAvg, p2latAvgExcld20, itc20, itc60, itc180, itc540, itcAvg, itcAvgExd20, itclat20, itclat60, itclat180, itclat540, itclatAvg, itclatAvgExd20, itc20left, itc60left, itc180left, itc540left, itcAvgleft, itcAvgExd20left, itclat20left, itclat60left, itclat180left, itclat540left, itclatAvgleft, itclatAvgExd20left, itc20right, itc60right, itc180right, itc540right, itcAvgright, itcAvgExd20right, itclat20right, itclat60right, itclat180right, itclat540right, itclatAvgright, itclatAvgExd20right\n');

numSubj = numel(subjs_EEG);
dataArrayITD = dataExtraction(subjs_EEG, OS, 'ITD3down1up', 'BothEar');
dataArrayFMleft = dataExtraction(subjs_EEG, OS, 'FM', 'LeftEar');
dataArrayFMright = dataExtraction(subjs_EEG, OS, 'FM', 'RightEar');
dataArrayHL_left = dataExtraction(subjs_EEG, OS, 'Audiogram', 'LeftEar');
dataArrayHL_right = dataExtraction(subjs_EEG, OS, 'Audiogram', 'RightEar');


for s = 1:numSubj
    ITDs = dataArrayITD{s}.thresh;
    ITDs = mean(ITDs);
    FMleftTmp = dataArrayFMleft{s};
    FMleftTmp = FMleftTmp(1);
    FMleft = mean(FMleftTmp.thresh);
    FMrightTmp = dataArrayFMright{s};
    FMrightTmp = FMrightTmp(1);
    FMright = mean(FMrightTmp.thresh);
    HLleft = dataArrayHL_left{s}.thresh;
    HLright = dataArrayHL_right{s}.thresh;
    freqs = dataArrayHL_left{s}.freqs;
    for b = 1:numel(ITDs)
        fprintf(fid, '%s, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f, ', ...
            subjs_EEG{s}, ITDs, FMleft, FMright, HLleft(freqs == 500), HLright(freqs == 500), HLleft(freqs == 4000), HLright(freqs == 4000), b, ...
            prctMstkITD(s), prctMstkFMleft(s), prctMstkFMright(s),...
            erp20(s), erp60(s), erp180(s), erp540(s), erpAvg(s), erpAvgExd20(s), ...
            n1lat20(s), n1lat60(s), n1lat180(s), n1lat540(s), n1latAvg(s), n1latAvgExd20(s), ...
            p2lat20(s), p2lat60(s), p2lat180(s), p2lat540(s), p2latAvg(s), p2latAvgExd20(s), ...
            ITC20(s), ITC60(s), ITC180(s), ITC540(s), ITCavg(s), ITCavgExd20(s), ...
            ITClat20(s), ITClat60(s), ITClat180(s), ITClat540(s), ITClatAvg(s), ITClatAvgExd20(s), ...
            ITC20left(s), ITC60left(s), ITC180left(s), ITC540left(s), ITCavgleft(s), ITCavgExd20left(s), ...
            ITClat20left(s), ITClat60left(s), ITClat180left(s), ITClat540left(s), ITClatAvgleft(s), ITClatAvgExd20left(s), ...
            ITC20right(s), ITC60right(s), ITC180right(s), ITC540right(s), ITCavgright(s), ITCavgExd20right(s), ...
            ITClat20right(s), ITClat60right(s), ITClat180right(s), ITClat540right(s), ITClatAvgright(s), ITClatAvgExd20right(s));
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

%% Model of ITD-evoked response 
fid = fopen('dataSetEEG.csv', 'w');
fprintf(fid, 'Subject, EEG_ITC, Conditions, ITD_avg, FM_avg\n');
numSubj = numel(subjs_EEG);
conditions = [20, 60, 180, 540]; % change as needed
for s = 1:numSubj
    ITDs = dataArrayITD{s}.thresh;
    ITDavg = mean(ITDs);
    FMleftTmp = dataArrayFMleft{s};
    FMleftTmp = FMleftTmp(1);
    FMleft = mean(FMleftTmp.thresh);
    FMrightTmp = dataArrayFMright{s};
    FMrightTmp = FMrightTmp(1);
    FMright = mean(FMrightTmp.thresh);
    FMavg = (FMleft + FMright)/2;
    EEGs = [EEG_20us(s), EEG_60us(s), EEG_180us(s), EEG_540us(s)];
    
    for b = 1:numel(EEGs)
        fprintf(fid, '%s, %f, %f, %f, %f', subjs_EEG{s}, EEGs(b), conditions(b), ITDavg, FMavg);
        fprintf(fid, '\n');
    end
    fprintf(fid, '\n');
end