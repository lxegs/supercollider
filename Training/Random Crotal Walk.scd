( //PMCrotal definition
SynthDef("PMCrotale", {
arg midi = 60, tone = 3, art = 1, amp = 0.8, pan = 0;
var env, out, mod, freq;
freq = midi.midicps;
env = Env.perc(0, art);
mod = 5 + (1/IRand(2, 6));
out = PMOsc.ar(freq, mod*freq,
pmindex: EnvGen.kr(env, timeScale: art, levelScale: tone),
mul: EnvGen.kr(env, timeScale: art, levelScale: 0.3));
out = Pan2.ar(out, pan);
out = out * EnvGen.kr(env, timeScale: 1.3*art,
levelScale: Rand(0.1, 0.5), doneAction:2);
Out.ar(0, out);
}).add;
)

(
a = ["C","C#","D","Eb","E","F","F#","G","Ab","A","Bb","B"];
"event,midi,pitch,octave".postln;
r = Task({
	inf.do({ arg count;
		var midi,oct,density;
		density = 1.0; // 100 % of time
		//density = 0.7;
		//density = 0.3;
		midi = [0,2,4,7,9,11].choose;
		// midi = [0, 2, 4, 5, 7, 9, 11].choose;
		// midi = [0, 2, 3, 5, 6, 8, 9, 11] .choose;
		// midi = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11] .choose;
		oct = [48, 60, 72].choose;
		if(density.coin,
			{ // true action
				"".postln;
				[midi + oct,a.wrapAt(midi),
				(oct/12).round(1)].post;
				Synth("PMCrotale",
					["midi",midi + oct, "tone", rrand(1,7),"art", rrand(0.3,2.0),"amp", rrand(0.3,0.6),"pan",1.0.rand2]);
		}, {["rest"].post}); // false action
		0.2.wait;
	});
}).start
)


