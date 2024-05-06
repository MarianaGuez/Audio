//AMBULANCE
{SinOsc.ar(SinOsc.ar(0.20,0,500,1000))}.play

//POLICE
(
{0.5*SinOsc.ar(SinOsc.ar(0.3,0,300,1000))+SinOsc.ar(SinOsc.ar(3,0,400,1000))}.play
)
s.scope

//ALARMA
(
var env = Env([0, 1, 0, 1, 0, 1, 0, 1, 0]);
{0.5*Saw.ar(10)*SinOsc.ar(2500) * EnvGen.kr(env)}.play
)

//CRICKET
(
SynthDef(\cricket, {
	var envs, signal, amps, freqs, durs,freqSum,freqs2,freqs3,pan,amp;
	pan = 0;
	amp = 1;
	amps = [1,0.9707,0.8878,0.8634,0.6195,0.4829,0.5561,1,0.9707,0.8878,0.6780,0.6244,0.5561,0.4829];
	freqs = [0.9198,0.9272,0.9430,0.9620,0.9519,0.9921,0.9015] * 4000;
	freqs2 = [0.0755,0.0754,0.0753,0.0755,0.0751,0.0756, 0.0749]*3000;
	freqs3 = freqs++freqs2;
	envs = EnvGen.kr(Env([0, 1,0,1,0,1,0]),levelScale:amps);
	signal = SinOsc.ar(freqs3) * envs;
	Out.ar(0,Pan2.ar(0.5*signal.sum  * amp/ amps.sum,pan));
}).send(s);
)

Synth(\cricket).play


//OTROS
{1.2*SinOsc.ar(Saw.ar(9)*SinOsc.ar(1,0,200,40))}.play
