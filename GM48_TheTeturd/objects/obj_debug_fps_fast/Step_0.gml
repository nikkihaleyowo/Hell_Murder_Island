// --- Toggle visibility of the debug graph with F2 key ---
if (keyboard_check_pressed(vk_f2)) {
    show_fps_graph = !show_fps_graph;
}

// If the graph is not set to be shown, exit the event early
if (!show_fps_graph) exit;

var tm = get_timer(); // Use a single variable for consistent timing

// --- FPS Data Sampling ---
if (tm - last_sample_time >= sample_interval_ms * 1000) {
    ds_list_add(fps_history, fps_real);
    if (ds_list_size(fps_history) > max_history_length) {
        ds_list_delete(fps_history, 0);
    }
    last_sample_time = tm;
}

// --- Memory Data Sampling ---
if (tm - last_mem_sample_time >= mem_sample_interval_ms * 1000) {
    var system_info = os_get_info();
    var sampled_memory_bytes = 0;
    if (system_info != noone && ds_map_exists(system_info, "mem_usage")) {
        sampled_memory_bytes = system_info[?"mem_usage"];
        ds_map_destroy(system_info);
    } else {
        if (system_info != noone) {
            ds_map_destroy(system_info);
        }
    }
    ds_list_add(mem_history, sampled_memory_bytes);
    if (ds_list_size(mem_history) > max_mem_history_length) {
        ds_list_delete(mem_history, 0);
    }
    last_mem_sample_time = tm;
}

// --- NEW ADDITION for Packets per Second (PPS) ---
// This calculates the PPS once every second.
if (tm - last_pps_time >= 1000 * 1000) { // Check for 1,000,000 microseconds (1 second)
    pps_last_second = global.packets - last_packet_count;
    last_packet_count = global.packets;
    last_pps_time = tm;
}