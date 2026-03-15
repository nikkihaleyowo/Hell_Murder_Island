// Inherit the parent event
event_inherited();

model_name = "zombie";

drop = 13;
drop_min = 2;
drop_max = 8;

is_static = false;

z_height = 54;

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
run_spd = 220;
run_min = 2;
run_max = 5;
run_amount = 0;

rock_cur = 0;
rock_dir = 1;
rock_spd = 10;
rock_amount = 20;

attack_dist = 32;
wall_attack_dist = 20;

wall_attacking = noone;

attack_time = 1.5;
attack_timer = 0;
attack_damage = 15;
used_attacked = false;

wall_attack_time = 1.5;
wall_attack_timer = 0;
wall_attack_damage = 15;

//sound 
sounds = [snd_zombie_moan_1,snd_zombie_moan_2]
sound_min = 5;
sound_max = 12;
sound_time = random_range(sound_min,sound_max);

walk_sound_min =.2;
walk_sound_max = .3;
walk_sound_time = random_range(walk_sound_min,walk_sound_max);

last_hp = hp;

soul_collector_dist = 300;
goto_collector_chance = .4;

stun_time = .4;
stun_timer = stun_time;

got_close_to_player = false;
close_to_distance = 300;
loss_distance = 600;

attack_tilt_cur = 0;
attack_tilt_dir =1;
attack_tilt = false;
attack_tilt_spd = 6;
attack_tilt_amount = -20;

function NextState(){
	if(distance_to_object(obj_soul_collector)<soul_collector_dist){
		if(goto_collector_chance<random(1)){
			SetState(MOB_STATE.GOTO_COLLECTOR);
			return 0;
		}
	}
	
	if(global.hell_mode || attacked){
		SetState(MOB_STATE.GOTO_PLAYER)
		
	}else{
		var _r = random(1);
		if(_r<0.5){
			SetState(MOB_STATE.IDLE);
		}else{
			SetState(MOB_STATE.MOVE);
		}
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
		case MOB_STATE.GOTO_PLAYER:
			var _found = global.physical_world.CanPath(x,y);
			if(!_found){
				SetState(MOB_STATE.GOTO_WALL);	
			}
			break;
		case MOB_STATE.GOTO_WALL:
			var _list = ds_list_create();
			var _num = collision_line_list(x,y,Camera.player.x,Camera.player.y,obj_wall,false,true,_list,true);
			
			if(_num==0){
				SetState(MOB_STATE.GOTO_PLAYER);	
			}else{
				var _nearest = ds_list_find_value(_list,0);
				var _dist = distance_to_object(_nearest);
				for(var i = 1; i<_num;i++){
					var _temp = ds_list_find_value(_list,i);
					var _t_d = distance_to_object(_temp);
					if(_t_d<_dist){
						_dist = _t_d;
						_nearest = _temp;
					}
				}
				wall_attacking = _nearest;
				
				goto_x = _nearest.x;
				goto_y = _nearest.y;
			}
			break;
		case MOB_STATE.GOTO_COLLECTOR:
			var _list = ds_list_create();
			var _num = collision_line_list(x,y,obj_soul_collector.x,obj_soul_collector.y,obj_wall,false,true,_list,true);
			
			if(_num==0){
				SetState(MOB_STATE.GOTO_PLAYER);	
			}else{
				var _nearest = ds_list_find_value(_list,0);
				var _dist = distance_to_object(_nearest);
				for(var i = 1; i<_num;i++){
					var _temp = ds_list_find_value(_list,i);
					var _t_d = distance_to_object(_temp);
					if(_t_d<_dist){
						_dist = _t_d;
						_nearest = _temp;
					}
				}
				wall_attacking = _nearest;
				
				goto_x = _nearest.x;
				goto_y = _nearest.y;
			}
			break;
	}
}