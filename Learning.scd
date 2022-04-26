(
var x;
x=2;
x=x+2;
)

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

|freq1=440, freq2=440, amp1=0.5, amp2=0.5|

var sine1, sine2, output;

sine1 = SinOsc.ar(freq1, mul:amp1);

sine2 = SinOsc.ar(freq2, mul:amp2);

output = sine1+sine2;

}

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




















