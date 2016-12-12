({PMOsc.ar
	(Line.kr(440,10000,
		exprand(500,2000)),
	Line.kr(100,17000,
		exprand(1,1000)),
	12)}
.scope)


({PMOsc.ar
	(MouseX.kr(TGaussRand.kr(440,1000),
		ExpRand(500,2000)),
	 MouseY.kr(100,170,
		exprand(1,100)),
	1)}
.scope)

{PMOsc.ar(400, MouseY.kr(1,550), MouseX.kr(1;15))}.scope

{SinOsc.ar(mul: MouseX.kr(0,1.0))}.scope



({PMOsc.ar
	(Line.kr(0,300,30),
		Line.kr(0,300,5),
		XLine.kr(0,3000,20),
		mul:0.3)}
.scope)


(
// 1.4 p 17
{
	Blip.ar(
		TRand.kr( //VCO
			1000,1000, //range
			Impulse.kr(Line.kr(1,20,60))), //trigger
		TRand.kr( //VCF(harmonics)
			1,10, // range
			Impulse.kr(Line.kr(1,20,60))), //trigger
		Linen.kr( //VCA
			Impulse.kr(1,20,60)), //trigger
		0, //atatck
		0.5, //sustain
		1/Line.kr(1,20,60) //trigger
)
}.scope
)

(
// 1.4 p 17 --> stereo version
{
	Blip.ar(
		[TRand.kr( //VCO
			1000,1000, //range
			Impulse.kr(Line.kr(1,20,60))),
		TRand.kr( //VCO
			1000,1000, //range
			Impulse.kr(Line.kr(1,20,60)))], //trigger
		TRand.kr( //VCF(harmonics)
			1,10, // range
			Impulse.kr(Line.kr(1,20,60))), //trigger
		Linen.kr( //VCA
			Impulse.kr(1,20,60)), //trigger
		0, //atatck
		0.5, //sustain
		1/Line.kr(1,20,60) //trigger
)
}.scope
)