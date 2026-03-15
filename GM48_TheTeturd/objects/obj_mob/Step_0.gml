if(global.paused){
	exit;
}

// Inherit the parent event
event_inherited();

if(hp<=0){
	instance_destroy();	
}

if(distance_to_object(Player)>global.mob_despawn_dist){
	instance_destroy();	
}

sound_time -= delta_time/1_000_000;
if(sound_time<=0){
	sound_time = random_range(sound_min,sound_max);
	
	//play sound
	var _p = random_range(.9,1.1);
	var _r = floor(random(array_length(sounds)));
	var _snd = sounds[_r];
	audio_play_sound_at(_snd,x,y,0,100,1000,1,false,2,.3,0,_p);
}


if(state==MOB_STATE.MOVE || state==MOB_STATE.RUN){
	rock_cur += rock_dir*rock_spd*delta_time/1_000_000;
	if(rock_dir==1){
		if(rock_cur>=1){
			rock_cur =1;
			rock_dir = -1;
		}
	}else{
		if(rock_cur<=0){
			rock_cur =0;
			rock_dir = 1;
		}
	}
	walk_sound_time-=delta_time/1_000_000;
	if(walk_sound_time<=0){
		walk_sound_time = random_range(walk_sound_min,walk_sound_max);
		var _p = random_range(.9,1.1);
		audio_play_sound_at(walk_sound,x,y,0,100,1000,1,false,2,.5,0,_p);
	}
}else{
	rock_cur = 0;	
}

y_rot = rock_cur*rock_amount;

if(attacked){
	attacked = false;
	run_amount = floor(random_range(run_min,run_max));
	
	var _p = random_range(.9,1.1);
	audio_play_sound_at(hit_sound,x,y,0,100,1000,1,false,2,.5,0,_p);
		
	var _x = x + random_range(-run_away_dist,run_away_dist);
	var _y = y + random_range(-run_away_dist,run_away_dist);
	var _count = 0;
	while((place_meeting(_x,_y,obj_wall) || !point_in_rectangle(_x,_y,0,0,global.world_size_px,global.world_size_px)) && _count<10){
		_x = x + random_range(-run_away_dist,run_away_dist);
		_y = y + random_range(-run_away_dist,run_away_dist);
		_count++;
	}
	goto_x = _x;
	goto_y = _y;
	
	state = MOB_STATE.RUN;
}

switch(state){
	case MOB_STATE.IDLE:
		idle_time-=delta_time/1_000_000;
		if(idle_time<=0){
			NextState();	
		}
		break;
	case MOB_STATE.MOVE:
		var _old_x =x;
		var _old_y =y;
		
		var _done = mp_potential_step_object(goto_x,goto_y,walk_spd*delta_time/1_000_000,obj_wall);
		
		if(x!=_old_x&&y!=_old_y){
			var _angle = point_direction(_old_x,_old_y,x,y);
			
			z_rot = _angle;
		}
		
		if(_done){
			NextState();	
		}
		break;
	case MOB_STATE.RUN:
		var _old_x =x;
		var _old_y =y;
		
		var _done = mp_potential_step_object(goto_x,goto_y,run_spd*delta_time/1_000_000,obj_wall);
		
		if(x!=_old_x&&y!=_old_y){
			var _angle = point_direction(_old_x,_old_y,x,y);
			
			z_rot = _angle;
		}
		
		if(_done){
			run_amount--;
			if(run_amount>=0){
				var _x = x + random_range(-run_away_dist,run_away_dist);
				var _y = y + random_range(-run_away_dist,run_away_dist);
				var _count = 0;
				while((place_meeting(_x,_y,obj_wall) || !point_in_rectangle(_x,_y,0,0,global.world_size_px,global.world_size_px)) && _count<10){
					_x = x + random_range(-run_away_dist,run_away_dist);
					_y = y + random_range(-run_away_dist,run_away_dist);
					_count++;
				}
				goto_x = _x;
				goto_y = _y;	
			}else{
				NextState();	
			}
		}
		break;
}
