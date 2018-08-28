function dataArray = dataExtraction(subjs, pcType, stimType, earType)
dataArray = cell(1, numel(subjs));
for s = 1:numel(subjs)
    subjID = subjs{s};
    if strcmp(subjID(end-1:end), 'DD')
        subjID = subjID(1:end-2);
    end
    
    if strcmp(pcType, 'Mac') % CHANGE AS NEEDED
        rootDir = '/Users/baoagudemu1/Desktop/Lab/PilotExperiment/DataAnalysis/Data/';
    elseif strcmp(pcType, 'Ubuntu')
        rootDir = '/media/agudemu/Storage/Data/Behavior/';
    end
    
    if strcmp(stimType, 'FM')
        dataDir = strcat(rootDir, subjID, '_behavior/', subjs(s), '_', earType);
    elseif strcmp(stimType, 'ITD3down1up')
        dataDir = strcat(rootDir, subjID, '_behavior/', subjs(s), '_3down1up');
    elseif strcmp(stimType, 'ITD')
        dataDir = strcat(rootDir, subjID, '_behavior/', subjs(s));
    end
    
    allFiles = dir(strcat(dataDir{1}, '/*.mat')); % this makes sure hidden files are not included
    thresholds = zeros(1, numel(allFiles));
    for i = 1:numel(allFiles)
        fileName = allFiles(i).name;
        fileDir = strcat(dataDir, '/', fileName);
        load(fileDir{1});
        if strcmp(stimType, 'ITD') || strcmp(stimType, 'ITD3down1up')
            thresholds(i) = round(thresh*1e6, 1);
        else
            thresholds(i) = thresh;
        end
    end
    result = struct('subj', subjs(s),'thresh', thresholds);
    dataArray{s} = result;
end
end