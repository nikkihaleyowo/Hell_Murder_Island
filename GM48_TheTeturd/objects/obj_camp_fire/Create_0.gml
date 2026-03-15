// Inherit the parent event
event_inherited();

interact_text = "cook food";

fire_fuel_max = 2;
fire_fuel = 2;
fire_fuel_spd = .01;

cook_time = 25;
cook_timer = 0;

has_food = false;
food_done = false;

food_model = Get3DModel("meat.d3d");
food_raw_tex = sprite_get_texture(tex_raw_meat,0);
food_cooked_tex = sprite_get_texture(tex_cooked_meat,0);

fire_model = Get3DModel("fire.d3d");
fire_tex = sprite_get_texture(tex_fire,0);

Interact = function(){
	var _item = Camera.inv.GetItemSlot(Camera.inv.selected);
	if(_item!=-1){
		if(_item.item_id==0){
			if(fire_fuel <= 1.7){
				fire_fuel +=1;
				fire_fuel = min(fire_fuel, fire_fuel_max);
				Camera.inv.RemoveItem(_item.item_id,1);
			}
		}else if(_item.item_id == 6){
			if(has_food){
				if(food_done){
					if(Camera.inv.CanAddItem(7,1)){
						Camera.inv.AddItem(7,1);
						has_food = false;
						food_done = false;
					}
				}
			}else{
				has_food = true;
				food_done = false;
				cook_timer = cook_time;
				Camera.inv.RemoveItem(6,1);
			}
		}else{
			if(has_food){
				if(food_done){
					if(Camera.inv.CanAddItem(7,1)){
						Camera.inv.AddItem(7,1);
						has_food = false;
						food_done = false;
					}
				}
			}
		}
	}else{
		if(has_food){
			if(food_done){
				if(Camera.inv.CanAddItem(7,1)){
					Camera.inv.AddItem(7,1);
					has_food = false;
					food_done = false;
				}
			}
		}
	}
	Camera.dont_consume = true;
}

strength = 50;

wall = noone;
