function Get3DModel(file_name){
	var file_name_with_ext = file_name;
	if(!string_ends_with(file_name, ".d3d")){
		file_name_with_ext += ".d3d";
	}
	
	if(ds_map_exists(global.model_map, file_name_with_ext)){
		show_debug_message("Model found in cache: "+file_name_with_ext);
		return global.model_map[? file_name_with_ext];
	}
	
	if(!file_exists(file_name_with_ext)){
		show_debug_message("Model not found");
		return -1;
	}
	
	var _vb = load_model(file_name_with_ext);
	ds_map_add(global.model_map,file_name_with_ext, _vb);
	
	return _vb;
}


function load_model(_file) {

	var model = vertex_create_buffer();
	
	vertex_begin(model, global.vertex_format);

	var file = file_text_open_read(_file);

	var version = file_text_read_real(file);

	var n = file_text_read_real(file);
	file_text_readln(file);

	var line = array_create(10, 0);

	for (var i = 0; i < n; i++){
		for (var j = 0; j < 11; j++){
			line[j] = file_text_read_real(file);
		}
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
				vertex_add_point(model, xx, yy, zz, nx, ny, nz, xtex, ytex, color, alpha);
				break;
		}
	}

	file_text_close(file);
	vertex_end(model);
	vertex_freeze(model);

	return model;


}


function load_model_to_VB(filename,vertex_buffer,_x,_y,_z,_z_rot = 0, _scale = 1) {

	var file = file_text_open_read(filename);

	var version = file_text_read_real(file);

	var n = file_text_read_real(file);
	file_text_readln(file);

	var line = array_create(10, 0);

	for (var i = 0; i < n; i++){
		for (var j = 0; j < 11; j++){
			line[j] = file_text_read_real(file);
		}
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

	file_text_close(file);
}
