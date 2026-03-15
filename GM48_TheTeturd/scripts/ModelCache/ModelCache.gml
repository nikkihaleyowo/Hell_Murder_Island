function ModelCache() constructor{
	self.models_loaded = ds_map_create();
	
	static GetModelArray = function(filename){
		var file = file_text_open_read(filename);

		var version = file_text_read_real(file);

		var n = file_text_read_real(file);
		file_text_readln(file);
		
		var _model_arr = [];
		for (var i = 0; i < n; i++){
			var line = array_create(10, 0);
			for (var j = 0; j < 11; j++){
				line[j] = file_text_read_real(file);
			}
			array_push(_model_arr,line);
		}
		file_text_close(file);
		return _model_arr;
	}
	
	static AddVertexBuffer = function(model_arr,vertex_buffer,_x,_y,_z,_z_rot = 0, _scale = 1){
		for(var i = 0; i<array_length(model_arr);i++){
			var line = model_arr[i];
			var type = line[0];
			switch (type){
				case 9:	
					var xx = line[1];
				    var yy = line[2];
				    var zz = line[3];
				    var nx = line[4];
				    var ny = line[5];
				    var nz = line[6];
				    var xtex = line[7]; 
				    var ytex = line[8]; 
				    var color = line[9];
				    var alpha = line[10];

				    var rotation_angle_z = _z_rot 

				    var rotated_xx = xx * dcos(rotation_angle_z) - yy * -dsin(rotation_angle_z);
				    var rotated_yy = xx * -dsin(rotation_angle_z) + yy * dcos(rotation_angle_z);

				    var rotated_nx = nx * dcos(rotation_angle_z) - ny * -dsin(rotation_angle_z);
				    var rotated_ny = nx * -dsin(rotation_angle_z) + ny * dcos(rotation_angle_z);
				    var rotated_nz = nz;

				    vertex_add_point(vertex_buffer, _x + rotated_xx *_scale, _y + rotated_yy *_scale, _z + zz*_scale, rotated_nx, rotated_ny, rotated_nz, xtex, ytex, color, alpha);
				    break;
			}
		}
	}
	
	static AddVertexBufferUVOffset = function(model_arr,_vbuffer,_x,_y,_z,_z_rot, _scale, _uv_x_offset, _uv_y_offset, _uv_width_scale, _uv_height_scale){
		for(var i = 0; i<array_length(model_arr);i++){
			var line = model_arr[i];
			var type = line[0];
			switch (type){
				case 9:
					var xx = line[1]; var yy = line[2]; var zz = line[3]; var nx = line[4]; var ny = line[5]; var nz = line[6]; var xtex = line[7]; var ytex = line[8]; var color = line[9]; var alpha = line[10];
					var new_xtex = _uv_x_offset + (xtex * _uv_width_scale);
					var new_ytex = _uv_y_offset + (ytex * _uv_height_scale);
					var rotation_angle_z = _z_rot;
					var rotated_xx = xx * dcos(rotation_angle_z) - yy * -dsin(rotation_angle_z);
					var rotated_yy = xx * -dsin(rotation_angle_z) + yy * dcos(rotation_angle_z);
					var rotated_nx = nx * dcos(rotation_angle_z) - ny * -dsin(rotation_angle_z);
					var rotated_ny = nx * -dsin(rotation_angle_z) + ny * dcos(rotation_angle_z);
					var rotated_nz = nz;
					vertex_add_point(_vbuffer, _x + rotated_xx*_scale, _y + rotated_yy*_scale, _z + zz*_scale, rotated_nx, rotated_ny, rotated_nz, new_xtex, new_ytex, color, alpha);
					break;
			}
		}
	}
	
	static AddModel = function(filename,vertex_buffer,_x,_y,_z,_z_rot = 0, _scale = 1){
		var _model_arr = ds_map_find_value(self.models_loaded, filename);
		if(is_undefined(_model_arr)){
			_model_arr = GetModelArray(filename);
			ds_map_add(self.models_loaded,filename,_model_arr);
		}
		AddVertexBuffer(_model_arr,vertex_buffer,_x,_y,_z,_z_rot, _scale)
	}
	
	static AddModelUVOffset = function(_filename, _vbuffer, _x, _y, _z, _z_rot, _scale, _uv_x_offset, _uv_y_offset, _uv_width_scale, _uv_height_scale){
		var _model_arr = ds_map_find_value(self.models_loaded, _filename);
		if(is_undefined(_model_arr)){
			_model_arr = GetModelArray(_filename);
			ds_map_add(self.models_loaded,_filename,_model_arr);
		}
		AddVertexBufferUVOffset(_model_arr,_vbuffer,_x,_y,_z,_z_rot, _scale, _uv_x_offset, _uv_y_offset, _uv_width_scale, _uv_height_scale)
	}
	
	static Clean = function(){
		ds_map_destroy(self.models_loaded);
		self.models_loaded = ds_map_create();
	}
}