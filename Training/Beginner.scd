(
//Server.default=s=Server.internal.boot;

play({SinOsc.ar(LFNoise0.kr(12, mul: 600, add: 1000), 0.3)})

)

{SinOscFB.ar(LFNoise0.kr(12000,600,1000),300)}.plot

plot({RLPF.ar(Dust.ar([1800,1500]), LFNoise1.ar(1/[300,4000], 1500, 1600), 12)});

play({
	var sines=5,speed=6;
	Mix.fill(sines,
		{arg x;
			Pan2.ar(
				SinOsc.ar(x+1*100,
					mul: max(0,
						LFNoise1.kr(speed)+
						Line.kr(1,-1,30)
					)
), rand2(1.0))})/sines})


({
	var sines=5,speed=6;
	Mix.fill(sines,
		{arg x;
			Pan2.ar(
				SinOsc.ar(x+1*100,
					mul: max(0,
						LFNoise1.kr(speed)+
						Line.kr(1,-1,30)
					)
), rand2(1.0))})/sines}).plot

