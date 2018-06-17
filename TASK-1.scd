/*__________________________________________________________________/*

   TASKS TO COMPLETE - week 1

      - Make at least 3 different synthdefs, one that sounds like a percussion instrument, one like pads and one that is noisy/unpredictable.
      - Do the reading!
- Record a 3-5 minute jam using synths you've edited

      - Email me your completed code and audio [midigirl1990@gmail.com]

*/__________________________________________________________________*/

s.boot;

// Additive Synthesis
~sound_1 = {Splay.ar(SinOsc.ar([520, 206, 320], 0, 0.5))};
~sound_1.play;
~sound_1.stop;

// Subtractive Synthesis
~sound_2 = {Pan2.ar(WhiteNoise.ar(0.5), 0)};
~sound_2_filter = {RLPF.ar(~sound_2, 440)};
~sound_2_filter.play;
~sound_2_filter.stop;

// Ring modulation
~sound_3a = {Splay.ar(SinOsc.ar([720, 206, 320], 0, 0.5))}; // carrier
~sound_3b = {Splay.ar(SinOsc.ar([320, 156, 120], 0, 0.5))}; // modulator
~sound_3 = {~sound_3a * ~sound_3b};
~sound_3.play;
~sound_3.stop;

// Amplitude modulation
~sound_4a = {Pan2.ar(SinOsc.ar(230, 0, 0.5), 0)}; // carrier
~sound_4b = {Pan2.ar(SinOsc.ar(0.5, 0, 0.5, 0.5), 0)}; // modulator
~sound_4 = {~sound_4a * ~sound_4b};
~sound_4.play;
~sound_4.stop;

// Frequency modulation
~sound_5a = {SinOsc.ar(1)};
~sound_5 = {SinOsc.ar([230, 240] + (100*~sound_5a), 0, 0.6)};
~sound_5a.scope;
~sound_5.play;
~sound_5.stop;


p = ProxySpace.push;
p.pop;

ProxyMixer.new(p);

s.meter;
s.quit;

/*
Basic sounds to use:
- SinOsc
- LFSaw
- Pulse
- PinkNoise
- BrownNoise
- WhiteNoise
- Impulse
*/

/*
Control with:
- Pan2
- Mix
- Splay
- RHPF - filter
- RLPF- another filter
- MouseX, MouseY
- Line
*/

/*
Combine via:
- Additive Synthesis:
-- using arrays, Mix, Splay, Pan2
- Subtractive Synthesis:
-- using filters: LPF, HPF, BPF
- Ring Modulation
*/

/*
Don't forget
- ProxySpace for live coding
and mix it all together with
- ProxyMixer
*/
