% this code move rgb videos from a MoSeq folder into a new folder suitable for DeepLabCut analysis, also rename those rgb video by mice names and date

cd /media/alex/DataDrive1/MoSeqData/combineL_tmp/

groupname='combineL_tmp';
rootpath=cd;
mkdir([groupname '_DLC']);
cd([groupname '_MoSeq']);

folderpath = cd;
folderd = dir(folderpath);
isub = [folderd(:).isdir];
foldernames = {folderd(isub).name}';
foldernames(ismember(foldernames,{'.','..'})) = [];
folderlen=length(foldernames);

for i=1:folderlen
    disp(i)
    cd(foldernames{i});

    subfolderpath = cd;
    subd = dir(subfolderpath);
    subisub = [subd(:).isdir];
    subfoldernames = {subd(subisub).name}';
    subfoldernames(ismember(subfoldernames,{'.','..'})) = [];
    subfolderlen=length(subfoldernames);

    for j=1:subfolderlen %%%%%%%%%%%%%%%%%%%%%
        disp(j)
        cd(subfoldernames{j});

        mkdir([rootpath '/' groupname '_DLC' '/' foldernames{i}],subfoldernames{j})

        ssubfolderpath = cd;
        ssubd = dir(ssubfolderpath);
        ssubisub = [ssubd(:).isdir];
        ssubfoldernames = {ssubd(ssubisub).name}';
        ssubfoldernames(ismember(ssubfoldernames,{'.','..'})) = [];
        ssubfolderlen=length(ssubfoldernames);

        for k=1:ssubfolderlen
            disp(k)
            cd(ssubfoldernames{k});
            
            if(isfile('depth_ts.txt'))%'rgb.mp4'))
%                 movefile('rgb.mp4',   [rootpath '/' groupname '_DLC' '/' foldernames{i} '/' subfoldernames{j} '/' ...
%                     foldernames{i} '_' subfoldernames{j} '_' char(sprintfc('%02d', k)) '_' 'rgb.mp4'])
%                 movefile('rgb_ts.txt',[rootpath '/' groupname '_DLC' '/' foldernames{i} '/' subfoldernames{j} '/' ...
%                     foldernames{i} '_' subfoldernames{j} '_' char(sprintfc('%02d', k)) '_' 'rgb_ts.txt'])
                copyfile('depth_ts.txt',[rootpath '/' groupname '_DLC' '/' foldernames{i} '/' subfoldernames{j} '/' ...
                    foldernames{i} '_' subfoldernames{j} '_' char(sprintfc('%02d', k)) '_' 'depth_ts.txt'])
%                   copyfile('depth_ts.txt',[rootpath '/' groupname '_DLC' '/' foldernames{i} '/' ...
%                       foldernames{i} '_' subfoldernames{j} '_' char(sprintfc('%02d', k)) '_' 'depth_ts.txt'])
            end

            cd ..

        end

        cd ..
    
    end

    cd ..

end

cd
