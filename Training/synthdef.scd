{SinOsc.ar(440,0,0.5)}.scope

SynthDef("sinus_oscillator",{Out.ar(0,SinOsc.ar(440,0,0.5))}).play

(
SynthDef("sine_oscillator",{
var out, freq=440;
out=SinOsc.ar(freq,0,0.5);
Out.ar(0,out)
}).add;
Synth("sine_oscillator");
)

(
SynthDef("grains_synth", {
	var out, trigger,duration,freq;
	trigger=Impulse.kr(10);
	duration=0.2;
	freq=WhiteNoise.kr.range(4,40,880);
	out=SinGrain.ar(trigger,duration,freq);
	Out.ar(0,out)
}).add;
Synth("grains_synth");
)

(
SynthDef(\some_grains, {
	arg gate = 1 , amp = 1;
	var out;
	out=FMGrain.ar(
		Impulse.ar(20),0.2,440,200,
		LFNoise1.kr(1).range(1,10),
		EnvGen.kr(
			Env([0,1,0],[1,1], \sin,1),gate,
		levelScale: amp,
		doneAction: 2));
	Out.ar(0,out);
	Out.ar(1,out);
}).add;)
Synth("some_grains");
