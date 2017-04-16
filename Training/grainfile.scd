/*** grainfile.scd ***/

d=SoundFile.use(Platform.resourceDir +/+ "sounds/a11wlk01.wav", {|f| f.duration});

b=Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

(
SynthDef(\grainfile,{|buffer=0, pos=0, dur=1, amp=1|
	var rate, output, env;
	rate = BufRateScale.ir(buffer);
	output = PlayBuf.ar(1, buffer, rate, 1, pos, 1);
	env = EnvGen.ar(Env.linen(dur/100, dur*0.98, dur/100, amp), doneAction:2);
	OffsetOut.ar(0, output*env)
}).add
)

(

var clouds = 0!4;

clouds[0] = Pbind(
	\instrument, \grainfile,
	\buffer, b,
	\pos, 0,
	\dur, Pseries(0.1, 0.1, 8)++Pseq([d]),
	\amp, 1,
);

clouds[1] = Pbind(
	\instrument, \grainfile,
	\buffer, b,
	\pos, 70000,
	\dur, Pgeom(1, 0.9, 20),
	\amp, 1,
);

clouds[2] = Pbind(
	\instrument, \grainfile,
	\buffer, b,
	\pos, 70000,
	\dur, Pwhite(0.15, 0.25, 100),
	\amp, Pseq((0.99, 0.98..0)/100, 100),
);

clouds[3] = Pbind(
	\instrument, \grainfile,
	\buffer, b,
	\pos, Pwhite(0, 100000, 100),
	\dur, Pwhite(0.15, 0.25, 100),
	\amp, Pseq((0.01, 0.02..1)/10, 100),
);

Routine{
	Pseq([clouds[0], clouds[1]]).play;
	(14.8223).wait;
	100.do{Ppar([clouds[2], clouds[3]]).play}
}.play
)