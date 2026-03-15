// --- Basic Control & History ---
show_fps_graph = false; 

fps_history = ds_list_create();
max_history_length = 200;
sample_interval_ms = 100;
last_sample_time = get_timer();

// --- Graph Positioning & Size ---
graph_x = 10;
graph_y = 10;
graph_width_pixels = 200;
graph_height_pixels = 100;

// --- FPS Range for Graph ---
graph_max_fps = 1200;

// --- Graph Colors & Appearance ---
graph_bg_color = c_black;
graph_alpha = 0.6;
graph_color_normal = c_green;
graph_color_dip = c_yellow;
graph_color_critical = c_red;
graph_border_color = c_white;
graph_text_color = c_white;
graph_text_font = -1;

// --- Memory Usage Variables ---
mem_history = ds_list_create();
max_mem_history_length = 200;
mem_sample_interval_ms = 500;

last_mem_sample_time = get_timer();
mem_graph_height = 80;
mem_graph_y_offset = 120;
mem_line_color = c_aqua;
mem_bg_color = c_black;
mem_border_color = c_white;
mem_text_color = c_white;
max_mem_display_mb = 512;

// --- NEW ADDITIONS for Packets per Second (PPS) ---
global.packets = 0; // Initialize the global counter
pps_last_second = 0; // The value we will display
last_packet_count = 0; // To track the total at the last sample time
last_pps_time = get_timer(); // Timer to measure one second