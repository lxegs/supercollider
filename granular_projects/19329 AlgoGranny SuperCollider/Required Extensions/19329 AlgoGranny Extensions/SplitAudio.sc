/*
Splits up audio file passed into the arguments.

Cuts the audio into equal sized grains of 689.0625 samples long.
Sets the size of the AlgoGranny Composition as twice as long as the original track.
Cuts up the AlgoGranny comp into three sections.

Part of the AlgoGranny Studio Project,
© 2013-2014, Jamie Stuart, Candidate Number 19329
Studio Project, University of Sussex, Spring 2014
*/

SplitAudio {

	// Original audio variables
	classvar <>originalAudio, <>audioArray;
	// Grain variables
	classvar <>numFrames, <>numGrains, <>samplesPerGrain, <>grainArray;
	classvar <>grainArrayIncrement, grainSampleAmount;
	// section variables
	classvar <>eachSectionLength;
	// algoGranny variables
	classvar <>algoGranny;
	classvar <>algoGrannySize;

	*new{arg soundFile;
		^super.newCopyArgs.splitUpAudio(soundFile);
	}

	splitUpAudio {arg soundFile;

		algoGranny = List();
		grainArrayIncrement = -1;
		grainSampleAmount = 690;

		// Read in the audio file
		"Reading in soundfile...".postln;
		originalAudio = SoundFile();
		originalAudio.openRead(soundFile,);

		// Our float Array (audioArray) is our audio file
		audioArray = FloatArray.fill((originalAudio.numFrames) * (originalAudio.numChannels),0);
		originalAudio.readData(audioArray);
		"Sound File read".postln;
		("Original Size:   " + audioArray.size).postln;
		// Set composition as seven minutes long
		algoGrannySize = 18522000;
		("algoGrannySize:  " + (algoGrannySize)).postln;

		// Split up the original array into grains
		numFrames = audioArray.size; // num of frames
		numGrains = numFrames/grainSampleAmount; // amount of grains
		samplesPerGrain = numFrames/numGrains; // length in samples of each grain
		("numFrames:       " + numFrames).postln;
		("numGrains:       " + numGrains).postln;
		("samplesPerGrain: " + samplesPerGrain).postln;

		// Set up Array of grains
		grainArray = Array.fill(numGrains, {List()});

		// Split audio into grains (Assigning amount of samples per grain)
		"Cutting up audio and storing samples in individual arrays...".postln;
		audioArray.do{arg i, j; // i = amplitude, j = number increment
			case
			// Reach the samples per grain limit -- move to the next grain
			{j%samplesPerGrain == 0} {grainArrayIncrement = grainArrayIncrement+1;}
			// Haven't reached the sample per grain amount -- (so store sample in the current grain array)
			{j%samplesPerGrain != 0} {grainArray[grainArrayIncrement].add(i)}
		};

		// Notify user
		"Cutting complete, arrays loaded and ready".postln;
		("Grain Array Size:  " + grainArray.size).postln;
		"Completed Splitting Audio into Grains".postln;

		// Split the Track into three equal sections
		eachSectionLength = audioArray.size/7;

		// Show difference between original and split size
		"Original Size".postln;
		audioArray.size.postln;
		"Each section length".postln;
		eachSectionLength.postln;

		// Finish
		"Audio Split".postln;
	}

	// Getters for higher level classes
	getAudioArray {
		^audioArray;
	}

	getNumFrames {
		^numFrames;
	}

	getNumGrains {
		^numGrains;
	}

	getSamplesPerGrain {
		^samplesPerGrain;
	}

	getGrainArray {
		^grainArray;
	}

	getEachSectionLength {
		^eachSectionLength;
	}

	getAlgoGrannySize {
		^algoGrannySize;
	}
}
