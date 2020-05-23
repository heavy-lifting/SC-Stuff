//**********Based on a workshop developed by Shelly Knotts**********


//Boot the server

s.boot;

//First run this line of code

p = ProxySpace.push;

//Let's make a sound

().play

//Because we didn't give SuperCollider any information it played the default sound

//We can give our sounds names

//Let's make a new name with some parameters:

~alicia = { SinOsc.ar }

//Play the sound

~alicia.play

//Stop the sound
~alicia.stop

//Clear the information
~alicia.clear


// SinOsc is a type of waveform, other waveforms include:

~amelia = { Saw.ar };

~amelia.play

~anne = { PinkNoise.ar };

~anne.play

~aphrodite = { Pulse.ar };

~aphrodite.stop

//let's look at the waveform

s.scope(2)

//How do you stop these sounds?

//SuperCollider uses the default values for anything we don't define

//To add our own values we need to add a new bit of code called ARGUMENTS.

~alicia = { SinOsc.ar(freq: 700, phase: 0, mul: 0.3 )  };

~alicia.play

// try changing the values for 'freq' and 'mul'

// We can fade between changes

p.fadeTime = 2;

// we can also set the fade time for individual sounds

~alicia.fadeTime = 0.5;

~andrea.fadeTime = 0.3;

//We don't need to write all the names of the arguments

~alicia = { SinOsc.ar(600, 0, 0.2) };

~alicia.play

//You can find the names of the arguments in the help browser - try Cmd + D for a shortcut

~andrea = { Saw.ar(freq: 500, mul: 0.1) };

~andrea.play

~anne = { PinkNoise.ar(0.2) };

~anne.play

//We can use a mixer to control our sounds

ProxyMixer.new(p); // automatic mixer for the sounds you make

// this gives you a nice way to start and stop sounds and to change the volume of the sounds that are running.

// if we make a new sound now it'll appear in the mixer

~beatrice = { Impulse.ar(freq: 5) }

~beatrice.stop

// We can use [] to give SuperCollider more than one piece of information

~andrea = { Saw.ar([700, 800, 900, 600], 0.1) };

~andrea.play

// this is where things get weird and a bit confusing...

// now try running ~betty

~betty = { Saw.ar([700, 800], 0.1) };

~betty.stop

// the sounds that we make keep the same number of channels as when we first run them.

// normally SuperCollider would see [700, 800] as making a 2 channel sound with frequency of 700 in the left (1st) channel and frequency 800 in the right (2nd) channel

// so if we add more pitches to ~andrea now it'll keep adding them to the first channel - as we only had 1 channel when we ran it the first time. and if we add more pitches to ~betty it'll keep alternating the pitches between left and right channels

// if we're making a new sound which has a lot of pitches though we can use Mix.new to tell SuperCollider we want to hear all of the pitches in 1 channel.

~boudica = { Mix.new( SinOsc.ar([70, 75, 100].midicps) ) }

~boudica.play

~boudica_2 = { Splay.ar( SinOsc.ar([500, 700, 1234, 288, 359, 1000.01, 4000]) ) }


~boudica_2.play

~boudica_2 = { Splay.ar( SinOsc.ar(Array.fill(5, { rrand(50, 5000) } )) ) }

Array.fill(5, { rrand(50, 5000) } )

// the first argument of Mix is the thing you want to Mix, so we can just drop our SinOsc right in there.

// WELL DONE! NOW YOU CAN DO ADDITIVE SYNTHESIS.


// Another easy type of synthesis is SUBTRACTIVE SYNTHESIS. This means using filters to get rid of some of the sounds.

// RLPF is a type of Low Pass filter - it cuts out all the frequencies above the 'Cutoff frequency'.

~filter_betty = { RLPF.ar(Saw.ar([700, 800], 0.1), 800, 0.2, 1)  }

~filter_betty.play

// here's another example with a high pass filter.

// we've replaced our 'Saw.ar([700, 800], 0.1)' with a reference to ~betty. This tells supercollider to use whatever code is called ~betty as the input.

~filter_betty = { RHPF.ar(~betty.ar, 800, 0.2, 1)  }


// a third type of synthesis which we can use to make more complex sounds is MODULATION. This means using a second waveform to change the first.

//The most simple type of modulation is Amplitude modulation.


~catherine = { Pulse.ar([100, 120], 0.5, SinOsc.kr(10, 0, 0.5, 0.5))  }

~catherine.play

// the SinOsc's frequency is how quickly the amplitude changes and the mul and add arguments are how much it changes.

~catherine = { Pulse.ar([100, 120], 0.5, 1)  }

// sometimes it's easier to specify the modulation amount with the range method. Here we specify the upper and lower limits of the amplitude modulation.

~catherine = { Pulse.ar([100, 120], 0.5, SinOsc.kr(10).range(0, 2))  }

// you can use other waveforms to modulate the amplitude. e.g.:

~catherine = { Pulse.ar([100, 120], 0.5, Saw.kr(1).range(0, 1))  }

~catherine = { Pulse.ar([100, 120], 0.5, LFNoise1.kr(100).range(0, 1))  }


// another type of modulation is FREQUENCY MODULATION. Here we multiply a base frequency with another waveform.

// try different values for the frequency and mul arguments of the modulator to get different sounds.

~cleopatra = { SinOsc.ar([300, 310] + SinOsc.ar(20, 0, 10), 0, 1 ) }

~cleopatra.play

// we can also use the other sounds that we've made as modulators.

~cleopatra = { SinOsc.ar([300, 350] + ~catherine.ar, 0, 1 ) }

// we can add other effects to our sounds like Reverb and Comb filters.

// you can find out what each of the arguments are by opening the helpfile. BE CAREFUL as very large room sizes or reverb times can crash SuperCollider.

~daphne = { GVerb.ar(~cleopatra.ar, 10, 0.1) }

~daphne.play

~delia = { CombC.ar(~catherine.ar, 1, 0.05)  }

~delia.play

~dolores = { Decimator.ar(~alicia.ar, 44100 * 1, 2) }

~dolores.play

~dorothy = { DFM1.ar(BPF.ar(~anne.ar, 600, 0.3), 600, 0.99) }

~dorothy.play

// start combining things to make more complex sounds.

~laurie = { (SinOsc.ar([440, 442] + 1000 * LFSaw.kr(10).range(1, 0.9), 0, LFSaw.kr(15).range(1, 0)) * LFSaw.kr(1).range(SinOsc.ar(0.1).range(1, 6), 0) ).tanh}

~laurie.play

~filter_laurie = {  (CombC.ar(~laurie.ar, 1, LFNoise0.kr(20).range(0.01, 0.1).round(0.01)) * LFSaw.kr(0.3).range(0, 2)).tanh }

~filter_laurie.play

~filter_laurie_2 = { GVerb.ar(DFM1.ar(~filter_laurie.ar, 500, 0.99), 10, 4) * 2 }

~filter_laurie_2.play

// synth defs
// a synth def is a recipe for making sound
// we can use it again and again to make similar sounds.
// We can give ourselves paramatres that we can change later. e.g. frequency/pitch, amplitude, etc.

(
SynthDef(\sn, { |out=0,amp=0.1,sustain=0.1,freq=440|
	var snd, env;

	snd = SinOsc.ar(freq, 0.5pi, 3).tanh;

	env = EnvGen.ar(Env.perc(0.01,sustain),doneAction:2);
	OffsetOut.ar(out, snd * env * amp);
}).add;
)


// to trigger one sound we just make a synth with the same name as the pattern we've just made.

x = Synth(\sn);

x = Synth(\sn, [\freq, 800, \sustain, 5]);

(
Pdef(\pattern_1,
	Pbind(
		\amp, 1,
		\instrument, \sn,
		\dur, 0.5,
		\degree, 1, //degree is like 'freq' but lets us use scales instead of frequencies.
		\octave, 4,
		\out, 0,
	)
);
)

Pdef(\pattern_1).play


// what about if we want to play the whole scale?
(
Pdef(\pattern_2,
	Pbind(
		\amp, Pseq([1, 0.5, 0.2], inf),
		\instrument, \sn,
		\dur, Pseq([0.5, 0.5, 1], inf),
		\degree, Prand([0, 5, 3], inf), // Pseq tells the pattern to play through the list in order. In this case we just play through it once, but we can also use 'inf' to repeat the pattern forever.
		\out, 0,
	)
);
)

Pdef(\pattern_2).play

(
Pdef(\pattern_2,
	Pbind(
		\amp, 1,
		\instrument, \sn,
		\dur, 0.5,
		\degree, Prand([0, 1, 2, 3, 4, 5, 6, 7], 3), // we can also use Prand to choose from the list at random.
		\octave, Prand([4, 5, 6, 7], 3),
		\out, 0,
	)
);
)

Pdef(\pattern_2).play

(
Pdef(\pattern_3,
	Pbind(
		\amp, Pwhite(0.0, 1.0),
		\instrument, \sn,
		\dur, 0.1,
		\degree, Pwhite(0, 7), // or Pwhite to choose between a range of numbers.
		\out, 0,
	)
);
)

Pdef(\pattern_3).play

// try making a new pattern which uses Pseq/Prand or Pwhite to set the amplitude, and duration.

// more synth def examples

SynthDef(\dr, { |out=0,amp=0.1,sustain=0.01,freq=440, noise = 0.1, line=0.1|
	var snd, env, ctrl;

	//ctrl = ;
	snd = SinOsc.ar([freq, freq + 10] * XLine.kr(1, 0.001, line), 0.5pi, 3).tanh;
	snd = snd + BrownNoise.ar(noise * XLine.kr(1, 0.001, 0.05));
	snd = BPF.ar(snd, freq + 50, 0.9);
	snd = LeakDC.ar(snd);
	env = EnvGen.ar(Env.perc(0.01,sustain),doneAction:2);
	OffsetOut.ar(out, snd * env * amp);
}).add;


SynthDef(\nz, { |out=0,amp=0.1,sustain=0.01,freq=440, noise = 0.1, q = 0.5|
	var snd, env, ctrl;

	//ctrl = ;
	snd = (PinkNoise.ar(noise)).tanh;
	snd = BPF.ar(snd, freq, q);
	env = EnvGen.ar(Env.perc(0.01,sustain),doneAction:2);
	OffsetOut.ar(out, snd * env * amp);
}).add;


Pdef(\drum_pattern_1, // basic bass drum
	Pbind(
		\amp, 4,
		\instrument, \dr,
		\dur, 0.5,
		\freq, Pwhite(80, 120),
		\out, 0,
	)
);

Pdef(\drum_pattern_1).play

Pdef(\drum_pattern_2, //hi tom
	Pseq([
		Pbind(
			\amp, 4,
			\instrument, \dr,
			\dur, 0.5,
			\freq, Pwhite(80, 120, 4),
			\out, 0,
		),
		Pbind(
			\amp, Pseq([0, 2], inf),
			\instrument, \dr,
			\dur, 0.5,
			\legato, 0.1,
			//\noise, 0.9,
			\freq, Pwhite(680, 720, 4),
			//\line, 0.07,
			\out, 0,
		)
	], 2)
);

Pseq([Pdef(\drum_pattern_2), Pdef(\pattern_3)], inf).stop

Pdef(\drum_pattern_2).stop


Pdef(\noise_pattern_1, //snare
	Pbind(
		\amp, Pseq([3, 5, 4, 4, 2], inf),
		\instrument, \nz,
		\dur, Pseq([0.125, 0.25, 0.25, 0.25, 0.125], inf),
		\legato, 0.1,
		\noise, 4,
		\q, 0.99,
		\freq, Pwhite(1280, 1220),
		\out, Pseq([0, 6, 8], inf),// [0,6,8]
	)
);

Pdef(\noise_pattern_1).stop

PdefAllGui.new

// adding effects

Ndef(\a, { Out.ar(0, GVerb.ar(InFeedback.ar(6), 10, 0.1 )  )  });
Ndef(\a).stop

Ndef(\b, { Out.ar(0, CombC.ar(InFeedback.ar(8), 1, 0.1 )  )  });
Ndef(\b).stop

// mic input

~in = { SoundIn.ar(0).scope }
~in.clear

// scheduling

t = Task{

	{

		~laurie.play;

		4.wait;

		~laurie.stop;

		4.wait;

	}.loop

}

t.stop;

// recording

s.makeWindow



