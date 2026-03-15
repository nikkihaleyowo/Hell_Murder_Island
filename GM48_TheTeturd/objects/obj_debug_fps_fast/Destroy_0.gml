// Destroy DS lists to prevent memory leaks
if (ds_list_exists(fps_history)) {
    ds_list_destroy(fps_history);
}
if (ds_list_exists(mem_history)) {
    ds_list_destroy(mem_history);
}
// No need to delete font if using default (-1) or a static asset.
// If you dynamically added a font from a sprite, you would put font_delete(graph_text_font) here.