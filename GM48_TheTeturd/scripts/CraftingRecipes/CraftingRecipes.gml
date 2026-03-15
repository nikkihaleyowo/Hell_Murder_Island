global.crafting_recipes = ds_list_create();

ds_list_add(global.crafting_recipes,{//hatchet
	needs_workstation: false,
	needs_alchemist: false,
	items_needed: [{item_id:0, amount:15},{item_id:1, amount:10},{item_id:4, amount:10}],
	time: 7,
	item_id: 3,
	item_amount: 1,
})

ds_list_add(global.crafting_recipes,{//wood club
	needs_workstation: false,
	items_needed: [{item_id:0, amount:15}],
	time: 7,
	item_id: 17,
	item_amount: 1,
	needs_alchemist: false,
})

ds_list_add(global.crafting_recipes,{//workstation
	needs_workstation: false,
	items_needed: [{item_id:13, amount:10}],
	time: 10,
	item_id: 2,
	item_amount: 1,
	needs_alchemist: false,
})

ds_list_add(global.crafting_recipes,{//camp fire
	needs_workstation: false,
	items_needed: [{item_id:0, amount:15},{item_id:1, amount:5}],
	time: 10,
	item_id: 8,
	item_amount: 1,
	needs_alchemist: false,
})

ds_list_add(global.crafting_recipes,{//throwing stone
	needs_workstation: false,
	items_needed: [{item_id:1, amount:10}],
	time: 3,
	item_id: 12,
	item_amount: 5,
	needs_alchemist: false,
})



///work bench needed

ds_list_add(global.crafting_recipes,{//wood spear
	needs_workstation: true,
	items_needed: [{item_id:1, amount:10},{item_id:0, amount:30},{item_id:4, amount:10}],
	time: 10,
	item_id: 14,
	item_amount: 1,
	needs_alchemist: false,
})


ds_list_add(global.crafting_recipes,{//dart
	needs_workstation: true,
	items_needed: [{item_id:1, amount:5},{item_id:0, amount:5},{item_id:16, amount:2}],
	time: 5,
	item_id: 15,
	item_amount: 5,
	needs_alchemist: false,
})

ds_list_add(global.crafting_recipes,{//chess	
	needs_workstation: true,
	items_needed: [{item_id:0, amount:30}],
	time: 10,
	item_id: 5,
	item_amount: 1,
	needs_alchemist: false,
})

ds_list_add(global.crafting_recipes,{//alchemist table	
	needs_workstation: true,
	items_needed: [{item_id:0, amount:50},{item_id:1, amount:20},{item_id:13, amount:50}],
	time: 15,
	item_id: 18,
	item_amount: 1,
	needs_alchemist: false,
})

ds_list_add(global.crafting_recipes,{//alchemist table	
	needs_workstation: true,
	items_needed: [{item_id:0, amount:10}],
	time: 5,
	item_id: 9,
	item_amount: 1,
	needs_alchemist: false,
})

ds_list_add(global.crafting_recipes,{//alchemist table	
	needs_workstation: true,
	items_needed: [{item_id:0, amount:15}],
	time: 5,
	item_id: 10,
	item_amount: 1,
	needs_alchemist: false,
})

ds_list_add(global.crafting_recipes,{//alchemist table	
	needs_workstation: true,
	items_needed: [{item_id:0, amount:15}],
	time: 5,
	item_id: 11,
	item_amount: 1,
	needs_alchemist: false,
})

//alchemist
ds_list_add(global.crafting_recipes,{//health postion
	needs_workstation: false,
	items_needed: [{item_id:13, amount:15}],
	time: 5,
	item_id: 19,
	item_amount: 1,
	needs_alchemist: true,
})