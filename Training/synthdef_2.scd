(
SynthDef("different_tones", {
	arg freq = 440;
	var out;
	out = SinGrain.ar(freq)*0.3;
	Out.ar(0,out);
});

a = Synth("different_tones",["freq"]);
a.set("freq",64.midicps);
a.free;
