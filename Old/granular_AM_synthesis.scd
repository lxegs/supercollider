(
var movements = Array(7);
var slowstatic;
var slowmod, lessslowmod, increasedmod, fastmod, increasedfastmod, fastermod, biggerfastermod, slowermod, evenslowermod;
var deg1, deg2, deg3, deg4;
var envlen1, envlen2, envlen3;
var speed1, speed2,speed3, slowspeed;
var ampnormal;
var modamprising, modampdescending;
var width, height;

var colorValues;
var colors;
var label;
var labeltext = "";
var noteEvents;


(
o = Server.local.options;
o.maxNodes = 10000;
o.memSize = 8192*2;
s = Server.local;
s.boot;
);

m = NetAddr("127.0.0.1", NetAddr.langPort); // loopback

s.waitForBoot({
	// AM synthesis
	(
		SynthDef(\amsynth,
			{   | out = 0, freq = 440, freq_modulator = 300, amp = 0.5, amp_modulator = 0.5,
				envlen=0.01, spread=0.5, center=0.0 |
				var carrier = amp*SinOsc.ar(freq);
				var modulator = amp_modulator*SinOsc.ar({freq_modulator});
				var envelope = EnvGen.kr(Env.perc(envlen, 1, 1), doneAction:2);
				Out.ar(out, Splay.ar(envelope*carrier*modulator!2, spread, 1, center));
		}).add;
	);

	Pdef(\bg).fadeTime = 1.0;

	(
		slowmod = Pfunc({rrand(3,20)});
		lessslowmod = Pfunc({rrand(3,5)});
		increasedmod = Pseries(3,0.1);
		fastmod = Pfunc({rrand(150,200)});
		increasedfastmod = Pwhite(Pseries(200,0.1),Pseries(200,2));
		fastermod = Pfunc({rrand(150,1800)});
		biggerfastermod = Pfunc({rrand(50,5000)});
		slowermod = Pwhite(150,Pseries(1800,-10));
		ampnormal = Pfunc({rrand(0.01,0.03)});
		evenslowermod = Pwhite(Pseries(200,-5), Pseries(900,-25));


		deg1 = Pn(Pstutter(100,[0,5,7,8]),inf);
		deg2 = Pn(Pstutter(100,[0,5,7,9]),inf);
		deg3 = Pn(Pstutter(100,[0,5,7,10]),inf);
		deg4 = Pn(Pstutter(100,[0,5,7,11]),inf);

		envlen1 = Pwrand([0.01,0.02,0.03,0.1,0.2,0.3,1,2,3],[0.0,0.0,0.1,0.0,0.1,0.1,2,2,2],inf);
		envlen2 = Pwrand([0.01,0.02,0.03,0.1,0.2,0.3,1,2,3],[0.2,0.2,0.1,0.1,0.6,0.1,2,2,2],inf);
		envlen3 = Pwrand([0.01,0.02,0.03,0.1,0.2,0.3,1,2,3],[0.6,0.6,0.6,0.02,0.02,0.02,0,0,0],inf);
		speed1 = Prand([0.1,0.2,0.3],inf)/10;
		speed2 = Prand([0.1,0.2,0.3],inf)/20;
		speed3 = (Prand([0.1,0.2,0.3,0.4,0.5],inf)/Pgeom(20,0.99));
		slowspeed= Prand([0.1,0.2,0.3],inf);

		slowstatic =
		Pbind(\instrument, \amsynth,
			\freq_modulator, slowmod,
			\amp, ampnormal,
			\degree, deg1,
			\dur, speed1,
			\envlen, envlen1
		);
	);

	(
		movements.add({
			"*************************".postln;
			"*  Variations on 440Hz  *".postln;
			"*************************".postln;
			"*                       *".postln;
			"*   An exploration of   *".postln;
			"*       GRANULAR        *".postln;
			"*     AM SYNTHESIS      *".postln;
			"*                       *".postln;
			"*  (no filters, no fx)  *".postln;
			"*                       *".postln;
			"* Stefaan Himpe(shiihs) *".postln;
			"*************************".postln;
			"".postln;
		});
		movements.add({
			Pdef(\bg,
				Pbindf(slowstatic,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Slow modulation (tremolo)".postln;
			5.wait;

			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator, lessslowmod,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Speed up modulation".postln;
			10.wait;
		});
		movements.add({
			2.do({
				Pdef(\bg,
					Pbindf(slowstatic,
						\freq_modulator, lessslowmod,
						\degree, deg2,
						\sendtogui, Pfunc({ |ev|
							m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
						});
				));
				"Make a little melody".postln;

				4.wait;
				Pdef(\bg,
					Pbindf(slowstatic,
						\freq_modulator, lessslowmod,
						\degree, deg4,
						\sendtogui, Pfunc({ |ev|
							m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
						});
				));
				"Make a little melody".postln;
				4.wait;
				Pdef(\bg,
					Pbindf(slowstatic,
						\freq_modulator, lessslowmod,
						\degree, deg3,
						\sendtogui, Pfunc({ |ev|
							m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
						});
				));
				"Make a little melody".postln;
				4.wait;
				Pdef(\bg,
					Pbindf(slowstatic,
						\freq_modulator, lessslowmod,
						\degree, deg1,
						\sendtogui, Pfunc({ |ev|
							m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
						});
				));
				"Make a little melody".postln;
				6.wait;
			});

			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator, lessslowmod,
					\degree, deg2,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Make a little melody".postln;
			8.wait;

			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator, lessslowmod,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Make a little melody".postln;
			4.wait;
		});

		movements.add({
			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator, increasedmod,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Increasing modulator frequency".postln;
			25.wait;
		});

		movements.add({
			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator, fastmod,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Fast random modulator frequency".postln;
			10.wait;

			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator, fastmod,
					\envlen, envlen2,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Choose more short envelopes".postln;
			5.wait;

			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator, fastmod,
					\envlen, envlen3,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Reduce #long envelopes".postln;
			5.wait;

			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator, increasedfastmod,
					\envlen, envlen3,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Increase random modulator frequency range".postln;
			15.wait;

			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator, fastermod,
					\envlen, envlen3,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Bigger random modulator frequency range".postln;
			15.wait;

			Pdef(\bg).fadeTime = 10.0;

			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator, biggerfastermod,
					\envlen, envlen3,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Highest frequency times 5".postln;
			15.wait;
		});

		movements.add({
			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator, biggerfastermod,
					\envlen, envlen3,
					\dur, speed2,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Faster speed".postln;
			15.wait;

			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator,biggerfastermod,
					\envlen, envlen3,
					\dur, speed3,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Slow down speed".postln;
			15.wait;

			Pdef(\bg).fadeTime = 1.0;

			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator,biggerfastermod,
					\envlen,envlen2,
					\dur,slowspeed,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Longer envelopes".postln;
			10.wait;

			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator,biggerfastermod,
					\envlen,envlen1,
					\dur,slowspeed,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Even longer envelopes".postln;
			10.wait;

			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator,fastermod,
					\envlen,envlen1,
					\dur,slowspeed,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Reduce highest freq".postln;
			5.wait;

			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator,slowermod,
					\envlen,envlen1,
					\dur,slowspeed,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Further reduce highest freq".postln;
			15.wait;
		});
		movements.add({

			Pdef(\bg,
				Pbindf(slowstatic,
					\freq_modulator,evenslowermod,
					\envlen,envlen1,
					\dur,slowspeed,
					\sendtogui, Pfunc({ |ev|
						m.sendMsg("/gui", 1, ev[\freq_modulator], ev[\amp], ev[\degree], ev[\dur], ev[\envlen]);
					});
			));
			"Further slow down to initial settings".postln;
			5.wait;
		});
	);

	(
		width = 1280;
		height = 720;
		colorValues = (
			background: "d0d0ff",
			chord: "00aabb",
			splotch: "f43530",
			harmonics: "46454b",
			0 : "28ff00",
			1 : "00fff2",
			2 : "007aff",
			3 : "0500ff",
			4 : "4700ed",
			5 : "6300b2",
			6 : "ae0000",
			7 : "ff0000",
			8 : "ff33ff",
			9 : "ff6600",
			10 : "ffef00",
			11 : "99ff00",
			blend2: "f66cc",
			blend1: "ffff00"
		);
		colors = colorValues.collect({|item| Color.fromHexString(item)});
		noteEvents = Array.fill(30, { List.new(5) });

		o=OSCFunc({|msg| switch( msg[1].asInteger,
			1, {
				var freq_modulator = msg[2];
				var amp = msg[3];
				var degree = [ msg[4][3], msg[4][15], msg[4][19], msg[4][23] ]; // TODO: decent osc blob decoding...
				var dur = msg[5];
				var envlen = msg[6];
				noteEvents[0].add([freq_modulator, amp, degree, dur, envlen]);
			},
			2, {
				msg[2].postln;
				labeltext = msg[2];
			}

		)}, '/gui');

		w = Window(bounds: Rect(0, 0, width, height));
		v = UserView(w, w.view.bounds);

		v.animate = true;
		v.background = colors['background'];
		label = StaticText(v, Rect(40, 15, width-40, 50));
		label.font = Font("Helvetica", 45, true);
		label.align = \center;
		label.stringColor = colors['harmonics'];

		v.drawFunc = {
			label.string = labeltext;

			noteEvents.do{ |item, i|
				item.do{ |subItem|
					var degrees = subItem[2];
					var amp = subItem[1];
					var barheight = 20;
					var ampscaled = amp.explin(0.01,0.03,0,1);
					Pen.alpha = 27;

					degrees.do({ | item, i |
						Pen.fillColor = colors[(degrees[i] % 12)];
						Pen.addRect(Rect(0, degrees[i].linlin(-1,12,height, 0)+(barheight*(ampscaled/2.0)), w.bounds.width, barheight*ampscaled));
						Pen.perform(\fill);
					});
				};
			};

			noteEvents.do{ |item, i|
				Pen.fillColor = colors['splotch'];
				Pen.alpha = (30-i).linexp(1,27,0.01,1);
				item.do{ |subItem|
					var freq_modulator = subItem[0];
					var amp = subItem[1];
					var dur = subItem[3].asFloat;
					var envlen = subItem[4].asFloat;
					Pen.fillColor = colors['blend1'].blend(colors['blend2'],amp.explin(0.01,0.03,0,1));
					Pen.alpha = (30-i).linexp(1,27,0.01,1);
					Pen.fillOval(Rect.aboutPoint(
						dur.linexp(0,0.3,(3*width/4),(width/4)) @ freq_modulator.explin(3,5000,height,0),
						envlen.explin(0.01, 3, 1, 10)*(30-i).linlin(1,300,1,75),
						envlen.explin(0.01, 3, 1, 10)*(30-i).linlin(1,300,1,75)));
				};
			};
			noteEvents = noteEvents.shift(1, List.new(5));
		};

		w.onClose_({
			Pdef(\bg).fadeTime = 20.0;
			Pdef(\bg).stop;
			Pdef(\bg).clear;
		});

		w.front;
	);

	Pdef(\bg).play;
	movements[0].();
	m.sendMsg("/gui",2,"***   Introduction    ***");
	movements[1].();
	m.sendMsg("/gui",2,"***    Swan Song     ***");
	movements[2].();
	m.sendMsg("/gui",2,"***  Transfiguration  ***");
	movements[3].();
	m.sendMsg("/gui",2,"***    Tube Travel    ***");
	movements[4].();
	m.sendMsg("/gui",2,"***   Drowsy Drips    ***");
	movements[5].();
	m.sendMsg("/gui",2,"***   Sweet Dreams    ***");
	movements[6].();
	m.sendMsg("/gui",2,"***   Welcome Back    ***");
	movements[1].();
	m.sendMsg("/gui",2,"***  We\'ve Missed You ***");
	movements[2].();
	m.sendMsg("/gui",2,"");
	movements[0].();
	Pdef(\bg).fadeTime = 20.0;
	Pdef(\bg).stop;
	Pdef(\bg).clear;
});
);