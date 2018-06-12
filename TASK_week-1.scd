/*__________________________________________________________________/*

   TASKS TO COMPLETE - week 1

      - Make at least 3 different synthdefs, one that sounds like a percussion instrument, one like pads and one that is noisy/unpredictable.
      - Do the reading!
- Record a 3-5 minute jam using synths you've edited

      - Email me your completed code and audio [midigirl1990@gmail.com]

*/__________________________________________________________________*/

s.boot;

// Good old drone
~sound_1 = {SinOsc.ar([110, 106], 0, 0.5)}; ~sound_1.play;

~sound_2

~sound_3

~sound_1.play;
~sound_1.stop;

p = ProxySpace.push;
p.pop;
ProxyMixer.new(p);

s.meter;

s.quit;

/*
Basic sounds to use:
- SinOsc
- Saw
- LFSaw - guess that's just a low frequency version of Saw ...
- Pulse
- PinkNoise
- BrownNoise
- WhiteNoise
- Impulse
*/

/*
Control with:
- Pan2
- OnePole - dunno what that does
- Mix
- RHPF - filter
- LPF - another filter
*/

/*
Combine via:
- Ring Modulation
*/

/*
Don't forget
- ProxySpace for live coding
and mix it all together with
- ProxyMixer
*/
