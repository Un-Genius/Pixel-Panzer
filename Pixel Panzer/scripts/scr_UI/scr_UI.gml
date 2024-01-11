#region Save Functions

/// @function loadStringFromFile(filename);
/// @param {_filename} Filename to open and load
function loadStringFromFile(_filename) {
	var _buffer = buffer_load(_filename);
	var _string = buffer_read(_buffer, buffer_string);

	buffer_delete(_buffer);

	var _json = json_decode(_string);

	return _json;
}

/// @function saveStringToFile(filename, _string);
/// @param {_filename} Filename to save to
/// @param {_string} String data to save
function saveStringToFile(_filename, _string) {

	var _buffer = buffer_create(string_byte_length(_string) + 1, buffer_fixed, 1);

	buffer_write(_buffer, buffer_string, _string);
	buffer_save(_buffer, _filename);
	buffer_delete(_buffer);
}


#endregion

#region UI

#region Chat Functions

/// @function chat_add(client, string, color);
/// @param {_client} steamID to display as name
/// @param {_text} String to display
/// @param {_color} Color to display text
function chat_add(_client, _text, _color) {
	
	#region Get ride of \n

	// Find next line
	var qPos = string_pos("\n", _text);
	var _chat_text = _text;
	
	// Loop for each new line
	while(qPos != 0)
	{
		// Get rid of new line
		_chat_text = string_delete(_chat_text, qPos, 1);
		
		// Find next new line
		qPos = string_pos("\n", _chat_text);
	}
		
	_text = _chat_text;
	
	#endregion
	
	// Add steamUserMap
	_text = string(_client) + ": " + _text;
	
	#region Re-Add \n
	
	_chat_text			= "";
	var _nextSpace		= 0;
	var _piece_length	= 0;
	
	var _length = string_length(_text) + 1;
	
	for(var o = 0; o < _length + 1; o++)
	{	
		var _frontDelete	= string_delete(_text, o + 1, _length - o);
		var _backDelete		= string_delete(_frontDelete, 1, o - 1);
		
		_chat_text += _backDelete;
		string_delete(_chat_text, o + 1 , _length - o);
		
		// Get width
		var _width = currentLineWidth(_chat_text);
		
		// Find next space
		for(var k = 0; k < _length - _piece_length + 1; k++)
		{			
			var _check = string_char_at(_chat_text, k);
			
			if _check == " "
			{
				_nextSpace = k;	
				k = _nextSpace + 1;
			}
		}
		
		if _width > 420
		{			
			_piece_length = string_length(_chat_text);
			var _text_piece = string_delete(_chat_text, _nextSpace, _piece_length);
			
			// Add to chat
			ds_list_insert(global.chat, 0, _text_piece);
			ds_list_insert(global.chatColor, 0, _color);
			
			// Reset string
			_chat_text = string_delete(_chat_text, 1, _nextSpace - 1);
		}
		else
		{
			if o + 1 == _length
			{				
				// Add to chat
				ds_list_insert(global.chat, 0, _chat_text);
				ds_list_insert(global.chatColor, 0, _color);
			}
		}
	}
	
	#endregion
}

/// @function chat_send(string, color);
/// @param {_string} text to display
/// @param {_color} color to display text as
function chat_send(_string, _color) {

	with(oManager) 
	{
		if(lobby)
		{
		    var _packet = packet_start(packet_t.chat);
			buffer_write(_packet, buffer_u64, steamUserName);
		    buffer_write(_packet, buffer_string, _string);
			buffer_write(_packet, buffer_u16, _color);
		    packet_send_all(_packet);
		}
	}
}

/// @function currentLineWidth(string);
/// @param {baseString} text to calculate width with
function currentLineWidth(baseString) {
	var qPos = 1;
	
	// Add buffer
	baseString = string_insert(" ", baseString, 0)
	
	while(qPos != 0)
	{
	    baseString = string_delete(baseString, 1, qPos);
	    qPos = string_pos("\n", baseString);
	}
	
	return string_width(baseString);
}
	
#endregion

// Scripts to execute on button press
#region List scripts

// Host Type
function scr_GUI_list0() {
	steam_update_lobby();
}

// 1 is a break

// Map
	
// Color
function scr_GUI_list4() {		
	with(oManager)
	{
		// Hold previous color
		var _prevNumColor = numColor;
		
		// Find position
		numColor = ds_grid_get(global.savedSettings, 1, setting.color);
		
		// Compare to others
		var _size = ds_list_size(steamNetList);
		
		for(var i = 0; i < _size; i++)
		{
			var _id = ds_list_find_value(steamNetList, i);
			
			// Get data map
			var _dataMap	= ds_map_find_value(steamDataMap, _id);
			
			var _numColor	= ds_map_find_value(_dataMap, "numColor");
			
			// If its taken...
			if _numColor == numColor
			{
				// Check if cycling through or back list			
				if numColor - _prevNumColor > 0
				{
					// Skip to next color and check all others again
					numColor++;
					i = 0;
						
					// Check if its the last color
					if numColor == 9
					{
						// Reset it
						numColor = 1
						i = 0;
					}
				}
				else
				{
					// Skip to next color and check all others again
					numColor--;
					i = 0;
						
					// Check if its the last color
					if numColor == -1
					{
						// Reset it
						numColor = 8
						i = 0;
					}
				}
			}
		}
		
		// Set new position
		ds_grid_set(global.savedSettings, 1, setting.color, numColor);
		
		// Find color
		hashColor = findColor(numColor);
						
		// Update everyone else
		var _buffer = packet_start(packet_t.data_map);
		buffer_write(_buffer, buffer_u64, steamUserName);
		buffer_write(_buffer, buffer_string, "numColor");
		buffer_write(_buffer, buffer_s16, numColor);
		packet_send_all(_buffer);
	
		// Update UI
		alarm[3] = 1;
	}
}

// Fullscreen
function scr_GUI_list8() {
	// Get data
	var _windowType = ds_grid_get(global.savedSettings, 1, setting.fullscreen);

	with(oManager)
	{
		window_set_fullscreen(_windowType);
	
		// --- Reset Settings
	
		// Resolution
		global.RES_W = display_get_width();
		global.RES_H = display_get_height();
	
		if !_windowType
		{
			// Resolution
			global.RES_W = 1920;
			global.RES_H = 1080;
	
			aspect_ratio = global.RES_W / global.RES_H;
		}
	
		// Find aspect_ration
		aspect_ratio = global.RES_W / global.RES_H;
	
		// Modify width resolution to fit aspect_ratio
		global.RES_W = round(global.RES_H * aspect_ratio);

		// Check for odd numbers
		if(global.RES_W & 1)
			global.RES_W++;
	
		// Resize window
		window_set_size(global.RES_W, global.RES_H);
		
		// Delay recenter
		alarm[2] = 1;

		surface_resize(application_surface, global.RES_W, global.RES_H);
		display_set_gui_size(global.RES_W, global.RES_H);
		
		// Zoom
		zoom = 1;
		
		// Reset menu
		reset_menu();
	}
}

// Game Mode
function scr_GUI_list13() {
	
	with(oManager)
	{
		// Update UI
		alarm[3] = 1;
	}
	
	scr_GUI_list14();
}

// Team
function scr_GUI_list14() {
	
	// Get data
	var _gameMode = ds_grid_get(global.savedSettings, 1, setting.game_mode);
	
	with(oManager)
	{	
		// Update team
		team = ds_grid_get(global.savedSettings, 1, setting.team_number) + 1;
		
		// Update team
		if _gameMode == 0
			team = 0;
			
		// Update position
		ds_grid_set(global.savedSettings, 1, setting.team_number, 0);
		
		// Send new team number
		var _buffer = packet_start(packet_t.data_map);
	
		buffer_write(_buffer, buffer_u64, steamUserName);
		buffer_write(_buffer, buffer_string, "team");
		buffer_write(_buffer, buffer_s16, team);
	
		packet_send_all(_buffer);
		
		// Send gamemode
		_buffer = packet_start(packet_t.data_map);
		
		buffer_write(_buffer, buffer_u64, steamUserName);
		buffer_write(_buffer, buffer_string, "game_mode");
		buffer_write(_buffer, buffer_s16, _gameMode);
		
		packet_send_all(_buffer);
	}
}

#endregion

/// @function get_hover(x1, y1, x2, y2);
// Checks if mouse is in that box
function get_hover(_x1, _y1, _x2, _y2) {

	var _mouseX = device_mouse_x_to_gui(0);
	var _mouseY = device_mouse_y_to_gui(0);

	return point_in_rectangle(_mouseX, _mouseY, _x1, _y1, _x2, _y2);
}

/// @function on_click();
// Returnes button text clicked
function on_click() {
	show_debug_message("Button clicked: " + text);
}

/// @function reset_menu();
// Deletes all menu buttons
function reset_menu() {
	// Find size
	var _size = ds_list_size(buttonList);
	
	for(var i = 0; i < _size; i++)
	{
		// Find and destroy button
		instance_destroy(ds_list_find_value(buttonList, i))
	}
	
	// Reset list
	ds_list_clear(buttonList);

	// Update Chat, just for fun
	chatX = global.RES_W - 500;
	chatY = global.RES_H - 100;
}

#endregion

#region GUI
#region Create
function add_list(_inst, _ref) {
	var _savedSettings = global.savedSettings;

	// Set values
	with(_inst)
	{	
		var _width = ds_grid_width(_savedSettings);
		var _height = ds_grid_height(optionGrid);
	
		ds_grid_resize(optionGrid, _width, _height + 1)
	
		ds_grid_add(optionGrid, 0, _height, _ref);
	
		// Add values to list
		for(var i = 1; i < _width; i++)
		{	
			var _value = ds_grid_get(_savedSettings, i - 1, _ref);
		
			// Add value to grid
			ds_grid_add(optionGrid, i, _height, _value);	
		}
	}
}
/// @arg steamUserMap
/// @arg pos
/// @arg values...
function add_setting() {

	// Amout of additional arguments
	var _argCount = argument_count;
	
	// Set values
	var _savedSettings = global.savedSettings;

	var _height = ds_grid_height(_savedSettings);
	var _width = ds_grid_width(_savedSettings);
	
	if _argCount > _width
		_width = _argCount;

	ds_grid_resize(_savedSettings, _width, _height + 1);
	
	for(var i = 0; i < _width; i++)
	{		
		if _argCount > i
			ds_grid_add(_savedSettings, i, _height, argument[i]);
		else
			ds_grid_add(_savedSettings, i, _height, -1);
	}


}
/// @arg x
/// @arg y
/// @arg width
/// @arg height
/// @arg text
/// @arg script
/// @arg parent
/// @arg buttonObj
function create_button() {

	// Arguments
	var _x			= argument[0];
	var _y			= argument[1];
	var _width		= argument[2];
	var _height		= argument[3];
	var _text		= argument[4];
	var _script		= argument[5];
	var _parent		= argument[6];
	var _buttonObj	= argument[7];

	// Create button
	var _button = instance_create_layer(_x, _y, "UI", _buttonObj);
	
	// Set Values
	with(_button)
	{
		width	= _width;
		height	= _height;
		text	= _text;
		script	= _script;
		parent	= _parent;
	}

	return _button;
}
/// @arg x
/// @arg y
/// @arg width
/// @arg title
function create_list() {

	// Arguments
	var _x		= argument[0];
	var _y		= argument[1];
	var _width	= argument[2];
	var _title	= argument[3];

	// Create list
	var _list = instance_create_layer(_x, _y, "UI", oList);

	// Set values
	with(_list)
	{
		width	= _width;
		title	= _title;
	}

	return _list;


}
/// @arg x
/// @arg y
/// @arg text
/// @arg textLimit
/// @arg parent
function create_textbox() {

	// Arguments
	var _x			= argument[0];
	var _y			= argument[1];
	var _text		= argument[2];
	var _textLimit	= argument[3];
	var _parent		= argument[4];

	// Create button
	var _textbox = instance_create_layer(_x, _y, "UI", oTextbox);
	
	// Set Values
	with(_textbox)
	{
		text	= _text;
		limit	= _textLimit + 1;
		parent	= _parent;
	}

	return _textbox;


}
#endregion
#region Button Scripts

#endregion
#endregion