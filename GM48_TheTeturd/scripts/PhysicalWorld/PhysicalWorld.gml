function PhysicalWorld() constructor{
	self.grid = mp_grid_create(0,0,global.world_size*global.chunk_size,global.world_size*global.chunk_size,32,32);
	self.path = path_add();
	
	static AddWall = function(_x,_y){
		mp_grid_add_cell(self.grid, _x, _y);
	}

	static RemoveWall = function(_x, _y){
		mp_grid_clear_cell(self.grid, _x, _y);
	}
	
	static CanPath = function(_x,_y){
		return mp_grid_path(self.grid, self.path, _x, _y,Camera.player.x,Camera.player.y,true);
	}
	
	static Destroy = function(){
		mp_grid_destroy(self.grid);
		path_delete(self.path);
	}
}