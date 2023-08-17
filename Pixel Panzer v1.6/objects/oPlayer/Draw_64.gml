#region Draw Binaculars
if (mouse_check_button(mb_right))
{
	var _newBinocularsX = device_mouse_x_to_gui(0);
	var _newBinocularsY = device_mouse_y_to_gui(0);
	
	var _guiW = display_get_gui_width();
	var _guiH = display_get_gui_height();
	
	draw_line(_newBinocularsX, _newBinocularsY, _guiW/2, _guiH/2);
	
	draw_circle(_guiW/2, _guiH/2, 6, false);
}
#endregion