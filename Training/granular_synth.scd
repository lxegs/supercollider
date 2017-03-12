/*** grainsine.scd granular synthesis using sine wave ***/

(
{
	var trig, dur, freq;
	dur = 1/40;
	trig = Impulse.ar(1/dur);
	freq = TRand.ar(440, 880, trig);
	GrainSin.ar(1, trig, dur, freq)
}.play
)

(
SynthDef(\grainsine,{

	|freq = 440, amp = 1, dur = 0.05|
	var env, output;
	env = EnvGen.ar(Env.triangle(dur, amp), doneAction : 2);
	output = SinOsc.ar(freq, mul : amp);
	OffsetOut.ar(0, output)

}).add
)

(
Pbind(
	\instrument, \grainsine,
	\freq, Pseq(Array.fill(1000,{rrand(100,10000)})),
	\amp, Pseq(Array.fill(1000,{exprand(0.05, 0.2)})),
	\dur, 0.01
).play
)