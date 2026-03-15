// Inherit the parent event
event_inherited();

interact_text = "add soul shard";

portal_model = Get3DModel("portal.d3d");
portal_tex = sprite_get_texture(tex_portal,0);

amount_needed = 1250;

added_first = false;

Interact = function(){
	if(wall.strength>amount_needed){
		//won game 
		global.progress_manager.GiveKey("fill_soul")
		global.won = true;
	}else{
		var _item = Camera.inv.GetItemSlot(Camera.inv.selected);
		if(_item!=-1){
			if(_item.item_id==13){
				wall.strength += 5;
				if(wall.strength>wall.start_strength){
					wall.start_strength = wall.strength	
				}
				added_first = true;
				Camera.inv.RemoveItem(13,1)
			}
		}
		Camera.dont_consume = true;
	}
}

strength = 50;

wall = noone;
