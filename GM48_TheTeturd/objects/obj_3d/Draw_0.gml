if(model==-1){
	model = Get3DModel(model_name+".d3d");
	var _spr = asset_get_index("tex_"+model_name);
	tex = sprite_get_texture(_spr,0);
}

matrix_set(matrix_world, m);
vertex_submit(model,pr_trianglelist,tex);
matrix_set(matrix_world, matrix_build_identity());