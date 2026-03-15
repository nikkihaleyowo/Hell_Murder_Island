global.grid_world.StepLoad(player.x,player.y);
global.music_manager.StepMusic();

if(global.paused || global.title_screen || menu_open || inv_open!=noone){
	window_set_cursor(cr_default)
}else{
	window_set_cursor(cr_none)
}

if(global.paused){
	if(keyboard_check_pressed(vk_escape)){
		global.paused = !global.paused;	
	}
	exit;
}

if(global.is_dead || global.won){
	global.title_screen = true;
	menu_open = false;
	inv_open = noone;
}

if(global.title_screen){
	if(keyboard_check(vk_space)){
		if(!starting_game)
			audio_play_sound(snd_start_hit, 1,false);
		starting_game = true;
		show_info = false;
	}
		
	if(keyboard_check_pressed(vk_escape)){
		if(show_info){
			show_info = false;
		}else{
			game_end();
		}
	}
	
	if(starting_game){
		if(title_fade_out>=1){
			StartGame();	
			starting_game = false;
			title_fade_out = 0;
			title_zoom_cur = 0;
		}
	}
	exit;	
}else{
	if(keyboard_check_pressed(vk_escape)){
		global.paused = !global.paused;	
	}
}


global.time_survived += delta_time/1_000_000;

x = player.x;
y = player.y;

if(keyboard_check_pressed(ord("P"))){
	global.raid_manager.SpawnHostile(1)
}

if(hit_fade>0){
	hit_fade-=hit_fade_spd*delta_time/1_000_000;
	if(hit_fade<0)
		hit_fade = 0;
}

if(last_hp>hp){
	last_hp = hp;
	hit_fade = hit_start;
	
	if(hunger>0){
		var _p = random_range(.9,1.1);
		audio_play_sound_at(snd_player_hit,player.x,player.y,0,100,1000,1,false,2,.5,0,_p);	
	}
}

if(hp<=0){
	//death screen
	global.is_dead = true;
	global.death_reason = "died of natural causes";
	hp = 0;
}

var _h_d = player.running ? hunger_base_decline*3 : hunger_base_decline;
hunger -= _h_d * delta_time/1_000_00;

if(hunger>=hunger_heal_level*max_hunger){
	hp += hunger_heal_rate*delta_time/1_000_000;
	hp = min(max_hp,hp);
}
if(hunger<=5){
	hp -= hunger_starve_rate*delta_time/1_000_000;
}else{
	if(distance_to_object(obj_camp_fire)<camp_fire_dist){
		hp+=camp_fire_heal_rate*delta_time/1_000_000;
		hp = min(hp, max_hp);
	}
}

//crafting
if(keyboard_check_pressed(vk_tab)){
	if(inv_open!=noone){
		inv_open = noone;	
	}else{
		menu_open = !menu_open;
	
		if(menu_open){
			craft_list_start = 0;
			var _near_workstation = false;
			if(instance_exists(obj_workstation)){
				if(distance_to_object(obj_workstation)<=workstation_distance){
					_near_workstation = true;
				}
			}
			
			var _near_alchemist = false;
			if(instance_exists(obj_alchemist_table)){
				if(distance_to_object(obj_alchemist_table)<=workstation_distance){
					_near_alchemist = true;
				}
			}
		
			for(var i = 0;i<ds_list_size(global.crafting_recipes);i++){
				var _cr = ds_list_find_value(global.crafting_recipes,i);
				if(_cr.needs_workstation){
					if(_near_workstation){
						ds_list_add(can_craft_list,i);	
					}
				}else if(_cr.needs_alchemist){
					if(_near_alchemist){
						ds_list_add(can_craft_list,i);	
					}
				}else{
					show_debug_message("penis")
					show_debug_message(i)
					ds_list_add(can_craft_list,i);
				}
			}
			show_debug_message("list back")
			for(var i = 0;i<ds_list_size(can_craft_list);i++){
				show_debug_message(ds_list_find_value(can_craft_list,i));	
			}
		}else{
			ds_list_clear(can_craft_list);	
		}
	}
}

if(attack_timer>0){
	attack_timer-=delta_time/1_000_000;
	if(attack_timer<=0)
		attack_timer = 0;
}


global.mob_manager.StepSpawn();
global.raid_manager.StepWorld();

if(ds_list_size(crafting_queue)>0){
	var _data = ds_list_find_value(crafting_queue,0);
	//show_debug_message(_data)
	if(_data.time<=0){
		_data.time = 0;
		if(inv.CanAddItem(_data.item_id,_data.amount)){
			inv.AddItem(_data.item_id,_data.amount)
			UpdateHand();
			if(_data.item_id==3)
				global.progress_manager.GiveKey("craft_hatchet")
			if(_data.item_id==2)
				global.progress_manager.GiveKey("craft_workstation")
			if(_data.item_id==8)
				global.progress_manager.GiveKey("cook_food")
			if(_data.item_id==12)
				global.progress_manager.GiveKey("craft_stone")
			ds_list_delete(crafting_queue,0);
		}
		
	}else{
		_data.time -= delta_time/1_000_000;
	}
}

instance_selected = noone;

if(!menu_open && Camera.inv_open==noone){
	///block world
	var _lx = -dcos(player.look_dir) * dcos(player.look_pitch);
	var _ly = dsin(player.look_dir) * dcos(player.look_pitch);
	var _lz = dsin(player.look_pitch);
	
	var _ray_start_x = x;
	var _ray_start_y = y;
	var _ray_start_z = player.z + player.player_height;
	var _ray_end_x = _ray_start_x + _lx * attack_distance;
	var _ray_end_y = _ray_start_y + _ly * attack_distance;
	var _ray_end_z = _ray_start_z + _lz * attack_distance;
	
	var _hit =raycast_check_mob(_ray_start_x,_ray_start_y, _ray_start_z,_ray_end_x,_ray_end_y,_ray_end_z);
	if(_hit!=noone){
		var _hit_instance = _hit.hit;
		if(mouse_check_button_pressed(mb_left)){
			if(attack_timer<=0){
				
				var _damage = base_attack_damage;
				var _range = base_attack_range;
				if(holding_tool){
					var _item = inv.GetItemSlot(inv.selected);
					var _data = ds_map_find_value(global.item_data,_item.item_id);
					_damage = _data.attack_damage;
					_range = _data.attack_range;
				}
				if(distance_to_object(_hit_instance)<_range){
					if(holding_tool){
						move_tool = true;
						tool_move_dir = 1;
						tool_move_cur = 0;	
					}
					attack_timer = attack_time;
					_hit_instance.hp -= _damage;
					_hit_instance.attacked = true;
					hunger -= hunger_attack;
					var _p = random_range(.9,1.1);
					audio_play_sound_at(snd_player_attack,player.x,player.y,0,100,1000,1,false,2,.5,0,_p);
				}
			}
		}
	}

	var _res = GetZAxisCrossingPoint(player.x,player.y,player.z+player.player_height,_lx,_ly,_lz);
	selector_found = _res.found;
	if(!mining_block){
	selector_x = -1;
	selector_y = -1;	
	}
	
	if(_res.found&&_hit==noone&&!mining_block){
		wall_selected = instance_place(_res.x,_res.y,obj_wall);
		
		selector_x = floor(_res.x/global.cell_size);
		selector_y = floor(_res.y/global.cell_size);
		
		instance_selected = global.grid_world.GetEntity(selector_x,selector_y);
	
		if(!mining_block){
			if(mouse_check_button_pressed(mb_left)){
				var _block_id = global.grid_world.GetCell(selector_x,selector_y);
				if(_block_id!=0){
					var _data = ds_map_find_value(global.block_data,_block_id);
					if(_data!=undefined){
						if(_block_id!=10){
							mining_block_id = _block_id;
							block_strength = _data.strength;
							block_strength_start = _data.strength;
							mining_block = true;
							mine_timer = 0;
							mining_x = selector_x;
							mining_y = selector_y;
						}
						if(_block_id==1){
							mine_ball_enabled = true;
							mine_ball_x = random_range(selector_x*global.cell_size,selector_x*global.cell_size+global.cell_size);
							mine_ball_y = random_range(selector_y*global.cell_size,selector_y*global.cell_size+global.cell_size);
							mine_ball_z = 0;
						}else if (_block_id == 2) {
						    mine_ball_enabled = true;
    
						    
						    var _cx = selector_x * global.cell_size + (global.cell_size / 2);
						    var _cy = selector_y * global.cell_size + (global.cell_size / 2);
						    var _cz = 0; 
    
						    var _dir = random(360);
						    var _pitch = random(90);

						    var _radius = 18;
						    mine_ball_x = _cx + lengthdir_x(_radius * dcos(_pitch), _dir);
						    mine_ball_y = _cy + lengthdir_y(_radius * dcos(_pitch), _dir);
						    mine_ball_z = _cz + (_radius * dsin(_pitch));
    
						}else{
							mine_ball_enabled = false;	
						}
					}
				}
			}	
		}
	
		if(mouse_check_button_pressed(mb_right)){
			var _block_id = global.grid_world.GetCell(selector_x,selector_y);
			if(_block_id==0){
				var _item = inv.GetItemSlot(inv.selected);
				if(_item!=-1){
					var _data = ds_map_find_value(global.item_data,_item.item_id);
					if(_data.can_place){
						global.grid_world.SetCell(selector_x,selector_y,_data.block_id);
						inv.RemoveItem(_item.item_id,1);
						var _p = random_range(.9,1.1);
						audio_play_sound_at(snd_player_place,player.x,player.y,0,100,1000,1,false,2,.5,0,_p);
					}
				}
			}
		}
	}
	
	if(instance_selected!=noone){
		if(mouse_check_button_pressed(mb_right)){
			if(object_is_ancestor(instance_selected.object_index, obj_interact)){
				instance_selected.Interact();
			}
		}
	}
	
	if(mining_block){
		if(mouse_check_button_released(mb_left)){
			mining_block = false;	
			mine_ball_enabled = false;
		}
		
		if(distance_to_point(selector_x*global.cell_size+global.cell_size/2,selector_y*global.cell_size+global.cell_size/2)>64){
			mining_block = false;	
			mine_ball_enabled = false;
		}
		
		else{
			mine_timer -= delta_time/1_000_000;
			if(mine_timer<=0){
				
				hunger -= hunger_mine;
				var _p = random_range(.9,1.1);
				
				var _mult = 1;
				
				if(mine_ball_enabled){
					var _player_z = player.z + player.player_height;

					var _target_dir = point_direction(player.x, player.y, mine_ball_x, mine_ball_y);
					var _target_pitch = point_pitch_3d(player.x, player.y, _player_z, mine_ball_x, mine_ball_y, mine_ball_z);

					var _diff_dir = abs(angle_difference(player.look_dir-180, _target_dir));
					var _diff_pitch = abs(angle_difference(player.look_pitch, _target_pitch));

					var _fov_threshold = 5; 
					if (_diff_dir < _fov_threshold && _diff_pitch < _fov_threshold) {
					    _mult = 1.5;
    
					    if(mining_block_id == 1) {
					        mine_ball_x = random_range(selector_x * global.cell_size, (selector_x + 1) * global.cell_size);
					        mine_ball_y = random_range(selector_y * global.cell_size, (selector_y + 1) * global.cell_size);
					        mine_ball_z = 0;
					    }else if (mining_block_id == 2) {
						    var _cx = selector_x * global.cell_size + (global.cell_size / 2);
						    var _cy = selector_y * global.cell_size + (global.cell_size / 2);
						    var _cz = 0; 
    
						    var _dir = random(360);
						    var _pitch = random(90);

						    var _radius = 18;
						    mine_ball_x = _cx + lengthdir_x(_radius * dcos(_pitch), _dir);
						    mine_ball_y = _cy + lengthdir_y(_radius * dcos(_pitch), _dir);
						    mine_ball_z = _cz + (_radius * dsin(_pitch));
						}
					}
				}
				
				audio_play_sound_at(snd_player_mine,player.x,player.y,0,100,1000,1,false,2,1,0,_p);
				if(!holding_tool)
					if(hunger<hunger_mine_level*max_hunger){
						block_strength-=base_mine_damage*.5*_mult;
					}else{
						block_strength-=base_mine_damage*_mult;
					}
				else{
					var _item = inv.GetItemSlot(inv.selected);
					var _data = ds_map_find_value(global.item_data,_item.item_id);
					if(hunger<hunger_mine_level*max_hunger){
						block_strength-=_data.mine_damage*.5*_mult;
					}else{
						block_strength-=_data.mine_damage*_mult;
					}
				}
				
				move_tool = true;
				tool_move_dir = 1;
				tool_move_cur = 0;
			
				if(block_strength<=0){
					var _block_id = global.grid_world.GetCell(selector_x,selector_y);
					if(_block_id!=0){
						var _data = ds_map_find_value(global.block_data,_block_id);
						var _amount = round(random_range(_data.item_min,_data.item_max));
					
						var _item_id = _data.item_drop;
						var _item_data = ds_map_find_value(global.item_data,_item_id);
					
						var _item = instance_create_depth(selector_x*global.cell_size+global.cell_size/2,selector_y*global.cell_size+global.cell_size/2,0,obj_item);
						_item.amount = _amount;
						_item.item_id = _item_id;
						_item.sprite_index = _item_data.spr;
					}
					if(_block_id=1)
						global.progress_manager.GiveKey("get_wood")
					global.grid_world.SetCell(selector_x,selector_y,0);
					instance_selected = noone;
					mining_block = false;
					mine_ball_enabled = false;
				}else{
					mine_timer = mine_time;	
				}
			}
		}
	}else{
		if(mouse_check_button_pressed(mb_right)){
			if(!dont_consume){
				var _item = inv.GetItemSlot(inv.selected);
				if(_item!=-1){
					var _data = ds_map_find_value(global.item_data,_item.item_id);
					if(_data.edible){
						hunger+=_data.hunger;
						hunger = min(hunger,max_hunger);
						
						hp+=_data.health;
						hp = min(hp,max_hp);
						
						var _p = random_range(.9,1.1);
						audio_play_sound_at(snd_player_consume,player.x,player.y,0,100,1000,1,false,2,.5,0,_p);
					
						inv.RemoveItem(_item.item_id,1);
					}
					if(_item.item_id==0){
						if(wall_selected!=noone){
							if(instance_exists(wall_selected)){
								if(wall_selected.strength<wall_selected.start_strength){
									wall_selected.strength += wood_repair_amount;
									inv.RemoveItem(0,1);
									if(wall_selected.strength>wall_selected.start_strength){
										wall_selected.strength = wall_selected.start_strength;
									}
								}	
							}
						}	
					}
				}
			}
		}
		if(mouse_check_button_pressed(mb_left)){
			var _item = inv.GetItemSlot(inv.selected);
				if(_item!=-1){
					if(_item.item_id==12){
						var _inst = instance_create_depth(player.x,player.y,0,obj_rock_projectile);
						_inst.z = player.z+player.player_height;
						_inst.mx = _lx*_inst.move_spd;
						_inst.my = _ly*_inst.move_spd;
						_inst.mz = _lz*_inst.move_spd;
						
						inv.RemoveItem(12,1);
					}
					else if(_item.item_id==15){
						var _inst = instance_create_depth(player.x,player.y,0,obj_dart_projectile);
						_inst.z = player.z+player.player_height;
						_inst.mx = _lx*_inst.move_spd;
						_inst.my = _ly*_inst.move_spd;
						_inst.mz = _lz*_inst.move_spd;
						
						inv.RemoveItem(15,1);
					}
				}
			
		}
	}

	if(mouse_wheel_down()){
		inv.selected++;
		if(inv.selected>=inv.inv_width)
			inv.selected =  0;
		UpdateHand();
	}
	if(mouse_wheel_up()){
		inv.selected--;
		if(inv.selected<0)
			inv.selected =  inv.inv_width-1;
		UpdateHand();
	}
	
	if(keyboard_check_pressed(ord("Q"))){
		var _item = inv.GetItemSlot(inv.selected);
		if(_item!=-1){
			var _inst = instance_create_depth(x+_lx*item_drop_dist,y+_ly*item_drop_dist,0,obj_item);
			_inst.item_id = _item.item_id;
			_inst.amount = _item.amount;
			var _data = ds_map_find_value(global.item_data,_inst.item_id);
			_inst.sprite_index = _data.spr;
			_inst.drop_time = 2;
			
			inv.ClearItemSlot(inv.selected)
			UpdateHand();
		}
	}
}else{
	//menu controls
	if(mining_block)
		mining_block = false;
		
	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);
		
	craft_on = -1;
	var _count = 0;
	for(var i = craft_list_start;(i<ds_list_size(can_craft_list))&&(_count<craft_list_show_amount);i++){
		var _i = i - craft_list_start;
		
		if(point_in_rectangle(_mx,_my,craft_x, craft_y+_i*craft_h,craft_x+craft_cell_size, craft_y+_i*craft_h+craft_cell_size)){
			craft_on = i;
			
			if(mouse_check_button_pressed(mb_left)){
				if(ds_list_size(crafting_queue)<max_crafting_queue){
					var _cr_index = ds_list_find_index(can_craft_list,i);
					var _data = ds_list_find_value(global.crafting_recipes,_cr_index);
					show_debug_message(_data)
				
					var _inputs = _data.items_needed;
					var _can_craft = true;
					for(var c = 0; c<array_length(_inputs);c++){
						var _item_needed = _inputs[c];
						if(!inv.HasItem(_item_needed.item_id,_item_needed.amount)){
							_can_craft = false;
							break;
						}
					}
				
					if(_can_craft){
						for(var c = 0; c<array_length(_inputs);c++){
							var _item_needed = _inputs[c];
							inv.RemoveItem(_item_needed.item_id,_item_needed.amount);
						}
						ds_list_add(crafting_queue,{item_id: _data.item_id, amount: _data.item_amount, time: _data.time});
					}
				}
			}
			
			break;
		}
		_count++;
	}
	
	craft_up_on = false;
	if(point_in_rectangle(_mx,_my,craft_up_x,craft_up_y,craft_up_x+up_down_size,craft_up_y+up_down_size)){
		craft_up_on = true;
		if(mouse_check_button_pressed(mb_left)){
			if(craft_list_start>0)
				craft_list_start--;
		}
	}
	
	craft_down_on = false;
	if(point_in_rectangle(_mx,_my,craft_down_x,craft_down_y,craft_down_x+up_down_size,craft_down_y+up_down_size)){
		craft_down_on = true;
		if(mouse_check_button_pressed(mb_left)){
			
			if(craft_list_start+craft_list_show_amount<ds_list_size(can_craft_list))
				craft_list_start++;
		}
	}
}

if(inv_open!=noone){
	if(mouse_wheel_down()){
		inv.selected++;
		if(inv.selected>=inv.inv_width)
			inv.selected =  0;
		UpdateHand();
	}
	if(mouse_wheel_up()){
		inv.selected--;
		if(inv.selected<0)
			inv.selected =  inv.inv_width-1;
		UpdateHand();
	}
	
	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);
	if(point_in_rectangle(_mx,_my,inv_open.draw_x,inv_open.draw_y,inv_open.draw_x+inv_open.draw_w,inv_open.draw_y+inv_open.draw_h)){
		var _inv_x = floor((_mx-inv_open.draw_x)/inv_open.cell_size);
		var _inv_y = floor((_my-inv_open.draw_y)/(inv_open.cell_size));
		
		var _slot = _inv_y * inv_open.inv_width + _inv_x;
		if(_slot<0 || _slot>(inv_open.inv_width*inv_open.inv_height))
			_slot = -1;
		inv_open.selected = _slot;
		
		if(mouse_check_button_pressed(mb_left)){
			if(_slot!=-1){
				var _chess = inv_open.GetItemSlot(inv_open.selected);
				var _inv = inv.GetItemSlot(inv.selected);
				
				inv_open.SetItemSlot(inv_open.selected,_inv);
				inv.SetItemSlot(inv.selected,_chess);
				
				UpdateHand();
			}
		}
		
	}
	
}

if(instance_exists(obj_item)){
	var _nearest = instance_nearest(player.x,player.y,obj_item);
	if(distance_to_object(_nearest)<pick_up_distance){
		var _items_near = ds_list_create();
		var _num = collision_circle_list(x,y,pick_up_distance,obj_item,false,true,_items_near,false);
		if(_num>0){
			for(var i = 0; i<_num;i++){
				var _item = ds_list_find_value(_items_near,0);
				if(_item!=undefined){
					if(instance_exists(_item)){
						if(_item.drop_time<=0){
							var _left = inv.AddItem(_item.item_id,_item.amount);
							if(_left==0){
								instance_destroy(_item);
							}else{
								_item.amount = _left;	
							}
						}
					}
				}
			}
		}
		ds_list_destroy(_items_near);
	}
}		

dont_consume = false;
hunger = clamp(hunger,0,max_hunger);