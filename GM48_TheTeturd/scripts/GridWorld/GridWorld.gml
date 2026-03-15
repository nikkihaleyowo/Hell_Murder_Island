global.world_size = 32;
global.chunk_size = 16;
global.cell_size = 32;

global.world_size_px = global.world_size*global.chunk_size*global.cell_size;

global.atlas_size = 4096;
global.atlas_frame_size = 256;
global.atals_row_size = global.atlas_size/global.atlas_frame_size;
global.atlas_frames = global.atals_row_size*self.atals_row_size;
global.atlas_tex = sprite_get_texture(tex_atlas,0);

global.seed = 9999;

function GridWorld() constructor{
	global.seed = irandom(9999);
	self.chunk_arr = array_create(global.world_size);
	
	self.load_distance = 8;
	self.unload_distance = 10;
	
	self.load_queue = ds_list_create();
	self.unload_queue = ds_list_create();
	
	static INIT = function(){
		for(var i = 0; i<global.world_size;i++){
			var _arr = array_create(global.world_size)
			for(var c = 0; c<global.world_size;c++){
				_arr[c] = new Chunk(i,c);
			}
			self.chunk_arr[i] = _arr;
		}
		
		GenRand();
	}INIT();
	
	static SetCell = function(_x,_y, _block_id){
		var _chunk_x = floor(_x/global.chunk_size);
		var _chunk_y = floor(_y/global.chunk_size);
		
		var _local_x = _x%global.chunk_size;
		var _local_y = _y%global.chunk_size;
		
		if(_chunk_x>=global.world_size || _chunk_x<0
			|| _chunk_y>=global.world_size || _chunk_y<0){
			
			return false;
		}
		
		var _chunk = self.chunk_arr[_chunk_x,_chunk_y];
		_chunk.SetCell(_local_x,_local_y,_block_id);
		
	}
	
	static GetCell = function(_x,_y){
		var _chunk_x = floor(_x/global.chunk_size);
		var _chunk_y = floor(_y/global.chunk_size);
		
		var _local_x = _x%global.chunk_size;
		var _local_y = _y%global.chunk_size;
		
		if(_chunk_x>=global.world_size || _chunk_x<0
			|| _chunk_y>=global.world_size || _chunk_y<0){
			
			return -1;
		}
		
		var _chunk = self.chunk_arr[_chunk_x,_chunk_y];
		return _chunk.GetCell(_local_x,_local_y);
	}
	
	static GetEntity = function(_x,_y){
		var _chunk_x = floor(_x/global.chunk_size);
		var _chunk_y = floor(_y/global.chunk_size);
		
		var _local_x = _x%global.chunk_size;
		var _local_y = _y%global.chunk_size;
		
		if(_chunk_x>=global.world_size || _chunk_x<0
			|| _chunk_y>=global.world_size || _chunk_y<0){
			
			return -1;
		}
		
		var _chunk = self.chunk_arr[_chunk_x,_chunk_y];
		return _chunk.GetEntity(_local_x,_local_y);
	}
	
	static GenRand = function(){
		for(var i = 0; i<global.world_size; i++){
			for(var c = 0; c<global.world_size; c++){
				var _chunk = self.chunk_arr[i,c];
				_chunk.GenRand();
			}
		}
	}
	
	static StepLoad = function(_x, _y){
		var _chunk_x = floor(_x/(global.chunk_size*global.cell_size));
		var _chunk_y = floor(_y/(global.chunk_size*global.cell_size));
		
		var _start_x = max(0,_chunk_x-self.load_distance);
		var _start_y = max(0,_chunk_y-self.load_distance);
		
		var _end_x = min(global.world_size-1, _chunk_x+self.load_distance);
		var _end_y = min(global.world_size-1, _chunk_y+self.load_distance);
		
		for(var i = _start_x; i<= _end_x;i++){
			for(var c = _start_y; c<=_end_y;c++){
				var _chunk = self.chunk_arr[i,c];
				if(_chunk.chunk_vb==noone && !_chunk.in_load_queue){
					ds_list_add(self.load_queue,_chunk);
					_chunk.in_load_queue = true;
				}
			}
		}
		
		var _unload_start_x = max(0,_chunk_x-self.unload_distance);
		var _unload_start_y = max(0,_chunk_y-self.unload_distance);
		
		var _unload_end_x = min(global.world_size-1, _chunk_x+self.unload_distance);
		var _unload_end_y = min(global.world_size-1, _chunk_y+self.unload_distance);
		
		for(var i = _unload_start_x; i<= _unload_end_x;i++){
			for(var c = _unload_start_y; c<=_unload_end_y;c++){
				if(!point_in_rectangle(i,c,_start_x,_start_y,_end_x,_end_y)){
					var _chunk = self.chunk_arr[i,c];
					if(_chunk.chunk_vb!=noone && !_chunk.in_unload_queue){
						ds_list_add(self.unload_queue,_chunk);
						_chunk.in_unload_queue = true;
					}
				}
			}
		}
		ProcessQueue();
	}
	
	static ProcessQueue = function(_load = 1, _destroy=1){
		if(ds_list_size(self.load_queue)>0){
			for(var i = 0; i<_load;i++){
				var _chunk = ds_list_find_value(self.load_queue,0);
				ds_list_delete(self.load_queue,0);
				_chunk.in_load_queue = false;
				_chunk.CreateVB();
			}
		}
		
		if(ds_list_size(self.unload_queue)>0){
			for(var i = 0; i<_destroy;i++){
				var _chunk = ds_list_find_value(self.unload_queue,0);
				ds_list_delete(self.unload_queue,0);
				_chunk.in_unload_queue = false;
				_chunk.DestroyVB();
			}
		}
	}
	
	static Render = function(_x,_y){
		var _chunk_x = floor(_x/(global.chunk_size*global.cell_size));
		var _chunk_y = floor(_y/(global.chunk_size*global.cell_size));
		
		var _start_x = max(0,_chunk_x-self.load_distance);
		var _start_y = max(0,_chunk_y-self.load_distance);
		
		var _end_x = min(global.world_size-1, _chunk_x+self.load_distance);
		var _end_y = min(global.world_size-1, _chunk_y+self.load_distance);
		
		for(var i = _start_x; i<= _end_x;i++){
			for(var c = _start_y; c<=_end_y;c++){
				var _chunk = self.chunk_arr[i,c];
				_chunk.Render();
			}
		}
	}
	
	static Destroy = function(){
		ds_list_destroy(self.unload_queue);
		ds_list_destroy(self.load_queue);
		
		for(var i = 0; i<global.world_size; i++){
			for(var c = 0; c<global.world_size; c++){
				var _chunk = self.chunk_arr[i,c];
				_chunk.DestroyVB();
			}
		}
	}
}

function Chunk(_chunk_x, _chunk_y) constructor{
	self.chunk_x = _chunk_x;
	self.chunk_y = _chunk_y;
	self.world_x = _chunk_x*global.chunk_size*global.cell_size;
	self.world_y = _chunk_y*global.chunk_size*global.cell_size;
	
	self.chunk_arr = array_create(global.chunk_size);
	self.chunk_entity_arr = array_create(global.chunk_size);
	self.chunk_vb = noone;
	
	self.in_load_queue = false;
	self.in_unload_queue = false;
	
	static INIT = function(){
		for(var i = 0;i<global.chunk_size;i++){
			self.chunk_arr[i] = array_create(global.chunk_size,0);	
		}
		for(var i = 0;i<global.chunk_size;i++){
			self.chunk_entity_arr[i] = array_create(global.chunk_size,noone);	
		}
	}
	INIT();
	
	static GetCell = function(_x,_y){
		return self.chunk_arr[_x,_y];	
	}
	
	static GetEntity = function(_x,_y){
		return self.chunk_entity_arr[_x,_y];	
	}
	
	static SetCell = function(_x, _y, _block_id){
		self.chunk_arr[_x,_y] = _block_id;
		if(_block_id!=0){
			var _data = ds_map_find_value(global.block_data,_block_id);
			if(_data.instance!=noone){
				var _inst = instance_create_depth((self.chunk_x*global.chunk_size+_x)*global.cell_size+global.cell_size/2,(self.chunk_y*global.chunk_size+_y)*global.cell_size+global.cell_size/2,0,_data.instance);
				_inst.strength = _data.strength;
				self.chunk_entity_arr[_x,_y]=_inst;
			}
		}else{
			if(self.chunk_entity_arr[_x,_y]!=noone){
				instance_destroy(self.chunk_entity_arr[_x,_y]);
				self.chunk_entity_arr[_x,_y] = noone;
			}
		}
		CreateVB();
	}
	
	static GenRand = function(){
		for(var i = 0; i<global.chunk_size;i++){
			for(var c = 0; c<global.chunk_size;c++){
				var _r = get_deterministic_random_value(global.seed, self.chunk_x*global.chunk_size+i, self.chunk_y*global.chunk_size+c,0,1000)/1000;
				if(_r<0.003){
					self.chunk_arr[i,c] = 2;	
				}else if(_r<0.01){
					self.chunk_arr[i,c] = 1;
				}else if(_r<0.03){
					self.chunk_arr[i,c] = 4;
				}
			}
		}
	}
	
	static CreateVB = function(){
		if(self.chunk_vb!=noone){
			vertex_delete_buffer(self.chunk_vb)	
		}
		var _temp_vb = vertex_create_buffer();
		vertex_begin(_temp_vb,global.vertex_format);
		
		var _model_count = 0;
		
		for(var i = 0; i<global.chunk_size;i++){
			for(var c = 0; c<global.chunk_size;c++){
				var _block_id = self.chunk_arr[i,c];
				if(_block_id != 0){
					var _data = ds_map_find_value(global.block_data,_block_id);
					var _col = _data.atlas_index % global.atals_row_size;
                    var _row = floor(_data.atlas_index / global.atals_row_size);
                    var _u = _col * global.atlas_frame_size / global.atlas_size;
                    var _v = _row * global.atlas_frame_size / global.atlas_size;
                    var _uv_size = global.atlas_frame_size / global.atlas_size;
                    
                    var _x = self.world_x + i * global.cell_size + global.cell_size / 2;
                    var _y = self.world_y + c * global.cell_size + global.cell_size / 2;
                    
                    global.model_cache.AddModelUVOffset(_data.model, _temp_vb, _x, _y, 0, 0, 1, _u, _v, _uv_size, _uv_size);
                    _model_count++;
				}
			}
		}
		
		if (_model_count > 0) {
            vertex_end(_temp_vb);
            vertex_freeze(_temp_vb);
            self.chunk_vb = _temp_vb;
        } else {
            vertex_delete_buffer(_temp_vb);
            self.chunk_vb = noone;
        }
	}
	
	static DestroyVB = function(){
		if(self.chunk_vb!=noone)
		vertex_delete_buffer(self.chunk_vb);
		self.chunk_vb = noone;
	}
	
	static Render = function(){
		if(self.chunk_vb!=noone)
			vertex_submit(self.chunk_vb,pr_trianglelist,global.atlas_tex);
	}
}	
	