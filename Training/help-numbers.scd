({PMOsc.ar
	(Line.kr(440,10000,
		exprand(500,2000)),
	Line.kr(100,17000,
		exprand(1,1000)),
	12)}
.plot)


({PMOsc.ar
	(MouseX.kr(440,1000,
		exprand(500,2000)),
	MouseY.kr(100,170,
		exprand(1,100)),
	6)}
.plot)