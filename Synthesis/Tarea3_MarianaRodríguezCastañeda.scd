(
SynthDef(\bell, {arg freq = 440, dur = 5, amp = 1, pan = 0;
	var envs, signal, amps, freqs, durs,freqSum;
	amps = [1,0.67,1,1.8,2.67,1.67,1.46,1.33,1.33,1,1.33];
	durs = [1,0.9,0.65,0.55,0.325,0.35,0.25,0.2,0.15,0.1,0.075] * dur;
	freqs = [0.56,0.56,0.92,0.92,1.19,1.7,2,2.74,3,3.76,4.07] * freq;
	freqs[1] = freqs[1] + 1;
	freqs[3] = freqs[3] + 1.7;
	envs = EnvGen.kr(Env.perc(1/durs*0.01), levelScale:amps, timeScale:durs);
	EnvGen.kr(Env([0,0],[dur]),doneAction:2);
	signal = SinOsc.ar(freqs) * envs;
	Out.ar(0,Pan2.ar(signal.sum  * amp/ amps.sum,pan));
}).send(s);
)
{BPF.ar(WhiteNoise.ar([1,0.67,1,1.8,2.67,1.67,1.46,1.33,1.33,1,1.33]),[0.56,0.56,0.92,0.92,1.19,1.7,2,2.74,3,3.76,4.07] * 440,).sum}.play
(
var weights, values, loop, cholula, cholula2;
weights = [1,1,2,3,5,8,13,13,8,5,3,2,1,1].normalizeSum;
loop = 5;
cholula = Routine {
loop.do {
	{
    Synth(\bell, [
        \dur, 5.0,     // Duración
		\amp, rrand(0.22,0.9),     // Amplitud
		\freq, 440,    // Frecuencia
        \pan, rrand(-1.0,1)      // Panorama
    ]);

	rrand(1.0,3).wait;

	Synth(\bell, [
        \dur, 5.0,     // Duración
        \amp, rrand(0.22,0.9),     // Amplitud
        \freq, rrand(65,75,weights).midicps,    // Frecuencia
        \pan, rrand(-1.0,1)      // Panorama
    ]);

	rrand(1.0,3).wait;

	Synth(\bell, [
        \dur, 5.0,     // Duración
        \amp, rrand(0.22,0.9),     // Amplitud
        \freq, rrand(65,75,weights).midicps,    // Frecuencia
		\pan, rrand(-1.0,1)     // Panorama
    ]);
    }.fork;

	rrand(1.0,3).wait;
};
};
cholula.play;
cholula2 = Routine {
	loop.do {
		Synth(\bell, [
			\dur, 5.0,     // Duración
			\amp, 0.9,     // Amplitud
			\freq, 60.midicps,    // Frecuencia
			\pan, 0.5      // Panorama
		]);

		1.5.wait;
	};
};

cholula2.play;
)


s.meter

//Synth(\bell,[\dur,5, \amp, 1.0, \freq, 63.midicps, \pan, 0]);
//{SinOsc.ar([1,1.4] * 440)*0.3}.play
//{SinOsc.ar([1,1,2,2,3,])}
//Hacer sonar campanas en tiempos aleatorios, con dur aleatorias y amp y paneos aleatorios. Construir un lindo paisaje sonoro de Cholula.¸