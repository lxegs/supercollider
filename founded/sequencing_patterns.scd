(
{
        var dur= 2.5;
        var legato= 0.75;
        var seq= {
                var g, t, d;
                g=Dstutter(2, Dseq([Dshuf(((1/8!14) ++ (1/16!4)), 4)],inf))*dur;
                t=TDuty.ar(g);  //trigger
                d=Demand.ar(t, 0, g); //duration
                EnvGen.ar(Env([1,1,0],[0,d*legato]),TDelay.ar(t, ControlDur.ir));
        }!2;
        SinOsc.ar([440, 660])*seq;
}.play(fadeTime:0)
)

(
{
        g={Dseq([Dshuf(((1/8!14) ++ (1/16!4)), 4)],inf)}!1;
        t= Duty.ar(g,0,g);
        r = TDuty.ar(g,0,g,0,0);
        //u= Trig.ar(r,t);
        e= EnvGen.ar(Env([1/8,1,1,1/8,1/8],[0.001,t-0.002-(1/64),0.001,1/64]),r);
        SinOsc.ar(440+SinOsc.ar(1740,0,220))*e
}.play
)

(
{
        var g, t, d, e;
        //g=Dstutter(2, Dseq([Dseq(((1/8!4) ++ (1/16!4)), 4)],inf));  //deterministic dseq durations
        g=Dstutter(2, Dseq([Dshuf(((1/8!14) ++ (1/16!4)), 4)],inf));  //dseq durations with stutter two because we use g twice
        t=TDuty.ar(g*3);  //trigger
        d=Demand.ar(t, 0, g); //duration
        d.poll(t);
        e= EnvGen.ar(Env([1,1,0],[0,d]),TDelay.ar(t, ControlDur.ir));
        SinOsc.ar(440)*e!2
}.play(fadeTime:0)
)


(
{
        var seq= {
                var g, t, d;
                g=Dstutter(2, Dseq([Dshuf(((1/8!14) ++ (1/16!4)), 4)],inf));
                t=TDuty.ar(g*3);  //trigger
                d=Demand.ar(t, 0, g); //duration
                EnvGen.ar(Env([1,1,0],[0,d]),TDelay.ar(t, ControlDur.ir));
        }!2;
        SinOsc.ar(440)*seq;
}.play(fadeTime:0)
)

