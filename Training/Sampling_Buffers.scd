// streaming
(

b=Buffer.cueSoundFile(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav",0,1,2**16);

p={DiskIn.ar(1,b,1)}.play;
)

b.free;b.close;p.release;



// read a soundfile
(
s.boot;
p = Platform.resourceDir +/+ "sounds/a11wlk01.wav";
b = Buffer.read(s, p);

// now play it

x = SynthDef(\help_Buffer, { arg out = 0, bufnum;
    Out.ar( out,
        PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum))
    )
}).play(s,[\bufnum, b]);
)

x.free; b.free;


/*** resampling.scd: sample rate conversion ***/

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

x = {PlayBuf.ar(b.numChannels, b.bufnum, BufRateScale.ir(b.bufnum))}.play;

x.release; b.close; b.free;

/*** transposition ***/
b=Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav");

(
SynthDef (\monoSampleTransposer, {|bufnum=0,tpose=0|
	var rate,ptr,output;
	rate=BufRateScale.ir(bufnum)*pow(2,tpose/12);
	ptr=Phasor.ar(0,rate,0,BufFrames.ir(bufnum));
	output=BufRd.ar(1,bufnum,ptr,1,4);
	Out.ar(0, output)
}).add;
)

y=Synth(\monoSampleTransposer,[\bufnum,b.bufnum]);

(
var tpose=1;
y.set(\tpose,tpose);
)

y.free;b.close;b.free;

