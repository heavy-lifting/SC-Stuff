MIDIClient.init;

/*
This is an example startup file. You can load it from your startup file
(to be found in Platform.userAppSupportDir +/+ "startup.scd")
*/


(
// configure the sound server: here you could add hardware specific options
// see http://doc.sccode.org/Classes/ServerOptions.html
s.options.numBuffers = 1024 * 2056; // increase this if you need to load more samples
s.options.memSize = 8192 * 32; // increase this if you get "alloc failed" messages
s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
s.options.numOutputBusChannels = 2; // set this to your hardware output channel size, if necessary
s.options.numInputBusChannels = 2; // set this to your hardware output channel size, if necessary
// boot the server and start SuperDirt
s.waitForBoot {
	~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
	~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
	// for example: ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");
	// s.sync; // optionally: wait for samples to be read
	~dirt.start(57120, 0 ! 12);   // start listening on port 57120, create two busses each sending audio to channel 0

	// optional, needed for convenient access from sclang:
	(
		~d1 = ~dirt.orbits[0]; ~d2 = ~dirt.orbits[1]; ~d3 = ~dirt.orbits[2];
		~d4 = ~dirt.orbits[3]; ~d5 = ~dirt.orbits[4]; ~d6 = ~dirt.orbits[5];
		~d7 = ~dirt.orbits[6]; ~d8 = ~dirt.orbits[7]; ~d9 = ~dirt.orbits[8];
		~d10 = ~dirt.orbits[9]; ~d11 = ~dirt.orbits[10]; ~d12 = ~dirt.orbits[11];
	);
};

s.latency = 0.3; // increase this if you get "late" messages
);



**********MIDI IN**********

//To accept MIDI in to Tidal we need to run a bit more code - this lets SuperCollider convert MIDI inputs from your controller into OSC messages

// Evaluate the block below to start the mapping MIDI -> OSC.

(
var on, trig, off, cc; // here we have four variables - on and trig both refer to a noteon message, off is a noteoff, and cc is a control change
var osc;

osc = NetAddr.new("127.0.0.1", 6010);

MIDIClient.init;
MIDIIn.connectAll;

// this next part sends the midi note number to "n" to be used in Tidal


on = MIDIFunc.noteOn({ |val, num, chan, src|

	osc.sendMsg("/ctrl", "n", num);

});


// this next part sends a value of 1  to "t" with a noteon message - we use this to turn the gain to 1 in Tidal

trig = MIDIFunc.noteOn({ |val, num, chan, src|

	osc.sendMsg("/ctrl", "t", 1);


//	osc.sendMsg("/ctrl", num.asString, val/127);


});

// this next part sends a value of 0 to "t" with a noteoff message - we use this to turn the gain to 0 in Tidal

off = MIDIFunc.noteOff({ |val, num, chan, src|
	osc.sendMsg("/ctrl", "t", 0);
});

// this next part is to map any cc messages you might want

cc = MIDIFunc.cc({ |val, num, chan, src|
	osc.sendMsg("/ctrl", num.asString, val/127);

});


if (~stopMidiToOsc != nil, {
	~stopMidiToOsc.value;
});

~stopMidiToOsc = {
	on.free;
	trig.free;
	off.free;
	cc.free;
};
)

// Evaluate the line below to stop it.
~stopMidiToOsc.value;


s.scope