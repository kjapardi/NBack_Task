%% imagetest.m

images = {'2235.jpg', '2383.jpg'};

for n = 1:length(images)
    imagecode{n} = imread(['TaskInputs/images/Practice_Set/', images{n}]);
end

Screen('Preference', 'VisualDebugLevel', 1);
[w, wrect] = Screen('OpenWindow', 0, 0);
HideCursor;

fgdim = [wrect(3:4).*(1/5) wrect(3:4).*(4/5)];

white = WhiteIndex(w); black = BlackIndex(w);
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

tIndex = Screen('MakeTexture', w, imagecode{1});
fgIndex = Screen('MakeTexture', w, imagecode{2});

Screen('DrawTextures', w, tIndex);
Screen('Flip', w);

WaitSecs(2);
% 
% Screen('DrawTextures', w, tIndex);
% Screen('DrawTextures', w, fgIndex, [], fgdim);
% Screen('Flip', w);
% 
% WaitSecs(2);

Screen('DrawTextures', w, [tIndex, fgIndex], [], [[], fgdim]);
Screen('Flip', w);

WaitSecs(2);
Screen('CloseAll');


%%
% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Make our sprial texure into a screen texture for drawing
spiralTexture = Screen('MakeTexture', window, spiral);

% Define the destination rectangles for our spiral textures. For this demo
% we will make the left hand destination rectangle half the size of the
% texture, the middle one the same size as the texture and the right hand
% on 1.25 times the size of the texture
[s1, s2] = size(x);
baseRect = [0 0 s1 s2];
dstRects = nan(4, 3);
dstRects(:, 1) = CenterRectOnPointd(baseRect .* 0.5, screenXpixels * 0.2, yCenter);
dstRects(:, 2) = CenterRectOnPointd(baseRect, screenXpixels * 0.5, yCenter);
dstRects(:, 3) = CenterRectOnPointd(baseRect .* 1.25, screenXpixels * 0.8, yCenter);

