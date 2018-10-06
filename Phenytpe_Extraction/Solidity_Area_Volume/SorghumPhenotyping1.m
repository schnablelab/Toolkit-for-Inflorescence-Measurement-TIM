%%%% Code to extract the following traits from Sorghum panicles with BLUE
%%%% CLAY: (1) Width - median and std; (2) Length (3) Bushiness (4)Hue
%%%% (5) Area and (6) Width distribution for volume

%%%%% Srikant Srinivasan, IIT Mandi, Jan 2017

clear

FolderList = dir;

FolderList(~[FolderList.isdir])=[]; FolderList(1:2)=[];

FolderList = {FolderList.name}';

for kk = 1:size(FolderList)
    
    SubFolderList = dir(FolderList{kk});
    
    SubFolderList(~[SubFolderList.isdir])=[]; SubFolderList(1:2)=[];
    
    SubFolderList = {SubFolderList.name}';
    
    for jj = 1 : size(SubFolderList)
        
        images = dir(fullfile(FolderList{kk}, SubFolderList{jj}, '*.jpg'));
        
        images = {images.name}';
        
        if isempty(images) || isempty(strmatch('Panicle', images))
            
            continue
        end
        
        
        RGB = imread( fullfile(FolderList{kk}, SubFolderList{jj},images{1}) );
        
        Ihsv = rgb2hsv(RGB);
        
        BW1 = createMaskBlueBack(Ihsv);
        BW2 = RGB(:,:,1) > 0;
        
        BW2= BW1 & BW2;
        
        BW2 = imerode(BW2, ones(5));
        
        BW2 = bwareafilt(BW2,1);
        
        BW2 = imdilate(BW2, ones(5));
        
        stats = regionprops(BW2, 'Area', 'MajorAxisLength', 'Solidity');
        
        WidthProfile = sum(BW2,2);
        
        WidthProfile(WidthProfile <1) = [];
        
        MedWidth = median(WidthProfile);
        
        StdWidth = std(WidthProfile);
        
        Ihsv(repmat(~BW2, [1 1 3])) = 0;
        
        Median_hue = median(median(Ihsv(:,:,1)));
        
        Median_sat = median(median(Ihsv(:,:,2)));
               
        tableprops = table([stats.MajorAxisLength, MedWidth, StdWidth, stats.Area, stats.Solidity, ...
            Median_hue, Median_sat]);
        
        tableprops.Properties.VariableNames = {'Length', 'MedWidth', 'StdWidth', 'Area', 'Solidity', ...
            'Median_hue', 'Median_sat'};
        
        writetable( tableprops, fullfile(FolderList{kk}, SubFolderList{jj}, ...
            strcat(images{1}(1:end-4), '.txt') ) );
        
        fileID = fopen( fullfile(FolderList{kk}, SubFolderList{jj},'WidthProfile.txt'), 'w');
        
        fprintf(fileID, '%d\n', round(WidthProfile));
        
        fclose(fileID);
    end
    
end