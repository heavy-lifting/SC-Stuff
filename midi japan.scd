//**********SuperCollider basics***********

//A line with '//' at the start is a comment

//The post window is where you can see messages and errors

//The help browser has lots of useful information

//To run a line of code in SuperCollider put your cursor on the line and hit [CMD] + RTN (mac) OR [CTRL] + RTN (windows and linux).



//***********MIDI basics**********

//MIDI (Musical Instrument Digital Interface) is a way of sending messages to a synthesizer

//We can send notes, clock, and control messages

//To use MIDI in SuperCollider we use MIDIClient


MIDIClient.init

MIDIClient.destinations


//MIDI Sources are devices that SuperCollider can receive MIDI from

//MIDI Destinations are devices that SuperCollider can send MIDI to

//But we haven't connected anything yet


//To send MIDI OUT of SuperCollder to our synthesizer we create a MIDIOut instance.

~mysynth = MIDIOut(1);

//The number in this code refers to a MIDI device index on the list of MIDI Destinations (we start counting at 0)

//We can now start sending MIDI data to our synth.

~mysynth.noteOn(0, 60, 60);

//The code above will send out a note on MIDI channel 1 at middle C (60) at a velocity of 60.

//noteOn(midichannel, midinote, velocity);

//MIDI channel on your synth is SuperCollider n + 1.

//MIDI note is a value between 0 and 127 https://is.gd/midinote

//Velocity is a value between 0 and 127

//Try changing the values and see what happens

//You can turn off a note using noteOff

~mysynth.noteOff(0, 60, 60);

//Turn off all notes on a channel

~mysynth.allNotesOff(0);

//Use latency to syncronise multiple devices

~mysynth.latency = 1; //latency is 1 second

//Spend some time droning with you synth and turning notes on and off. What effects can you create? What is frustrating/opportune?

//We can use an array of note numbers to make a chord

(
[42, 48, 56, 63, 70, 79].do{
	arg nn;
	~mysynth.noteOn(0, nn, 25);
}
)

//Using a Routine, we can create pauses between the notes to sequence them.

(
Routine({

		[42, 48, 56, 63, 70, 79].do{
			arg nn;
			~mysynth.noteOn(0, nn, 25);
			1.wait
		}
}).play

)

//Can you hear how the notes stay on? We can turn them off like this

(
Routine({

		[42, 48, 56, 63, 70, 79].do{
			arg nn;
			~mysynth.noteOff(0, nn, 25);
			1.wait
		}
}).play

)

//Here the Array is being randomly shuffled, check the Array help file to see what other methods can be used with arrays.

(
Routine({

		[42, 48, 56, 63, 70, 79].scramble.do{
			arg nn;
			~mysynth.noteOn(0, nn, 25);
			1.wait
		}
}).play

)

//Can you write a routine that plays the next note after the other one has stopped?


//If we place a {}.loop around the contents of the Routine it will run indefinitely

(
r = Routine({
	{
		[42, 48, 56, 63, 70, 79].scramble.do{
			arg nn;
			~mysynth.noteOn(0, nn, 25);
			0.25.wait
		};

		[42, 48, 56, 63, 70, 79].do{
			arg nn;
			~mysynth.noteOff(0, nn, 25);
			0.25.wait
	}}.loop;

}).play

)

//Stop the routine

r.stop

//When stop the Routine some noteOff messages never reach the synth meaning that the note will keep playing FOREVER! We might need to use the all notes off message

~mysynth.allNotesOff(0);

//Sometimes this does not work because the synth needs to be programmed to receive this message. We can try this instead:

(0..127).do{arg n; ~mysynth.noteOff(0, n)};


//**********Control change**********

//Control change messages can be used to change other elements of the sound

//Some controller numbers do certain things about the box. For example, channel 7 is usually volume

//Control works in a similar way to note on
//control(channelnumber, controller number, controller value)
~mysynth.noteOn(0, 56, 20)
~mysynth.control(0, 7, 127)

//You may or may not hear a change depending on the synthesizer you are using because it may not use the standard setup.

//You can setup control change values as you normally would in your DAW.

//You can look up a chart of all the MIDI control for your specific hardware.

//Find some CC you can connect to!

//Everytime you run the code below it will send a new random control value to your synth.

~mysynth.control(0, 7, rrand(0, 127))

//Try this example, to send a series of values to your control change

(
r = Routine({
	{
		//var note = rrand(60, 70);

		~mysynth.noteOn(0, 60, 60);
		(0, 15..127).do{ //how could you randomise this?
			arg val;
			~mysynth.control(0, 7, val);
			0.25.wait
		};
		//~mysynth.noteOff(0, note, 60);

	}.loop;


}).play

)


//How could you set a specific series of notes?

r.stop

~mysynth.allNotesOff(0);


//*********Pbinds and Pdefs**********



//This approach doesn't work well for live coding, because it requires too much typing! We can use patterns to automate this process.

//We can use Pbinds to generate events.

//You can see all the different types of event by searching for PG_08 in the Help browser—>

(
~s1_p1 = Pbind(
	\type, \midi,
	\midicmd, \noteOn, //noteOn is the default so only necessary if you are sending CC messages etc.
	\midiout, ~mysynth,
	\chan, 0,
	\dur, 0.5,
	//\midinote, 60 //+ Pwrand.new([0, 7, 9], [1, 3, 5].reverse.normalizeSum, inf),
	//\amp, Pwhite(0, 1.0) //This may not work on your synth!
	\sustain, Prand([0.02, 1], inf)
).play;
)

~s1_p1.stop


//Control changes in Pbinds

(
~s1_20 = Pbind(
	\type, \midi,
	\midicmd, \control,
	\midiout, ~mysynth,
	\chan, 0,
	\ctlNum, 7,
	\control, Pexprand(1, 127, inf).round,
	\dur, 0.5
).play;
)

~s1_20.stop

//If you run the code multiple times without stopping the Pbind, you layer the pattern.

//This can be confusing in a live performance as you lose control.

//There are better ways of working for live coding!

//Clear SuperCollider with Ctrl+Shift+L (Recompile Class Library)

MIDIClient.init;    // if not already done

~mysynth = MIDIOut.newByName("LoopBe Internal MIDI", "LoopBe Internal MIDI").latency_(Server.default.latency);


//We can use a Pdef to reference a stream that can be updated while playing.

//One pattern may be used in many streams in different places.

//A change in the pattern definition changes all streams.

//No disruption! Edit and reevaluate code live!

//First we should set the tempo

t=TempoClock.new(127/60);

//update the tempo like this

t.tempo = 80/60

//Here's a Pdef
(
Pdef(\s1_p1, Pbind(
	\type, \midi,
	\midicmd, \noteOn, //noteOn is the default so only necessary if you are sending CC messages etc.
	\midiout, ~mysynth,
	\chan, 0,
	\dur, 0.5,
	\midinote, [30,60,45],
	\sustain, Prand([0.02, 1], inf)
)).play(t);

)

//Stop the Pdef playing

Pdef(\s1_p1).stop(t)

//We can view all the Pdefs we have running using the code below

PdefAllGui(16)

//Here are some more patterns, let's see what they do?

(Pseq([100, 200, 300, 400], 1) + .x Pseq([1,2,3,4], 1)).do { |x| x.postln };

Pser([0,1,2,3,4], 8).do { |x| x.postln };

Pwhite(1, 12, 2).do { |x| x.postln };

//PATTERNS FROM THE PATTERN COOKBOOK
/*http://distractionandnonsense.com/sc/A_Practical_Guide_to_Patterns.pdf
"http://doc.sccode.org/Tutorials/A-Practical-Guide/PG_Cookbook04_Sending_MIDI.html"
"http://danielnouri.org/docs/SuperColliderHelp/Control/MIDIOut.html"
"http://danielnouri.org/docs/SuperColliderHelp/Control/UsingMIDI.html"
"https://www.youtube.com/watch?v=5h1g0hWpU_I"*/

//You can see more information on patterns by searching for 'Streams' in the Help browser.

//Rather than setting 'midinote' we can set 'degree' and 'scale'

//We can see more scales by running the code below

Scale.directory

//Run this patterns and play with the tonality. Find some scales that you like.
(
Pdef(\s1_p2,
	Pbind(
		\type, \midi,
		\midiout, ~mysynth,
		\chan, [0],
		//tonality
		\degree, [0,7, 9] + Pseq([0,1,2,3,4,5,6,7], inf),
		//select the scale
		\scale, Scale.gong,
		\root, -12, //The root note of the scale, default is 0 which is middle C
		\dur, 0.25,
		\amp, Pwhite(0.5, 1.0),
	)
).play(t);

)


//You can stop the pattern like this
Pdef(\s1_p2).stop(t)

//We can fade between patterns on updates like this..
Pdef(\s1_p2).fadeTime = 2
