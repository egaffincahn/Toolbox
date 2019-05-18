% HOW TO MAKE GOOD SOUNDS IN PSYCHTOOLBOX
%
% EG Gaffin-Cahn
% 2014


% parameters:
hz = 1500; % frequency of sound in hz
duration = .25; % how long the sounds last (seconds)


% I advise not changing any of these:
fq = 10000; % irrelevant number, as long as it's used consistently
channels = 1; % single channel for output
lowlevel = 0; % raise this number if you really care about sound timing

% Either make a beep using a PTB function:
sound = MakeBeep(hz,duration,fq);
% or load in your own sound:
% sound = wavread('chicken.wav');


% call these once at the beginning of the experiment:
InitializePsychSound;
pahandle = PsychPortAudio('Open',[],[],lowlevel,fq,channels);
PsychPortAudio('FillBuffer', pahandle, sound);



% when you want it play, put this in. Note that the audio will start and
% will continue while matlab goes on to the next line of code
PsychPortAudio('Start', pahandle);

% just so you can hear it before it closes
WaitSecs(2);

% at end of the experiment call this once:
PsychPortAudio('Close',pahandle);