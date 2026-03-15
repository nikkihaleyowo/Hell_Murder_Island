function vertex_add_point(_vb, _x, _y, _z, _nx, _ny, _nz, _utex, _vtex, _color, _alpha){
	vertex_position_3d(_vb, _x, _y, _z);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_texcoord(_vb, _utex, _vtex);
	vertex_color(_vb, _color, _alpha)
}