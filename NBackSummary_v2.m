%% NBackTask Summary File Creation

% Script Written By:
% Kevin Japardi, 11/30/2016
% UCLA, Department of Psychiatry and Biobehavioral Sciences
% kjapardi@gmail.com

% Last Updated: Kevin Japardi 20170602

% Creates summary files for NBack Task participants

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ['Data/Nback_', num2str(design.subjectID), '_EPI1_', design.type, '_', num2str(design.run), '.mat']
% 'script', 'design', 'var', 'response', 'flip'
% flip.fg(n)

close all;
clear all;

mfiles = dir('Data/Nback*.mat');
mfiles = {mfiles.name};

for m = 1:length(mfiles)
    output = ['SummaryFiles/', mfiles{m}(1:10), '_summary.txt'];
    if ~exist(output, 'file')
        load(['Data/', mfiles{m}]);
        fid = fopen(output, 'w+');
        
        if strcmp(mfiles{m}(end-4), '1')
            fprintf(fid, 'ID\tTrialNumber\tImageFile\tKeyPressed\tRT\tAccuracy\n');
        elseif strcmp(mfiles{m}(end-4), '2')
            fprintf(fid, 'ID\tTrialNumber\tFGImageFile\tBGImageFile\tKeyPressed\tRT\tAccuracy\n');
            bgimages = design.images(:,:,1);
            fgimages = design.images(:,:,2);
        end
        
        for n = 1:numel(design.list)
            if n >= 3
                if design.list(n) == design.list(n-2)
                    if strcmp(response.key{n}, '1')
                        acc = 1;
                    else
                        acc = 0;
                    end
                elseif design.list(n) ~= design.list(n-2)
                    if strcmp(response.key{n}, '2')
                        acc = 1;
                    else
                        acc = 0;
                    end
                end
            elseif n < 3
                if strcmp(response.key{n}, '1')
                    acc = 1;
                else
                    acc = 0;
                end
            end
            
            if strcmp(mfiles{m}(end-4), '1') % ID, TrialNumber, ImageFile, KeyPressed, RT, Accuracy
                fprintf(fid, '%s\t%.f\t%s\t\t%s\t%.3f\t%.f\n', mfiles{m}(1:10), n, design.images{n}, response.key{n}, response.RT(n), acc);
            elseif strcmp(mfiles{m}(end-4), '2') % ID, TrialNumber, FGImageFile, BGImageFile, KeyPressed, RT, Accuracy
                fprintf(fid, '%s\t%.f\t%s\t%s\t\t%s\t%.3f\t%.f\n', mfiles{m}(1:10), n, fgimages{n}, bgimages{n}, response.key{n}, response.RT(n), acc);
            end
        end
    end
end



