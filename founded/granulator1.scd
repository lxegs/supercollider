(
~buffer=Buffer.read(s,"D:/Sound Material/My Lib/Detunized/DTS004 - Vox Populi Vol 1/Samples/Detunized Samples/Voxpop1/a-1dec13.wav");

~granulator={
	Warp1.ar(~buffer.numChannels,
		~buffer.bufnum,
		([MouseX.kr(0,1),
			MouseY.kr(0,1)]*BufDur.kr(~buffer))+TRand.kr(0,0.1,Impulse.kr(400)),
		[MouseX.kr(0,2),
			MouseY.kr(0,2)]**WhiteNoise.ar([MouseX.kr(0,2),
			MouseY.kr(0,2)]),
		[MouseX.kr(0.05,60),
			MouseY.kr(0.05,60),
			MouseY.kr(0.05,60)],
		-1,8,1,4,1,0)};
)

~granulator.scope;

~granulator.stop;



/* TODO

granulator free method (add in variable)
set buffer in real-time (set method)
add params to set in real-time (set method)
Warp1 arguments ?? alternatives ??
replace MouseX/MouseY by Line/Env



*/

