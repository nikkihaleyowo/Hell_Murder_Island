if(global.title_screen){
	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);
	if(!global.is_dead && !global.won){
		if(title_wait<0){
			title_fade_in -= title_fade_spd*delta_time/1_000_000;
			title_fade_in = max(title_fade_in,0);
		}else{
			title_wait -= delta_time/1_000_000;	
		}
		draw_set_color(c_gray)
		draw_set_alpha(title_fade_in)
		draw_rectangle(0,0,display_get_gui_width(),display_get_gui_height(),false);
		
		draw_set_alpha(1.0);
		draw_sprite(spr_title_screen,0,0,0)	
		
		draw_set_halign(fa_left)
		draw_set_font(fnt_respawn);
		draw_set_halign(fa_center)
		draw_set_color(c_white)
		draw_text(display_get_gui_width()/2,680,"press space to spawn");
		
		var _a = .5;
		if(point_in_rectangle(_mx, _my, info_x,info_y,info_x+info_s,info_y+info_s)){
			_a = 1;
			if(mouse_check_button_pressed(mb_left)){
				show_info = true;	
			}
		}
		draw_set_alpha(_a)
		draw_sprite(spr_info,0,info_x,info_y);
		draw_set_alpha(1)
	}
	else if(global.is_dead){
		draw_set_color(c_white)
		draw_text(10,10,"Player Tips:")
		draw_text(10,40,global.tip)
		
		draw_set_font(fnt_respawn);
		draw_set_color(c_white)
		draw_set_halign(fa_center)
		draw_text(display_get_gui_width()/2,300,global.death_reason);
		
		draw_text(display_get_gui_width()/2,600,"press space to try again...");
	
		var _total_seconds = floor(global.time_survived);
		var _hours   = floor(_total_seconds / 3600);
		var _minutes = floor((_total_seconds / 60) % 60);
		var _seconds = _total_seconds % 60;

		var _str_time = string_format(_hours, 2, 0) + ":" + 
		                string_replace_all(string_format(_minutes, 2, 0), " ", "0") + ":" + 
		                string_replace_all(string_format(_seconds, 2, 0), " ", "0");

		draw_text(display_get_gui_width()/2, 200, "Time Survived: " + _str_time);
	}
	else if(global.won){
		draw_set_font(fnt_respawn);
		draw_set_color(c_white)
		draw_set_halign(fa_center)
		draw_text(display_get_gui_width()/2,300,"you won :) good job champ");
		
		draw_text(display_get_gui_width()/2,600,"press space to try again...");
	
		var _total_seconds = floor(global.time_survived);
		var _hours   = floor(_total_seconds / 3600);
		var _minutes = floor((_total_seconds / 60) % 60);
		var _seconds = _total_seconds % 60;

		var _str_time = string_format(_hours, 2, 0) + ":" + 
		                string_replace_all(string_format(_minutes, 2, 0), " ", "0") + ":" + 
		                string_replace_all(string_format(_seconds, 2, 0), " ", "0");

		draw_text(display_get_gui_width()/2, 20, "Time Survived: " + _str_time);
	}
	
	
	
	if(point_in_rectangle(_mx,_my,full_screen_x,full_screen_y,full_screen_x+full_screen_s,full_screen_y+full_screen_s)){
		if(mouse_check_button_pressed(mb_left)){
			global.full_screen = !global.full_screen;
			window_set_fullscreen(global.full_screen)
		}
	}
	draw_set_font(fnt_game)
	draw_set_color(c_white);
	draw_rectangle(full_screen_x,full_screen_y,full_screen_x+full_screen_s,full_screen_y+full_screen_s,!global.full_screen);
	draw_set_halign(fa_center);
	draw_text(full_screen_x+90,full_screen_y," Full Screen")
	draw_set_halign(fa_left)
	
	if(starting_game){
		title_zoom_cur -= title_zoom_spd*delta_time/1_000_000;
		title_fade_out += title_fade_out_spd*delta_time/1_000_000;
		
		draw_set_color(c_black)
		draw_set_alpha(title_fade_out);
		draw_rectangle(0,0,display_get_gui_width(),display_get_gui_height(),false);
		draw_set_alpha(1.0)
	}
	
	if(show_info){
		draw_sprite(spr_info_screen,0,0,0)
	}
	
	exit;
}

draw_set_color(c_white);
draw_rectangle(display_get_gui_width()/2-2,display_get_gui_height()/2-2+2,display_get_gui_width()/2,display_get_gui_height()/2+2,false)

global.progress_manager.Draw();

draw_set_halign(fa_left)
draw_set_font(fnt_game)

var _total_seconds = floor(global.time_survived);
var _hours   = floor(_total_seconds / 3600);
var _minutes = floor((_total_seconds / 60) % 60);
var _seconds = _total_seconds % 60;

var _str_time = string_format(_hours, 2, 0) + ":" + 
                string_replace_all(string_format(_minutes, 2, 0), " ", "0") + ":" + 
                string_replace_all(string_format(_seconds, 2, 0), " ", "0");

draw_text(40, 20, "Time Survived: " + _str_time);

//survival
draw_set_color(c_white);
draw_set_alpha(0.3);
draw_rectangle(hp_x,hp_y,hp_x+hp_w,hp_y+hp_h,false);
draw_set_color(c_red);
draw_set_alpha(0.5);
draw_rectangle(hp_x,hp_y,hp_x+hp_w*(hp/max_hp),hp_y+hp_h,false);
draw_set_color(c_white);
draw_set_alpha(1.0);
draw_rectangle(hp_x,hp_y,hp_x+hp_w,hp_y+hp_h,true);

draw_set_color(c_white);
draw_set_alpha(0.3);
draw_rectangle(hunger_x,hunger_y,hunger_x+hunger_w,hunger_y+hunger_h,false);
draw_set_color(c_orange);
draw_set_alpha(0.5);
draw_rectangle(hunger_x,hunger_y,hunger_x+hunger_w*(hunger/max_hunger),hunger_y+hunger_h,false);
draw_set_color(c_white);
draw_set_alpha(1.0);
draw_rectangle(hunger_x,hunger_y,hunger_x+hunger_w,hunger_y+hunger_h,true);

//others (dont judge my comments nerd)
inv.Draw();
draw_set_color(c_white)
draw_set_halign(fa_center);
var _t_i = inv.GetItemSlot(inv.selected);
if(_t_i!=-1){
	var _t_d = ds_map_find_value(global.item_data,_t_i.item_id);
	draw_text(display_get_gui_width()/2,display_get_gui_height()-130,_t_d.name);
}
draw_set_halign(fa_left)

global.raid_manager.Draw();

audio_listener_position(player.x, player.y, 0);
var _look_x = dcos(player.look_dir);
var _look_y = -dsin(player.look_dir);
audio_listener_orientation(_look_x, _look_y, 0, 0, 0, 1);

if(mining_block){
	draw_set_color(c_white);
	draw_set_alpha(0.3);
	draw_rectangle(mining_prog_x,mining_prog_y,mining_prog_x+mining_prog_w,mining_prog_y+mining_prog_h,false)
	draw_set_color(c_blue);
	draw_rectangle(mining_prog_x,mining_prog_y,mining_prog_x+(mining_prog_w*(1-(block_strength/block_strength_start))),mining_prog_y+mining_prog_h,false)
	
	draw_set_color(c_white);
	draw_set_alpha(1.0);
	draw_text(mining_prog_x,mining_prog_y,string(block_strength))

}

if(wall_selected != noone){
	if(instance_exists(wall_selected)){
		draw_set_color(c_white);
		draw_text(display_get_gui_width()/2,display_get_gui_height()/2+100,string(wall_selected.strength)+" / "+string(wall_selected.start_strength));
	}
}

if(instance_selected!=noone){
	if(object_is_ancestor(instance_selected.object_index, obj_interact)){
		draw_set_color(c_white);
		draw_text(display_get_gui_width()/2,display_get_gui_height()/2-100,instance_selected.interact_text)
	}
}

if(inv_open!=noone){
	inv_open.Draw();
}

if(menu_open){
	//show_debug_message(ds_list_size(can_craft_list))
	draw_set_color(c_grey);
	draw_set_alpha(.6);
	draw_rectangle(craft_x,craft_y,craft_x+recipe_w,craft_y+recipe_h,false)
	draw_rectangle(crafting_x,crafting_y,crafting_x+queue_w,crafting_y+queue_h,false)
	
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_text(craft_x,craft_y-30,"transmutation recipes")
	
	var _count = 0;
	for(var i = craft_list_start;(i<ds_list_size(can_craft_list))&&(_count<craft_list_show_amount);i++){
		var _i = i - craft_list_start;
		var _cr_index = ds_list_find_value(can_craft_list,i);
		var _data = ds_list_find_value(global.crafting_recipes,_cr_index);

		
		draw_set_color(c_white);
		draw_set_alpha(0.3);
		draw_rectangle(craft_x, craft_y+_i*craft_h,craft_x+craft_cell_size, craft_y+_i*craft_h+craft_cell_size,false)
		
		draw_set_alpha(1.0)
		var _item_data = ds_map_find_value(global.item_data, _data.item_id);
		var _scale = craft_cell_size / sprite_get_width(_item_data.spr);
		draw_sprite_ext(_item_data.spr,0,craft_x, craft_y+_i*craft_h,_scale,_scale,0,c_white,1);
		draw_text(craft_x+5, craft_y+_i*craft_h+2,string(_data.item_amount));
		
		draw_set_color(c_white);
		if(craft_on==i)
			draw_set_color(c_blue)
		draw_rectangle(craft_x, craft_y+_i*craft_h,craft_x+craft_cell_size, craft_y+_i*craft_h+craft_cell_size,true)
		
		draw_set_color(c_white);
		draw_text(craft_x,craft_y+_i*craft_h+craft_cell_size+2,_item_data.name)
		
		var _inputs = _data.items_needed;
		for(var c = 0;c<array_length(_inputs);c++){
			var _needed = _inputs[c];
			_item_data = ds_map_find_value(global.item_data, _needed.item_id);
			
			draw_set_color(c_white);
			draw_set_alpha(0.3);
			draw_rectangle(craft_x+craft_input_dist+c*craft_cell_size, craft_y+_i*craft_h,craft_x+craft_input_dist+c*craft_cell_size+craft_cell_size, craft_y+_i*craft_h+craft_cell_size,false)
		
			draw_set_alpha(1.0)
		
			_scale = craft_cell_size / sprite_get_width(_item_data.spr);
			draw_sprite_ext(_item_data.spr,0,craft_x+craft_input_dist+c*craft_cell_size, craft_y+_i*craft_h,_scale,_scale,0,c_white,1);
			
			if(!inv.HasItem(_inputs[c].item_id,_inputs[c].amount)){
				draw_set_color(c_red);
				draw_set_alpha(.3);
				draw_rectangle(craft_x+craft_input_dist+c*craft_cell_size, craft_y+_i*craft_h,craft_x+craft_input_dist+c*craft_cell_size+craft_cell_size, craft_y+_i*craft_h+craft_cell_size,false)
				draw_set_color(c_white);
				draw_set_alpha(1.0);
			}
			draw_text(craft_x+craft_input_dist+c*craft_cell_size+5, craft_y+_i*craft_h+2,string(_needed.amount));
			
			var _mx = device_mouse_x_to_gui(0);
			var _my = device_mouse_y_to_gui(0);
			if(point_in_rectangle(_mx,_my,craft_x+craft_input_dist+c*craft_cell_size, craft_y+_i*craft_h,craft_x+craft_input_dist+c*craft_cell_size+craft_cell_size, craft_y+_i*craft_h+craft_cell_size)){
				draw_text(_mx,_my+15,_item_data.name);
			}
		}
		_count++;
	}
	
	if((craft_list_start+craft_list_show_amount)<ds_list_size(can_craft_list)){
		draw_set_alpha(.5);
		if(craft_down_on)
			draw_set_alpha(1.0);
		draw_sprite(spr_down,0,craft_down_x,craft_down_y);
	}
	
	if(craft_list_start!=0){
		draw_set_alpha(.5);
		if(craft_up_on)
			draw_set_alpha(1.0);
		draw_sprite(spr_up,0,craft_up_x,craft_up_y);
	}
	
	
	///crafting_queue
	for(var i = 0;i<ds_list_size(crafting_queue);i++){
		var _data = ds_list_find_value(crafting_queue,i);
		var _item_data = ds_map_find_value(global.item_data,_data.item_id);
		
		draw_set_color(c_white);
		draw_set_alpha(.3);
		draw_rectangle(crafting_x,crafting_y+i*crafting_h,crafting_x+craft_cell_size,crafting_y+i*crafting_h+craft_cell_size,false);
			
		draw_set_alpha(1)
		var _scale = craft_cell_size / sprite_get_width(_item_data.spr);
		draw_sprite_ext(_item_data.spr,0,crafting_x,crafting_y+i*crafting_h,_scale,_scale,0,c_white,1);
		
		draw_text(crafting_x+crafting_time_pad,crafting_y+i*crafting_h,string(_data.time)+"s")
		
	}
}

if(instance_exists(obj_soul_collector)){

	var _bar_w = 500;
	var _bar_h = 32;
	var _gui_w = display_get_gui_width();
	var _cx = _gui_w / 2;
	var _cy = 20;
	var _fov = 90; 

	draw_set_alpha(.2);

	var _dir = point_direction(Camera.player.x, Camera.player.y, obj_soul_collector.x, obj_soul_collector.y);
	var _diff = angle_difference(_dir, Camera.player.look_dir-180);

	draw_rectangle_color(_cx - _bar_w/2, _cy - _bar_h/2, _cx + _bar_w/2, _cy + _bar_h/2, c_white, c_white, c_white, c_white, false);

	draw_set_alpha(.6);
	if (abs(_diff) < (_fov / 2)) {
	    var _marker_x = _cx + (_diff / (_fov / 2)) * (_bar_w / 2);
    
	    draw_sprite(spr_soul_fragment, 0, _marker_x-16, _cy-16);
	}

	draw_set_alpha(1.0)
}

if(hit_fade!=0){
	draw_set_alpha(hit_fade);
	draw_set_color(c_red);
	draw_rectangle(0,0,display_get_gui_width(),display_get_gui_height(),false);
	draw_set_color(c_white)
	draw_set_alpha(1.0)
}

if(global.paused){
	draw_set_alpha(0.5);
	draw_set_color(c_black);
	draw_rectangle(0,0,display_get_gui_width(),display_get_gui_height(),false);
	draw_set_alpha(1)
	draw_set_color(c_white);
	draw_set_halign(fa_center)
	draw_text(display_get_gui_width()/2,120,"[PAUSED]")
	
	draw_set_font(fnt_round);
	draw_set_valign(fa_middle);
	
	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);
	
	var _color = c_grey
	if(point_in_rectangle(_mx,_my,display_get_gui_width()/2-120,display_get_gui_height()/2-40,display_get_gui_width()/2+120,display_get_gui_height()/2+40)){
		_color = c_white;
		if(mouse_check_button_pressed(mb_left)){
			game_end();	
		}
	}
	draw_set_color(_color)
	draw_text(display_get_gui_width()/2,display_get_gui_height()/2,"EXIT")
	
	draw_set_font(fnt_game);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	
	if(point_in_rectangle(_mx,_my,full_screen_x,full_screen_y,full_screen_x+full_screen_s,full_screen_y+full_screen_s)){
		if(mouse_check_button_pressed(mb_left)){
			global.full_screen = !global.full_screen;
			window_set_fullscreen(global.full_screen)
		}
	}
	
	draw_set_color(c_white);
	draw_rectangle(full_screen_x,full_screen_y,full_screen_x+full_screen_s,full_screen_y+full_screen_s,!global.full_screen);
	draw_set_halign(fa_center);
	draw_text(full_screen_x+90,full_screen_y," Full Screen")
	draw_set_halign(fa_left)
}

