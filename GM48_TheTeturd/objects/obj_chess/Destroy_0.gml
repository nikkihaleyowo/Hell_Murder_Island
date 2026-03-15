for(var i = 0; i<inv.inv_width;i++){
	for(var c = 0;c<inv.inv_height;c++){
		var _item = inv.GetItemSlot(c*inv.inv_width+i);
		if(_item!=-1){
			var _data = ds_map_find_value(global.item_data, _item.item_id);
			var _r = random(360);
			var _inst = instance_create_depth(x+dcos(_r)*item_spread,y-dsin(_r)*item_spread,0,obj_item);
			_inst.item_id = _item.item_id;
			_inst.amount = _item.amount;
			_inst.sprite_index = _data.spr;
			_inst.drop_time = 1;
		}
	}
}

instance_destroy(wall);
var _i = instance_place(x,y,obj_wall);
if(_i!=noone){
	instance_destroy(_i);
}
