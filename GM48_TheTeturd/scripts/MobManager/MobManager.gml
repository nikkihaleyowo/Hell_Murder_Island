function MobManager() constructor{
	self.max_mobs = 10;
	self.mob_spawn_max = 2;
	self.mob_spawn_min = 1;
	self.mob_spawn_time = random_range(self.mob_spawn_min,self.mob_spawn_max);
	
	self.mob_spawn_dist = 2200;
	self.mob_goto_dist = 300;
	
	static StepSpawn = function(){
		self.mob_spawn_time -= delta_time/1_000_000;
		if(self.mob_spawn_time<0){
			show_debug_message("spawned mob")
			self.mob_spawn_time = random_range(self.mob_spawn_min,self.mob_spawn_max);
			
			if(instance_number(obj_mob)<self.max_mobs){
				var _r = random(360);
				var _x = max(0,Camera.player.x+dcos(_r)*self.mob_spawn_dist);
				_x = min(global.world_size_px, _x);
				
				var _y = max(0,Camera.player.y-dsin(_r)*self.mob_spawn_dist);
				_y = min(global.world_size_px, _y);
				
				var _inst = noone;
				if(random(1)>.3){
					_inst = instance_create_depth(_x,_y,0,obj_mob);	
				}else{
					_inst = instance_create_depth(_x,_y,0,obj_chicken);	
				}
				
				_r = random(360);
				_x = max(0,Camera.player.x+dcos(_r)*self.mob_goto_dist);
				_x = min(global.world_size_px, _x);
				
				_y = max(0,Camera.player.y-dsin(_r)*self.mob_goto_dist);
				_y = min(global.world_size_px, _y);
				
				_inst.state = MOB_STATE.MOVE;
				_inst.goto_x = _x;
				_inst.goto_y = _y;
				
			}
		}
	}
}