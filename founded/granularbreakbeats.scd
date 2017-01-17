(
~serverList = [Server.local];

//wrap synths in common parameters
~synthFactory = {|name, func,l=(Server.internal),pan =({[-1,1]})|    SynthDef(name, {|gate =0, atk=18, rel=10,amp=1,bus=0,doneAction=2|  	var out;
  out = SynthDef.wrap(func);
  Out.ar(bus,Mix.ar(Pan2.ar(out *amp,pan.value)) * EnvGen.ar(Env.asr(atk, 1, rel, 'linear'),gate, doneAction:doneAction))  	}).load(l)  };

~synthFactoryPerc = {|name, func,pan =({[-1,1]}),l=(Server.internal),doneAction=2|  	SynthDef(name, {|gate =0, atk=18, sus=1, rel=10,amp=1,bus=0|  	var out;  	out = SynthDef.wrap(func);  		Out.ar(bus,Mix.ar(Pan2.ar(out * amp,pan.value)) * EnvGen.ar(Env.perc(atk,rel,1,sus),gate, doneAction:doneAction))
}).send(l)  };

~synthFactoryBus = {|name, func,l=(Server.internal)|  	SynthDef(name, {|gate =0, atk=18, rel=10,amp=1,bus=0|  	var out;
  out = SynthDef.wrap(func);
  Out.ar(bus,Mix.ar(out *amp) * EnvGen.ar(Env.asr(atk, 1, rel, 'linear'),gate, doneAction:2))  	}).send(l)  };


//Tone generator - pretty much the same one used in "Orbital Slingshot"
~serverList.collect({|z|
  SynthDef("tone",{|f=1,m=1,bus=0|
    var p=528, pp=p/2,
    a = (1.5**(-5..2) *.x (1..128).reject({|x|x.factors.detect(_>11)!=nil}).reject({|n|((n%5)==0).or((n%7)==0)})* p).sort,
    b=SinOsc,
    c = HenonC.ar(256/p,1+f+((0..(a.size-1))/(a.size*4)),b.ar(m,0,0.15,0.15),0,0,1),
    d =(1/(1.5**(-2..5)));
    OffsetOut.ar(bus,Mix.ar(Pan2.ar(b.ar((a *b.ar(1/p,b.ar(d,0,pi-b.ar((2**(-2..2))/(p*4),pi,pi,0).clip(0,pi),0),[f,m],1) * b.ar(1/p,0,m,1)),0,(4*c)/(a+66)),[-1,1])));
  }).load(z);
});


SynthDef("aux-patch",{|in,out,amp=1|
  Out.ar(out,InFeedback.ar(in,2)*amp);
}).send(s);

)
(

//GrainBuf takes its own envelope - can't do beats with TGrains because the grain envelope fades in too slowly

~winenv = Env([1, 1, 1], [0.5, 0.5], [8, -8]);
~wb = Buffer.sendCollection(s, ~winenv.discretize, 1);

//the granular synth - 4 independent layers of sound
~f = {|i=#[1,2,3,4],
a=#[1,1,1,1],
ga=1,
bufnum=6,lbuf=6,rate=1,trigRate=8,interp=4,centerpos=0.5,density=1,r1=8,ra=1,slices = 32,envbuf=20,p2=0|

  var bdur = BufDur.kr(lbuf).reciprocal,
  t,
  xl = LFSaw.ar(r1*bdur,1,1),dur, xr,
  ck1 = ((i*(xl)*xl.acos)).cos;
  //the "timestretching" param (buffer pos) is modulated by a <a href="http://mathworld.wolfram.com/Carotid-KundaliniFractal.html">Carotid-Kundalini</a> function.

  trigRate = trigRate *  bdur;
  t=Impulse.ar(trigRate,0,1);
  dur = density/trigRate;
  ck1 = (ck1 * slices).ceil/slices;
  GrainBuf.ar(2,t,dur,bufnum,rate*a,ck1.abs,interp,p2,envbuf,128);
 };

~synthFactory.("grainpad1", ~f,l:s,pan:({([1,2]/[-2,2]).sort}));

//start the granulator with some defaults
~gran ={|bus=0,buf=0,env=0|
  var gp;
  gp = Synth("grainpad1",[\bus,bus,\bufnum,buf,\atk,0.1,\gate,1,\envbuf,env,\lbuf,buf]);
  gp.set(\density,1);
  gp.set(\rel,4);
  gp.set(\rate,1);
  gp.setn(\a,[1,1,1,1]);
  gp.setn(\i,[4,81,27,32]);
  gp.set(\trigRate,4*8/9);
  gp.set(\amp,1/3);
  gp.set(\interp,4);
  gp.set(\r1,1/(2**14));
  //return the synth so we can catch it and assign it to an env variable
  gp;
};
)




(
//start some tone generators - a lot of the params in this synth are hardcoded due to its complexity
~start = {|x=12,bus=0|
  ~s = Array.fill(x);
  ~s.size.do({|i|~s[i] = Synth("tone",[\bus,bus],~serverList.wrapAt(i));});
  ~o=[4,6,8,9]/(528*2);
  ~s.collect{|x,i|~s[i].set(\f,~o.reverse.wrapAt(i))};
  ~s.collect{|x,i|~s[i].set(\m,~o.wrapAt(i))};
};
)
//refresh buffers
~pbf = {
  ~padbuf = [Buffer.alloc(s, 44100*32,1),Buffer.alloc(s, 44100*32,1)]
};
~pbf.();
~padbuf;

//create a synth to record sound from a bus to a buffer
~f= {|in=4,bufnum=5,atk=1,rel,sus,gate,rec=1,pre=0|
RecordBuf.ar(RLPF.ar(InFeedback.ar(in,1),XLine.ar(64,16384,0.1),0.5)*EnvGen.ar(Env.perc(0.1,31.8,1,-1),1,doneAction:2)
    , bufnum, recLevel:rec,preLevel:pre,doneAction:2, loop:0);
};
~synthFactoryPerc.("pad1buf",~f,l:s,pan:({0}),doneAction:2);

//function to sample a channel to a buffer
(
~sample = {|channel,dur=8|
  ~p1bl = Synth("pad1buf",[\in,channel,\bus,98,\bufnum,~padbuf[0],\atk,0.1,\rel,dur,\sus,-1,\gate,1]);
}
)
//start the tone generator

~start.(2,2);

//patching our signals - tone
~toneAux = Synth("aux-patch",[\in,2,\out,10]);
~granAux = Synth("aux-patch",[\in,6,\out,0]);

//record channel 2 in stereo for 8 seconds ans ave to a buffer
~sample.(2,8);

//free the tone generator
~s.collect({|x|x.set(\gate,0)})

//since granulators are mono, create 2 of them for granulated tones
~gdl= ~gran.(0,19,~wb);
~gdr= ~gran.(0,19,~wb);

//call this function for each mono granulator - pass in the synth and catch it on the way out
~stereograins = {|g|
g.set(\density,48);
g.set(\rel,4);
g.set(\rate,(4/5)*4/3);
g.setn(\a, [6/4,3/4,8/4,4/4]);
g.setn(\i,[1024,729,243,512]);
g.set(\trigRate,32*8/3);
g.set(\amp,1);
g.set(\interp,2);
g.set(\r1,(4/3)*(1/(2**10)));
g.set(\lbuf,~b);
g;
};

~gdl = ~stereograins.(~gdl);
~gdr = ~stereograins.(~gdr);

//panning
[~gdl,~gdr].collect(_.set(\p2,2));
[~gdl,~gdr].collect(_.set(\trigRate,4/3));
~e = [~gl,~gr,~gdl,~grl];
//mess around with params for trigger rate and time-stretching
~e.collect(_.set(\trigRate,16*8/3));
~e.collect(_.set(\r1,(4/3)*(1/(2**11))));
~e = [~gdl,~gdr,~gl,~gr];
~e.collect(_.set(\trigRate,64*8/3));
~e.collect(_.set(\trigRate,16*8/3));
~e.collect(_.set(\trigRate,8*8/3));
~e.collect(_.set(\r1,(4/3)*(1/(2**24))));

//load the canonical Amen break (which I got from <a href="http://www.freesound.org/people/VEXST/sounds/24940/">Freesound</a>

//one buffer for each stereo channel
~bl = Buffer.readChannel(s,Platform.userHomeDir+/+"scsounds/amenbreak.wav",0,-1,[0]);
~br = Buffer.readChannel(s,Platform.userHomeDir+/+"scsounds/amenbreak.wav",0,-1,[1]);

//function to set params
~stereobreak = {|g|

g.setn(\a,[4/3,4/3,4/3,4/3]);
g.setn(\i,[1024,729,243,512]);
g.set(\density,1);
g.set(\trigRate,16*8/3);
g.set(\rate,8/9);
g.set(\amp,1/2);
g.set(\interp,4);
g.set(\slices,16);
g.set(\envbuf,~wb);
g.set(\r1,(4/3)*1/(2**10));
 g
};

//call the granulator with left and right breakbeat channels
~gl = ~gran.(0,~bl,~wb);
~gr = ~gran.(0,~br,~wb);

~gl.set(\p2,2);
~gr.set(\p2,2);


//set the params
~gl = ~stereobreak.(~gl);
~gr = ~stereobreak.(~gr);

//tweak some pitches via the \a param - an array of rate multipliers
~gl.setn(\a,[4/3,2/3,1,4/3]);

//mess around with some params
[~gl,~gr].collect(_.set(\r1,(4/3)*(1/(2**24))));
[~gl,~gr].collect(_.set(\r1,(4/3)*(1/(2**16))));
[~gl,~gr].collect(_.set(\r1,(4/3)*(1/(2**8))));
[~gl,~gr].collect(_.set(\trigRate,64*8/3));
[~gl,~gr].collect(_.set(\trigRate,16*8/3));