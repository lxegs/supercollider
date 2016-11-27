(

var amps, sine1, sine2;

amps = [-3.dbamp, 1/10];

sine1 = {SinOsc.ar(mul:amps[0])};

sine2 = {SinOsc.ar(mul:amps[1])};

{sine1+sine2}.play;








)
