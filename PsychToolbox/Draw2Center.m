function VBL = Draw2Center(window, text, x, y, color, wrapat, flipHorizontal, flipVertical, vSpacing, righttoleft, winRect, doFlip)

if nargin < 3 || isempty(x)
    x = 'center';
end
if nargin < 4 || isempty(y)
    y = 'center';
end
if nargin < 5 || isempty(color)
    color = [];
end
if nargin < 6 || isempty(wrapat)
    wrapat = [];
end
if nargin < 7 || isempty(flipHorizontal)
    flipHorizontal = [];
end
if nargin < 8 || isempty(flipVertical)
    flipVertical = [];
end
if nargin < 9 || isempty(vSpacing)
    vSpacing = [];
end
if nargin < 10 || isempty(righttoleft)
    righttoleft = [];
end
if nargin < 11 || isempty(winRect)
    winRect = [];
end
if nargin < 12 || isempty(doFlip)
    doFlip = true;
end

DrawFormattedText(window, text, x, y, color, wrapat, flipHorizontal, flipVertical, vSpacing, righttoleft, winRect);
if doFlip
    VBL = Screen('Flip', window);
else
    VBL = GetSecs;
end


