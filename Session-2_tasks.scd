/*__________________________________________________________________/*

   TASKS TO COMPLETE

      - Update you SynthDefs with your new knowledge of envelopes
      - Use patterns to control some SynthDefs.
      - Record a short improvisation with them.

*/__________________________________________________________________*/

// SynthDefs from session 1, updated
// SynthDef_percussion
(
SynthDef(\sn_perc,
	{ |out=0, amp=1, sustain=0.2, freq=40, pan=0|
		var snd, env;

		snd = {Pan2.ar(SinOsc.ar(Line.ar(freq, freq/2, sustain), 0, 1), pan)};
		env = EnvGen.ar(Env.perc(0.01, 1), doneAction:2);

		OffsetOut.ar(out, snd * env * amp);
}).add;
)

~sn_perc = Synth(\sn_perc, [\freq, 100, \sustain, 0.4]);

// SynthDef_pad
(
SynthDef(\sn_pad, { |out=0, amp=1, sustain=5, freq=320|
	var snd, env;

	snd = {Splay.ar(SinOsc.ar([freq * 2.4, freq * 2, freq * 1.4, freq, freq * 1.5, freq * 1.9, freq * 2.5], 0, 1/6))};
	env = EnvGen.ar(Env.linen(sustain * 0.08, sustain * 0.12, sustain * 0.8), doneAction:2);

	OffsetOut.ar(out, snd * env * amp);
}).add;
)

~sn_pad = Synth(\sn_pad, [\freq, 300, \sustain, 5]);

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

////////

// This just plays the percussive SynthDef in an everlasting loop
(
Pdef(\perc,
	Pbind(
		\instrument, \sn_perc,
		\freq, 120,
		\sustain, 0.5,
		\amp, 1,
		\pan, 0
	).loop;
)
)

Pdef(\perc).play(t);
Pdef(\perc).stop;

////////

s.boot;
s.reboot;
s.meter;
s.quit;