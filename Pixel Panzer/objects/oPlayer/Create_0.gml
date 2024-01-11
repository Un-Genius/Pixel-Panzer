// Inherit tank stats
event_inherited();

// Set up Movement
boostSpeed = 1.4; // change to adjust boost speed
boostEnabled = true; // change to false if you don't want boost functionality

// Camara Shake
shakeMag = 0;

tankType = -1;

newBulletAcc = 0;

add_score("Player", pointsScored);

ins_move = audio_play_sound(snd_move, 100, true);
audio_sound_gain(ins_move, 0, 0);
audio_sound_gain(ins_move, 0.15, 1000);

snd_turret_toggle = false;
snd_turret_delay = 0;
ins_turret = audio_play_sound(snd_turret_2, 50, true, 0.45);
audio_sound_gain(ins_turret, 0, 0);
audio_sound_pitch(ins_turret, 0.8)