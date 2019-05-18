function DrawWaitbar(window, fraction)

fraction = min(max(fraction, 0), 1); % make sure fraction is between 0 and 1
rect = Screen('Rect', window);
xc = rect(3)/2;
yc = rect(4)/2;
w = 100;
phi = (1+sqrt(5))/2;
h = w / phi;
Screen('FrameRect', window, [0 255 255], [xc-w/2, yc-h/2, xc+w/2, yc+h/2], 2);
Screen('FillRect', window, [0 255 255], [xc-w/2+(1-fraction)*w, yc-h/2, xc+w/2, yc+h/2]);
Screen('Flip', window);
