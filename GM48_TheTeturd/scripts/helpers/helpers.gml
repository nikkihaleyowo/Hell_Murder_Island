function map_value(_value, _current_lower_bound, _current_upper_bound, _desired_lowered_bound, _desired_upper_bound) {
	return (((_value - _current_lower_bound) / (_current_upper_bound - _current_lower_bound)) * (_desired_upper_bound - _desired_lowered_bound)) + _desired_lowered_bound;
}


function get_deterministic_random_value(_world_seed, _x_coord, _y_coord, _min_val, _max_val) {

    var _derived_seed = _world_seed + _x_coord * 1619 + _y_coord * 31337;

    _derived_seed = floor(_derived_seed);

    var _original_seed = random_get_seed(); 
    
    random_set_seed(_derived_seed);
    
    var _result = irandom_range(_min_val, _max_val); // Or random_range for floats
    
    random_set_seed(_original_seed);
    
    return _result;
}


function GetZAxisCrossingPoint(_x, _y, _z, _lx, _ly, _lz) {
    if (_lz == 0) {
        if (_z == 0) {
            return { found: true, x: _x, y: _y, z: _z };
        } else {
            return { found: false };
        }
    }
        
    if (sign(_z) == sign(_lz)) {
        return { found: false };
    }
        
    var _t = -_z / _lz;
        
    var _x_cross = _x + _lx * _t;
    var _y_cross = _y + _ly * _t;
    var _z_cross = _z + _lz * _t;

    return { found: true, x: _x_cross, y: _y_cross, z: _z_cross };
}

function draw_sprite_billboard(sprite, subimage, xx, yy, zz) {
    shader_set(shd_billboard);
    matrix_set(matrix_world, matrix_build(xx, yy, zz, 0, 0, 0, 1, 1, 1));
    draw_sprite(sprite, subimage, 0, 0);
    matrix_set(matrix_world, matrix_build_identity());
    shader_reset();
}


function raycast_check_mob(_x1, _y1, _z1, _x2, _y2, _z2) {
    var _potential_hits = ds_list_create();
    
    var _num_hits = collision_line_list(_x1, _y1, _x2, _y2, obj_mob, false, true, _potential_hits, false);
    
    if (_num_hits == 0) {
        ds_list_destroy(_potential_hits);
        return noone;
    }

    var _closest_hit = noone;
    var _min_distance_sq = -1;
    var _hit_position = noone;
    var _surface_normal = noone;

    for (var i = 0; i < ds_list_size(_potential_hits); i++) {
        var _inst = _potential_hits[| i];
        
        var _inst_bbox_min_x = _inst.x-_inst.sprite_width/2;
        var _inst_bbox_min_y = _inst.y-_inst.sprite_height/2;
        var _inst_bbox_min_z = _inst.z;
        var _inst_bbox_max_x = _inst.x+_inst.sprite_width/2;
        var _inst_bbox_max_y = _inst.y+_inst.sprite_height/2;
        var _inst_bbox_max_z = _inst.z + _inst.z_height;
        
        var _dx = _x2 - _x1;
        var _dy = _y2 - _y1;
        var _dz = _z2 - _z1;
        
        var _t_min_x = (_inst_bbox_min_x - _x1) / _dx;
        var _t_max_x = (_inst_bbox_max_x - _x1) / _dx;
        if (_dx < 0) { var temp = _t_min_x; _t_min_x = _t_max_x; _t_max_x = temp; }
        
        var _t_min_y = (_inst_bbox_min_y - _y1) / _dy;
        var _t_max_y = (_inst_bbox_max_y - _y1) / _dy;
        if (_dy < 0) { var temp = _t_min_y; _t_min_y = _t_max_y; _t_max_y = temp; }

        var _t_min_z = (_inst_bbox_min_z - _z1) / _dz;
        var _t_max_z = (_inst_bbox_max_z - _z1) / _dz;
        if (_dz < 0) { var temp = _t_min_z; _t_min_z = _t_max_z; _t_max_z = temp; }
        
        var _t_enter = max(_t_min_x, _t_min_y, _t_min_z);
        var _t_exit = min(_t_max_x, _t_max_y, _t_max_z);
        
        if (_t_enter < _t_exit && _t_exit > 0) {
            var _hit_x = _x1 + _dx * _t_enter;
            var _hit_y = _y1 + _dy * _t_enter;
            var _hit_z = _z1 + _dz * _t_enter;
            
            var _distance_sq = power(_hit_x - _x1, 2) + power(_hit_y - _y1, 2) + power(_hit_z - _z1, 2);
            
            if (_closest_hit == noone || _distance_sq < _min_distance_sq) {
                _closest_hit = _inst;
                _min_distance_sq = _distance_sq;
                _hit_position = [_hit_x, _hit_y, _hit_z];
                
                var _normal_x = 0;
                var _normal_y = 0;
                var _normal_z = 0;
                
                if (abs(_t_enter - _t_min_x) < 0.001) _normal_x = sign(_dx);
                else if (abs(_t_enter - _t_max_x) < 0.001) _normal_x = sign(_dx);
                else if (abs(_t_enter - _t_min_y) < 0.001) _normal_y = sign(_dy);
                else if (abs(_t_enter - _t_max_y) < 0.001) _normal_y = sign(_dy);
                else if (abs(_t_enter - _t_min_z) < 0.001) _normal_z = sign(_dz);
                else if (abs(_t_enter - _t_max_z) < 0.001) _normal_z = sign(_dz);
                
                _surface_normal = [_normal_x, _normal_y, _normal_z];
            }
        }
    }
    
    ds_list_destroy(_potential_hits);
    
    if (_closest_hit != noone) {
        return {
            hit: _closest_hit,
            x: _hit_position[0],
            y: _hit_position[1],
            z: _hit_position[2],
            normal_x: -_surface_normal[0], 
            normal_y: -_surface_normal[1],
            normal_z: -_surface_normal[2]
        };
    } else {
        return noone;
    }
}

/// @function point_pitch_3d(x1, y1, z1, x2, y2, z2)
function point_pitch_3d(_x1, _y1, _z1, _x2, _y2, _z2) {
    var _dist_xy = point_distance(_x1, _y1, _x2, _y2);
    // darctan2 returns degrees. We use z2 - z1 to get the elevation angle
    return darctan2(_z2 - _z1, _dist_xy);
}