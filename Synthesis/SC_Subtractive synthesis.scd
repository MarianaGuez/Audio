(
SynthDef(\bellAdd, {arg freq = 440, dur = 5, amp = 1, pan = 0;
	var envs, signal, amps, freqs, durs,freqSum;
	amps = [1,0.67,1,1.8,2.67,1.67,1.46,1.33,1.33,1,1.33];
	durs = [1,0.9,0.65,0.55,0.325,0.35,0.25,0.2,0.15,0.1,0.075] * dur;
	freqs = [0.56,0.56,0.92,0.92,1.19,1.7,2,2.74,3,3.76,4.07] * freq;
	freqs[1] = freqs[1] + 1;
	freqs[3] = freqs[3] + 1.7;
	envs = EnvGen.kr(Env.perc(1/durs*0.1), levelScale:amps, timeScale:durs);
	EnvGen.kr(Env([0,0],[dur]),doneAction:2);
	signal = BPF.ar(WhiteNoise.ar(amps),freqs,0.0001)*envs;
	Out.ar(0,Pan2.ar(signal.sum  * amp/ amps.sum ,pan));
}).send(s);
)

//{BPF.ar(WhiteNoise.ar([20,10,1,0.1]),[1,2,3,4] * 440, 0.0001).sum}.play

(
var weights, values, loop, cholula, notas, durs, pans, amps;

notas = [81,81,81,79,77,79,79];
durs = [1,2,1,2,3,2,5];
pans = [-1,0,0,0,0,1,1];
amps = [1,1,1,0.5,0.25,1,1];
cholula = Routine{
	notas.size.do{arg cont;
	Synth(\bellAdd, [
		\dur, durs[cont],
		\amp, amps[cont],
		\freq, notas[cont].midicps,
		\pan, pans[cont]]);
	if(cont != 8, {0.33.wait}, {2.wait});
	}
};
cholula.play;
)
s.scope