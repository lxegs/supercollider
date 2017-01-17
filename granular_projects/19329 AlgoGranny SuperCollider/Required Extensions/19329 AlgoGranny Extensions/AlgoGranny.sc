/*
Creates an Instance of an AlgoGranny Composition Baker.

Drag and drop in audio to be transformed into an algorithmic granular synthesis composition.

Part of the AlgoGranny Studio Project,
© 2013-2014, Jamie Stuart, Candidate Number 19329
Studio Project, University of Sussex, Spring 2014
*/

AlgoGranny {

	var server;

	*new{
		^super.newCopyArgs.createAICompressor();
	}

	createAICompressor {

		// GUI variables
		var analysisWindow;
		var halfcvs;
		var leftcvs;
		var leftcvs2;
		var audiocvs;
		var textcvs;
		var soundDrop;
		var soundPath, soundView, soundFile, soundFloatArray, pathDrop, pathPath;
		var font, font2;
		var leftText;
		var titleText;
		var resultsText;
		var universityText, unicv;
		var playStopButtons;
		var playStopButtons2;
		var bakeButton;
		var play = false;
		var stop = false;
		var inAudiocv, pathcv, bakecv, outcv;
		var pathText,scrollText;
		var recording = false;
		// Synth Variables
		var inputBuffer;
		var compositionBuffer;
		var inSynth;
		var compSynth;
		// Audio Analysis
		var analyse;
		// function variables
		var createGUI;
		var createSynth;
		var startRecording;
		var stopRecording;
		// AlgoGranny Comp files
		var algoGrannyFilePath;
		var soundFile2, soundFloatArray2;
		// algoGranny compose
		var algoGrannyCompose;
		var n;

		// Init Buffer synth def
		createSynth = {
			"Initialising Buffer Synths...".postln;
			SynthDef("algoGrannyInput", {arg out = 0, bufnum, num;
				var signal;
				signal = PlayBuf.ar(num.numChannels, bufnum);
				Out.ar(out, Pan2.ar(signal));
			}).store;

			SynthDef("algoGrannyComposition", {arg out = 0, bufnum, num;
				var signal;
				signal = PlayBuf.ar(num.numChannels, bufnum);
				Out.ar(out, Pan2.ar(signal));
			}).store;

			"Audio Buffer Synths Intitialised".postln;
		};

		// Init GUI
		createGUI = {
			"Initialising AlgoGranny Application...".postln;
			font = Font("Ariel", 30);
			font2 = Font("Ariel", 25);

			analysisWindow = Window.new("AlgoGranny Composition Baker", Rect(Window.availableBounds.width/4, Window.availableBounds.height/6, Window.availableBounds.width/2.2, Window.availableBounds.height/1.4), false);

			halfcvs = Array.fill(1, {arg i; CompositeView(analysisWindow, Rect(0, 0, analysisWindow.bounds.width, analysisWindow.bounds.height))});

			leftcvs = Array.fill(4, {arg i; CompositeView(halfcvs[0], Rect(0, 0 + (i*halfcvs[0].bounds.height/4), halfcvs[0].bounds.width/4, halfcvs[0].bounds.height/3))});

			audiocvs = Array.fill(4, {arg i; CompositeView(halfcvs[0], Rect(halfcvs[0].bounds.width/4, 0 + (i*halfcvs[0].bounds.height/4), halfcvs[0].bounds.width, halfcvs[0].bounds.height))});

			leftText = Array.fill(4, {arg i; StaticText(leftcvs[i], Rect(0, leftcvs[i].bounds.height/50, leftcvs[i].bounds.width, leftcvs[i].bounds.height/2.2)).align_(\center)});

			playStopButtons = Array.fill(2, {arg i; Button(leftcvs[0], Rect(leftcvs[0].bounds.width/12 + (i*(leftcvs[0].bounds.width/2.2)), leftcvs[0].bounds.height/3, leftcvs[0].bounds.width/2.5, leftcvs[0].bounds.height/5))});

			inAudiocv = Array.fill(2, {arg i; CompositeView(audiocvs[0], Rect(0, 0 + (i*audiocvs[0].bounds.height/6.5), (audiocvs[0].bounds.width/2)+(audiocvs[0].bounds.width/4), (audiocvs[0].bounds.height/3)*2 - (i*audiocvs[0].bounds.height/3)))});

			pathcv = Array.fill(2, {arg i; CompositeView(audiocvs[1], Rect(0, 0 + (i*audiocvs[1].bounds.height/6.5), (audiocvs[1].bounds.width/2)+(audiocvs[1].bounds.width/4), (audiocvs[1].bounds.height/3)*2 - (i*audiocvs[1].bounds.height/3)))});

			bakecv = CompositeView(audiocvs[2], Rect(audiocvs[2].bounds.width/20, audiocvs[2].bounds.height/30, audiocvs[2].bounds.width/1.55, audiocvs[2].bounds.height/5.5));

			bakeButton = Button(bakecv, Rect(0, 0, bakecv.bounds.width, bakecv.bounds.height));

			unicv =  CompositeView(audiocvs[3], Rect(audiocvs[3].bounds.width/20, audiocvs[3].bounds.height/30, audiocvs[3].bounds.width/1.55, audiocvs[3].bounds.height/5.5));

			playStopButtons[0].states_([["Play", Color.white, Color.grey]]);
			playStopButtons[1].states_([["Stop", Color.white, Color.grey]]);

			bakeButton.font_(font);
			bakeButton.states_([["Bake
				AlgoGranny Composition", Color.white, Color.grey]]);

			leftText[0].string = "PLAY/STOP AUDIO:".underlined($*);
			leftText[1].string = "

Writing Path:
This is the path
the AlgoGranny
Composition is
written to";
			leftText[2].string = "

Bake AlgoGranny Composition:
Click to generate
new AlgoGranny
Composition";
			leftText[3].string = "University \n Credentials:";

			halfcvs.do{arg i; i.background_(Color.rand)};


			audiocvs.do{arg i; i.background_(Color.rand)};

			inAudiocv[0].background_(Color.black);
			inAudiocv[1].background_(Color.red);

			pathcv[0].background_(Color.black);
			pathcv[1].background_(Color.red);

			leftcvs[0].background_(Color.fromHexString("d98080"));
			leftcvs[1].background_(Color.fromHexString("b56b6b"));
			leftcvs[2].background_(Color.fromHexString("d98080"));
			leftcvs[3].background_(Color.fromHexString("b56b6b"));

			leftcvs[0].background_(Color.gray(0.6));
			leftcvs[1].background_(Color.gray(0.7));
			leftcvs[2].background_(Color.gray(0.6));
			leftcvs[3].background_(Color.gray(0.7));


			audiocvs[2].background_(Color.fromHexString("b56b6b"));
			audiocvs[3].background_(Color.fromHexString("d98080"));

			inAudiocv[1].background_(Color.fromHexString("b56b6b"));
			pathcv[1].background_(Color.gray(0.6));

			inAudiocv[1].background_(Color.gray(0.18));
			pathcv[1].background_(Color.gray(0.18));
			audiocvs[2].background_(Color.gray(0.7));
			audiocvs[3].background_(Color.gray(0.18));


			universityText = StaticText(unicv, Rect(0,  0, unicv.bounds.width,  unicv.bounds.height)).align_(\center);
			universityText.stringColor = Color.white;

			universityText.string = "University of Sussex 2014 \n\n Studio Project \n\n Candidate No. 19329";

			// Input Buffer stop and Starts
			playStopButtons[0].action_({arg b;
				case
				{soundFile != nil} {
					// inSynth.free;
					case
					{stop == true} {
						inSynth = Synth(\algoGrannyInput, [\bufnum, inputBuffer, \num, soundFile]);
						stop = false;
					}
					{inSynth.free;
						inSynth = Synth(\algoGrannyInput, [\bufnum, inputBuffer, \num, soundFile]);
						stop = false;
					}
				};
			});
			playStopButtons[1].action_({arg b;
				case
				{soundFile != nil && stop == false} {
					inSynth.free;
					stop = true;
				};
			});

			// Perform Manipulation of Audio with Alogrithmic Granular Techniques
			bakeButton.action_({arg b;

				case
				{(soundFile != nil) && (recording == false) && (pathPath != nil)} {
					bakeButton.states_([["Stop Baking Composition", Color.red(0.8), Color.gray(0.18)]]);
					recording = true;
					algoGrannyFilePath = pathPath ++ "algoGranny"++Date.getDate.stamp++".aiff";
					server.record(algoGrannyFilePath);
					"Started Baking AlgoGranny Composition".postln;
					algoGrannyCompose = AlgoGrannyCompose(SplitAudio(soundPath));
				}
				// Else
				{(soundFile != nil) && (recording == true) && (pathPath != nil)} {

					"hello".postln;
					"hello yourself".postln;
					algoGrannyFilePath.postln;
					recording = false;
					server.stopRecording;
					"Stopped Baking AlgoGranny Composition".postln;
					bakeButton.states_([["Bake
				AlgoGranny Composition", Color.white, Color.grey]]);
					algoGrannyCompose.setServer();

					// May have to Free all on the sever when stopping!!!

				}
			});

			// Path Text
			pathText = StaticText(pathcv[1], Rect(0,  0, pathcv[1].bounds.width,  pathcv[1].bounds.height/4)).align_(\center);
			pathText.stringColor = Color.white;

			// Set the First to be an audio drop
			soundDrop = DragSink(inAudiocv[0], Rect(0-inAudiocv[0].bounds.width/20, 0-inAudiocv[0].bounds.height/20, inAudiocv[0].bounds.width+inAudiocv[0].bounds.width/1.8, inAudiocv[0].bounds.height+inAudiocv[0].bounds.height/6)).align_(\center);
			soundDrop.background = Color.grey;
			soundDrop.string = "Drag and Drop Audio Here";
			soundDrop.font_(font);
			soundDrop.stringColor = Color.white;
			soundDrop.canReceiveDragHandler = { View.currentDrag.isKindOf(Object) };
			soundDrop.receiveDragHandler = { arg v;

				case
				{soundFile != nil} { inSynth.free };

				soundDrop.string = "Loading In Audio...";

				"Loading in Audio...".postln;

				analyse = {

					"Loading in Audio...".postln;
					// Store path name of audio
					soundPath = View.currentDrag.value.asString;
					soundFile = SoundFile();
					soundFile.openRead( soundPath,); // a stereo or multi channel file
					soundFloatArray = FloatArray.fill((soundFile.numFrames) * (soundFile.numChannels),0);
					soundFile.readData(soundFloatArray);

					// Dispaly Audio Waveform
					soundView = SoundFileView.new(inAudiocv[1], Rect(0,0-inAudiocv[0].bounds.height/70, inAudiocv[0].bounds.width, inAudiocv[0].bounds.height/5.8));
					soundView.soundfile = soundFile;
					soundView.read(0, soundFile.numFrames);
					soundView.elasticMode = true;
					soundView.timeCursorOn = true;
					soundView.timeCursorColor = Color.blue;
					soundView.drawsWaveForm = true;
					soundView.gridOn = false;
					soundView.gridResolution = 0.2;
					soundView.setSelectionColor(0, Color.blue);

					// Set audio buffer
					inputBuffer = Buffer.loadCollection(server, soundFloatArray, soundFile.numChannels);
					"Audio Loaded In".postln;

					soundDrop.string = "Drag and Drop Audio Here";
				};
				analyse.defer(0.001);
};

			// Path Drop (Path the AlgoGranny Comp will be written to)
			pathDrop = DragSink(pathcv[0], Rect(0-pathcv[0].bounds.width/20, 0-pathcv[0].bounds.height/20, pathcv[0].bounds.width+pathcv[0].bounds.width/1.8, pathcv[0].bounds.height+pathcv[0].bounds.height/6)).align_(\center);
			pathDrop.background = Color.grey;
			pathDrop.string = "Drag and Drop Path Here";
			pathDrop.font_(font);
			pathDrop.stringColor = Color.white;

			// Set the dragSink to recieve path names (strings)
			pathDrop.canReceiveDragHandler = {View.currentDrag.isKindOf(String)};

			// Function for when path is dragged in, store as variable (pathPath)
			pathDrop.receiveDragHandler = { arg v;

				pathText.string = View.currentDrag.value.asString;

				// This gives us the path name as a string
				pathPath = View.currentDrag.value.asString;

				// Set recording path
				thisProcess.platform.recordingsDir = pathPath;

			};

			// Display GUI, on close free synth
			analysisWindow.front;
			analysisWindow.onClose_({
				case
				{soundFile != nil}
				{
					case
					{stop == true} {}
					{stop == false} {inSynth.free; compSynth.free;}
				}
			});
			"AlgoGranny Composition Baker Application Initialised".postln;
		};

		// Init functions when server booted
		server = Server.local;
		server.boot.doWhenBooted{
			createSynth.defer(0.001);
			createGUI.defer(0.01);
		};
	}
}