(
~func = {
	arg x = 5;
	x*x;
};
)

~func.value;

(
f={
	|x=5,y=5|
	var carre,output;
	carre = x*x;
	//output=carre;
}
)

f.play(args: [\x,40]);
f.value(45);


(

f = {

|freq1=220, freq2=220, amp1=0.05, amp2=0.05|

var sine1, sine2, output;

sine1 = SinOsc.ar(freq1, mul:amp1);

sine2 = SinOsc.ar(freq2, mul:amp2);

output = sine1+sine2;

};

)

f.play;

f.play(args: [\freq2, 550, \amp1, 0.1, \amp2,0.1]);

f.class;

"this is a string".class; // string
$i.class; // char
'sym'.class; // symbol
\sym.class; //symbol
~myarray = [1,"hello",-23.253,\toto]; //array

~myarray = [150,256,965,1458];
~myarray.at(1);
~myarray[3];


(
~func = {
	arg input;
	if (
		input > 5,
		{"sine".postln;},
		{"notsine".postln;}
	);
};
)

~func.value(8);

(
~func = {
	arg input;
	case
	{input < 0 }	{"negatif".postln}
	{input > 10 }	{"positif".postln}
	{true}			{ \blabla };
};
)

~func.value(5).class;

rrand(10,20);
10.rrand(20); // receiver notation
exprand(1,100).round //(.asinteger); //distrib exponentielle always float


(
f = {
	arg freq=200,amp=0.1;
	var sig;
	sig = SinOsc.ar(freq,0,amp,0);
	[sig,sig]; // --> output is an array with 2 channels --> stereo
};
)

~sin = f.play;
~sin.set(args: [\freq,300, \amp,0.15]);
~sin.free;
s.volume.gui; // master volume fader

f.plot(0.03);

(
{
	arg freq=400;
	var sig,mod;
	sig = WhiteNoise.ar(0.1);
	mod = SinOsc.ar(0.2).range(0.1,0.6).poll;
	sig = sig * mod;
	sig!2;
}.play;
)





















