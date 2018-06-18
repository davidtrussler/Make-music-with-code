/*__________________________________________________________________/*

   TASKS TO COMPLETE - week 1

      - Make at least 3 different synthdefs, one that sounds like a percussion instrument, one like pads and one that is noisy/unpredictable.
      - Do the reading!
- Record a 3-5 minute jam using synths you've edited

      - Email me your completed code and audio [midigirl1990@gmail.com]

*/__________________________________________________________________*/

s.boot;

// Additive Synthesis
~sound_1 = {Splay.ar(SinOsc.ar([520, 206, 780, 320, 160, 450], 0, 1/6))};
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
~sound_5a.play;
~sound_5.play;
~sound_5.stop;


// Envelopes
~snd = {Pan2.ar(SinOsc.ar(200), 0)};
~env = Env.sine();
~sound = {~snd * EnvGen.kr(~env)};
~sound.play;
~sound.stop;

Env.perc().plot
Env.linen().plot
Env.triangle().plot
Env.sine().plot


// Effects
~snd = {Pan2.ar(SinOsc.ar(200, 0, 0.5), 0)};
~effect = {GVerb.ar(~snd, 10)};
~effect = {CombC.ar(~snd, 10)};
~effect.play;
~effect.stop;


// SynthDefs

// SynthDef_percussion
(
SynthDef(\sn_perc,
	{ |out=0, amp=1, sustain=0.2, freq=40|
		var sin, wn, snd, env;
		sin = {Pan2.ar(SinOsc.ar(Line.ar(freq, freq/2, sustain), 0, 1), 0)};
		env = EnvGen.ar(Env.perc(0.01, 1), doneAction:2);

		OffsetOut.ar(out, sin * env * amp);
}).add;
)

// SynthDef_pad
(
SynthDef(\sn_pad, { |out=0, amp=1, sustain=5, freq=320|
	var snd, env;

	snd = {Splay.ar(SinOsc.ar([freq * 2.4, freq * 2, freq * 1.4, freq, freq * 1.5, freq * 1.9, freq * 2.5], 0, 1/6))};

	env = EnvGen.ar(Env.linen(sustain * 0.08, sustain * 0.12, sustain * 0.8), doneAction:2);

	OffsetOut.ar(out, snd * env * amp);
}).add;
)

// SynthDef_noisy/unpredictable
(
SynthDef(\sn_nun, { |out=0, amp=1, sustain=10, freq=440|
	var carrier, modulator, snd, env;

	carrier = {Pan2.ar(SinOsc.ar(freq, 0, 0.5))};
	modulator = {BrownNoise.ar(0.5)};
	snd = {carrier * modulator !2};
	env = EnvGen.ar(Env.triangle(sustain), doneAction:2);

	OffsetOut.ar(out, snd * env * amp);
}).add;
)


x = Synth(\sn_perc, [\freq, 80, \sustain, 0.4]);
y = Synth(\sn_pad, [\freq, 300, \sustain, 5]);
z = Synth(\sn_nun, [\freq, 2100, \sustain, 40]);

s.record();
s.stopRecording;


p = ProxySpace.push;
p.pop;

ProxyMixer.new(p);

s.meter;
s.scope;
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
