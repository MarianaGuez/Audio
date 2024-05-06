Routine({

	for(60,72){arg nota;
		~s1 = {SinOsc.ar(nota.midicps) * 0.1}.play;
		2.wait;
		~s1.free
	};


	for(1,40){ arg i;
		~notesForte = {SinOsc.ar(IRand().midicps)*0.7}.play;
		0.5.wait;
		~notesForte.free;
	};
	for(1,10){ arg i;
		~notesPiano = {SinOsc.ar(IRand().midicps)*0.1}.play;
		0.5.wait;
		~notesPiano.free;
	};

	for(0,11){arg menosUno;
		var nota = 72 - menosUno;
		~s1 = {SinOsc.ar(nota.midicps) * 0.1}.play;
		2.wait;
		~s1.free;
	};
}).play;

