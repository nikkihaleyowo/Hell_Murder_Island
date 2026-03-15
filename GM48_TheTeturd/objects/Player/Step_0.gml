if(global.title_screen)
	exit;


if(global.paused){
	exit;
}


var dx = 0;
var dy = 0;

if(!Camera.menu_open && Camera.inv_open==noone){

	look_dir -= (window_mouse_get_x() - window_get_width() /2) / SENSITIVITY;
	look_pitch -= (window_mouse_get_y() - window_get_height() /2) / SENSITIVITY;
	look_dir = (look_dir % 360 + 360) % 360;
	look_pitch = clamp(look_pitch, -85, 85);
	window_mouse_set(window_get_width() /2, window_get_height() /2);

	

	if(global.fly_enabled)
		z_vel = 0;

	if(keyboard_check(ord("A"))) {dx += dsin(look_dir); dy += dcos(look_dir)};
	if(keyboard_check(ord("D"))) {dx -= dsin(look_dir); dy -= dcos(look_dir)};
	if(keyboard_check(ord("W"))) {dx -= dcos(look_dir); dy += dsin(look_dir)};
	if(keyboard_check(ord("S"))) {dx += dcos(look_dir); dy -= dsin(look_dir)};

	running = keyboard_check(vk_shift);
}

var _is_grounded = false;
var _ground_z = 0;
if(z_vel == 0 && z <= _ground_z + 0.1){
	_is_grounded = true;
}

if(!global.fly_enabled){
	if(_is_grounded){
		if(keyboard_check_pressed(vk_space)){
			z_vel = jump_force;
		}
	}else{
		z_vel -= global.grav*2*delta_time/1_000_000;	
	}
}else{
	if(keyboard_check(vk_space)){
		z_vel = jump_force;
	}
	if(keyboard_check(vk_control)){
		z_vel = -jump_force;
	}
}

var _m = running ? run_spd : walk_spd;
var _move_spd = global.fly_enabled ? 1000 : _m;
if(Camera.hunger<Camera.hunger_slow_level*Camera.max_hunger)
	_move_spd = _move_spd*.65;

var x_move = dx*delta_time/1_000_000*_move_spd;
var y_move = dy*delta_time/1_000_000*_move_spd;
var z_move = z_vel*delta_time/1_000_000;
	
if(place_meeting(x+x_move,y,obj_wall)){
	while(!place_meeting(x+sign(x_move),y,obj_wall)){
		x+= sign(x_move);	
	}
	x_move = 0;
}
	
if(place_meeting(x,y+y_move,obj_wall)){
	while(!place_meeting(x,y+sign(y_move),obj_wall)){
		y+= sign(y_move);	
	}
	y_move = 0;
}

if(x_move!=0||y_move!=0){
	walk_sound_time-=delta_time/1_000_000;
	if(walk_sound_time<=0){
		walk_sound_time = random_range(walk_sound_min,walk_sound_max);
		if(!running)
			walk_sound_time*=1.5;
		var _p = random_range(.9,1.1);
		audio_play_sound_at(snd_player_walk,x,y,0,100,1000,1,false,2,1.5,0,_p);
	}	
}

x+= x_move;
y+= y_move;
z+= z_move;
	
x = clamp(x,0,global.world_size_px);
y = clamp(y,0,global.world_size_px);
	
if(z <= 0){
	z_vel = 0;
	z = 0;
}

