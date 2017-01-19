SynthDef(\readsf_v1,
 {arg out = 0, buf = 0, rate = 1, amp = 0.5, pan = 0, pos = 0, rel=15, verb=0, saturation=0, delay=0, cutoff=1,
 atk=0.2,
 // reverb arguments
 room = 1,
 // saturation arguments
 dist=100,
 // delay arguments
 dtime=0.1, mdelay= 0.5,
 // cutoff arguments
 freq=150, rq=1;

 var sig,env,glide,env1;

 sig = Pan2.ar(PlayBuf.ar(2,buf,BufRateScale.ir(buf) * rate,1,BufDur.kr(buf)*pos*44100,doneAction:2),pan);

 env = EnvGen.ar(Env.linen(atk,1,rel, 1, -3),doneAction:2);

 // SATURATION
 sig = LinXFade2.ar( sig, tanh(sig * dist), saturation);
 // DELAY
 sig = LinXFade2.ar(sig,CombL.ar(sig* env, mdelay, dtime, 1, 1, sig), delay);
 // BAND PASS FILTER
 sig = LinXFade2.ar( sig, BRF.ar(sig, freq, rq), cutoff);
 // FREEVERB
 sig = LinXFade2.ar( sig, GVerb.ar(sig, room, 3, 1), verb);

 sig = sig * env;
 sig = sig * amp;

 Out.ar(out,Pan2.ar(sig,pan));


}).add;