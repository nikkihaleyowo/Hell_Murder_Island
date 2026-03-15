global.block_data = ds_map_create();

ds_map_add(global.block_data,1,{
	model: "tree.d3d",
	atlas_index: 0,
	item_drop: 0,
	item_min: 4,
	item_max: 10,
	strength: 100,
	instance: noone,
})

ds_map_add(global.block_data,2,{
	model: "rock.d3d",
	atlas_index: 1,
	item_drop: 1,
	item_min: 4,
	item_max: 8,
	strength: 150,
	instance: noone,
})

ds_map_add(global.block_data,3,{
	model: "workstation.d3d",
	atlas_index: 2,
	item_drop: 2,
	item_min: 1,
	item_max: 1,
	strength: 50,
	instance: obj_workstation,
})

ds_map_add(global.block_data,4,{
	model: "bush.d3d",
	atlas_index: 3,
	item_drop: 4,
	item_min: 2,
	item_max: 4,
	strength: 20,
	instance: noone,
})

ds_map_add(global.block_data,5,{
	model: "chess.d3d",
	atlas_index: 4,
	item_drop: 5,
	item_min: 1,
	item_max: 1,
	strength: 50,
	instance: obj_chess,
})

ds_map_add(global.block_data,6,{
	model: "camp_fire.d3d",
	atlas_index: 5,
	item_drop: 8,
	item_min: 1,
	item_max: 1,
	strength: 50,
	instance: obj_camp_fire,
})

ds_map_add(global.block_data,7,{
	model: "wood_wall.d3d",
	atlas_index: 6,
	item_drop: 9,
	item_min: 1,
	item_max: 1,
	strength: 250,
	instance: obj_wall_tall,
})

ds_map_add(global.block_data,8,{
	model: "wood_barrier.d3d",
	atlas_index: 7,
	item_drop: 10,
	item_min: 1,
	item_max: 1,
	strength: 150,
	instance: obj_wall,
})

ds_map_add(global.block_data,9,{
	model: "wood_door_frame.d3d",
	atlas_index: 8,
	item_drop: 11,
	item_min: 1,
	item_max: 1,
	strength: 150,
	instance: obj_door,
})


ds_map_add(global.block_data,10,{
	model: "soul_collector.d3d",
	atlas_index: 9,
	item_drop: 1,
	item_min: 1,
	item_max: 1,
	strength: 250,
	instance: obj_soul_collector,
})

ds_map_add(global.block_data,11,{
	model: "alchemist_table.d3d",
	atlas_index: 10,
	item_drop: 18,
	item_min: 1,
	item_max: 1,
	strength: 150,
	instance: obj_alchemist_table,
})
