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

