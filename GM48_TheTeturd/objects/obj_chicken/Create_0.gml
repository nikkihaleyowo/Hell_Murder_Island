// Inherit the parent event
event_inherited();

model_name = "chicken";
drop = 16;
drop_min = 1;
drop_max = 2;

hp = 35;

walk_spd = 120;

run_spd = 310;

sounds = [snd_chicken_call_1,snd_chicken_call_2]
sound_min = 20;
sound_max = 40;
sound_time = random_range(sound_min,sound_max);

walk_sound_min =.5;
walk_sound_max = .7;
walk_sound_time = random_range(walk_sound_min,walk_sound_max);

walk_sound = snd_chicken_wall;
hit_sound = snd_chicken_hit;