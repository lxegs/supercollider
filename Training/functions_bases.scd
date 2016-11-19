{SinOsc.ar}.play;

{Saw.ar}.play;

{|chaos=1.5| Crackle.ar(chaos)}.play(args:[\chaos, 2]);

{RHPF.ar(WhiteNoise.ar)}.play;


s.boot;

(

f = {

|freq1=440, freq2=440, amp1=0.5, amp2=0.5|

var sine1, sine2, output;

sine1 = SinOsc.ar(freq1, mul:amp1);

sine2 = SinOsc.ar(freq2, mul:amp2);

output = sine1+sine2;

};



f.play;

f.play(args: [\freq2, 550, \amp1, 0.25]);
)