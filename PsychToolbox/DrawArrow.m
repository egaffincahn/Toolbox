function flip_time = DrawArrow(w, errorVector, color, doFlip)

if nargin < 3 || isempty(color)
    color = [0 0 0];
end

screenSize = Screen('Rect', w);

x = -errorVector(1);
y = errorVector(2);
lengthVector = sqrt(x^2+y^2);
arrowAngle = atan2(x,y);
rotation = [cos(arrowAngle), -sin(arrowAngle); sin(arrowAngle), cos(arrowAngle)];
arrowSize = 2-2*exp(-(lengthVector/50)^2);

xCtopleft = 100;
yCtopleft = 50;
xCtopright = screenSize(3)-100;
yCtopright = 50;
xCbottomleft = 100;
yCbottomleft = screenSize(4)-50;
xCbottomright = screenSize(3)-100;
yCbottomright = screenSize(4)-50;

points = [0 -50; -25 0; -12.5 0; -12.5 50; 12.5 50; 12.5 0; 25 0];
pointsScaled = arrowSize * points;
pointsRotated = (rotation * pointsScaled')';

Screen('FillPoly', w, color, bsxfun(@plus, pointsRotated, [xCtopleft yCtopleft]), []);
Screen('FillPoly', w, color, bsxfun(@plus, pointsRotated, [xCtopright yCtopright]), []);
Screen('FillPoly', w, color, bsxfun(@plus, pointsRotated, [xCbottomleft yCbottomleft]), []);
Screen('FillPoly', w, color, bsxfun(@plus, pointsRotated, [xCbottomright yCbottomright]), []);

if nargin < 4 || doFlip
    flip_time = Screen('Flip', w);
else
    flip_time = GetSecs;
end
