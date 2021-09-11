Server.default.makeGui;


s.prepareForRecord;

s.record;

(

/*** sample programme ***/

x = {SinOsc.ar}.play;

/*** end of programme ***/

)

s.stopRecording;

x.free;


s.recSampleFormat = int16;