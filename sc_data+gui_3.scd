// INTRO TO SUPERCOLLIDER
// MUSIC HACKSPACE
// 11-07-18
// JOANNE ARMITAGE

/*__________________________________________________________________/*

   RECAP

Last week we looked at patterns
--What patterns do you remember?
--How are your SynthDefs
--Share some sounds.

*/__________________________________________________________________*/



/*__________________________________________________________________/*

   OUTLINE
    - Arrays and Data in SC
    - Buffers
    - Mouse and keyboard
    - GUI
    - Some cool examples

*/__________________________________________________________________*/


/*
RECAP: Complete the following tasks

*/

//Identify the two errors in this example.
// {SinOsc.ar(LFNoise0.ar([10, 15], 400 800), 0, 0.3}.play
{SinOsc.ar(LFNoise0.ar([10, 15], 400, 800), 0, 0.3)}.play

//Modify the CombN code below so that the contents of each enclosure are indented successive levels. For example, SinOsc.ar(rrand(100, 200)) would become:
SinOsc.ar(
		rrand(
			100,
			200 )
	)

CombN.ar(WhiteNoise.ar(0.01), [1, 2, 3, 4], XLine.kr(0.0001, 0.01, 20), -0.2)
CombN.ar(
		WhiteNoise.ar(0.01),
		[1, 2, 3, 4],
		XLine.kr(0.0001, 0.01, 20),
		-0.2
	)

//In the above example, which Ugens are nested?

//What would this pattern return?

Pseq([109, 104, 100], 10) + Pseq([1, 2], 10)

//Which of these are not legal variable names?
lfNoise0ar, 6out, array6, InternalBus, next pitch, midi001, midi.01, attOne

(
		var b, c;
		b = 2;
		c = 3;
		b + c
)

/*__________________________________________________________________/*

   BUFFERS

      - You might want to play back existing audio files in SuperCollider.
      - To do this we need to create memory buffers on the server.
      - I've included a folder with some samples but you are very welcome to add some of your own.
      - All you need is the file path to the sound.
      - There are 1024 buffers by default.
      - After audio is loaded into a buffer it is then available for processing, quotation, or precise playback manipulation.
      - We can deal with buffers super-easily using 'Buffer'
*/__________________________________________________________________*/

Buffer

//SuperCollider also has some built in samples that we can use too
Platform.resourceDir +/+ "sounds/a11wlk01.wav"

//The  line below reads audio from a sound file. The arguments for Buffer are the server where the audio is loaded (think of it as a tape deck), and the sound file name.

~b_1=Buffer.read(s, "/Users/davidtrussler/MusicProduction/Make-music-with-code/samples/001_v_blipp02.wav");


//If we look at the post window we can see that the first value we get is 0. This is the buffer number

//We can also post this information to the window
[~b_1.bufnum, ~b_1.numChannels, ~b_1.path, ~b_1.numFrames].postln;

~b_1.bufnum
~b_1.numChannels
~b_1.path
~b_1.numFrames
~b_1.sampleRate
~b_1.plot()

//We can play this buffer. We know what the first number is doing but what about the second?
{PlayBuf.ar(1, ~b_1.bufnum)}.play(s);

//We should see server memory has gone up a bit running this line.

//Free the buffer!
~b_1.free


//You can also record to a buffer from any input. Assuming you have a two channel system, the inputs should be 2 and 3. (Check your sound settings in the system preferences.) You can record over an existing buffer, e.g. the ones we just created above, but it is more likely you will want a new one, which has to be created, or allocated before hand. The size of the buffer is the sample rate * number of seconds

//Not working, maybe test later

// allocate a Buffer
~b_2 = Buffer.alloc(s, 44100 * 4.0, 1); // a four second 1 channel Buffer
// b = Buffer.alloc(s, 44100 * 4.0, 1); // a four second 1 channel Buffer

// record for four seconds
RecordBuf.ar(In.ar(0, 1), ~b_2.bufnum, doneAction: 2, loop: 0);
// (
// SynthDef(\help_RecordBuf, { arg out = 0, bufnum = 0;
// 	    var formant;
// 	//     formant = Formant.ar(XLine.kr(100,600, 4), 2000, 800, 0.125);
// 	formant = In.ar();
// 	    RecordBuf.ar(formant, bufnum, doneAction: 2, loop: 0);
// }).play(s,[\out, 0, \bufnum, b]);
// )

// Play it back
// {PlayBuf.ar(1, ~b_2.bufnum)}.play(s);
(
SynthDef('~b_2', { arg out = 0, bufnum = 0;
	    var playbuf;
	    playbuf = PlayBuf.ar(1,bufnum);
	    FreeSelfWhenDone.kr(playbuf); // frees the synth when the PlayBuf is finished
	    Out.ar(out, playbuf);
}).play(s, [\out, 0, \bufnum, ~b_2.bufnum]);
)

// Free the buffer
~b_2.free;
// b.free;


//this loads into a buffer the default sound that comes with SuperCollider
~b_3 = Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav"); //store handle to Buffer in global variable b

(
SynthDef("playbuf",{ arg out=0,bufnum=0, rate=1, trigger=1, startPos=0, loop=1;
	Out.ar(out,
		Pan2.ar(PlayBuf.ar(1,bufnum, BufRateScale.kr(bufnum)*rate, trigger, BufFrames.ir(bufnum)*startPos, loop),0.0)
	)
}).add;
)

Synth(\playbuf, [\out, 0, \bufnum, ~b_3.bufnum]);

//Repeats as there is not envelope.

//Add your own sound


//Example with GUI in next section
//Example using a folder (i.e. Ultiverse synthdef)

//Basic introduction to buffers. You can explore things like:
//Granular synthesis:
//Wavetables:

s.quit


/*__________________________________________________________________/*

   DATA

      - You can easily store data in Arrays in SuperCollider from .csv files or whatever you like.
      - You can also use live data and I have included some examples for how you might do this using Arduino.

*/__________________________________________________________________*/


//Here is an example below we have the Array 'y' we are removing index '1' which is the second value in the Array.
y = [ 1, 2, 3 ];
y.removeAt(1);
y.postln;


//Here is some data that we will be playing with today. We will use it to make a song.
~ch_n = [63, 63, 60, 63, 60, 63, 60, 63, 67, 67, 65, 63, 65, 63, 65, 63, 63, 63, 60, 63, 60, 63, 60, 63, 67, 67, 65, 63, 65, 63, 65, 63, 63, 63, 60, 63, 60, 63, 60, 63, 67, 67, 65, 63, 65, 63, 65, 63, 63, 63, 60, 63, 60, 63, 60, 63, 67, 67, 65]


~ch_r = [0.75, 1.25, 0.75, 1.25, 0.75, 1.25, 0.75, 1.25, 0.75, 0.75, 1.5, 1, 1, 0.5, 1, 1.5, 0.75, 1.25, 0.75, 1.25, 0.75, 1.25, 0.75, 1.25, 0.75, 0.75, 1.5, 1, 1, 0.5, 1, 1.5, 0.75, 1.25, 0.75, 1.25, 0.75, 1.25, 0.75, 1.25, 0.75, 0.75, 1.5, 1, 1, 0.5, 1, 1.5, 0.75, 1.25, 0.75, 1.25, 0.75, 1.25, 0.75, 1.25, 0.75, 0.75, 1.5]

//We can find out the size of this data
~ch_n.size
~ch_r.size


//We could plot this data
[~ch_n, ~ch_r].plot("mystery data");
~ch_n.plot("mystery data");

//We can select a point in the array that we want to find:

~ch_n[34]
~ch_n.at(34);

//This returns the 35th value in the array.

//Can you find the 37th value in the ~ch_r array?


//We can use a Task or Routine to cycle through the data.
~ch_n = [63, 63, 60, 63];
~ch_r = [0.75, 1.25, 0.75];

(
t = Task.new({
	~ch_n.size.do({arg i;
		~ch_n[i].postln;
		~ch_r[i]/2.wait;
	});
})
)

t.play;

//And we can play this data

(
SynthDef(\plucking, {arg amp = 0.1, freq = 440, decay = 5, coef = 0.1;
var env, snd;
env = EnvGen.kr(Env.linen(0, decay, 0), doneAction: 2);
snd = Pluck.ar(
        in: WhiteNoise.ar(amp),
        trig: Impulse.kr(0),

        maxdelaytime: 0.1,
        delaytime: freq.reciprocal,
        decaytime: decay,
        coef: coef);
    Out.ar(0, [snd, snd]);
}).add;
)

(
Pdef(\test,
	Pbind(
		\instrument, \plucking,
		\midinote, Pseq(~ch_n, inf),
		\dur, Pseq(~ch_r, inf)/2,
		\pan, Pwhite(-1.0, 1.0)
	));
Pdef(\test).play(t);
)

t = TempoClock(40);

Pdef(\test).stop;


//three lions data is adapted from this sheet music site ;). adapted from from here:: "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=2ahUKEwiH1fXgh5XcAhWJLsAKHUcWC-AQjRx6BAgBEAU&url=https%3A%2F%2Fwww.musicnotes.com%2Fsheetmusic%2Fmtd.asp%3Fppn%3DMN0106406&psig=AOvVaw0PaYhq93iUUrcb-qC-gCZB&ust=1531330195383892"



/*__________________________________________________________________/*

   OBLIGATORY FOOTIE TASK

Using your new knowledge of arrays and buffers, complete the following task:
      - Using example samples, or additional freesound (https://freesound.org) examples create a buffer playing synthdef
      - Make a short re-mix of the above tune.

*/__________________________________________________________________*/




/*__________________________________________________________________/*

   BUSES

      - There are two kinds of busses in SC: audio and control.
      - In previous workshops, we have been looking at the audio output buses and understanding how we route audio to different outputs.
      - We haven't really used audio in but this would be on buses too.
      - There are 128 audio busses and 4096 control busses.
      - Audio buses connect to In.ar and Out.kr
      - Control buses have no default connections
*/__________________________________________________________________*/

{In.ar([2, 3])}.play

//We don't really have time to cover control buses but you will find them useful when you start to get a bit further in SC.

//Check here: https://composerprogrammer.com/teaching/supercollider/sctutorial/6.2%20Control%20Buses.html


/*__________________________________________________________________/*

   MOUSE AND KEYBOARD

      - Mouse X and Y values can control parameters of a sound
      - More dynamic control of a sound like a slider or switch
      - This is what MouseX.kr and MouseY.kr will do. They link mouse movement and position to values that can be used in the patch. The first three arguments are: minval, maxval, warp.
      - These ugens can replace any static value with a range of values that change in real time in relation to the position of the mouse on the screen.
*/__________________________________________________________________*/

//MouseX

{SinOsc.ar(LFNoise0.ar(MouseX.kr(2, 50), 500, 600), mul: 0.5)}.play;

//MouseY

{SinOsc.ar(440, mul: MouseY.kr(0.9, 0))}.play;

{SinOsc.ar(MouseX.kr(220, 880), mul: 0.3)}.play;


/*
One reason it may be difficult to pick out a melody is that the warp is set to linear (the default). A linear warp means the numeric values change with the same proportion as the motion and position of the mouse. But the increase of frequency over successive octaves is not linear, but exponential. The amount of change between one of the low octaves (such as 110 to 220) is smaller (110) in comparison to a higher octave (1760 to 3520; a change of 1760). With a linear warp and a range of 220 to 880 the middle of the screen will be 550. But if we want the screen to visually represent a musical scale the middle should be 440, the left half for pitches between 220 and 440 (a difference of 220) and the right half should be 440 to 880 (a difference of 440). This can be corrected using the warp. The warp value is set using a symbol (a word in single quotes), either linear or exponential. You can also enter the number 0 for linear or 1 for exponential. Try playing a melody or major scale with the following adjustments. You will notice that with an exponential warp the whole and half-steps seem to be the same distance all across the screen.
*/

{SinOsc.ar(MouseX.kr(220, 880, 'exponential').poll, mul: 0.3)}.play;

//Use this to make a theremin-type interface that controls frequency and volume.
{Pan2.ar(SinOsc.ar(MouseX.kr(100, 800, 'exponential'), 0, MouseY.kr(0.1, 0.9)), 0)}.play;


//Try adding a MouseX and Y control for each of these.

(
{SinOsc.ar(
	freq: SinOsc.ar(freq: 512, mul: 638,
		add: LFNoise0.kr(freq: [MouseX.kr(1, 10), MouseY.kr(1, 10)], mul: 500, add: 600
		)), mul: 0.6)}.play
)

(
{
	var out, delay;
	out = SinOsc.ar(freq:
		abs(LFNoise0.kr(freq: 0.5, mul: 600,
			add: SinOsc.kr(freq: 1.5, mul: 50, add: 500 ))),
		mul: 0.1);
	delay = CombN.ar(out, 3.0, [1.35, 0.7], 6); Pan2.ar(out, 0) + delay
}.play
)

(
{ CombN.ar(
	SinOsc.ar(
		freq: LFNoise1.ar(freq: 4, mul: 24,
		add: LFSaw.ar(freq: [8,7.23], mul: 3, add: 80) ).midicps, mul: 0.04), 0.2, 0.2, 4)}.play
)

//Example from James McCartney

(
    // strummable guitar
    // use mouse to strum strings
{
	var pitch, mousex, out;
	pitch = [ 52, 57, 62, 67, 71, 76 ];		// e a d g b e
	mousex = MouseX.kr;
	out = Mix.fill(pitch.size, { arg i;
		var trigger, pluck, period, string;
		// place trigger points from 0.25 to 0.75
		trigger = HPZ1.kr(mousex > (0.25 + (i * 0.1))).abs;
		pluck = PinkNoise.ar(Decay.kr(trigger, 0.05));
		period = pitch.at(i).midicps.reciprocal;
		string = CombL.ar(pluck, period, period, 4);
		Pan2.ar(string, i * 0.2 - 0.5);
	});
	LPF.ar(out, 12000);
	LeakDC.ar(out);
}.play;
)

//Also Mouse Button

{ SinOsc.ar(MouseButton.kr(400, 800), 0, 0.1) }.play;

//You can also use the keyboard to trigger things.

// execute the code below to find out a key's keycode
// the char and keycode of any key you press will be printed in the post window
(
w = Window.new("I catch keystrokes");
w.view.keyDownAction = { arg view, char, modifiers, unicode, keycode;  [char, keycode].postln; };
w.front;
)

//key code 0 = 'a' key
{ SinOsc.ar(800, 0, KeyState.kr(0, 0, 0.1)) }.play; //Server-side


//Create your own Synth that you can control using your mouse and keyboard.


/*__________________________________________________________________/*

   GUI

      - Convenient way to make custom virtual synths
      - Controls for the user or performer
      - Control such as slider, buttons, dials, drop down lists, drag and drop.
      - NB check and update this


*/__________________________________________________________________*/


//You can see the GUI options for different OS by going to these helpfiles:
GUI
GUI-Classes

//You'll see there are different options availiable depending on your OS. You can only use one GUI library at a time.

//The standard GUI library is QT. You can see what GUI Library you are using by default by running this line of code
GUI.current

//You can switch between QT, Cocoa and SwingOSC like this
GUI.qt;

//Don't worry too much though, you use the same class names i.e. Slider, Button etc. regardless of which GUI library you use.

//Both qt and SwingOSC act like servers, sending and receiving messages from the language app. On OS X, a native Cocoa implementation is built into the standard language environment for SC3.5 and earlier.

//To make a window

//Rect specifies the boundaries and position of the window.

(
var w;

w=Window("My Window", Rect(600,200,500,200)); //hmmm what is this doing 🧐

w.front; //this line bring the window to front of screen
)


//We can't do much with a blank window.
//Now we can add different elements to the window and define parameters for use.
//We specify the window we wish to use i.e. and use Rect to specify where the controls appear and their size.
//Now this time the co-ordinates are no longer relative to the screen, but relative to the top left corner of the window, and x and y positions indicate distance from left and from top respectively.

(
var w, slider;
w = Window("My Window", Rect(100,500,200,100));
slider = Slider(w,Rect(10,10,180,40))
    .background_(Color.rand)
    .orientation_(\horizontal)
    .step_(0.1);
slider.action_({slider.value.postln;});
w.front;
)

//The default slider range is from 0.0 to 1.0

//We might not want to create numbers from 0.0 to 1.0, but remap the value to other ranges. 0.0 to 1.0 is a very useful starting point, though. Try:

1.0.rand	//create a random number from 0.0 to 1.0

1.0.rand*50	//create a random number from 0.0 to 1.0, and multiply it by 50 to get a new range from 0.0 to 50.0

1.0.rand*50+14.7	//create a random number from 0.0 to 1.0, multiply it by 50, then add 14.7, to get a new range from 14.7 to 64.7

1.0.rand.linlin(0.0,1.0,14.7,64.71)	//create a random number from 0.0 to 1.0, and use a built in function to remap it to the output range 14.7 to 64.71

1.0.rand.linexp(0.0,1.0,14.7,64.71) //create a random number from 0.0 to 1.0, and use a built in function to remap it to the output range 14.7 to 64.71 with an exponential function, which tends to spend longer over lower values


//Rather than doing these remappings yourself, an alternative is to take advantage of a ControlSpec, a helpful class which can be used to turn input into any desired range through various available precanned mappings

(
var w, slid, cs;

w=Window("My Window", Rect(100,500,200,100));
//A 200 by 200 window appears at screen co-ordinates (100, 500)

slid=Slider(w,Rect(10,10,180,40));

//arguments minimum value, maximum value, warp (mapping function), stepsize, starting value
cs= ControlSpec(20, 20000, \exponential, 10, 1000);

slid.action_({cs.map(slid.value).postln;}); //map to the desired range

w.front;
)

//Given the action function for a GUI component, we can plug through to sound synthesis. Here we use the set command to modulate the control arguments of a running synth.

//Demo of using 2D-Slider for synthesis
//Borrowed from Nick Collins tutorial
(
SynthDef(\filterme,{arg freq=1000, rq=0.5;    //make sure there are control arguments to affect!
	Out.ar(0,Pan2.ar(
		BPF.ar(Impulse.ar(LFNoise0.kr(15,500,1000),0.1, WhiteNoise.ar(2)),freq,rq)
	))
}).add;
)

(
var w, slid2d, syn;

w=Window("My Window", Rect(100,300,200,200));
slid2d= Slider2D(w,Rect(5,5,175,175));

syn=Synth(\filterme);	//create synth

slid2d.action_({
	[slid2d.x, slid2d.y].postln;
	syn.set(\freq,100+(10000*slid2d.y),\rq,0.01+(0.09*slid2d.x));  //I'm doing my own linear mapping here rather than use a ControlSpec
});

w.front;

w.onClose={syn.free;};	//action which stops running synth when the window close button is pressed
)

//Talk about what mapping is
//Look at FM example?
//Can you edit the code above and make your own 2D controlled synth?


//If you want to arrange a bank of dials, for instance, you might use a helper class (a 'decorator') for arranging views on screen:

//Note:
//10@10  //is the Point (10,10), an (x,y) co-ordinate position


//However, maximum precision will come from specifying positions yourself. Make use of SuperCollider as a programming language to do this:

(
w= Window("programming it directly ourselves",Rect(200,200,400,400));

//now, when GUI views are added to the main view, they are automatically arranged, and you only need to say how big each view is
k= Array.fill(16,{|i| Knob(w,Rect((i%4)*100+10,i.div(4)*100+10,80,80)).background_(Color.rand)});

//if worried by the use of % for modulo and .div for integer division, try the code in isolation:
//i.e., try out 5%4, and 5.div(4) as opposed to 5/4. How does this give the different grid positions as
//argument i goes from 0 to 15?

w.front; //make GUI appear
)

k[3].background_(Color.rand);

//You can dynamically add and remove views from a window.

//Run these one at a time:

w=Window();

w.front;	//window appears

Slider(w,Rect(10,10,100,100));	//slider appears straight away

w.view.children //slider should be in the list, even though we didn't store any reference to the slider object in a global variable (like w) ourselves

w.view.children[0].remove //nothing happens visually immediately

w.refresh; //refresh updates the appearance of the window and the slider disappears

//Some other examples to look at in the workshop folder under GUI examples.

(
// create a GUI window with some NumberBoxes.
// You can command click on a control to drag its value to another control for cocoa, or control click for swing
var w, n, f, s;
w = Window("number box test", Rect(128, 64, 260, 80));
w.view.decorator = f = FlowLayout(w.view.bounds);

n = NumberBox(w, Rect(0,0,80,24));
n.value = 123;

n = NumberBox(w, Rect(0,0,80,24));
n.value = 456;

n = DragBoth(w, Rect(0,0,80,24));
n.object = 789;

f.nextLine;

s = Slider(w, Rect(0,0,240,24));

w.front;
)


(
SynthDef(\mysound,{arg density=100, centrefreq=1000, rq=0.1, amp=0.1;
	var dust, filter;

	//Dust is a stochastic source of impulse clicks, density per second
	dust= Dust.ar(density);

	//the filtering is twofold; shaping the clicks via attack and decay smoothing in Decay2, and then a Band Pass Filter
	filter= BPF.ar(50*Decay2.ar(dust,0.01,0.05),centrefreq, rq);

	Out.ar(0,(filter*amp).dup(2))
}).add
)



//GUI code. The MIDI Controller option is commented out; it was added spontaneously to answer an inquiry about how to hook up an external control to a graphical user interface control. You may want to look back at this after later material in the course on MIDI.
(
var w, slid2d, knob, numberbox;
var sound;

//use that SynthDef!
sound= Synth(\mysound);

w= Window("mysound's window",Rect(100,300,300,200));

slid2d= Slider2D(w,Rect(10,10,180,180));

knob= Knob(w,Rect(210,10,80,80));

numberbox= NumberBox(w,Rect(210,110,80,80));

//slid2d.action = {stuff...} is the same as slid2d.action_({stuff...})
slid2d.action = {
	sound.set(\density,slid2d.x*100.0+1,\rq,slid2d.y*0.5+0.01);
};

knob.action={sound.set(\centrefreq,knob.value*2000+500)};

//to let any MIDI control message set the knob position, and trigger the corresponding action
/*
MIDIIn.control={arg src,chan,num,val;
	//defer avoids complaints from the system that the GUI is being updated outside of a safe thread; it pushes the code through to the AppClock (see week 6 of course)
	{knob.value= (val/127.0); knob.action.value;}.defer;
};
*/

numberbox.action={var temp;

temp= numberbox.value.max(0.0).min(1.0);
sound.set(\amp,temp);

numberbox.value = temp;
};

w.front;

w.onClose= {sound.free;};
)

//BUFFER EXAMPLE WITH GUI

(
var w, rateslid, trigslid, startposslid, loopslid, a;

a=Synth(\playbuf, [\out, 0, \bufnum, ~b_2.bufnum]);

w=Window("PlayBuf Example",Rect(10,200,300,150));

w.front;

//control positioning of new GUI elements so I don't have to think too hard about it
w.view.decorator= FlowLayout(w.view.bounds);

//James' shortcut slider class
//250@24 means a Point of size 250 by 24
//|ez| is the same as arg ez;  - the EZSlider object is being passed into the callback action function
rateslid= EZSlider(w, 250@24, "Rate", ControlSpec(0.5, 10, 'exponential', 0.1), {|ez| a.set(\rate,ez.value)}, 1);

trigslid= EZSlider(w, 250@24, "Trigger", ControlSpec(0, 1, 'lin', 1), {|ez| a.set(\trigger,ez.value)}, 1);

startposslid= EZSlider(w, 250@24, "StartPos", ControlSpec(0.0, 1.0, 'lin', 0.01), {|ez| a.set(\startPos,ez.value)}, 0);

loopslid= EZSlider(w, 250@24, "Loop", ControlSpec(0, 1, 'lin', 0.1), {|ez| a.set(\loop,ez.value)}, 1);

w.onClose_({a.free;});
)

//Task, create your own gui to control a synth.

//Do something on MIDI?


(
SynthDef(\sillyVoice, { arg
	freq = 220,
	amp = 0.5,
	vibratoSpeed = 6,
	vibratoDepth = 4,
	vowel = 0,
	att = 0.01,
	rel = 0.1,
	lag = 1,
	gate = 1;

	var in, vibrato, env, va, ve, vi, vo, vu, snd;

	vibrato = SinOsc.kr(vibratoSpeed, mul: vibratoDepth);
	in = Saw.ar(Lag.kr(freq, lag) + vibrato);
	env = EnvGen.kr(Env.asr(att, 1, rel), gate, doneAction: 2);

	va = BBandPass.ar(
		in: in,
		freq: [ 600, 1040, 2250, 2450, 2750 ],
		bw: [ 0.1, 0.067307692307692, 0.048888888888889, 0.048979591836735, 0.047272727272727 ],
		mul: [ 1, 0.44668359215096, 0.35481338923358, 0.35481338923358, 0.1 ]);

	ve = BBandPass.ar(
		in: in,
		freq: [ 400, 1620, 2400, 2800, 3100 ] ,
		bw: [ 0.1, 0.049382716049383, 0.041666666666667, 0.042857142857143, 0.038709677419355 ],
		mul: [ 1, 0.25118864315096, 0.35481338923358, 0.25118864315096, 0.12589254117942 ]);

	vi = BBandPass.ar(
		in: in,
		freq: [ 250, 1750, 2600, 3050, 3340 ] ,
		bw: [ 0.24, 0.051428571428571, 0.038461538461538, 0.039344262295082, 0.035928143712575 ],
		mul: [ 1, 0.031622776601684, 0.15848931924611, 0.079432823472428, 0.03981071705535 ] );

	vo = BBandPass.ar(
		in: in,
		freq:[ 400, 750, 2400, 2600, 2900 ] ,
		bw: [ 0.1, 0.10666666666667, 0.041666666666667, 0.046153846153846, 0.041379310344828 ],
		mul: [ 1, 0.28183829312645, 0.089125093813375, 0.1, 0.01 ]);

	vu = BBandPass.ar(
		in: in,
		freq: [ 350, 600, 2400, 2675, 2950 ],
		bw: [ 0.11428571428571, 0.13333333333333, 0.041666666666667, 0.044859813084112, 0.040677966101695 ],
		mul: [ 1, 0.1, 0.025118864315096, 0.03981071705535, 0.015848931924611 ]);

	snd = SelectX.ar(Lag.kr(vowel, lag), [va, ve, vi, vo, vu]);
	snd = Mix.new(snd);
	Out.ar(0, snd!2 * env * amp);
}).add;
)

(
var sound;
w= Window("Silly Voice :P",Rect(200,200,400,400));

k= Array.fill(9,{|i| Knob(w,Rect((i%4)*100+10,i.div(4)*100+10,80,80)).background_(Color.rand)});

//Set the synth
sound= Synth(\sillyVoice);

//Set the mappings
k[0].action={sound.set(\freq,k[0].value*2000+500)};
k[1].action={sound.set(\amp, k[1].value)};
k[2].action={sound.set(\vibratoSpeed, k[2].value * 10)};
k[3].action={sound.set(\vibratoDepth, k[3].value * 10)};
//Can you make some more mappings?

w.front;
w.onClose={sound.free;}
)

//////////

// SynthDef_pad
(
SynthDef(\sn_pad, { |out=0, amp=1, sustain=5, freq=320|
	var snd, env;

	snd = {Splay.ar(SinOsc.ar([freq * 2.4, freq * 2, freq * 1.4, freq, freq * 1.5, freq * 1.9, freq * 2.5], 0, 1/6))};
	// env = EnvGen.ar(Env.linen(sustain * 0.08, sustain * 0.12, sustain * 0.8), doneAction:2);

	OffsetOut.ar(out, snd * amp);
}).add;
)

(
var sound = Synth(\sn_pad);
w= Window("Pad", Rect(200,200,400,100));
k= Array.fill(4,{|i| Slider(w,Rect((i%4)*100+10,i.div(4)*100+10,80,80)).background_(Color.rand)});
w.front;
w.onClose={sound.free;}
k[0].action={sound.set(\freq, k[0].value*500 + 500)};
)



/*__________________________________________________________________/*

   WEKINATOR EXAMPLE

      - Machine learning tool designed by Rebecca Fiebrink at Goldsmiths.
      - Probably won't have time for this but will include a link to the resources.
*/__________________________________________________________________*/



/*__________________________________________________________________/*

   SOME MORE RESOURCES

      - http://nagasm.org/ASL/berlin/index.html

      - http://swiki.hfbk-hamburg.de:8888/MusicTechnology/6

      - http://rhoadley.net/courses/tech_resources/supercollider/tutorials/cottle/CMSC7105.pdf
*/__________________________________________________________________*/


