
(
p = Platform.resourceDir +/+ "sounds/a11wlk01.wav";
b = Buffer.read(s, p);

SynthDef(\FMGrains, {
	arg gate = 1, amp = 1, rate = 10, maxgrains = 512, soundfile;
	var trigger, dur, carfreq, modfreq, index, pan, env, numberchannels, numberbuffer, out;
	//numberchannels = soundfile.numChannels;

	trigger = Impulse.ar(rate);
	dur = rate.reciprocal;
	carfreq = LFNoise2.kr.range(100, 110);
	modfreq = LFTri.kr(0.1).exprange(200, 840);
	index = LFCub.kr(0.2).range(4, 10);
	pan = WhiteNoise.ar.range(-0.1, 0.1);
	env = EnvGen.kr(
		Env([0,1,0], [1, 1], \sin, 1),
		gate,
		levelScale: amp,
		doneAction: 2);
	Out.ar(0,
		GrainBuf.ar(2, trigger, dur * 10, b, 1, b.bufnum, maxGrains: maxgrains) * env)
}).add;
)

a = Synth(\FMGrains, [\rate, 80, \amp, 0.4, \maxgrains, 1024]);
b = Synth(\FMGrains, [\rate, 42, \amp, 0.2, \maxgrains, 512]);
c = Synth(\FMGrains, [\rate, 121, \amp, 0.2, \maxgrains, 512]);

[a,b,c].do({arg thisSynth; thisSynth.set(\gate, 0, \maxgrains, 2048)});

