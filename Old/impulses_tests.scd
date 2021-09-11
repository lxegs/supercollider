(
var osc1,osc2;

osc1=osc2={RLPF.ar(Dust.ar([10, 3000]), LFNoise2.ar([0.9, 0.2]).range(100, 3000), 0.2)};


(osc1+osc2)*osc1.plot



)