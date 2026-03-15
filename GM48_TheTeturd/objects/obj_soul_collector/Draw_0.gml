if(wall!=noone){
	if(added_first){
		var _s = wall.strength/amount_needed;
		matrix_set(matrix_world, matrix_build(x,y,24,0,0,0,_s,_s,_s));
		vertex_submit(portal_model,pr_trianglelist,portal_tex);
		matrix_set(matrix_world, matrix_build_identity());
	}
}