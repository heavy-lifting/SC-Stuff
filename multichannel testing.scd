(
// Server.default.options.device = "ASIO : ASIO4ALL v2";
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

s.scope