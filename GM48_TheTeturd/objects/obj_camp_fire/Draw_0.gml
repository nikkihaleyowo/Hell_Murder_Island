if(fire_fuel>0){
	var _scale = max(fire_fuel,.4);
	matrix_set(matrix_world, matrix_build(x,y,0,0,0,0,_scale,_scale,_scale));
	vertex_submit(fire_model,pr_trianglelist,fire_tex);
	matrix_set(matrix_world, matrix_build_identity());
}

if(has_food){
	var _tex = food_done ? food_cooked_tex : food_raw_tex;
	matrix_set(matrix_world, matrix_build(x,y,24,0,0,0,1,1,1));
	vertex_submit(food_model,pr_trianglelist,_tex);
	matrix_set(matrix_world, matrix_build_identity());
}

