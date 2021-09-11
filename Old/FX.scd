~houston = Buffer.read(s, "sounds/a11wlk01-44_1.aiff");
~chooston = Buffer.read(s, "sounds/a11wlk01.wav");


({Out.ar(0,Pan2.ar( PlayBuf.ar(1, ~houston, loop: 1) * SinOsc.ar(LFNoise0.kr(12, mul: 500, add: 600)),0.5))}.scope
)
(
{
var source, delay;

 source = PlayBuf.ar(1, ~chooston, loop: 1);

 delay = AllpassC.ar(source, 2, [0.65, 1.15], 10);

 Out.ar(0,

 Pan2.ar(source,source*delay) + delay

 )
}.play
)


///////////// Figure 1.11 FX routing using buses.

// Create and name buses
~delay = Bus.audio(s, 2);
~mod = Bus.audio(s, 2);
~gate = Bus.audio(s, 2);
~k5 = Bus.control;

{Out.kr(~k5, LFNoise0.kr(4))}.play; // start the control

// Start the last item in the chain, the delay
{Out.ar(0, AllpassC.ar(In.ar(~delay, 2), 2, [0.65, 1.15], 10))}.play

// Start the next to last item, the modulation
{Out.ar(~delay, In.ar(~mod, 2) * SinOsc.ar(In.kr(~k5)*500 + 1100))}.play

// Start the third to last item, the gate
{Out.ar([0, ~mod], In.ar(~gate, 2) * max(0, In.kr(~k5)))}.play

// Start one buffer
{Out.ar(~gate, Pan2.ar(PlayBuf.ar(1, ~houston, loop: 1), 0.5))}.play;

// Start the other
{Out.ar(~gate, Pan2.ar(PlayBuf.ar(1, ~chooston, loop: 1), -0.5))}.play

/////////////