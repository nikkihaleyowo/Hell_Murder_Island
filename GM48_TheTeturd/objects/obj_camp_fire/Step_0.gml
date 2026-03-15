if(global.paused){
	exit;
}

if(fire_fuel>0){
	fire_fuel-=fire_fuel_spd*delta_time/1_000_000;
}

if(has_food){
	if(!food_done){
		if(fire_fuel>0){
			cook_timer -= delta_time/1_000_000;
			if(cook_timer<=0){
				food_done = true;
			}
		}
	}
}	

if(wall==noone){
	wall = instance_create_depth(x,y,0,obj_wall);	
	wall.strength = strength;
}