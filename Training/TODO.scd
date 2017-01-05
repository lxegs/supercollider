// freeverb2 : in & in2 --> in (Pan2 ....) & in2 (Pan2 + delay)


(
x={
	var lfn=LFNoise2.kr(1);
	var saw=Saw.ar(
		freq:30,mul:LFPulse.kr(freq:LFNoise1.kr(1).range(1,10),width: 0.1));
	var bpf=BPF.ar(in:saw,freq:lfn.range(500,2500),rq:0.01,mul:20);
	FreeVerb2.ar(in: Out.ar(Pan2.ar(in:bpf,pos:lfn));
}.play;
)