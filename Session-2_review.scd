// Review of Session 2
// Compiled with general notes (https://www.evernote.com/shard/s336/nl/52980809/4025006e-4517-4451-a468-cf2ea64cecd3/)

s.boot;

// Envelopes

// Env
Env.linen(0.03,0.5,0.1).plot
Env.perc(0.05,0.5,1.0,0).plot

// EnvGen
EnvGen.ar(Env.perc(0.05,0.5,1.0,0), doneAction: 2);


/************************************************************/


// SynthDef
(
SynthDef(\sn, {
    |out=0, amp=1, sustain=0.1, pan=0, freq = 200|
    var snd, env;
    snd = Pan2.ar(SinOsc.ar(freq), pan);
    env = EnvGen.ar(Env.perc(0.01, sustain), doneAction:2);
    Out.ar(out, snd * env * amp);
}).add;
)

// Triggers one sound to test it's working
x = Synth(\sn);

// Control parameters of the SynthDef
x = Synth(\sn, [\freq, 200, \sustain, 5, \pan, -1]);


/************************************************************/


// Tasks and Routines

// Routine
(
r = Routine({
    [168, 192, 224, 252, 280, 316].scramble.do {
        arg nn;
        Synth(\sn, [\freq, nn, \sustain, 5, \pan, 0]);
        1.wait
    }
}).loop
)

r.play;
r.stop;

// Some useful Array methods to use with Routines
(
10.do({ arg i;
    [1, 2, 3, 4].pyramid(i + 1).postcs;
});
)

[1, 2, 3, 4, 5].rotate(3).postln;

[1, 2, 3].stutter(2).postln;

[1, 2, 3, 4].mirror.postln;

[1, 2, 3, 4].mirror1.postln;

[1, 2, 3, 4].mirror2.postln;

[1, 2, 3].reverse;

[1, 2, 3].normalize; // default min=0, max= 1
[1, 2, 3].normalize(-20, 10);


/************************************************************/


// Patterns

Pseries(0, 1, 10).asStream.all;

Pseq([100, 200, 300, 400], 2).asStream.all;

Pser([0,1,2,3,4], 8).asStream.all;

Pslide([1, 2, 3, 4, 5, 6, 7, 8], 7, 3, 1, 0, false).asStream.all;

Prand([1, 2, 3, 4, 5], 6).asStream.all;

Pxrand([1, 2, 3, 4, 5], 6).asStream.all;

Pshuf([1, 2, 3, 4, 5], 3).asStream.all;

Pwrand([1, 2, 3, 4, 5], [1, 3, 5].normalizeSum, 3).asStream.all;

// Can't get my head round these two at all at the minute
// Pwalk, Ptuple
(
Pwalk(
	// list
	[1, 2, 3, 4, 5],
	// stepPattern
	Pwrand([-2, -1, 0, 1, 2], [0.05, 0.1, 0.15, 1, 0.1].normalizeSum, inf),
	// directionPattern
	1,
	// startPos
	0
).asStream.all;
)

(
// var a, b;
a = Pseq([1, 2, 3], inf);
b = Pseq([65, 76], inf);
c = Ptuple([a, a, b], inf);
x = c.asStream;
8.do({ x.next.postln; });
)

// This works but dunno what it's doing
Place([0, [1, 2], [3, 4, 5]], 3, 0).asStream.all;

// Don't seem to get anything from this either
Pwhite(1, 10).asStream.all;


/************************************************************/

// Pbind

(
b = Pbind(
	\instrument, \sn,
	\freq, Pseries(100, 100, 10),
	\sustain, 2,
	\pan, 0
).loop
)

b.play;

/************************************************************/

// Pdef
// Hmm WTF?!

(
Pdef(\test,
	Pbind(
		\instrument, \sn,
		\freq, Pseries(100, 100, 10),
		\sustain, 2,
		\pan, 0
	).loop
)
)

Pdef(\test).play;
Pdef(\test).stop;
Pdef(\test).fadeTime = 2

/************************************************************/

s.quit;
s.meter;
