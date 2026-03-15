function Inventory(_w,_h) constructor{
	self.inv_width = _w;
	self.inv_height = _h;
	
	self.cell_size = 64;
	self.draw_w = self.cell_size*self.inv_width;
	self.draw_h = self.cell_size*self.inv_height;
	self.draw_x = display_get_gui_width()/2-self.draw_w/2;
	self.draw_y = display_get_gui_height()-self.draw_h-32;
	
	self.inv_arr = array_create(self.inv_width)
	
	self.selected = 0;
	
	static INIT = function(){
		for(var i = 0;i<self.inv_width;i++){
			self.inv_arr[i] = array_create(self.inv_height,-1)
		}
	}INIT();
	
	static GetItemSlot = function(_index){
		var _y = floor(_index/self.inv_width);
		var _x = _index%self.inv_width;
		return self.inv_arr[_x,_y];
	}
	
	static ClearItemSlot = function(_index){
		var _y = floor(_index/self.inv_width);
		var _x = _index%self.inv_width;
		self.inv_arr[_x,_y] = -1;
	}
	
	static SetItemSlot = function(_index, _data){
		var _y = floor(_index/self.inv_width);
		var _x = _index%self.inv_width;
		self.inv_arr[_x,_y] = _data;
	}
	
	static HasItem = function(_item_id,_amount){
		var _left = _amount;
		for(var i = 0;i<self.inv_width;i++){
			for(var c = 0;c<self.inv_height;c++){
				var _item = self.inv_arr[i,c];
				if(_item!=-1){
					if(_item.item_id==_item_id){
						_left -= _item.amount;
						if(_left<=0)
							return true;
					}
				}
			}
		}
		return false;
	}
	
	static RemoveItem = function(_item_id, _amount){
		var _left = _amount;
		for(var i = 0;i<self.inv_width;i++){
			for(var c = 0;c<self.inv_height;c++){
				var _item = self.inv_arr[i,c];
				if(_item!=-1){
					if(_item.item_id==_item_id){
						if(_item.amount>_left){
							_item.amount -= _left
							return true;
						}else{
							_left -= _item.amount;
							self.inv_arr[i,c] = -1;
						}
					}
				}
			}
		}
		return false;
	}
	
	static AddItem = function(_item_id, _amount){
		var _left = _amount;
		var _data = ds_map_find_value(global.item_data,_item_id);
		if(_data.can_stack){
			for(var i = 0;i<self.inv_width;i++){
				for(var c = 0;c<self.inv_height;c++){
					var _item = self.inv_arr[i,c];
					if(_item!=-1){
						if(_item.item_id==_item_id){
							var _amount_can_add = 100-_item.amount;
							if(_amount_can_add>=_left){
								_item.amount += _left;
								return 0;
							}else{
								_item.amount += _amount_can_add;
								_left -= _amount_can_add;
							}
							if(_left<=0)
								return 0;
						}
					}
				}
			}
		}
		if(_left!=0){
			for(var i = 0;i<self.inv_width;i++){
				for(var c = 0;c<self.inv_height;c++){
					var _item = self.inv_arr[i,c];
					if(_item==-1){
						self.inv_arr[i,c] = {item_id:_item_id, amount: _left};
						return 0;
					}
				}
			}
		}
		return _left;
	}
	
	static CanAddItem = function(_item_id, _amount){
		var _left = _amount;
		for(var i = 0;i<self.inv_width;i++){
			for(var c = 0;c<self.inv_height;c++){
				var _item = self.inv_arr[i,c];
				if(_item!=-1){
					if(_item.item_id==_item_id){
						var _amount_can_add = 100-_item.amount;
						if(_amount_can_add>=_left){
							return true;
						}else{
							_left -= _amount_can_add;
						}
						if(_left<=0)
							return true;
					}
				}
			}
		}
		if(_left!=0){
			for(var i = 0;i<self.inv_width;i++){
				for(var c = 0;c<self.inv_height;c++){
					var _item = self.inv_arr[i,c];
					if(_item==-1){
						return true;
					}
				}
			}
		}
		return false
	}
	
	static CenterAt = function(_x,_y){
		self.draw_x = _x-self.draw_w/2;
		self.draw_y = _y-self.draw_h/2;
	}
	
	static Draw = function(){
		
		var _sel_y = floor(self.selected/self.inv_width);
		var _sel_x = self.selected%self.inv_width;
		for(var i = 0;i<self.inv_width;i++){
			
			for(var c = 0;c<self.inv_height;c++){
				
				draw_set_color(c_white);
				draw_set_alpha(0.3);
				var _start_x = self.draw_x+i*self.cell_size;
				var _start_y = self.draw_y+c*self.cell_size;
				draw_rectangle(_start_x,_start_y,_start_x+self.cell_size,_start_y+self.cell_size,false);
				
				draw_set_alpha(1.0);
				
				var _item= self.inv_arr[i,c];
				if(_item!=-1){
					var _data = ds_map_find_value(global.item_data,_item.item_id);
					var _spr = _data.spr;
					var _w = sprite_get_width(_spr);
					var _scale = self.cell_size/_w;
					draw_sprite_ext(_spr,0,_start_x,_start_y,_scale,_scale,0,c_white,1);

					draw_text(_start_x+5,_start_y+2,string(_item.amount))
				}
				
				if(i==_sel_x&&c==_sel_y)
					draw_set_color(c_blue);
				draw_rectangle(_start_x,_start_y,_start_x+self.cell_size,_start_y+self.cell_size,true);
			}	
		}
	}
}