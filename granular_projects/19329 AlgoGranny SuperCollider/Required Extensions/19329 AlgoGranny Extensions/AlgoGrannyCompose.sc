/*
Creates the AlgoGranny Composition.

@ splitAudio an audio file that has been passed through the split audio class.
This creates the grains for the track which can be used here.

Part of the AlgoGranny Studio Project,
© 2013-2014, Jamie Stuart, Candidate Number 19329
Studio Project, University of Sussex, Spring 2014
*/

AlgoGrannyCompose {

	classvar <>server;

		// Original grain variables
		var splitAudio;
		var grainArray;
		var startArray;

		// Setting grain array variables
		var originalGrains;
		var whiteNoise;
		var grainNoiseMix1;
		var grainNoiseMix2;

		// New grain array variables
		var chosenArray;
		var individualGrains;
		var grainIncrement;

		// Section Variables
		var sectionOrder;
		var sectionCounter = 0;
		var section1, section2, section3;
		var section4, section5, section6, section7;

		// Function variables
		var createSynths;
		var createGrains;

		// Buffers
		var x, g, f;

	*new{arg splitAudio;
		^super.newCopyArgs.compose(splitAudio);
	}

	compose {arg splitAudio;

		createSynths = {
			"Synth Def Added".postln;
			// Store synthDefs
			SynthDef(\algoGrannySynth,{arg buffer, dur=0.05, pos = 0.0, amp= 0.5, pan= 0.0, rate = 1, loop = 0, attack = 0.5, release = 2;
				var env, source;
				var envArray;
				envArray = [EnvGen.ar(Env.perc(attack, release), 1, doneAction:2)];
				source = PlayBuf.ar(1,buffer,rate, loop:loop);
				// env = EnvGen.ar(Env([0,1,1,0],[0.01,dur,0.01]),doneAction:2);
				env = Select.ar(0, envArray);
				Out.ar(0,Pan2.ar(env*source*amp,pan))
			}).add;

			SynthDef(\algoGrannySynth2, {arg bufnum=0, pan=0.0, startPos=0.0, amp=0.05, dur=0.04, rate = 1, sustain;
				var grain;
				grain= PlayBuf.ar(1,bufnum, rate, 1, BufFrames.ir(bufnum)*startPos, 0)
				*
				(EnvGen.kr(Env.linen(0.01, sustain, 0.01),doneAction:2))*amp;
				Out.ar(0,Pan2.ar(grain, pan))}).add;
		};

		// Create Grain values
		createGrains = {

			"Creating Grains...".postln;
			// Assign audio array to grain array
			grainArray = splitAudio.getGrainArray;

			"grain Array 1".postln;
			grainArray[0].postln;
			grainArray[0].size.postln;

			"Split Audio Complete".postln;

			// Grab a random number of grains from the grain array (Min 5, Max 20 iteratations). And store randomly.
			startArray = Array.fill(1, {0});
			rrand(10, 40).do{arg i;
				startArray = startArray++grainArray[rrand(0, grainArray.size)];
			};

			// Assign grains as either original grains or a mix of white noise and original grains
			originalGrains = startArray;
			grainNoiseMix1 = Array.fill(startArray.size/2, {arg i; startArray[i]}).scramble;
			grainNoiseMix2 = Array.fill(startArray.size/2, {arg i; startArray[i]});
			grainNoiseMix2 = grainNoiseMix2++grainNoiseMix1;

			// Randomly choose whether to use pure grains or a mix of white noise and grains
			chosenArray = [originalGrains, grainNoiseMix2].choose;
			case
			{chosenArray == originalGrains} {"Original Grains Chosen".postln;}
			{chosenArray == grainNoiseMix2} {"Grain and Noise Mix Chosen".postln;};

			// Size of array chosen
			("Size of array chosen:  " + chosenArray.size).postln;

			// Store grains into individual arrays
			grainIncrement = 0;
			individualGrains = Array.fill(chosenArray.size, {List()});
			chosenArray.do{arg i, j;
				j = j+1;
				case
				{j%689 == 0} {grainIncrement = grainIncrement+1;} {
					individualGrains[grainIncrement].add(i);
				}
			};

			// Choose the section order of the piece at random:
			sectionOrder = [1, 2, 4, 2, 3, 1, 4, 2, 1];
			sectionOrder = sectionOrder.scramble;

			// Store chosen array into a buffer (here we can add more than one buffer)
			x = Buffer.loadCollection(server, chosenArray, 1);

			// Evaluate the sections:
			case
			// section 1
			{sectionOrder[sectionCounter] == 1} {section1.defer(0.01);}
			{sectionOrder[sectionCounter] == 2} {section2.defer(0.01);}
			{sectionOrder[sectionCounter] == 3} {section3.defer(0.01);}
			{sectionOrder[sectionCounter] == 4} {section4.defer(0.01);};
			// Increment section counter
			sectionCounter = sectionCounter+1;
		};

		// Init functions after server has booted.
		server = Server.local;
		server.boot.doWhenBooted{
			createSynths.defer(0.01);
			createGrains.defer(0.1);
		};

		// Section 1:
		section1 = {
			{
				20.do {arg j;
					j = j+1;

					30.do{arg i;
						// make attack 5 for aweosme slow downs
						Synth(\algoGrannySynth, [\buffer,x, \attack, rrand(0.0, 30), \release, 1, \rate, i*0.0005, \pan, rrand(-1.0, 1.0), \amp, 0.005*j]);
						// 0.5.wait;
					};
					rrand(0.1, 0.9).wait;
					rrand(0.5, 1.2).wait;
					f.release;
				};

				// Next Sections
				case
				// section 1
				{sectionOrder[sectionCounter] == 1} {section1.defer(0.01)}
				{sectionOrder[sectionCounter] == 2} {section2.defer(0.01)}
				{sectionOrder[sectionCounter] == 3} {section3.defer(0.01)}
				{sectionOrder[sectionCounter] == 4} {section4.defer(0.01)};
				// Increment section counter
				sectionCounter = sectionCounter+1;

			}.fork;
		};


		// Section 2:
		section2 = {
			{
				20.do {arg j;
					j = j+1;

					40.do{arg i;
						// make attack 5 for aweosme slow downs
						Synth(\algoGrannySynth, [\buffer,x, \attack, rrand(0.0, 10), \release, 1, \rate, rrand(0.008, 0.02), \pan, rrand(-1.0, 1.0), \amp, 0.04]);
						// f.free;
						// 0.5.wait;
					};

					rrand(0.1, 0.9).wait;

					Synth(\algoGrannySynth, [\buffer,x, \attack, rrand(0.1, 10), \release, 10, \rate, rrand(0.0, 1), \pan, rrand(-1.0, 1.0), \amp, 0.1]);

					rrand(0.5, 1.2).wait;

					Synth(\algoGrannySynth, [\buffer,x, \attack, rrand(0.1, 10), \release, 1, \rate, rrand(0.0, 5), \pan, rrand(-1.0, 1.0), \amp, 0.1]);

					// g.release;
				};

				// Next section
				case
				// section 1
				{sectionOrder[sectionCounter] == 1} {section1.defer(0.01)}
				{sectionOrder[sectionCounter] == 2} {section2.defer(0.01)}
				{sectionOrder[sectionCounter] == 3} {section3.defer(0.01)}
				{sectionOrder[sectionCounter] == 4} {section4.defer(0.01)};
				// Increment section counter
				sectionCounter = sectionCounter+1;

			}.fork;
		};

		// Section 3:
		section3 = {
			{

				5.do {arg j;
					j = j+1;

					25.do{arg i;
						// make attack 5 for aweosme slow downs
						Synth(\algoGrannySynth, [\buffer,x, \attack, rrand(0.0, 30), \release, 1, \rate, i*0.05, \pan, rrand(-1.0, 1.0), \amp, 0.1]);
						// f.free;
						0.5.wait;
						// 2.wait;
						// f.release;
					};

					rrand(0.1, 0.9).wait;

					Synth(\algoGrannySynth, [\buffer,x, \attack, rrand(0.1, 10), \release, 10, \rate, rrand(0.0, 1), \pan, rrand(-1.0, 1.0), \amp, 0.1]);

					rrand(0.5, 1.2).wait;
					// g.release;
				};

				// Next Sections
				case
				// section 1
				{sectionOrder[sectionCounter] == 1} {section1.defer(0.01)}
				{sectionOrder[sectionCounter] == 2} {section2.defer(0.01)}
				{sectionOrder[sectionCounter] == 3} {section3.defer(0.01)}
				{sectionOrder[sectionCounter] == 4} {section4.defer(0.01)};
				// Increment section counter
				sectionCounter = sectionCounter+1;
			}.fork;
		};

		// Section 4:
		section4 = {
			{
				1.do{arg j;
					{
						50.do {arg i;
							Synth(\algoGrannySynth2,[\bufnum, x.bufnum, \startPos,rrand(0.0,1), \pan, i*0.05, \attack, 0.2, \sustain, 0.01, \rate, rrand(0.004, 5)]);
							// rrand(0.1, 0.5).wait;

							exprand(0.05,1.5).wait;
							// 1.5.wait;
						};
						// rrand(0.1, 0.5).wait;
					}.fork;

					{
						50.do {arg i;
							Synth(\algoGrannySynth2,[\bufnum, x.bufnum, \startPos,rrand(0.0,1), \pan, i*(-0.05), \attack, 0.2, \sustain, 0.01, \rate, rrand(0.004, 5)]);
							exprand(0.05,1).wait;
							// 1.5.wait;
						}
					}.fork;

					{
						50.do {arg i;
							Synth(\algoGrannySynth2,[\bufnum, x.bufnum, \startPos,rrand(0.6,1), \pan, i*(-0.05), \attack, 2, \sustain, 0.01, \rate, rrand(0.004, 1)]);
							exprand(0.05,1).wait;
							// 1.5.wait;
						}
					}.fork;

					{
						50.do {arg i;
							Synth(\algoGrannySynth2,[\bufnum, x.bufnum, \startPos,rrand(0.2,1), \pan, i*0.05, \attack, 2, \sustain, 0.01, \rate, rrand(0.004, 1)]);
							exprand(0.5,0.1).wait;
							// 1.5.wait;
						}
					}.fork;
					5.wait;
				}
			}.fork;

			// Stacatto Grain Shots
			{
				7.do {arg j;
					j = j+1;

					50.do{arg i;
						// make attack 5 for aweosme slow downs
						Synth(\algoGrannySynth, [\buffer,x, \attack, rrand(0.0, 1), \release, rrand(0.0, 1), \rate, i*0.05, \pan, rrand(-1.0, 1.0), \amp, 0.01]);
						// 0.5.wait;
					};
					rrand(0.1, 0.9).wait;

					Synth(\algoGrannySynth, [\buffer,x, \attack, rrand(0.01, 1), \release, rrand(0.0, 1), \rate, rrand(0.0, 0.05), \pan, rrand(-1.0, 1.0), \amp, 0.01]);

					rrand(0.5, 1.2).wait;
					// f.release;
				};

				2.wait;

				// Stacatto Grain Shot Variation
				7.do {arg j;
					j = j+1;

					50.do{arg i;
						// make attack 5 for aweosme slow downs
						Synth(\algoGrannySynth, [\buffer,x, \attack, rrand(0.0, 1), \release, rrand(0.0, 1), \rate, i*0.5, \pan, rrand(-1.0, 1.0), \amp, 0.01]);
						// 0.5.wait;
					};
					rrand(0.1, 0.4).wait;

					Synth(\algoGrannySynth, [\buffer,x, \attack, rrand(0.01, 1), \release, rrand(0.0, 1), \rate, rrand(0.0, 0.05), \pan, rrand(-1.0, 1.0), \amp, 0.01]);

					rrand(0.5, 1.2).wait;
					// f.release;
				};

				// Next Sections
				case
				// section 1
				{sectionOrder[sectionCounter] == 1} {section1.defer(0.01)}
				{sectionOrder[sectionCounter] == 2} {section2.defer(0.01)}
				{sectionOrder[sectionCounter] == 3} {section3.defer(0.01)}
				{sectionOrder[sectionCounter] == 4} {section4.defer(0.01)};
				// Increment section counter
				sectionCounter = sectionCounter+1;

			}.fork;
		};
	}

	setServer {
		server.stop;
		server.quit;
		server = Server.local;
		server.freeAll;
		server.boot;
		server.freeAll;
	}
}
