include("SuperDirt")

SuperDirt.start

Quarks.gui

s.options.numOutputBusChannels = 16;

s.waitForBoot{
	~dirt = SuperDirt(2,s);
	~dirt.start(57120, [0, 2, 4, 6, 8, 10, 12, 14]);
	s.meter;
	s.latency = 0.0;
}

MIDIClient.init;

~midiOut = MIDIOut.newByName("Pro40", "MIDI");

~midiOut.latency = 0;

~dirt.soundLibrary.addMIDI(\midi, ~midiOut);


(
s.options.numBuffers = 1024 * 256;
s.options.numOutputBusChannels = 16;

s.waitForBoot{
	~dirt = SuperDirt(2,s);
	~dirt.loadSoundFiles;
	~dirt.start(57120, [0, 2, 4, 6, 8, 10, 12, 14]);
	s.latency = 0.0;
};
)


s.scope

-- my code


(
s.options.numBuffers = 1024 * 256;
s.options.memSize = 8192 * 16;
s.options.maxNodes = 1024 * 32;
s.options.numOutputBusChannels = 8; // total number of channels output
s.options.numInputBusChannels = 2;

s.waitForBoot {
    ~dirt = SuperDirt(2, s); // pan across two channels
    ~dirt.loadSoundFiles;
    ~dirt.start(57120, [0, 2, 4, 6]); // set up four orbits, and start each output at a diff channel
};
s.latency = 0.3;
);