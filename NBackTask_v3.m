%% NBackTask.m

% Script Written By:
% Kevin Japardi, 20161029
% UCLA, Department of Psychiatry and Biobehavioral Sciences
% kjapardi@gmail.com

% Last Updated: Kevin Japardi 20170602

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Run 1: BLOCK ORDER
% A: Neutral | Negative | Neutral | Negative
% B: Negative | Neutral | Negative | Neutral

% 20 pictures for each set of images

% TRIAL STRUCTURE
% Task (0.5 seconds) | ISI (2.5 seconds)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Run 2: BLOCK ORDER
% A: Neutral 3 foreground, Neutral 4 background
% B: Neutral 4 background, Neutral 3 foreground

% TRIAL STRUCTURE
% Task (0.750 seconds) | ISI (2.5 seconds)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Necessary Directories and Files
% Task Input
%   - images
%       - Negative_Set1 (run1)
%           - 80 .jpg
%       - Negative_Set2 (run2 background)
%           - 94 .jpg
%       - Neutral_Set1 (run1)
%           - 80 .jpg
%       - Neutral_Set2 (run2 background)
%           - 94 .jpg
%       - Neutral_Set3 (run2 foreground)
%           - 188 .jpg
%       - Practice_Set
%           - 15 .jpg images
%   - list1.txt, list2.txt, list3.txt, list4.txt
% Data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;

%% SCRIPT DETAILS & INPUTS
script = struct('name', 'NBackTask.m', 'PsychtoolboxVersion', PsychtoolboxVersion, 'matlabVersion', version);
script.path = which(script.name);

design.list = [];
var = struct('fonttype', 'Helvetica', 'fontsize', 40, 'durations', [0.5 2.5 0]);
response.timing = []; response.key = {};
flip.trial = []; flip.isi = [];

conditions = {'Neutral', 'Negative'; 'Negative', 'Neutral'};

design.subjectID = input('Enter Subject ID #: '); % Subject ID
type = input('Behavioral [1] or Practice [2]: '); % Is this a real session or practice?
design.run = input('Enter Run # [1 or 2]: '); % Run #

%% INSTRUCTION LOAD

if design.run == 1
    instructions = ['You will see a series of images on the screen\n\n'...
        'Press [1] if the picture on the screen\n'...
        'MATCHES the one you saw two trials back\n\n'...
        'Press [2] if the picture on the screen\n'...
        'DOES NOT MATCH the one you saw two trials back\n\n\n'...
        'Please press [1] to continue'];
elseif design.run == 2
    instructions = ['You will see a series of image pairs:\n'...
        'a background scene and a smaller picture of a single object (foreground)\n\n'...
        'Press [1] if the foreground image on the screen\n'...
        'MATCHES the one you saw two trials back\n\n'...
        'Press [2] if the foreground image on the screen\n'...
        'DOES NOT MATCH the one you saw two trials back\n\n'...
        'Please press [1] to continue'];
end

%% TRIAL SETUP & IMAGE LOAD
if type == 1
    design.assignment = input('Block Order [1 or 2]: '); % Determines the order of Neutral/Negative alternations or Neutral3/Neutral4 usage
    design.type = 'behav';

    for n = 1:4
        lists(:,:,n) = dlmread(['TaskInputs/list', num2str(n), '.txt']);
    end

    for m = 1:4
        order = lists(:,4,m);
        design.list(:,m) = 1:size(lists,1);
        for n = 3:length(order)
            if order(n) == 1 % 2-back
                design.list(n,m) = design.list(n-2,m);
            elseif order(n) == 4 % 3-back
                design.list(n,m) = design.list(n-3,m);
            elseif order(n) == 5 % 1-back
                design.list(n,m) = design.list(n-1,m);
            end
        end
    end
    
    if design.run == 1
        for n = 1:2
            images = dir(['TaskInputs/images/', conditions{design.assignment,n},'_Set1/*.jpg']);
            images = {images.name};
            images = images(randperm(length(images)));
            design.images(:,n) = images(design.list(:,n));
            
            subimages = images(~ismember(images, images(design.list(:,n))));
            design.images(:,n+2) = subimages(design.list(:,n+2));
        end
        
    elseif design.run == 2
        var.durations = [0.5 2.5 0.25];
        
        % Background Stimuli
        for n = 1:2
            images = dir(['TaskInputs/images/', conditions{design.assignment,n},'_Set2/*.jpg']);
            images = {images.name};
            images = images(randperm(length(images)));
            design.images(:, [n n+2], 1) = reshape(images, [length(design.list),2]);
        end
        
        % Foreground Stimuli
        images = dir('TaskInputs/images/Neutral_Set3/*.jpg');
        images = {images.name};
        images = images(randperm(length(images)));

        design.images(:, 1, 2) = images(design.list(:,1));
        for n = 2:4
            subimages = images(~ismember(images, images(design.list(:, n))));
            design.images(:, n, 2) = subimages(design.list(:, n));
        end
    end

    flag = [1 2 1 2];
    for m = 1:size(design.list,2)
        for n = 1:size(design.list,1)
            if design.run == 1
                imagecode{n,m} = imread(['TaskInputs/images/', conditions{design.assignment, flag(m)}, '_Set1/', design.images{n,m,1}]);
            elseif design.run == 2
                imagecode{n,m} = imread(['TaskInputs/images/', conditions{design.assignment, flag(m)}, '_Set2/', design.images{n,m,1}]);
                fgimagecode{n,m} = imread(['TaskInputs/images/Neutral_Set3/', design.images{n,m,2}]);
            end
        end
    end

elseif type == 2
    design.run = input('Practice Run # [1 or 2]: '); % Run #
    
    design.assignment = 1;
    design.type = 'prac';
    design.list = [1 2 3 2 4 5 4 6 7 8 7 8 9 10 11 12 13 12 14 15]';
    
    if design.run == 1
        images = dir('TaskInputs/images/Practice_Set/*.jpg');
        images = {images.name};
        
        for n = 1:length(design.list)
            design.images(n) = images(design.list(n));
            imagecode{n} = imread(['TaskInputs/images/Practice_Set/', design.images{n}]);
        end
    elseif design.run == 2
        images = dir('TaskInputs/images/Practice_Set/*.jpg');
        images = {images.name};
        
        images = images(randperm(length(images)));
        design.images(1,:,1) = images(design.list);
        
        images = images(randperm(length(images)));
        design.images(1,:,2) = images(1:length(design.list));
        
        for n = 1:length(design.list)
            if design.run == 1
                imagecode{n,m} = imread(['TaskInputs/images/Practice_Set/', design.images{1,n,1}]);
            elseif design.run == 2
                imagecode{n,m} = imread(['TaskInputs/images/Practice_Set/', design.images{1,n,1}]);
                fgimagecode{n,m} = imread(['TaskInputs/images/Practice_Set/', design.images{1,n,2}]);
            end
        end
    end
end

%% BUTTON INFO
KbName('UnifyKeyNames');
FlushEvents('keyDown');
allowedKeys = {'1', '2', '1!', '2@'};

devices = PsychHID('Devices');
devices = {devices.usageName};
keyboardname = find(strcmp('Keyboard', devices));

%% INITIALIZE SCREEN
Screen('Preference', 'VisualDebugLevel', 1);
[w, wrect] = Screen('OpenWindow', 0, 0);
HideCursor;

fgdim = [wrect(3:4).*(2.5/5) wrect(3:4).*(3.5/5)];

white = WhiteIndex(w); black = BlackIndex(w);
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

Screen('TextFont', w, var.fonttype);
Screen('TextSize', w, 30);
DrawFormattedText(w, instructions, 'center', 'center', white);
Screen('Flip',w);

while 1
    [~, var.abs_start, keyCode] = KbCheck(-1);
    if keyCode(KbName('1!')) || keyCode(KbName('!'))
        break;
    end
end

Screen('TextFont', w, var.fonttype);
Screen('TextSize', w, var.fontsize);
DrawFormattedText(w, 'Press "5" to start...', 'center', 'center', white);
Screen('Flip',w);

while 1
    [~, var.abs_start, keyCode] = KbCheck(-1);
    if keyCode(KbName('5%'))
        break;
    end
end

%% NBACK TASK
DrawFormattedText(w, '4', 'center', 'center', white);
Screen('Flip', w, var.abs_start);
for n = 3:-1:1
    DrawFormattedText(w, num2str(n), 'center', 'center', white);
    Screen('Flip', w, var.abs_start + abs(n-4));
end

for n = 1:numel(design.images(:,:,1))
    % N-Back Trial Images
    tIndex = Screen('MakeTexture', w, imagecode{n});
    Screen('DrawTextures', w, tIndex);
    flip.trial(n) = Screen('Flip', w, (n-1)*sum(var.durations) + var.abs_start + 4);

    if design.run == 2
        Screen('DrawTextures', w, tIndex);
        fgIndex = Screen('MakeTexture', w, fgimagecode{n});
        Screen('DrawTextures', w, fgIndex, [], fgdim);
        flip.fg(n) = Screen('Flip', w, flip.trial(n) + var.durations(3));
    end
    
    basetime = GetSecs;
    while 1
        if GetSecs - basetime > var.durations(1)
            response.timing(n) = nan; response.RT(n) = nan; response.key{n} = 'nan';
            break;
        end
        WaitSecs(0.001);

        [~, response.timing(n), keyCode] = KbCheck(keyboardname);
        key = KbName(keyCode);
        
        if design.run == 1
            response.RT(n) = response.timing(n) - flip.trial(n) + var.durations(3);
        elseif design.run == 2
            response.RT(n) = response.timing(n) - flip.fg(n) + var.durations(3);
        end

        if ~isempty(key)
            % if they pressed two keys at the same time, just take first one
            if iscell(key)
                key = key{1};
            end

            % Only looking at the first option of that key
            if ismember(key(1), allowedKeys)
                response.key{n} = key(1);
                break;
            end
        end
    end

    % Inter-Stimulus Intervals
    DrawFormattedText(w, '+', 'center', 'center', white);
    if design.run == 1
        flip.isi(n) = Screen('Flip', w, flip.trial(n) + var.durations(1) + var.durations(3));
    elseif design.run == 2
        flip.isi(n) = Screen('Flip', w, flip.fg(n) + var.durations(1) + var.durations(3));
    end
        
    basetime = GetSecs;
    while 1
        if ~isnan([response.timing(n) response.RT(n)]) & ~strcmp(response.key{n}, 'nan')
            break
        end

        if GetSecs - basetime > var.durations(2)
            response.timing(n) = nan; response.RT(n) = nan; response.key{n} = 'nan';
            break;
        end
        WaitSecs(0.001);

        [~, response.timing(n), keyCode] = KbCheck(keyboardname);
        key = KbName(keyCode);
        if design.run == 1
            response.RT(n) = response.timing(n) - flip.trial(n) + var.durations(3);
        elseif design.run == 2
            response.RT(n) = response.timing(n) - flip.fg(n) + var.durations(3);
        end

        if ~isempty(key)
            % if they pressed two keys at the same time, just take first one
            if iscell(key)
                key = key{1};
            end

            % Only looking at the first option of that key
            if ismember(key(1), allowedKeys)
                response.key{n} = key(1);
                break;
            end
        end
    end
end

DrawFormattedText(w, 'Run Complete', 'center', 'center', white);
Screen('Flip', w, flip.isi(end) + var.durations(2));
WaitSecs(1);

flip.trial = flip.trial - var.abs_start;
flip.isi = flip.isi - var.abs_start;

if design.run == 2
    flip.fg = flip.fg - var.abs_start;
end

response.timing = response.timing - var.abs_start;
save(['Data/Nback_', num2str(design.subjectID), '_EPI1_', design.type, '_', num2str(design.run), '.mat'], 'script', 'design', 'var', 'response', 'flip');
Screen('CloseAll');
    






