~houston = Buffer.read(s, "sounds/a11wlk01-44_1.aiff");
~chooston = Buffer.read(s, "sounds/a11wlk01.wav");

{PlayBuf.ar(1,~houston)}.play;
{PlayBuf.ar(1,~chooston)}.play;


[~houston.bufnum, ~houston.numChannels, ~houston.path, ~houston.numFrames];

[~chooston.bufnum, ~chooston.numChannels, ~chooston.path, ~chooston.numFrames];

(  // phasing
{
	var rate, trigger, frames;
	frames = ~chooston.numFrames; // or use ~chooston.numFrames

	rate = [1, 1.01];
	trigger = Impulse.kr(rate);
	PlayBuf.ar(1, ~chooston,1,trigger, frames * Line.kr(0, 1, 60)) *
		EnvGen.kr(Env.linen(0.01, 0.96, 0.01), trigger) * rate;
}.play;
)

(  // speed and direction change
{
	var speed, direction;
	speed = LFNoise0.kr(12) * 0.2 + 1;
	direction = LFClipNoise.kr(1/3);
	PlayBuf.ar(1, ~houston, (speed * direction), loop: 1);
}.scope(zoom:4);
)

// Using Bus for controls
(
~kbus1 = Bus.control;
~kbus2 = Bus.control;
{
	var speed, direction;
	speed = In.kr(~kbus1, 1) * 0.2 +1;
	direction = In.kr(~kbus2);
	PlayBuf.ar(1, ~chooston, (speed * direction), loop: 1);
}.scope;
)
(
// now starts the controls
{Out.kr(~kbus1, LFNoise0.kr(12).scope)}.play;
{Out.kr(~kbus2, LFClipNoise.kr(1/4))}.play;
)
/* Now start the second buffer with the same control input buses,
but send it to the right channel using Out.ar(1 etc.) */
({
var speed, direction;
speed = In.kr(~kbus1, 1) * 0.2 + 1;
direction = In.kr(~kbus2);
Out.ar(1, PlayBuf.ar(1, ~houston, (speed * direction), loop: 1));
}.play;
)

~kbus3 = Bus.control; // a control bus
~kbus4 = Bus.control; // a control bus
{Out.kr(~kbus3, SinOsc.kr(3).scope("out3") * 100)}.play;
{Out.kr(~kbus4, LFPulse.kr(1/3).scope("out4") * 200)}.play;
{Out.ar(0, SinOsc.ar(In.kr(~kbus3) + In.kr(~kbus4) + 440).scope("left"))}.play;
{Out.ar(1, SinOsc.ar(In.kr(~kbus3) + In.kr(~kbus4) + 880).scope("right"))}.play;

// combined with SynthDef
~kbus3 = Bus.control; // a control bus
~kbus4 = Bus.control; // a control bus
{Out.kr(~kbus3, SinOsc.kr(3).range(340, 540))}.play;
{Out.kr(~kbus4, LFPulse.kr(6).range(240, 640))}.play;
SynthDef("Switch", {arg freq = 440; Out.ar(0, SinOsc.ar(freq, 0, 0.3)) }).add;
x = Synth("Switch"); // default

x.map(\freq, ~kbus3);
x.map(\freq, ~kbus4);


