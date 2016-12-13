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
{Synth("grains_synth")}.scope;
)

