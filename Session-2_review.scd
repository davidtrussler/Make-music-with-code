// Review of Session 2
// Compiled with general notes (https://www.evernote.com/shard/s336/nl/52980809/4025006e-4517-4451-a468-cf2ea64cecd3/)

s.boot;

// Envelopes

// Env
Env.linen(0.03,0.5,0.1).plot
Env.perc(0.05,0.5,1.0,0).plot

// EnvGen
EnvGen.ar(Env.perc(0.05,0.5,1.0,0), doneAction: 2);


// SynthDef
(
SynthDef(\sn, {
    |out=0, amp=0.1, sustain=0.1, pan=0, freq = 200|
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


s.quit;




s.meter;

a = Pseries(0, 1, 10);
b = a.asStream;
b.next
