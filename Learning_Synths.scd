(
~fn = {
	arg freq = 200,offset = 2,lpf = 1500, amp = 0.2;
	var sig;
	sig = Saw.ar(freq + [0, offset]);
	sig = LPF18.ar(sig,lpf);
	sig = sig * amp;
};)

~fn.play(args: [\offset,2,\lpf,400,\amp,0.1]);

(
SynthDef.new(\saw, {
	arg freq = 200,offset = 2,lpf = 1500, amp = 0.2, out = 0;
	var sig;
	sig = Saw.ar(freq + [0, offset]);
	sig = LPF18.ar(sig,lpf);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\saw, [\freq, 100, \lpf, 600]);