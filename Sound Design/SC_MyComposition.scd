(
SynthDef(\fmco, {arg freq = 440, imod = 0.5, ampmod = 10000, dur=5, ivarti = 0.5, amp = 0.5, pan = 0;
	var portadora, moduladora, envgen, envtimbrica, envimod;
	envimod = Line.kr(imod - ivarti, imod, dur);
	envtimbrica = Line.kr(ampmod, ampmod * 0.5, dur);
	envgen = EnvGen.kr(Env.perc(0.01,dur-0.01), doneAction: 2);
	moduladora = SinOsc.ar(freq * envimod, 0, envtimbrica);
	portadora = SinOsc.ar(freq + moduladora, 0, 0.5);
	Out.ar(0, Pan2.ar(portadora * envgen * amp, pan));
}).send(s);
)

(
var freqs, imods, ampmods, durs, amps, pans, ivartis, time, sonidoNum, weights;
freqs = [466.16, 160.41, 130.81, 0, 0, 146.83, 554.37, 659.26, 554.37, 739.99];
imods = [0.45, 0.48, 0.026, 0, 0, 0.54, 0.14, 0.94, 0.14, 0.85];
ampmods = [21.58, 48.54, 33.24, 0, 0, 32.05, 56.62, 32.81, 49.29, 39.82];
durs = [6.17, 1, 6, 0, 0, 2.91, 2, 2, 2, 1];
amps = [1.26, 1.78, 3.98, 0, 0, 2.82, 1.26, 1, 1.26, 0.71];
pans = [-1, 1, 1, 0, 0, -1, 1, 1, -1, 0];
ivartis = [0.002, 0.004, 0.004, 0, 0, 0.008, 0.009, 0.002, 0.007, 0.005];
Routine({
	2.do{
	Synth(\fmco, [\freq, freqs[8], \imod, imods[8], \ampmod, ampmods[8], \dur, durs[8], \amp, amps[8], \pan, pans[8], \ivarti, ivartis[8]]);
	1.wait;
	Synth(\fmco, [\freq, freqs[1], \imod, imods[1], \ampmod, ampmods[1], \dur, durs[1], \amp, amps[1], \pan, pans[1], \ivarti, ivartis[1]]);
		1.wait;};
	Synth(\fmco, [\freq, freqs[8], \imod, imods[8], \ampmod, ampmods[8], \dur, durs[8], \amp, amps[8], \pan, pans[8], \ivarti, ivartis[8]]);
	1.wait;
	Synth(\fmco, [\freq, freqs[8], \imod, imods[8], \ampmod, ampmods[8], \dur, durs[8], \amp, amps[8], \pan, pans[8], \ivarti, ivartis[8]]);
	1.wait;
	2.do{Synth(\fmco, [\freq, freqs[5], \imod, imods[5], \ampmod, ampmods[5], \dur, durs[5], \amp, amps[5], \pan, pans[5], \ivarti, ivartis[5]]);
		1.wait;
		Synth(\fmco, [\freq, freqs[1], \imod, imods[1], \ampmod, ampmods[1], \dur, durs[1], \amp, amps[1], \pan, pans[1], \ivarti, ivartis[1]]);
		1.wait;};
	Synth(\fmco, [\freq, freqs[5], \imod, imods[5], \ampmod, ampmods[5], \dur, durs[5], \amp, amps[5], \pan, pans[5], \ivarti, ivartis[5]]);
		1.wait;
	Synth(\fmco, [\freq, freqs[5], \imod, imods[5], \ampmod, ampmods[5], \dur, durs[5], \amp, amps[5], \pan, pans[5], \ivarti, ivartis[5]]);
		1.wait;
	Synth(\fmco, [\freq, freqs[2], \imod, imods[2], \ampmod, ampmods[2], \dur, durs[2], \amp, amps[2], \pan, pans[2], \ivarti, ivartis[2]]);
	1.wait;
	3.do{Synth(\fmco, [\freq, freqs[0], \imod, imods[0], \ampmod, ampmods[0], \dur, durs[0], \amp, amps[0], \pan, pans[0], \ivarti, ivartis[0]]);
		0.3.wait;
	};
	Synth(\fmco, [\freq, freqs[9], \imod, imods[9], \ampmod, ampmods[9], \dur, durs[9], \amp, amps[9], \pan, pans[9], \ivarti, ivartis[9]]);
	1.wait;
	3.do{Synth(\fmco, [\freq, freqs[0], \imod, imods[0], \ampmod, ampmods[0], \dur, durs[0], \amp, amps[0], \pan, pans[0], \ivarti, ivartis[0]]);
		0.3.wait;
	};
	2.do{Synth(\fmco, [\freq, freqs[9], \imod, imods[9], \ampmod, ampmods[9], \dur, durs[9]*1.25, \amp, amps[9], \pan, pans[9], \ivarti, ivartis[9]]);
		0.5.wait;
		Synth(\fmco, [\freq, freqs[2]/2, \imod, imods[2], \ampmod, ampmods[2], \dur, durs[2]/3, \amp, amps[2], \pan, pans[2], \ivarti, ivartis[2]]);
		0.5.wait;};

	2.do{Synth(\fmco, [\freq, freqs[9], \imod, imods[9], \ampmod, ampmods[9], \dur, durs[9], \amp, amps[9], \pan, pans[9], \ivarti, ivartis[9]]);
		0.5.wait;
		Synth(\fmco, [\freq, freqs[6], \imod, imods[6], \ampmod, ampmods[6], \dur, durs[6], \amp, amps[6], \pan, pans[6], \ivarti, ivartis[6]]);
		0.25.wait;};
	Synth(\fmco, [\freq, freqs[7], \imod, imods[7], \ampmod, ampmods[7], \dur, durs[7], \amp, amps[7], \pan, pans[7], \ivarti, ivartis[7]]);
	1.wait;
	Synth(\fmco, [\freq, freqs[7], \imod, imods[7], \ampmod, ampmods[7], \dur, durs[7], \amp, amps[7], \pan, pans[7], \ivarti, ivartis[7]]);
	0.5.wait;

	2.do{Synth(\fmco, [\freq, freqs[9], \imod, imods[9], \ampmod, ampmods[9], \dur, durs[9], \amp, amps[9], \pan, pans[9], \ivarti, ivartis[9]]);
		0.5.wait;
		Synth(\fmco, [\freq, freqs[6], \imod, imods[6], \ampmod, ampmods[6], \dur, durs[6], \amp, amps[6], \pan, pans[6], \ivarti, ivartis[6]]);
		0.25.wait;};
	Synth(\fmco, [\freq, freqs[7], \imod, imods[7], \ampmod, ampmods[7], \dur, durs[7], \amp, amps[7], \pan, pans[7], \ivarti, ivartis[7]]);
	1.wait;
	Synth(\fmco, [\freq, freqs[7], \imod, imods[7], \ampmod, ampmods[7], \dur, durs[7], \amp, amps[7], \pan, pans[7], \ivarti, ivartis[7]]);
	0.5.wait;
	4.do{Synth(\fmco, [\freq, freqs[8], \imod, imods[8], \ampmod, ampmods[8], \dur, durs[8], \amp, amps[8], \pan, pans[8], \ivarti, ivartis[8]]);
		1.wait;};
	Synth(\fmco, [\freq, freqs[2]/2, \imod, imods[2], \ampmod, ampmods[2], \dur, durs[2], \amp, amps[2], \pan, pans[2], \ivarti, ivartis[2]]);
	1.wait;
}).play;

)
//Aquí comenzó la parte creativa
//Se realizaron varias pruebas con valores random y se imprimían para conocer los valores de los sonidos que agradaban
//Se seleccionaron diez sonidos de los cuales solo se usaron 7 en la pieza final

(
{
	var freq, imod, ampmod, dur, amp, pan, ivarti;
	5.do{
		freq = rrand(30,80).midicps;
		imod = rrand(0.01,0.99);
		ampmod = rrand(0.0, 100);
		dur = rrand(4.0,20.0);
		amp = rrand(-6,12).dbamp;
		pan = rrand(-1,1);
		ivarti = rrand(0,0.01);

		Synth(\fmco, [
			\freq, freq,
			\imod, imod,
			\ampmod, ampmod,
			\dur, dur,
			\amp, amp,
			\pan, pan,
			\ivarti, ivarti]);
		"Valores Asignados: \n".post;
		"freq: " ++ freq.postln;
		"imod: " ++ imod.postln;
		"ampmod: " ++ ampmod.postln;
		"dur: " ++ dur.postln;
		"amp: " ++ amp.postln;
		"pan: " ++ pan.postln;
		"ivarti: " ++ ivarti.postln;
		"\n \n".postln;
		1.wait;
	}
}.fork
)