// Inherit the parent event
event_inherited();

interact_text = "use door"

open = false;

door_model = Get3DModel("wood_door.d3d")
door_tex = sprite_get_texture(tex_wood_door,0);

Interact = function(){
	if(open&&place_meeting(x,y,Camera.player))
		return noone;
		
	open = !open
	if(open){
		instance_destroy(wall)
		wall = noone;	
	}else{
		wall = instance_create_depth(x,y,0,obj_wall);
		wall.z_height = 64;
	}
}

strength = 50;

wall = instance_create_depth(x,y,0,obj_wall);
wall.z_height = 64;