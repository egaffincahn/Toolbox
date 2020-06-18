% In the schematic, waitDur is two ticks (two IFIs). We call VBL=Flip(...)
% and then the second VBL=Flip(...) with the WHEN argument. The WHEN amount
% is equal to the first VBL+waitDur-slack. We want the screen to update
% waitDur seconds after the first VBL (thus VBL+waitDur). The flip command
% will wait until the WHEN amount is up and then wait until the next
% refresh. In the case that there is some jittering or randomness in the
% system and the VBL+waitDur happens to be a microsecond after the refresh
% that we wanted it to update during, it will have to wait a whole
% additional refresh. Therefore, we subtract slack (VBL+waitDur-slack) so
% that it gets ready half of an IFI before it refreshes:
%
%     |-------------------|-------------------|-------------------| = system ticks
%     |___________________| = IFI
%     |_______________________________________| = waitDur (two system ticks)
%                                  |__________| = slack = IFI/2
%                          VBL+waitDur-slack
%  VBL=Flip#1                              VBL=Flip#2
%
% EG Gaffin-Cahn
% 2013

RED = [255 0 0]; GREEN = [0 255 0];
[w rect] = Screen('OpenWindow',max(Screen('Screens')));

IFI = Screen('GetFlipInterval',w); % interflip interval
waitDur = IFI*100; % duration that RED will be on the screen
if mod(waitDur/IFI,1) > 1.0001
    error('waitDur must be a multiple of 1/screen refresh rate')
end
slack = IFI/2;

Screen('FillRect',w,RED);
% returns the sync time (equivalent to calling GetSecs on the next line but
% more accurate) with the refresh the buffer flipped with
VBLTimestamp = Screen('Flip',w);

Screen('FillRect',w,GREEN);
when = VBLTimestamp + waitDur - slack;
VBL2 = Screen('Flip',w,when);

WaitSecs(3);

Screen('CloseAll');

calc = 1000*(VBL2-VBLTimestamp);
param = 1000*waitDur;

fprintf('\n\n\nThe time between the two flips (according to the PTB timestamps)\n')
fprintf('was %.3f ms. Your desired interstimulus interval was %.3f ms.\n',calc,param)
fprintf('These numbers should be < 1ms difference (%.3f ms).\n\n\n',abs(calc-param))