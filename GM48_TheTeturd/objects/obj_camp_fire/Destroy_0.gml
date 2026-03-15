
instance_destroy(wall);

var _i = instance_place(x,y,obj_wall);
if(_i!=noone){
	instance_destroy(_i);
}