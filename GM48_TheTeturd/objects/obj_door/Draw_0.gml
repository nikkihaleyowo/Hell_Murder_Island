if(!open){
	matrix_set(matrix_world, matrix_build(x,y,0,0,0,0,1,1,1));
	vertex_submit(door_model,pr_trianglelist,door_tex);
	matrix_set(matrix_world, matrix_build_identity());
}