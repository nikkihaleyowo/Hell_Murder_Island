if(hp<=0){

	var _data = ds_map_find_value(global.item_data,drop);
	var _amount = round(random_range(drop_min,drop_max));

	var _inst = instance_create_depth(x,y,0,obj_item);
	_inst.item_id = drop;
	_inst.amount = _amount;
	_inst.sprite_index = _data.spr;
}