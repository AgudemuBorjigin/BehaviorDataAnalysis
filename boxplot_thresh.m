function boxplot_thresh(data, subjs, stimType) % data contain thresholds

threshSet = [];
nameSet = cell(1, numel(subjs) * numel(data{1}.thresh));
for s = 1:numel(subjs)
    threshSet = [threshSet, data{s}.thresh];  %#ok<AGROW>
    for i = 1:numel(data{s}.thresh)
        nameSet{(s-1)*numel(data{s}.thresh) + i} = data{s}.subj;
    end
end
boxplot(threshSet, nameSet);
if strcmp(stimType, 'FM')
    ylabel('FM [Hz]');
    title('FM thresholds for all subjects');
elseif strcmp(stimType, 'ITD') || strcmp(stimType, 'ITD3down1up')
    ylabel('ITD [us]');
    title('ITD thresholds for all subjects');
end
end