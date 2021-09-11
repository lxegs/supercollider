~buffer = Buffer.alloc(s, 2**16);
~fund = 440;
~harmN = ((s.sampleRate/2)/~fund).floor;
~norm = -3.dbamp;
(
var sine;
sine = ~buffer.sine1([1]);
{Osc.ar(sine, ~fund, mul:~norm)}.scope.play;
)
(

var amps, pulse;

amps = 1/(1!~harmN);

pulse = ~buffer.sine1(amps, asWavetable:false);

{OscN.ar(pulse, ~fund, mul:~norm)}.scope;

)

(
var freqs, amps, square;

freqs = (1, 3..~harmN);

amps = 1/freqs;

square = ~buffer.sine2(freqs, amps);

{Osc.ar(square, ~fund, mul:~norm)}.play;

)