// Inherit the parent event
event_inherited();

model_name = "pig";

drop = 6;
drop_min = 1;
drop_max = 3;

is_static = false;

z_height = 24;

hp = 50;

attacked = false;

state = MOB_STATE.IDLE;
idle_min = 1;
idle_max = 5;
idle_time = 0;

goto_x = 0;
goto_y = 0;

roam_distance = 500;

walk_spd = 100;

run_away_dist = 800;
run_spd = 250;
run_min = 2;
run_max = 5;
run_amount = 0;

rock_cur = 0;
rock_dir = 1;
rock_spd = 10;
rock_amount = 20;

//sound 
sounds = [snd_oink_1,snd_oink_2]
sound_min = 20;
sound_max = 40;
sound_time = random_range(sound_min,sound_max);

walk_sound_min =.5;
walk_sound_max = .7;
walk_sound_time = random_range(walk_sound_min,walk_sound_max);

walk_sound = snd_step;
hit_sound = snd_pig_hit;

function NextState(){
	var _r = random(1);
	if(_r<0.5){
		SetState(MOB_STATE.IDLE);
	}else{
		SetState(MOB_STATE.MOVE);
	}
}

function SetState(_state){
	state = _state;
	switch(state){
		case MOB_STATE.IDLE:
			idle_time = random_range(idle_min,idle_max);
			z_rot = random(360);
			break;
		case MOB_STATE.MOVE:
			var _x = x + random_range(-roam_distance,roam_distance);
			var _y = y + random_range(-roam_distance,roam_distance);
			var _count = 0;
			while((place_meeting(_x,_y,obj_wall) || !point_in_rectangle(_x,_y,0,0,global.world_size_px,global.world_size_px)) && _count<10){
				_x = x + random_range(-roam_distance,roam_distance);
				_y = y + random_range(-roam_distance,roam_distance);
				_count++;
			}
			if(_count == 10){
				SetState(MOB_STATE.IDLE);
				show_debug_message("no found")
			}else{
				goto_x = _x;
				goto_y = _y;
			}
			break;
	}
}