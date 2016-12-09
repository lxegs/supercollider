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