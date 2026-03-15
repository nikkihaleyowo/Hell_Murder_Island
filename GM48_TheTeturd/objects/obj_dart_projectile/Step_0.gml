if(global.paused){
	exit;
}

// Inherit the parent event
event_inherited();

mz-=global.grav*1.5*delta_time/1_000_000;

var _last_x = x;
var _last_y = y;

x+=mx*delta_time/1_000_000;
y+=my*delta_time/1_000_000;
z+=mz*delta_time/1_000_000;

z_rot = point_direction(_last_x,_last_y,x,y)

var _inst = instance_place(x,y,obj_mob);
if(_inst!=noone){
	if(z < _inst.z_height){
		_inst.hp -= damage;
		_inst.attacked = true;
		instance_destroy();
	}
}

_inst = instance_place(x,y,obj_wall);
if(_inst!=noone){
	if(z < _inst.z_height){
		instance_destroy();
	}
}

if(z<=0)
	instance_destroy();