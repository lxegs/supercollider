Pbind(\note, Pseq([[0,1,2],[3,4,5]],3),\dur,0.3,\legato, 0.4, \strum, 0.1).trace.play;
Pbind(\degree, Pseq([0,1,2,3,4,5,6,7],inf),\scale, Scale.harmonicMinor).trace.play;
Scale.directory


(
{
	"test1".postln;
	1.wait;
	"test2".postln;
	3.wait;
	"test3".postln;
}.fork
)