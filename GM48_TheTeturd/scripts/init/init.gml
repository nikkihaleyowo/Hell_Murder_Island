randomise()
window_set_caption("Hell Murder Island")

audio_falloff_set_model(audio_falloff_linear_distance);

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_color();
global.vertex_format = vertex_format_end();

global.fly_enabled = false;

global.grav = 90;

global.model_map = ds_map_create();

global.model_cache = new ModelCache();

global.grid_world = new GridWorld();

global.max_stack = 100;

global.mob_despawn_dist = 3000;

global.mob_manager = new MobManager();

global.physical_world = new PhysicalWorld();

global.hell_mode = false;

global.raid_manager = new RaidManager();

global.title_screen = true;
global.is_dead = false;
global.death_reason = "idk man";

global.time_survived = 0;

global.won = false;

global.music_manager = new MusicManager();

global.progress_manager = new ProgressManager();

global.paused = false;

global.full_screen = false;

global.tip = "get good";