gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
gpu_set_alphatestenable(true);
gpu_set_cullmode(cull_noculling);

gpu_set_tex_repeat(true);

//window_set_fullscreen(true)

camera_distance = 1;

player = instance_create_depth(global.world_size_px/2,global.world_size_px/2,0,Player);

vb_floor = vertex_create_buffer();
vertex_begin(vb_floor, global.vertex_format);

_floor_size = 4096;
var _floor_color = c_white;

vertex_add_point(vb_floor, 0, 0, 0,		0, 0, 1,	0, 0,	_floor_color, 1);
vertex_add_point(vb_floor, _floor_size, 0, 0,		0, 0, 1,	0, 0,	_floor_color, 1);
vertex_add_point(vb_floor, _floor_size, _floor_size, 0,		0, 0, 1,	0, 0,	_floor_color, 1);

vertex_add_point(vb_floor, _floor_size, _floor_size, 0,		0, 0, 1,	0, 0,	_floor_color, 1);
vertex_add_point(vb_floor, 0, _floor_size, 0,		0, 0, 1,	0, 0,	_floor_color, 1);
vertex_add_point(vb_floor, 0, 0, 0,		0, 0, 1,	0, 0,	_floor_color, 1);

vertex_end(vb_floor);

///selector

selector_x = 0;
selector_y = 0;
selector_found = false;

vb_selector = vertex_create_buffer();
vertex_begin(vb_selector, global.vertex_format);

var _selector_size = 32;
var _selector_height = 1;

vertex_add_point(vb_selector, 0, 0, _selector_height,		0, 0, 1,	0, 0,	c_white, 1);
vertex_add_point(vb_selector, _selector_size, 0, _selector_height,		0, 0, 1,	0, 0,	c_white, 1);
vertex_add_point(vb_selector, _selector_size, _selector_size, _selector_height,		0, 0, 1,	0, 0,	c_white, 1);

vertex_add_point(vb_selector, _selector_size, _selector_size, _selector_height,		0, 0, 1,	0, 0,	c_white, 1);
vertex_add_point(vb_selector, 0, _selector_size, _selector_height,		0, 0, 1,	0, 0,	c_white, 1);
vertex_add_point(vb_selector, 0, 0, _selector_height,		0, 0, 1,	0, 0,	c_white, 1);

vertex_end(vb_selector);

inv = new Inventory(8,1);

pick_up_distance = 32;

base_mine_damage = 15;
mine_time = .5;
mine_timer = 0;

mining_block = false;
mining_block_id = 0;
block_strength = 0;
block_strength_start = 0;
mining_x = 0;
mining_y = 0;

mining_prog_w = 200;
mining_prog_h = 60;
mining_prog_x = display_get_gui_width()/2-mining_prog_w/2;
mining_prog_y = display_get_gui_height()/2-200;

//mining sphere
mine_ball_model = Get3DModel("mine_ball");
mine_ball_tex = sprite_get_texture(spr_mine_ball,0);
mine_ball_x = 0;
mine_ball_y = 0;
mine_ball_z = 0;
mine_ball_enabled = false;

///crafting
menu_open = false;
workstation_distance = 100;

can_craft_list = ds_list_create();
craft_on = -1;

crafting_queue = ds_list_create();
max_crafting_queue = 6;

craft_list_start = 0;
craft_list_show_amount = 6;

craft_x = 100;
craft_y = 100;
craft_h = 82;
craft_cell_size = 48;

craft_input_dist = 150;
craft_input_pad = 8;

up_down_size = 48;
craft_down_x = 100;
craft_down_y = 600;
craft_down_on = false;

craft_up_x = 250;
craft_up_y = 600;
craft_up_on = false;

crafting_x = 550;
crafting_y = 100;
crafting_h = 64;

crafting_time_pad = 100;

recipe_w = 300;
recipe_h = 560;

queue_w = 160;
queue_h = 400;

//item drop
item_drop_dist = 32;

//holding tool
holding_tool = false;
tool_model = noone;
tool_tex = noone;

tool_dist = 14;

move_tool = false;
tool_move_cur = 0;
tool_move_dir = 1;
tool_move_spd = 5;
tool_move_angle = 25;

tool_float_amount = 1;

//attacking 
base_attack_damage = 32;
attack_distance = 100;
base_attack_range = 18;
attack_time = 1;
attack_timer = 0;

function UpdateHand(){
	if(holding_tool){
		holding_tool = false;
		tool_model = noone;
		tool_tex = noone;
	}
	
	var _item = inv.GetItemSlot(inv.selected);
	if(_item!=-1){
		var _data = ds_map_find_value(global.item_data,_item.item_id);
	
		if(_data.tool){
			holding_tool = true;
			tool_model = Get3DModel(_data.model);
			tool_tex = _data.tex;
		}
	}
}

//interactable
instance_selected = noone;

//inv
inv_open = noone;

//survival 
max_hp = 100;
hp = max_hp;
max_hunger = 100;
hunger = max_hunger;

hp_w = 200;
hp_h = 30;
hp_x = display_get_gui_width()-50-hp_w;
hp_y = display_get_gui_height()-100;

hunger_w = 200;
hunger_h = 30;
hunger_x = display_get_gui_width()-50-hunger_w;
hunger_y = hp_y + 40;

dont_consume = false;

hunger_attack = 2;
hunger_mine = .2;
hunger_base_decline = .01;

hunger_heal_level = .8;
hunger_slow_level = .2;
hunger_mine_level = .4;

hunger_heal_rate = 1;
hunger_starve_rate = .4;

//wall repair
wall_selected = noone;
wood_repair_amount = 50;


//place blood collector 
var _t = global.world_size*global.chunk_size/2-2;
global.grid_world.SetCell(_t,_t,10)


title_fly_height = 200;
title_fly_dist = 300;

title_wait = 0;
title_fade_in = 1;
title_fade_spd = .2;

title_fade_out = 0;
title_fade_out_spd = .3;

title_zoom_cur = 1;
title_zoom_spd = .3;

starting_game = false;

function StartGame(){
	global.title_screen = false;	
	
	global.tip = global.player_tips[floor(random(array_length(global.player_tips)))]
	
	if(global.is_dead || global.won){
		global.grid_world.Destroy();
		global.physical_world.Destroy();
		
		global.grid_world = new GridWorld();
		global.mob_manager = new MobManager();
		global.physical_world = new PhysicalWorld();
		global.raid_manager = new RaidManager();
		
		global.title_screen = false;
		global.is_dead = false;
		global.time_survived = 0;
		global.won = false;
		room_restart();
	}else{
		global.title_screen = false;
	}
}


///fullscreen

full_screen_x = 30;
full_screen_y = display_get_gui_height()-50;

full_screen_s = 32;


//hit
hit_start = .2;
hit_fade_spd = .3;
hit_fade = 0;
last_hp = hp;

//info
show_info = false;
info_x = display_get_gui_width()-70;
info_y = 20;
info_s = 48;

camp_fire_dist = 64;
camp_fire_heal_rate = .5;