(
//~buffer=Buffer.read(s,"D:/Sound Material/My Lib/Detunized/DTS004 - Vox Populi Vol 1/Samples/Detunized Samples/Voxpop1/a-1dec13.wav");

~buffer=Buffer.read(s,"sounds/a11wlk01.wav");
~buffer.bufnum.postln;

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

// granulator in SynthDef

(
p = Platform.resourceDir +/+ "sounds/a11wlk01.wav";
b = Buffer.read(s, p);

SynthDef(\granulator, {
	arg soundfile;
	var numberchannels, numberbuffer, out;
	numberchannels = soundfile.numChannels;



	out = Warp1.ar(numberchannels,b.bufnum,([MouseX.kr(0,1),MouseY.kr(0,1)]*BufDur.kr(soundfile))+TRand.kr(0,0.1,Impulse.kr(400)),[MouseX.kr(0,2),MouseY.kr(0,2)]**WhiteNoise.ar([MouseX.kr(0,2),MouseY.kr(0,2)]),[MouseX.kr(0.05,60),MouseY.kr(0.05,60),MouseY.kr(0.05,60)],-1,8,1,4,1,0);

	Out.ar(0, out);
}).add.send(s);
)

x=Synth(\granulator, [\soundfile, b]);
s.scope;
x.free;





/* TODO

display arguments name
granulator free method (add in variable)
set buffer in real-time (set method)
add params to set in real-time (set method)
Warp1 arguments ?? alternatives ??
replace MouseX/MouseY by Line/Env



*/

