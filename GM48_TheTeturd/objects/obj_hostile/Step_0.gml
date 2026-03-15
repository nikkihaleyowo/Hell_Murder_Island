if(global.is_dead)
	exit;

if(global.paused){
	exit;
}

if(!is_static){
	m = matrix_build(x,y,z,0,y_rot,z_rot,scale,scale,scale);	
}

if(hp<=0){
	instance_destroy();	
}

if(last_hp!=hp){
	var _p = random_range(.9,1.1);
	audio_play_sound_at(snd_zombie_hit,x,y,0,100,1000,1,false,2,.5,0,_p);
	last_hp = hp;
	SetState(MOB_STATE.GOTO_PLAYER);
	stun_timer = stun_timer;
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

if(attack_tilt){
	attack_tilt_cur += attack_tilt_dir*attack_tilt_spd*delta_time/1_000_000;
	
	if(attack_tilt_dir==1){
		if(attack_tilt_cur>=1){
			attack_tilt_dir = -1;
		}
	}else{
		if(attack_tilt_cur<=0){
			attack_tilt_dir = 1;
			attack_tilt_cur = 0;
			attack_tilt = false;
		}
	}
}

if(state==MOB_STATE.MOVE || state==MOB_STATE.RUN || state==MOB_STATE.GOTO_PLAYER || state==MOB_STATE.GOTO_WALL){
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
		audio_play_sound_at(snd_zombie_walk,x,y,0,100,1000,1,false,2,.5,0,_p);
	}
}else{
	rock_cur = 0;	
}

y_rot = rock_cur*rock_amount + attack_tilt_cur*attack_tilt_amount;

/*
if(attacked && !global.hell_mode){
	attacked = false;
	run_amount = floor(random_range(run_min,run_max));
	
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
}*/

if(distance_to_object(Camera.player)<loss_distance && got_close_to_player){
	if(attacked==false){
		attacked = true
		NextState();	
	}
}

if(stun_timer<=0){
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
		case MOB_STATE.GOTO_PLAYER:
			var _old_x =x;
			var _old_y =y;
			
			var _done = mp_potential_step_object(Camera.player.x,Camera.player.y,run_spd*delta_time/1_000_000,obj_wall);
		
			if(x!=_old_x&&y!=_old_y){
				var _angle = point_direction(_old_x,_old_y,x,y);
			
				z_rot = _angle;
			}
		
			if(distance_to_point(Camera.player.x, Camera.player.y)<attack_dist){
				SetState(MOB_STATE.ATTACK);
			}
			
			if(!got_close_to_player){
				if(distance_to_object(Camera.player)<close_to_distance){
					got_close_to_player = true;
				}
			}else{
				if(distance_to_object(Camera.player)>loss_distance){
					attacked = false;
					NextState();
				}
			}
			
			break;
		case MOB_STATE.GOTO_WALL:
			var _old_x =x;
			var _old_y =y;
		
			var _done = mp_potential_step_object(goto_x,goto_y,run_spd*delta_time/1_000_000,obj_wall);
		
			if(x!=_old_x&&y!=_old_y){
				var _angle = point_direction(_old_x,_old_y,x,y);
			
				z_rot = _angle;
			}
		
			if(distance_to_point(goto_x, goto_y)<attack_dist){
				SetState(MOB_STATE.ATTACK_WALL);
			}
			break;
		case MOB_STATE.ATTACK:
			if(!used_attacked){
				if(distance_to_object(Camera.player)<attack_dist){
					Camera.hp -= attack_damage;
					var _p = random_range(.9,1.1);
					attack_tilt = true;
					audio_play_sound_at(snd_zombie_attack,x,y,0,100,1000,1,false,2,.5,0,_p);
					attack_timer = attack_time;
					used_attacked = true;
				}
			}else{
				attack_timer -= delta_time/1_000_000;
				if(attack_timer<=0){
					used_attacked = false;
					NextState();	
				}
			}
			break;
		case MOB_STATE.ATTACK_WALL:
			if(instance_exists(wall_attacking)){
				if(!used_attacked){
					if(distance_to_object(wall_attacking)<wall_attack_dist){
						wall_attacking.strength-= attack_damage;
						attack_tilt = true;
						attack_timer = attack_time;
						var _p = random_range(.9,1.1);
						audio_play_sound_at(snd_zombie_wall,x,y,0,100,1000,1,false,2,.7,0,_p);
						used_attacked = true;
					}
				}else{
					attack_timer -= delta_time/1_000_000;
					if(attack_timer<=0){
						used_attacked = false;
						if(global.physical_world.CanPath(x,y)){
							NextState();	
						}
					}
				}
			}else{
				NextState();
			}
			break;
		case MOB_STATE.GOTO_COLLECTOR:
			var _old_x =x;
			var _old_y =y;
		
			var _done = mp_potential_step_object(goto_x,goto_y,run_spd*delta_time/1_000_000,obj_wall);
		
			if(x!=_old_x&&y!=_old_y){
				var _angle = point_direction(_old_x,_old_y,x,y);
			
				z_rot = _angle;
			}
		
			if(distance_to_point(goto_x, goto_y)<attack_dist){
				SetState(MOB_STATE.ATTACK_WALL);
			}
			break;
	}
}else{
	stun_timer-=delta_time/1_000_000;
}

var _neighbor_dist = 40;
var _sep_force = 0.2;

with(object_index) {
    if (id != other.id) {
        if (point_distance(x, y, other.x, other.y) < _neighbor_dist) {
            var _dir = point_direction(x, y, other.x, other.y);
            other.x += lengthdir_x(_sep_force, _dir);
            other.y += lengthdir_y(_sep_force, _dir);
        }
    }
}