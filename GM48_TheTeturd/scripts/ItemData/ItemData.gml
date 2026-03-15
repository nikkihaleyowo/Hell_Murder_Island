global.item_data = ds_map_create();
ds_map_add(global.item_data,0,{
	name: "log",
	spr: spr_log,
	can_place: false,
	edible: false,
	can_stack: true,
	tool: false,
})

ds_map_add(global.item_data,1,{
	name: "rock",
	spr: spr_rock,
	can_place: false,
	edible: false,
	can_stack: true,
	tool: false,
})

ds_map_add(global.item_data,2,{
	name: "transmutation circle",
	spr: spr_workstation,
	can_place: true,
	can_stack: false,
	edible: false,
	tool: false,
	model: "workstation.d3d",
	atlas_index :2,
	block_id: 3,
})

ds_map_add(global.item_data,3,{
	name: "hatchet",
	spr: spr_hatchet,
	can_place: false,
	can_stack: false,
	edible: false,
	tool: true,
	mine_damage: 40,
	attack_damage: 20,
	attack_range:32,
	model: "hatchet.d3d",
	tex: sprite_get_texture(tex_hatchet,0),
})

ds_map_add(global.item_data,4,{
	name: "fiber",
	spr: spr_fiber,
	can_place: false,
	can_stack: true,
	tool: false,
	edible: false,
})

ds_map_add(global.item_data,5,{
	name: "chess",
	spr: spr_chess,
	can_place: true,
	can_stack: false,
	tool: false,
	edible: false,
	model: "chess.d3d",
	atlas_index :4,
	block_id: 5,
})

ds_map_add(global.item_data,6,{
	name: "raw pork",
	spr: spr_raw_pork,
	can_place: false,
	can_stack: true,
	tool: false,
	edible: true,
	hunger: 15,
	health: 0,
})

ds_map_add(global.item_data,7,{
	name: "cooked pork",
	spr: spr_cooked_pork,
	can_place: false,
	can_stack: true,
	tool: false,
	edible: true,
	hunger: 35,
	health: 0,
})

ds_map_add(global.item_data,8,{
	name: "camp fire",
	spr: spr_camp_fire,
	can_place: true,
	can_stack: false,
	tool: false,
	edible: false,
	model: "camp_fire.d3d",
	atlas_index :5,
	block_id: 6,
})

ds_map_add(global.item_data,9,{
	name: "wood wall",
	spr: spr_wood_wall,
	can_place: true,
	can_stack: true,
	tool: false,
	edible: false,
	model: "wood_wall.d3d",
	atlas_index :6,
	block_id: 7,
})


ds_map_add(global.item_data,10,{
	name: "wood barrier",
	spr: spr_wood_barrier,
	can_place: true,
	can_stack: true,
	tool: false,
	edible: false,
	model: "wood_barrier.d3d",
	atlas_index :7,
	block_id: 8,
})

ds_map_add(global.item_data,11,{
	name: "wood door",
	spr: spr_wood_door,
	can_place: true,
	can_stack: true,
	tool: false,
	edible: false,
	model: "wood_door_frame.d3d",
	atlas_index :8,
	block_id: 9,
})

ds_map_add(global.item_data,12,{
	name: "throwing stone",
	spr: spr_throwing_stone,
	can_place: false,
	edible: false,
	can_stack: true,
	tool: false,
})

ds_map_add(global.item_data,13,{
	name: "soul fragment",
	spr: spr_soul_fragment,
	can_place: false,
	edible: false,
	can_stack: true,
	tool: false,
})

ds_map_add(global.item_data,14,{
	name: "wood spear",
	spr: spr_wood_spear,
	can_place: false,
	can_stack: false,
	edible: false,
	tool: true,
	mine_damage: 10,
	attack_damage: 20,
	attack_range: 64,
	model: "wood_spear.d3d",
	tex: sprite_get_texture(tex_wood_spear,0),
})


ds_map_add(global.item_data,15,{
	name: "dart",
	spr: spr_dart,
	can_place: false,
	edible: false,
	can_stack: true,
	tool: false,
})

ds_map_add(global.item_data,16,{
	name: "feather",
	spr: spr_feather,
	can_place: false,
	edible: false,
	can_stack: true,
	tool: false,
})

ds_map_add(global.item_data,17,{
	name: "wood club",
	spr: spr_wood_club,
	can_place: false,
	can_stack: false,
	edible: false,
	tool: true,
	mine_damage: 15,
	attack_damage: 30,
	attack_range: 42,
	model: "wood_club.d3d",
	tex: sprite_get_texture(tex_wood_club,0),
})

ds_map_add(global.item_data,18,{
	name: "alchemist table",
	spr: spr_alchemist_table,
	can_place: true,
	can_stack: false,
	edible: false,
	tool: false,
	model: "alchemist_table.d3d",
	atlas_index :10,
	block_id: 11,
})

ds_map_add(global.item_data,19,{
	name: "health potion",
	spr: spr_health_potion,
	can_place: false,
	can_stack: true,
	tool: false,
	edible: true,
	hunger: 0,
	health: 35,
})
