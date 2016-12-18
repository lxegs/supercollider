~houston = Buffer.read(s, "sounds/a11wlk01-44_1.aiff");
~chooston = Buffer.read(s, "sounds/a11wlk01.wav");

{PlayBuf.ar(1,~houston)}.play;
{PlayBuf.ar(1,~chooston)}.play;


[~houston.bufnum, ~houston.numChannels, ~houston.path, ~houston.numFrames];

[~chooston.bufnum, ~chooston.numChannels, ~chooston.path, ~chooston.numFrames];

(  // phasing
{
	var rate, trigger2, frames2;
	frames2 = ~chooston.numFrames; // or use ~chooston.numFrames

	rate = [1, 1.01];
	trigger2 = Impulse.kr(rate);
	PlayBuf.ar(1, ~chooston,rate:1,trigger:trigger2, frames:frames2 * Line.kr(0, 1, 60)) *
		EnvGen.kr(Env.linen(0.01, 0.96, 0.01), trigger2) * rate;
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



