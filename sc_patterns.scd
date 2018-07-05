// INTRO TO SUPERCOLLIDER
// MUSIC HACKSPACE
// 19-06-18
// JOANNE ARMITAGE



/*__________________________________________________________________/*

   RECAP

Some issues arose in the emails that I'm going to cover quickly now.


*/__________________________________________________________________*/

//(1) Variables

/*
A variable is a name for an object.

This explanation by Les Hutchins is really nice: http://sc3howto.blogspot.com/2005/02/object-oriented-programming.html

Also see Daniel Nouri if you want more understanding here: http://danielnouri.org/docs/SuperColliderHelp/Tutorials/Getting-Started/Functions%20and%20Other%20Functionality.html

In other languages you need to declare your variables before using them, and you need to declare the type of the variable (that means you need to say if you plan to store a number or some text in a variable). In SuperCollider you don't specify the type because it automatically knows.

Variable names have something special about them in SuperCollider. In other languages you can use any name for your variable (as long as it's not a reserved word like while, for or if). SuperCollider distinguishes three types of names:

i) names which are one letter long, like a, b, c. These are global variables and can be used any time. The variable s is special, and it's predefined. It contains the local audio server, so don't use s. Use any other one letter variable between a and z.

ii) names that begin with tilde (~). These are also global variables and don't need to be declared, and can be long, like ~width, ~height, ~theSizeOfMyNose.

iii) You can also declare variables at the top of any block of code which you execute altogether (i.e. by selecting it all). In such a case that block of code is the variable's scope. Execute the block (in parentheses) and then the last line.

*/

(
  var greeting;
  greeting = "hello world";
  greeting.postln;
)

//But if we run this line it is outside the 'scope' of the block and we get an error.
greeting


//(2)Controlling the stereo field


//One channel
{ Blip.ar(800,4,0.1) }.play;

//Two channel
{ [ Blip.ar(800,4,0.1), WhiteNoise.ar(0.1) ] }.play;

//Three channels
{ [ Blip.ar(800,4,0.1), WhiteNoise.ar(0.1), Dust.ar(XLine.kr(20000, 2, 10), 0.5) ] }.play;

{ Blip.ar(500,8,0.1) }.play // one channel

// the array in the freq input causes an Array of 2 Blips to be created :
{ Blip.ar([499,600],8,0.1) }.play // two channels


{ Blip.ar([499,600],8,0.1) !2 }.play // two both frequencies channels

//We don't hear the 600
{Pulse.ar([400, 500, 600],[0.5, 0.1], 0.2)}.play

//Splay spreads channels across the stereo field. You can hearall sounds across the stereo field.
{Splay.ar(Pulse.ar([400, 1000, 600],[0.5, 0.1], 0.2)) }.play;

//(3)Controlling the audio output

//This allows us to see what devices we can use for input i.e. your audio interface.
ServerOptions.inDevices


//This allows us to see what devices we can use for output i.e. your audio interface or bluetooth headphones. You could also set this to be something like Soundflower so you can route SC in to your DAW.
ServerOptions.outDevices

(
o = ServerOptions.new;

//The number of kilobytes of real time memory allocated to the server. This memory is used to allocate synths and any memory that unit generators themselves allocate (for instance in the case of delay ugens which do not use buffers, such as CombN), and is separate from the memory used for buffers. Setting this too low is a common cause of 'exception in real time: alloc failed' errors. The default is 8192.

o.memSize = o.memSize * 32;
//We are working with stereo so only need two input channels
o.numOutputBusChannels = 2;
o.device = "AKG Y50BT"; //Change the device name to where you want to sound to go.
s.options = o;

)

s.boot

//(4).kr and .ar

/*
(ar) Audio rate

Ugens to which an .ar message is sent run at the audio rate, by default, at 44,100 samples per second. Send the .ar message to unit generators when they're part of the audio chain that will be heard.

*/

SinOsc.ar(440, 0, 1);

/*(kr) Control rate

Ugens to which a .kr message is appended run at the control rate.

By default, control rate ugens generate one sample value for every sixty-four sample values made by an audio rate ugen. Control rate ugens thus use fewer resources and are less computationally expensive than their audio rate counterparts.

Use control rate ugens as modulators, that is, as signals that shape an audio signal.

*/

SinOsc.kr(440, 0, 1);

//Here, a control rate SinOsc modulates the frequency of the audio rate Pulse wave.

(
SynthDef("anExample", {
	Out.ar(
		0,
		Pulse.ar(
			[220, 221.5] + SinOsc.kr([7, 8], 0, 7), // the control rate conserves CPU cycles
			0.35,
			0.02
		)
	)
}).load(s);
)

Synth("anExample")

//Type command-period (cmd-.) to stop synthesis.

/*__________________________________________________________________/*

   SHARE AN EXAMPLE SOUND YOU MADE

     - Some listening
     - Look at SynthDefs
     - Anything unexpected (good/bad/troubleshooting)

*/__________________________________________________________________*/





/*__________________________________________________________________/*

   OUTLINE
    - Envelopes
    - Playing SynthDefs
    - Using Patterns
    - Extensions and Quarks
    - Pbinds
    - Pdefs
    - Clocks
    - Ppar
    - Tasks

*/__________________________________________________________________*/


/*__________________________________________________________________/*

   ENVELOPES

      - We looked at little bit an envelopes in the last session but now we will be a bit more focussed on them.
      - Envelopes can be used to shape parameters of a sound over time.
      - We often use them to shape amplitude or how loud a sound is

Nice examples here: https://composerprogrammer.com/teaching/supercollider/sctutorial/3.1%20Envelopes.html
*/__________________________________________________________________*/

//This sound goes on forever unless we press [CMD/CTRL] + [.]
{SinOsc.ar(440,0,0.1)}.scope


//This sound stops audibly after we play is but we can see that it is still active on the server unless we stop it with [CMD/CTRL] + [.].

{SinOsc.ar(440,0,Line.kr(0.1,0,1))}.scope

//doneAction:2 causes the Synth to be terminated once the line generator gets to the end of its line. It's a forth argument in Line.kr
//It we look at the help file we can see there are different done actions we can chose from. We are going to use 2 because it frees the synth from the server.

{SinOsc.ar(440,0,Line.kr(0.1,0,1,doneAction:2))}.scope


//We can use envelopes to control how a sound changes over time.
//We can find more out about Envelopes using the helpfile

//This makes an Envelope with three control points, at y positions given by the first array, and separated in x by the values in the second (see the Env help file). The curve drawn out should actually look like a letter envelope!
Env.new([1,0,1],[1,1]).plot

//So if we increase the second x value to 12 we can see it stretches the second half of the envelope
Env([1,0,1],[1,12]).plot

//We can add a third array that impacts in the shape of the line.
Env.new([0, 1, 0.9, 0], [0.1, 0.5, 1],[\sine]).plot;

//linen has attackTime, sustainTime, releaseTime, level, curve
Env.linen(0.03,0.5,0.1).plot

Env.adsr(0.01, 0.5, 0.5, 0.1, 1.0, 0).plot  //attackTime, decayTime, sustainLevel, releaseTime,
				peakLevel, curve
//note that the sustain portion is not shown in time; this particular envelope type deals with variable hold times, and the hold is missed out in the plot

Env.perc(0.05,0.5,1.0,0).plot //arguments attackTime, releaseTime, level, curve: good for percussive hit envelopes

//Can you discover some more envelopes?

Env.shapeNames;

/*__________________________________________________________________/*

   PLAYING SYNTHDEFS

      - You can define parameters to be controlled by a sequence i.e. frequency, duration, sustain, noise, pan etc.
      - Make your own SynthDef for Catherine below.
*/__________________________________________________________________*/

s.boot;

(
SynthDef(\sn, {
	|out=0, amp=0.1, sustain=0.1, pan=0, freq = 200|
	var snd, env;
	snd = Pan2.ar(SinOsc.ar(freq), pan);
	env = EnvGen.ar(Env.perc(0.01, sustain), doneAction: 2);
	Out.ar(out, snd * env * amp);
}).add;
)

//Triggers one sound to test it's working
x = Synth(\sn)

//Control parameters of the SynthDef
x = Synth(\sn, [\freq, 200, \sustain, 1, \pan, 0]);


//But just running those instances of the synth sound is really not a very easy way of making music.. also we have to like manually change the nubmers everytime we want a fresh sound. Eurgh it's so annoying! There must be a better way? Well I'm gonna take you through a whole host of different ways until we come to the way that I think works best.


//We can iterate through an array of note number to create a chord.
(
[156, 234, 378].do{
	arg nn;
	Synth(\sn, [\freq, nn, \sustain, 5, \pan, 0]);
}
)


//Using a Task or Routine, we can create pauses between the notes to sequence them.

(
r = Routine({
	[168, 192, 224, 252, 280, 316].do{
		arg nn;
		Synth(\sn, [\freq, nn, \sustain, 5, \pan, 0]);
		1.wait
	}
}).loop
)

r.play;
r.stop;


<<<<< REVIEWED TO HERE >>>>>


//Below we can see that if we place a {}.loop around the contents of the Routine it will run indefinitely
(
r = Routine({
	{
		[42, 48, 56, 63, 70, 79].scramble.do{
			arg nn;
			Synth(\sn, [\freq, nn, \sustain, 5, \pan, 0]);
			0.25.wait
		};

		[42, 48, 56, 63, 70, 79].do{
			arg nn;
			Synth(\sn, [\freq, nn, \sustain, 5, \pan, 0]);
			0.25.wait
	}}.loop;

}).play
)

//OK this is sounding a bit more musical and you can't really predict what is going on very well. What is that scramble method doing? Do we have some more options here?

//We could add .pyramid, .rotate, .stutter, .mirror, .mirror1, .mirror2, .reverse, normalize(min, max)

//What if we were to put another array within the array.

//You can see more options by pressing [CMD/CTRL] + [D] on 'Array' below.
Array

//Stop the routine
r.stop


//What issues are we facing here?


/*__________________________________________________________________/*

   USING PATTERNS

      - Patterns can be used to generate a set of values without explicitly desrcibing each step
      - Patterns allow us to use less syntax to make more complexity
      - This pre-definition means we are less likely to make mistakes
      - Although we have to learn extra syntax
      - Patterns define behavior; streams execute it.

*/__________________________________________________________________*/


//It we wanted to generate a series of numbers, using a Routine we could write something a bit like this:

a = Routine {
	var i=0;
	loop {
		i.yield;
		i = i + 1;
};};

a.nextN(15);


//We can simplify this a bit

a = Routine {(0..).do{ |i| i.yield; }; };

a.nextN(10);

//But using patterns we can just say hey start at 0 and increase by 1 infinitely

a = Pseries(start: 0, step: 1, length: inf).asStream;

a.nextN(10);

//We can just write this as
a = Pseries(0,1,inf).asStream;
a.nextN(10)

/*

I like James Harkin's expanation: http://distractionandnonsense.com/sc/A_Practical_Guide_to_Patterns.pdf

A pattern is like a blueprint for a building, showing how all the parts fit together. The building doesn't exist until the contractors go and do what the plans specify. When a stream is made from a pattern, it follows the plans laid out in the pattern's blueprint. Rendering the plans into a real-world result does not change the blueprint in any way, but to get the result, the stream has to go through different states.

A pattern is supposed to describe behavior, and in general, evaluating the pattern (by way of a stream) should not change anything in the Pattern object itself. In computer science terms, patterns are stateless; their definition does not change over time. The stream is what keeps track of where we are in the pattern's evaluation.

This explains an easy "gotcha" with patterns -- forgetting to turn the pattern into a stream doesn't get the expected result. Since a pattern doesn't have any concept of a current state, calling 'next' on it is meaningless, so 'next' does what it does for most objects: return the receiver object itself. The method 'asStream' creates the stream conforming to the pattern's specification, and calling 'next' on the stream advances to its next state and returns the new value.
*/

a = Pseries(0, 1, 10);
a.next; // always returns the Pseries, not actual numbers

q = a.asStream;
q.next; // calling this repeatedly gets the desired increasing integers


//but we can of course simplify this as above to

a = Pseries(0, 1, 10).asStream;
a.next; // always returns the Pseries, not actual numbers

//Lovely!


//What is cool about this is that the stream does not modify the original pattern so we can use it multiple times

r = a.asStream;
r.next; // starts from zero, even though q already gave out some numbers
q.next; // resumes where q left off, with no effect from getting values from r
[q.next, r.next] // and so on...

//There are lots of different patterns we can use in SuperCollider

//Ooooo look some below. Let's see if we can work out what is going on here 🤔?

//LIST PATTERNS
//We can give pattern a list of values and have it read them out in different orders. We can control the repeats.

(Pseq([100, 200, 300, 400], 1) + .x Pseq([1,2,3,4], 1)).asStream.all;

Pser([0,1,2,3,4], 8).asStream.all;

//OK What about this one:

Pslide(#[1, 2, 3, 4, 5, 6, 7, 8], 10, 3, 1, 0, false).asStream.all


//Other patterns, can you make them stream? What are they doing?

Prand
Pxrand
Pshuf
Pwrand
Pwalk
Ptuple

//I'm gonna show you Place because it's too good to miss.

Place([0, [1, 2], [3, 4, 5]], 3).asStream.all;


//I like this one also, you can nest patterns is anything, but let's see what this one does.

Ppatlace([Pwhite(1, 10), Pwhite(57, 65)], 5).asStream.all



//So we also write patterns that generate their own values. You'll have seend the Pwhite in the example above. These often have less-predictable outcomes.

Pwhite(1, 12, 12).asStream.all;

//Apart from Pseries which we looked at before there is Pgeom

Pgeom(1, 12, 4).asStream.all


//If you want an arithmetic or geometric series to start at one number and end at another specific number, the step size/multiplier must be calculated from the endpoints and the number of items desired. The ddwPatterns quark includes a convenience method, fromEndpoints, for both Pseries and Pgeom that performs this calculation. It's necessary to give an exact number of repeats, at least two and less than infinity.

//We can use patterns that other people have made.
Quarks.gui

p = Pgeom.fromEndpoints(5, 1, 15).asStream.all;



/*EXTENSION!
I really like Euclidean rhythms and there is a pattern for that! You can get Quarks and Extensions that add to SuperCollider and allow you to do different things. These are bits of code or UGens that other people have built.
You can download it here: https://github.com/supercollider-quarks/Bjorklund
Mac/Linux: http://danielnouri.org/docs/SuperColliderHelp/Extending%20and%20Customizing%20SC/Using-Extensions.html
Windows: http://www.brianlheim.com/supercollider/db/d51/md__r_e_a_d_m_e__w_i_n_d_o_w_s.html*/

//Some more number generating patterns, see you you can implement them and understand them
Pbrown
Pgbrown
Pbeta
Pexprand
Pcauchy
Pgauss
Phprand
Plprand
Pmeanrand
Ppoisson
Pprob

//We can see what these distributions look like by plotting them as historgrams.
Pwhite(0.0, 1.0, inf).asStream.nextN(10000).histo(200, 0.0, 1.0).plot;


/*__________________________________________________________________/*

   PBINDS

      - Pbinds allow us to dive names to things generated through patterns and streams.
      - When you ask a Pbind stream for its next value, the result is an object called an Event
      - An event is a set of "key-value pairs": each value is named by a key.

*/__________________________________________________________________*/

//We sound make our Pseries and add it to the synth like this:
a = Pseries(100, 100, 10).asStream;


Synth(\sn, [\freq, a.next, \sustain, 5, \pan, rrand(-1.0, 1.0)]);

//Very nice! Do you like the likee random touch on the pan?

//We could also go and it would go on forever. Still I think we could do better?

a = Prand((1..10)*100, inf).asStream;


e = (freq: 440, dur: 0.5); // an Event
e.at(\freq) // access a value by name
e[\freq]
e.freq // See IdentityDictionary help for more on this usage
e.put(\freq, 880); // Change a value by name e[\freq] = 660;
e.freq = 220;
e.put(\amp,0.6); //Addanewvalueintotheevent e.put(\dur, nil); // Remove a value

//A Pbind allows us to build lists of keys+values or events.
//The things that WE definte in our SynthDef are keys.

(
b = Pbind(
	\freq, Pseq(#[0, 0, 4, 4, 5, 5, 4], 1),
	\dur, Pseq(#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1], 1)
).asStream; // remember, you have to make a stream out of the pattern before using it )
)
b.next(Event.new);

//Ok so how do we sounds this? First of all we need to assign and isntrument and then we need to tell it to play.
//When an Event is 'played', it does some work that usually makes noise on the server.

(
b = Pbind(
	\instrument, \sn,
	\freq, Pseq(#[0, 0, 4, 4, 5, 5, 4], inf),
	\dur, Pseq(#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1], inf)
).play
)

//We can stop b
b.stop

//And we can play b again
b.play

//So we might want to play some of the SynthDefs that you made last week? I've also included a MASSIVE SynthDef list in the folder.

//The SynthDefs we have been making normally have Control inputs that we can define.
//Here is a SynthDef we can see we have defined 3 Control inputs: freq, decay and amp.
(
SynthDef(\ringkick, {arg freq = 40, decay = 0.25, amp = 0.2;
	var snd;
	snd = Ringz.ar(
		in: LPF.ar(
			in: Impulse.ar(0),
			freq: 1000),
		freq: freq,
		decaytime: decay,
		mul: 7 * amp).tanh.sin*2;
	Out.ar(0, snd!2);
}).add;
)

//So here we can define these Control inputs.
(
b = Pbind(
	\instrument, \ringkick,
	\freq, Pseq([60, 80, 70], inf),
	\decay, Pseq([0.4, 1, 0.5, 0.1], inf),
	\amp, Pseq([0.6, 0.1], inf),
).play;
)

//When we press play, we can hear that the sound has some elements that we we have not defined like a rhythm.
//We can add rhythm using \dur
(
b = Pbind(
	\instrument, \ringkick,
	\freq, Pseq([60, 80, 70], inf),
	//added dur here: you could also write this Pseq([Pn(1,4), Pn(0.5, 2), Pn(0.25, 4)], inf)
	\dur, Pshuf([1, 1, 1, 1, 0.5, 0.5, Pn(0.25, 4)], inf),
	\decay, Pseq([0.4, 1, 0.5, 0.1], inf),
	\amp, Pseq([1, 0.5], inf),
).play;
)

b.stop

//Let's have a little look at tonality and how we can control it in SuperCollider. Let's bring our lil \sn synth back in to the picture.

(
SynthDef(\sn, { |out=0,amp=0.1,sustain=0.1,freq=440, pan=0|
	var snd, env, panner;

	snd = SinOsc.ar(freq, 0.5pi, 3).tanh;

	env = EnvGen.ar(Env.perc(0.01,sustain),doneAction:2);

	panner = Pan2.ar(snd, pan, env);

	OffsetOut.ar(out, panner);
}).add;

)

//Using scales
(
b = Pbind(
	\instrument, \sn,
	//tonality
	\degree, [0,7, 9] + Pseq((1..9), inf),
	//select the scale
	\scale, Scale.gong, //More scales at Scale.directory
	\dur, 1,
).play
)

b.stop

//Embedding patterns
(
b = Pbind(
	\instrument, \sn,
	//tonality
	\degree, Pseq([
		Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }), Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }), Pseries({ rrand(7, 14) }, -1, { rrand(4, 8) })], inf),
	//select the scale
	\scale, Scale.gong, //More scales at Scale.directory
	\dur, 1,
).play(t)
)
b.stop

//Run line below to see a range of scales
Scale.directory

//We could edit these Pbinds on the fly using this line like before:
p = ProxySpace.push;

//Or I can show you an alternative.

/*__________________________________________________________________/*

   PDEF

      - Pdef registers patterns by key.
      - All accesses to the registered patterns go through the Pdef class via that key.
      - Registered patterns can be replaced while running.
      - The old pattern and its replacement can automatically crossfade and the time of replacement can be quantized.

*/__________________________________________________________________*/

(
Pdef(\test,
	Pbind(
		\instrument, \sn,
		\degree, Pseq([7, 2, 1, 7, 3], inf)+10,
		\scale, Scale.gong, //More scales at Scale.directory
		\dur, 0.5,
		\pan, Pwhite(-1.0, 1.0)
	))
)

Pdef(\test).play

Pdef(\test).fadeTime = 2

//You can see all the Pdefs you have running in a cute GUI using this line of code.

PdefAllGui(16)


/*__________________________________________________________________/*

   CLOCKS

      - OK so we want to start sending this data to our sounds.
      - To do this we need to setup a clock that can time our streams
      - The default clock is 60 bpm let's change this

*/__________________________________________________________________*/

t = TempoClock.new(140/60)

//We can update the tempo like this

t.tempo = 45/60

Pdef(\test).stop(t)
/*__________________________________________________________________/*

   PPAR

      - Using Ppar we can embed two Pdefs together


*/__________________________________________________________________*/




(
Pdef(\testp,
	Ppar([
		Pbind(
			\instrument, \sn,
			\degree, Pseq([7, 2, 1, 7, 3], inf)+10,
			\scale, Scale.gong,
			\dur, 0.5,
			\pan, Pwhite(-1.0, 1.0)
		),



		Pbind(
			\instrument, \sn,
			\freq, Pseq([60, 80, 70], inf),
			\decay, Pseq([0.4, 1, 0.5, 0.1], inf),
			\amp, Pseq([0.6, 0.1], inf),
		);

	]),

	Pdef(\testp).stop(t) ;
)
)

//NB JA show examples of some Array sorting and also more embedding and


/*__________________________________________________________________/*

   EFFECTS

      - Here is a quick example using effects.
      - We will look at buses more in SC next session.


*/__________________________________________________________________*/

(
// efx synthdef- dig the timing on the delay and the pbind. :-P
SynthDef(\pbindefx, { arg out, in, time1=0.25, time2=0.5;
    var audio, efx;
    audio = In.ar([20, 21], 2);
    efx=CombN.ar(audio, 0.5, [time1, time2], 10, 1, audio);
    Out.ar(out, efx);
}).add;
)
// create efx synth
a = Synth.after(1, \pbindefx);

(
SynthDef(\acid, { arg out, freq = 1000, gate = 1, pan = 0, cut = 4000, rez = 0.8, amp = 1;
    Out.ar(out,
        Pan2.ar(
            RLPF.ar(
                Pulse.ar(freq, 0.05),
            cut, rez),
        pan) * EnvGen.kr(Env.linen(0.02, 1, 0.3), gate, amp, doneAction:2);
    )
}).add;
)
//Here you are setting the output to 20 which goes to the input of the EFX Synthdef
(
Pbind(\instrument, \acid, \out, 20, \dur, Pseq([0.25, 0.5, 0.25], inf), \root, [-24, -17],
    \degree, Pseq([0, 3, 5, 7, 9, 11, 5, 1], inf),
	\pan, Pfunc({1.0.rand2}),
    \cut, Pxrand([1000, 500, 2000, 300], inf),
	\rez, Pfunc({0.7.rand +0.3}),
	\amp, 0.12).play;
)

/*__________________________________________________________________/*

   TASKS TO COMPLETE

      - Update you SynthDefs with your new knowledge of envelopes
      - Use patterns to control some SynthDefs.
      - Record a short improvisation with them.


*/__________________________________________________________________*/


