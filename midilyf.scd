MIDIClient.init;


~midiOut = MIDIOut.newByName("VT-4", "VT-4"); // substitute your own device here


~midiOut1 = MIDIOut.newByName("Rocket", "Rocket"); // substitute your own device here


~midiOut2 = MIDIOut.newByName("QUAD-CAPTURE", "QUAD-CAPTURE"); // substitute your own device here

~midiOut3= MIDIOut.newByName("Microsoft GS Wavetable Synth", "Microsoft GS Wavetable Synth"); // substitute your own device here



/*
This is an example startup file. You can load it from your startup file
(to be found in Platform.userAppSupportDir +/+ "startup.scd")
*/


(
// configure the sound server: here you could add hardware specific options
// see http://doc.sccode.org/Classes/ServerOptions.html
s.options.numBuffers = 1024 * 512; // increase this if you need to load more samples
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



~dirt.soundLibrary.addMIDI(\vt4, ~midiOut);


~dirt.soundLibrary.addMIDI(\ro, ~midiOut1);


~dirt.soundLibrary.addMIDI(\qc, ~midiOut2);

~dirt.soundLibrary.addMIDI(\ms, ~midiOut3);



~midiOut.latency = 0.45;

~midiOut1.latency = 0.1;

~midiOut2.latency = 0.45;

~midiOut3.latency = 0.45;



s.scope