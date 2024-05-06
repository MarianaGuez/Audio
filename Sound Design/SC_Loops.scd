SynthDef(\perc,{arg freq = 440, amp = 0.1, dur = 0.5;
	var env = EnvGen.kr(Env.perc(0.1, dur), doneAction: 2);
	var signal = SinOsc.ar(freq);
	Out.ar(0, Pan2.ar(signal * env * amp, 0));
}).send(s);
(
var repetir,x,z,octava, notas;
var dur, esperar,aver,comp,tempo;
repetir = 20;
z = [1,1,4,4,5,5,6,2];
//z = [1,1];
notas = [392,440,493.88,523.25,587.33,659.26,739.99,783.99];
octava = [0.25,0.1,0.1,1,1,1,2,4];
tempo = [0.1,0.75,0.25,1,2,1.5,0.75];
Routine({
	repetir.do{
		x = switch(z.choose)
		{1}{
			dur = rrand(tempo.choose,tempo.choose);
			aver = octava.choose;
			Synth(\perc, [
			\freq, 392*octava.choose,
			\amp, 0.1,
			\dur, dur
			]);
			Synth(\perc, [
			\freq, 493.88*octava.choose,
			\amp, 0.1,
			\dur, dur
			]);
			Synth(\perc, [
			\freq, 587.33*octava.choose,
			\amp, 0.1,
			\dur, dur
			]);
			comp = dur*rrand(0.3,1);
			Synth(\perc, [
			\freq,notas.choose*octava.choose,
			\amp, 0.1,
			\dur, comp
			]);
			Synth(\perc, [
			\freq,notas.choose*octava.choose,
			\amp, 0.1,
			\dur, 1-comp
			]);

			dur.wait;
		}
		{5}{
			dur = rrand(tempo.choose,tempo.choose);
			aver = octava.choose;
			Synth(\perc, [
			\freq, 587.33*octava.choose,
			\amp, 0.1,
			\dur, dur
			]);
			Synth(\perc, [
			\freq, 739.99*octava.choose,
			\amp, 0.1,
			\dur, dur
			]);
			Synth(\perc, [
			\freq, 880*octava.choose,
			\amp, 0.1,
			\dur, dur
			]);
			comp = dur*rrand(0.3,1);
			Synth(\perc, [
			\freq,notas.choose*octava.choose,
			\amp, 0.1,
			\dur, comp
			]);

			Synth(\perc, [
			\freq,notas.choose*octava.choose,
			\amp, 0.1,
			\dur, 1-comp
			]);
			dur.wait;
		}
		{6}{
			dur = rrand(tempo.choose,tempo.choose);
			aver = octava.choose;
			Synth(\perc, [
			\freq, 659.26*octava.choose,
			\amp, 0.1,
			\dur, dur
			]);
			Synth(\perc, [
			\freq, 783.99*octava.choose,
			\amp, 0.1,
			\dur, dur
			]);
			Synth(\perc, [
			\freq, 987.77*octava.choose,
			\amp, 0.1,
			\dur, dur
			]);
			comp =  dur*rrand(0.3,1);
			Synth(\perc, [
			\freq,notas.choose*octava.choose,
			\amp, 0.1,
			\dur, comp
			]);

			Synth(\perc, [
			\freq,notas.choose*octava.choose,
			\amp, 0.1,
			\dur, 1-comp
			]);


			dur.wait;
		}
		{4}{
			dur = rrand(tempo.choose,tempo.choose);
			aver = octava.choose;
			Synth(\perc, [
			\freq, 523.25*octava.choose,
			\amp, 0.1,
			\dur, dur
			]);
			Synth(\perc, [
			\freq, 659.26*octava.choose,
			\amp, 0.1,
			\dur, dur
			]);
			Synth(\perc, [
			\freq, 783.99*octava.choose,
			\amp, 0.1,
			\dur, dur
			]);
			comp =  dur*rrand(0.3,1);
			Synth(\perc, [
			\freq,notas.choose*octava.choose,
			\amp, 0.1,
			\dur, comp
			]);

			Synth(\perc, [
			\freq,notas.choose*octava.choose,
			\amp, 0.1,
			\dur, 1-comp
			]);
			dur.wait;
		};
		//x.postln;
		//rrand(0.1,0.4).wait;
	}
}).play;


)
