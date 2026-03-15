gpu_set_fog(true,c_black,1000,2000)

var camera = camera_get_active();

var xto = player.x;
var yto = player.y;
var zto = player.z+player.player_height;
var xfrom = xto + camera_distance * dcos(player.look_dir) * dcos(player.look_pitch);
var yfrom = yto - camera_distance * dsin(player.look_dir) * dcos(player.look_pitch);
var zfrom = zto - camera_distance * dsin(player.look_pitch);

var view_mat = matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1);
var proj_mat = matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 2, 32_000);

if(global.title_screen){
	xfrom = player.x + dcos(current_time/1000)*title_fly_dist*title_zoom_cur;
	yfrom = player.y - dsin(current_time/1000)*title_fly_dist*title_zoom_cur;
	zfrom = title_fly_height*title_zoom_cur;
	xto = player.x;
	yto = player.y;
	zto = 0;
	
	view_mat = matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1);
}

camera_set_view_mat(camera, view_mat);
camera_set_proj_mat(camera, proj_mat);
camera_apply(camera);

//floor 
matrix_set(matrix_world, matrix_build(player.x-_floor_size/2,player.y-_floor_size/2, 0, 0, 0, 0,1,1,1));
vertex_submit(vb_floor, pr_trianglelist, sprite_get_texture(tex_floor, 0))
matrix_set(matrix_world, matrix_build_identity());

if(mine_ball_enabled){
	matrix_set(matrix_world, matrix_build(mine_ball_x,mine_ball_y, mine_ball_z, 0, 0, 0,1,1,1));
	vertex_submit(mine_ball_model, pr_trianglelist, mine_ball_tex)
	matrix_set(matrix_world, matrix_build_identity());
}

if(global.grid_world!=noone){
	global.grid_world.Render(player.x,player.y);
}

with(obj_3d){
	event_perform(ev_draw,0);	
}

with(obj_camp_fire){
	event_perform(ev_draw,0);
}	

with(obj_door){
	event_perform(ev_draw,0);
}	

with(obj_soul_collector){
	event_perform(ev_draw,0);
}	


if(selector_found){
	matrix_set(matrix_world, matrix_build(selector_x*global.cell_size, selector_y*global.cell_size, 0, 0, 0, 0,1,1,1));
	vertex_submit(vb_selector, pr_trianglelist, sprite_get_texture(tex_selector, 0))
	matrix_set(matrix_world, matrix_build_identity());
}

//tool
if(holding_tool){
	if(move_tool){
		tool_move_cur += tool_move_dir*tool_move_spd*delta_time/1_000_000;
		
		if(tool_move_dir==1){
			if(tool_move_cur>=1){
				tool_move_cur = 1;	
				tool_move_dir = -1;
			}
		}else{
			if(tool_move_cur<=0){
				tool_move_cur = 0;	
				move_tool = false;
			}
		}
	}	
	
	matrix_set(matrix_world, matrix_build(player.x+dcos(player.look_dir+180-30)*tool_dist, player.y-dsin(player.look_dir+180-30)*tool_dist, player.z+24+tool_float_amount*cos(current_time/500), 0, -player.look_pitch+ tool_move_cur*tool_move_angle, player.look_dir,1,1,1));
	vertex_submit(tool_model, pr_trianglelist, tool_tex)
	matrix_set(matrix_world, matrix_build_identity());
}

with(obj_billboard){
	Render();	
}

gpu_set_fog(false,c_black,1000,2000)