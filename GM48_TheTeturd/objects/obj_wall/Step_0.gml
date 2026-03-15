if(start_strength==noone){
	start_strength = strength+20;	
}

if(strength<0){
	var _x = floor(x/global.cell_size);
	var _y = floor(y/global.cell_size);
	global.grid_world.SetCell(_x,_y,0);
}	