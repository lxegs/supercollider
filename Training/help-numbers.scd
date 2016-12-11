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
{
	Blip.ar(
		TRand.kr(
			1000,1000,
			Impulse.kr(Line.kr(1,20,60))),
		TRand.kr(
			1,10,
			Impulse.kr(Line.kr(1,20,60))),
		Linen.kr(
			Impulse.kr(1,20,60)),
		0,
		0.5,
		1/Line.kr(1,20,60)
)
}.scope
)