function ProgressManager() constructor{
	self.keys = [
	{key_id:"get_wood", has_key: false, title:"Get Wood:", text:"punch trees"},
	{key_id:"craft_hatchet", has_key: false, title:"Craft Tools:", text:"make a hatchet"},
	{key_id:"craft_stone", has_key: false, title:"Ranged Damage:", text:"make a throwing stones"},
	{key_id:"craft_workstation", has_key: false, title:"Better Stuff:", text:"make a transmutation circle"},
	{key_id:"cook_food", has_key: false, title:"Hunger:", text:"make a camp fire to cook food"},
	{key_id:"fill_soul", has_key: false, title:"Beat Game:", text:"fill soul collector"},
	]
	
	static GiveKey = function(_key){
		for(var i = 0;i<array_length(self.keys);i++){
			var _lock = self.keys[i].key_id;
			if(_key==_lock){
				self.keys[i].has_key = true;
			}
		}
	}
	
	static Draw = function(){
		draw_set_color(c_white)	
		draw_set_font(fnt_respawn);
		for(var i = 0;i<array_length(self.keys);i++){
			var _key = self.keys[i];	
			if(!_key.has_key){
				draw_text(20,display_get_gui_height()-100,_key.title);
				draw_set_font(fnt_game);
				draw_text(20,display_get_gui_height()-60,_key.text);
				break;
			}
		}
	}
}