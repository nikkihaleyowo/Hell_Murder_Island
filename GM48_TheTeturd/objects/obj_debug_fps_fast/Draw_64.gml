// 1. EXIT EARLY - If the graph isn't needed, don't run a single line of logic
if (!show_fps_graph) exit;

// 2. PRE-CALCULATE CONSTANTS (Do this once, not inside a loop)
var _base_y = graph_y + 20;
var _graph_bottom = _base_y + graph_height_pixels;
var _fps_scale = graph_height_pixels / graph_max_fps;
var _fps_count = ds_list_size(fps_history);
var current_fps = fps_real;

// 3. DETERMINE COLOR STATE (Calculate once for the whole frame)
var fps_color = graph_color_normal;
if (current_fps < graph_max_fps * 0.5) {
    fps_color = graph_color_critical;
} else if (current_fps < graph_max_fps * 0.8) {
    fps_color = graph_color_dip;
}

// 4. DRAW TEXT ELEMENTS
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(fps_color);
draw_text(graph_x, graph_y, "FPS: " + string(floor(current_fps)));

draw_set_color(graph_text_color);
draw_text(graph_x + 100, graph_y, "PPS: " + string(pps_last_second));

// 5. DRAW GRAPH BACKGROUND (Alpha handling)
draw_set_alpha(graph_alpha);
draw_set_color(graph_bg_color);
draw_rectangle(graph_x, _base_y, graph_x + graph_width_pixels, _graph_bottom, false);
draw_set_alpha(1.0);

// 6. DRAW GRAPH LINES (The High-Performance Part)
// Using pr_linestrip sends all points to the GPU in one single batch
if (_fps_count > 1) {
    draw_set_color(fps_color); 
    draw_primitive_begin(pr_linestrip);
    
    for (var i = 0; i < _fps_count; i++) {
        // [| i] is the "accessor" shorthand for ds_list_find_value, which is faster
        var _val = fps_history[| i];
        
        // Calculate Y: Bottom of graph minus (value * scale)
        var _draw_y = clamp(_graph_bottom - (_val * _fps_scale), _base_y, _graph_bottom);
        
        // Add point to the GPU batch
        draw_vertex(graph_x + i, _draw_y);
    }
    
    draw_primitive_end(); // Push the whole line to the GPU at once
}

// 7. DRAW BORDERS & REFERENCE LINES
draw_set_color(graph_border_color);
draw_rectangle(graph_x, _base_y, graph_x + graph_width_pixels, _graph_bottom, true);

// Mid-point Reference (e.g., 30 FPS or 72 FPS)
draw_set_color(c_white);
var _mid_fps = graph_max_fps * 0.5;
var _y_mid = _graph_bottom - (_mid_fps * _fps_scale);

draw_line(graph_x, _y_mid, graph_x + graph_width_pixels, _y_mid);
draw_text(graph_x + graph_width_pixels + 5, _y_mid - 5, string(round(_mid_fps)) + " FPS");

// Top-point Reference (Optional, only if high refresh)
if (graph_max_fps > 60) {
    var _top_ref_fps = graph_max_fps * 0.8;
    var _y_top = _graph_bottom - (_top_ref_fps * _fps_scale);
    draw_line(graph_x, _y_top, graph_x + graph_width_pixels, _y_top);
    draw_text(graph_x + graph_width_pixels + 5, _y_top - 5, string(round(_top_ref_fps)) + " FPS");
}

// 8. RESET DRAW STATE
draw_set_color(c_white);
draw_set_alpha(1.0);