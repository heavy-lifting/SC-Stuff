
// version 0.3

// first, initialize your midi device.
(
MIDIClient.init;
MIDIClient.list; // to check, which are there, you can query them
)


// create a midi out connection
~midiOut = MIDIOut.newByName("3- VT-4", "3- VT-4"); // substitute your own device here

~midiOut2 = MIDIOut.newByName("QUAD-CAPTURE", "QUAD-CAPTURE"); // substitute your own device here

~midiOut3 = MIDIOut.newByName("Rocket", "Rocket"); // substitute your own device here


 // you may want to adjust the latency here
~midiOut.latency = 0.125;

~midiOut2.latency = 0.125;

~midiOut3.latency = 0.125;

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

// define one instrument called "midi" (you may call it what you like)
// it uses the built in event type "midi" (this is predefined).

~dirt.soundLibrary.addMIDI(\vt4, ~midiOut);

~dirt.soundLibrary.addMIDI(\qc, ~midiOut2);

~dirt.soundLibrary.addMIDI(\ro, ~midiOut3);

s.scope

// note: parameter names may change in the future!

// in tidal, define the following parameters:

    (midicmd, midicmd_p) = pS "midicmd" (Nothing)
    (midichan, midichan_p) = pF "midichan" (Nothing)
    (progNum, progNum_p) = pF "progNum" (Nothing)
    (val, val_p) = pF "val" (Nothing)
    (uid, uid_p) = pF "uid" (Nothing)
    (array, array_p) = pF "array" (Nothing)
    (frames, frames_p) = pF "frames" (Nothing)
    (seconds, seconds_p) = pF "seconds" (Nothing)
    (minutes, minutes_p) = pF "minutes" (Nothing)
    (hours, hours_p) = pF "hours" (Nothing)
    (frameRate, frameRate_p) = pF "frameRate" (Nothing)
    (songPtr, songPtr_p) = pF "songPtr" (Nothing)
    (ctlNum, ctlNum_p) = pF "ctlNum" (Nothing)
    (control, control_p) = pF "control" (Nothing)


// the following midicmds and their parameters are then supported
// the usual note/freq and legato/sustain parameters are taken into account

polyTouch: midichan, midinote, polyTouch
program: midichan, progNum
bend: midichan, val
sysex: uid, array
noteOn: midichan, midinote, amp // default
allNotesOff: midichan
smpte: frames, seconds, minutes, hours, frameRate
songPtr: songPtr
control: midichan, ctlNum, control
touch: midichan, val
noteOff: midichan, midinote, amp // sent automatically, after sustain.



	(
		~d1 = ~dirt.orbits[0]; ~d2 = ~dirt.orbits[1]; ~d3 = ~dirt.orbits[2];
		~d4 = ~dirt.orbits[3]; ~d5 = ~dirt.orbits[4]; ~d6 = ~dirt.orbits[5];
		~d7 = ~dirt.orbits[6]; ~d8 = ~dirt.orbits[7]; ~d9 = ~dirt.orbits[8];
		~d10 = ~dirt.orbits[9]; ~d11 = ~dirt.orbits[10]; ~d12 = ~dirt.orbits[11];
	);