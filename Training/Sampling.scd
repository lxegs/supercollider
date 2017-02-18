{

b=Buffer.cueSoundFile(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav",0,1,2**16);

p={DiskIn.ar(1,b,1)}.play;

}

b.free;b.close;p.release;