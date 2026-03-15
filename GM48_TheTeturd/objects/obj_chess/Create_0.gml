// Inherit the parent event
event_inherited();

inv = new Inventory(6,2);
inv.CenterAt(display_get_gui_width()/2,100);
item_spread = 32;

Interact = function(){
	Camera.inv_open = inv;
	Camera.dont_consume = true;
}

strength = noone;

wall = noone;