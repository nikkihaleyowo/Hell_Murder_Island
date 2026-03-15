// Inherit the parent event
event_inherited();

if(global.paused){
	exit;
}

mz-=global.grav*1.5*delta_time/1_000_000;

x+=mx*delta_time/1_000_000;
y+=my*delta_time/1_000_000;
z+=mz*delta_time/1_000_000;

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