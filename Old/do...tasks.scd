a = ["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"];
a.at(8);
"Item at index 5 is: ".post; a.at(5).postln;
"Item at index 0 is: ".post; a.at(0).postln;

do(50, {["C", "D", "E", "F", "G", "A", "B"].at(7.rand).postln})

(Task({
	50.do({
		["C", "D", "E", "F", "G", "A", "B"].at(7.rand).postln;
		0.1.wait;
	});
}).play) // Cmd-. or equivalent to stop


(
Task({
a = ["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"];
"count, midi, pitch, octave".postln;

 do(50, {arg count;

 p = rrand(36, 72);

 [count, p, a.wrapAt(p), (p/12).round(1) - 1].postln;

 1.wait;

 })
}).play
)


