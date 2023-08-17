if (keyboard_check_pressed(vk_escape))
{
	game_end();
}

if (keyboard_check_pressed(vk_f1))
	window_set_fullscreen(!window_get_fullscreen());

if (keyboard_check_pressed(vk_f2))
	global.Debug = -global.Debug;

var _gameSwitch = false;

#region UI
/*
// Positioning value
var _centerX = global.RES_W/2;

// Default Button size
var _bigWidth	= 250;
var _medWidth	= 175;
var _smallWidth	= 100;
var _height = 75;

// Default List size
var _widthList	= 700;

var inst = noone;

// Activate menuOverlayState
switch(menuOverlayState)
{	
	case menu.home:
		#region Button checks
		
		// Find size
		var _size = ds_list_size(buttonListDynamic);
		
		if(ds_list_size(_size)) != 0
		{
			for(var i = 0; i < _size; i++)
			{
				// Find and destroy button
				instance_destroy(ds_list_find_value(buttonListDynamic, i))
			}
	
			// Reset list
			ds_list_clear(buttonListDynamic);
		}
		
		#endregion
	
		#region Home Buttons
		
		// Check if list already in use
		if(ds_list_size(buttonList)) > 0 break;
		
		// Play Button
		inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Public Match", scr_GUI_Public, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Options Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 40, _smallWidth, _height, "Options\n(N/A)", on_click, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Quit Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 40, _smallWidth, _height, "Quit", scr_GUI_Quit, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Host Button
		inst = create_button(_centerX - (_medWidth/2), 150, _medWidth, _height, "Host", scr_GUI_Host, self, oMenuButton);
		ds_list_add(buttonList, inst);
		
		// Join Button
		inst = create_button(_centerX - (_smallWidth/2) + 165, 150, _smallWidth, _height, "Join\nFriend", scr_GUI_Join_Private,	self, oMenuButton);
		ds_list_add(buttonList, inst);
		
		// Campaign Button
		inst = create_button(_centerX - (_medWidth/2), 260,	_medWidth, _height, "Campaign\n(Not Available)", on_click, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		#endregion
		break;

	case menu.public:
		#region Show public lobbies
		
		if(steam_lobby_list_is_loading())
		{
			// Refresh in 10 sec
			alarm[0] = room_speed * 5;
		}
		
		if(ds_list_size(buttonListDynamic)) == 0
		{		
			// Get amount of lobbies
		    var _amount = min(32, steam_lobby_list_get_count());
		
		    for (var o = 0; o < _amount; o++)
			{	
				// Get data
				var _lobbyTitle		= steam_lobby_list_get_data(o, "title");
				var _lobbyCurrent	= steam_lobby_list_get_data(o, "game_size_current");
				var _lobbyMax		= steam_lobby_list_get_data(o, "game_size_max");
				
				// Display steamUserMap
		        var _string = "Join " + _lobbyTitle + "\n" + _lobbyCurrent + "/" + _lobbyMax + " Players\n";
				
				// Create Button for public lobby
				inst = create_button(400, 40 + o * (_height + 40), 300, _height * 1.5, _string, scr_GUI_Join_Public, self, oMenuButton);
				
				ds_list_add(buttonListDynamic, inst);
		    }
		}
		
		#endregion
			
		#region Play Page Buttons
		
		// Check if list already in use
		if(ds_list_size(buttonList)) > 0 break;
		
		// Refresh Button
		inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Refresh", scr_GUI_Refresh, self, oMenuButton);
		ds_list_add(buttonList, inst);
		
		// Options Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 40, _smallWidth, _height, "Options (N/A)", on_click, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
				
		// Back Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 40, _smallWidth, _height, "Back", scr_GUI_Back, self, oMenuButton);
		ds_list_add(buttonList, inst);
				
		#endregion
		break;
		
	case menu.hostPage:			
		#region Start match
		
		if lobby
		{
			var _lobbyCount = steam_lobby_get_member_count();
				
			if _lobbyCount == playersReady
			{
				// Broadcast start
				var _buffer = packet_start(packet_t.start);
				packet_send_all(_buffer);
				
				// Go to room
		        room_goto(rm_test);
		
				// Set Target menuOverlayState
				menuOverlayState = menu.inGame;
				
				inGame = true;
	
				// Reset menu
				reset_menu();
														
				break;
			}
		}
		
		#endregion
			
		#region Host Page Buttons
		
		// Check if list already in use
		if(ds_list_size(buttonList)) > 0 break;
		
		if !lobby_is_owner
		{
			// Get data
			var _lobbyType = ds_grid_get(global.savedSettings, 1, setting.host_type);
		
			// Create Friends only lobby with a max of 16 people (8v8)
			steam_lobby_create(_lobbyType, 16);
		}
		
		_widthList	= 400;
			
		// Settings list	
		inst = create_list(global.RES_W - 490, global.RES_H - 550, _widthList, "Game settings:");		
		add_list(inst, setting.host_type);
		add_list(inst, setting.break_slot);
		add_list(inst, setting.player_count);
		add_list(inst, setting.map);
		add_list(inst, setting.spawn_points);
		add_list(inst, setting.color);
		add_list(inst, setting.game_mode);
		
		// Add team if game mode is set to teams
		if(ds_grid_get(global.savedSettings, 1, setting.game_mode) == 1)
			add_list(inst, setting.team_number);
		
		ds_list_add(buttonList, inst);
			
		if !ready
		{
			// Ready Button
			inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Ready Up", readyChange, self, oMenuButton, false);
			ds_list_add(buttonList, inst);
		}
		else
		{
			// UnReady Button
			inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Ready Down", readyChange, self, oMenuButton, false);
			ds_list_add(buttonList, inst);
		}
		
		// Lobby display
		inst = instance_create_layer(global.RES_W - 725, global.RES_H - 250, "UI", oLobby);
		ds_list_add(buttonList, inst);
		
		// Invite Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 40, _smallWidth, _height, "Invite", scr_GUI_Invite, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Leave Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 40, _smallWidth, _height, "Leave",	scr_GUI_Back,	self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		#endregion
		break;
		
	case menu.joinPage:		
		#region Host Page Buttons
		
		// Check if list already in use
		if(ds_list_size(buttonList)) > 0 break;
				
		_widthList	= 400;
			
		// Settings list	
		inst = create_list(global.RES_W - 490, global.RES_H - 525, _widthList, "Game settings:");		
		add_list(inst, setting.color);
		
		// Get data map
		var _dataMap = ds_map_find_value(steamDataMap, steamLobbyOwner);
		
		// Find value
		var _gameMode = ds_map_find_value(_dataMap, "game_mode");
		
		if _gameMode == 1
			add_list(inst, setting.team_number);
		
		ds_list_add(buttonList, inst);
			
		if !ready
		{
			// Ready Button
			inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Ready Up", readyChange, self, oMenuButton, false);
			ds_list_add(buttonList, inst);
		}
		else
		{
			// UnReady Button
			inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Ready Down", readyChange, self, oMenuButton, false);
			ds_list_add(buttonList, inst);
		}
		
		// Lobby display
		inst = instance_create_layer(global.RES_W - 725, global.RES_H - 250, "UI", oLobby);
		ds_list_add(buttonList, inst);
		
		// Invite Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 40, _smallWidth, _height, "Invite", scr_GUI_Invite, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Leave Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 40, _smallWidth, _height, "Leave",	scr_GUI_Back,	self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		#endregion
		break;
		
	case menu.loadingPage:		
		#region Button checks
		
		// Find size
		var _size = ds_list_size(buttonListDynamic);
		
		if(ds_list_size(_size)) != 0
		{
			for(var i = 0; i < _size; i++)
			{
				// Find and destroy button
				instance_destroy(ds_list_find_value(buttonListDynamic, i))
			}
	
			// Reset list
			ds_list_clear(buttonListDynamic);
		}
		
		#endregion
	
		#region Host Page Buttons
		
		// Check if list already in use
		if(ds_list_size(buttonList)) > 0 break;
				
		_widthList	= 400;
								
		// Leave Button
		inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Cancel",	scr_GUI_Back,	self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		#endregion
		break;
		
	case menu.optionsPage:		
		#region Button checks
		
		// Find size
		var _size = ds_list_size(buttonListDynamic);
		
		if(ds_list_size(_size)) != 0
		{
			for(var i = 0; i < _size; i++)
			{
				// Find and destroy button
				instance_destroy(ds_list_find_value(buttonListDynamic, i))
			}
	
			// Reset list
			ds_list_clear(buttonListDynamic);
		}
		
		#endregion
	
		#region Options Page Buttons
		
		// Check if list already in use
		if(ds_list_size(buttonList)) > 0 break;
		
		if !inGame
		{
			// Play Button
			inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Public Match", scr_GUI_Public, self, oMenuButton, false);
			ds_list_add(buttonList, inst);
		}
		
		// Options Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 40, _smallWidth, _height, "Save", scr_GUI_Save, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Back Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 40, _smallWidth, _height, "Back", scr_GUI_Back, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Controls Button
		inst = create_button(_centerX - (_medWidth/2) - 200, 150, _medWidth, _height, "Controls", scr_GUI_Controls, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
				
		// Sounds Button
		inst = create_button(_centerX - (_medWidth/2), 150, _medWidth, _height, "Sounds", scr_GUI_Sounds, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
			
		// Graphics Button
		inst = create_button(_centerX - (_medWidth/2) + 200, 150, _medWidth, _height, "Graphics", scr_GUI_Graphics, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
				
		#endregion
		break;
		
	case menu.inGame:	
		#region Start
		
		if room == rm_menu
			break;
		
		if !started
		{			
			started = true;
			
			// Start alarm
			alarm[3] = 3 * room_speed;
						
			reset_pathfind();
		}
		
		#endregion
	
		// Check if list already in use
		if(ds_list_size(buttonList)) > 0 break;
	
		#region Zone buttons
		
		// Camp Button
		inst = create_button(_centerX - 410, global.RES_H - 60, 120, 40, "Camp $" + string(unitCost[zoneType.camp]),  zoneToolCamp, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Camp Button
		inst = create_button(_centerX - 270, global.RES_H - 60, 150, 40, "Boot Camp $" + string(unitCost[zoneType.bootCamp]),  zoneToolBootCamp, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Camp Button
		inst = create_button(_centerX - 100, global.RES_H - 60, 230, 40, "Supplies Gathering $" + string(unitCost[zoneType.money]),  zoneToolMoney, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Camp Button
		inst = create_button(_centerX + 150, global.RES_H - 60, 170, 40, "Supply Depot $" + string(unitCost[zoneType.supplies]),  zoneToolSupplies, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		#endregion
	
		#region Ingame Menu
		
		if !menuOverlayToggle break
		
		// Options Button
		inst = create_button(_centerX - (_smallWidth/2), 40, _smallWidth, _height, "Options",  on_click, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Exit Button
		inst = create_button(_centerX - (_smallWidth/2) + 125, 40, _smallWidth, _height, "Exit",	scr_GUI_Menu, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		#endregion
		break;
		
	#region Options
	
	case menu.graphicsPage:	
		#region Graphics Page Buttons
		
		// Check if list already in use
		if(ds_list_size(buttonList)) > 0 break;
				
		if !inGame
		{
			// Play Button
			inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Public Match", scr_GUI_Public, self, oMenuButton, false);
			ds_list_add(buttonList, inst);
		}
		
		// Options Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 40, _smallWidth, _height, "Save", scr_GUI_Save, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Back Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 40, _smallWidth, _height, "Back", scr_GUI_Back, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Main Button
		inst = create_button(_centerX - (_bigWidth/2), 150, _bigWidth, _height, "Main Options", on_click, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Controls Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 150, _smallWidth, _height, "Controls", scr_GUI_Controls, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
				
		// Sounds Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 150, _smallWidth, _height, "Sounds", scr_GUI_Sounds, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
				
		// Graphics list
		inst = create_list(_centerX - 100, 250, _widthList, "Graphics settings:");
		add_list(inst, setting.graphics);
		add_list(inst, setting.gui_size);
		add_list(inst, setting.fullscreen);
		ds_list_add(buttonList, inst);
						
		#endregion
		break;
		
	case menu.soundsPage:			
		#region Audio Page Buttons
		
		// Check if list already in use
		if(ds_list_size(buttonList)) > 0 break;
		
		if !inGame
		{
			// Play Button
			inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Public Match", scr_GUI_Public, self, oMenuButton, false);
			ds_list_add(buttonList, inst);
		}
		
		// Options Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 40, _smallWidth, _height, "Save", scr_GUI_Save, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Back Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 40, _smallWidth, _height, "Back", scr_GUI_Back, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Main Button
		inst = create_button(_centerX - (_bigWidth/2), 150, _bigWidth, _height, "Main Options", on_click, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Controls Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 150, _smallWidth, _height, "Controls", scr_GUI_Controls, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
				
		// Graphics Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 150, _smallWidth, _height, "Graphics", scr_GUI_Graphics, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Audio list
		inst = create_list(_centerX - 100, 250, _widthList, "Audio settings:");
		add_list(inst, setting.main_volume);
		add_list(inst, setting.music_volume);
		add_list(inst, setting.special_sound_effects);
		ds_list_add(buttonList, inst);
				
		#endregion
		break;
			
	case menu.controlsPage:			
		#region Controls Page Buttons
		
		// Check if list already in use
		if(ds_list_size(buttonList)) > 0 break;
				
		if !inGame
		{
			// Play Button
			inst = create_button(_centerX - (_bigWidth/2), 40, _bigWidth, _height, "Public Match", scr_GUI_Public, self, oMenuButton, false);
			ds_list_add(buttonList, inst);
		}
		
		// Options Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 40, _smallWidth, _height, "Save", scr_GUI_Save, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Back Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 40, _smallWidth, _height, "Back", scr_GUI_Back, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Main Button
		inst = create_button(_centerX - (_bigWidth/2), 150, _bigWidth, _height, "Main Options", on_click, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Audio Button
		inst = create_button(_centerX - (_smallWidth/2) + 200, 150, _smallWidth, _height, "Audio", scr_GUI_Sounds, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
				
		// Graphics Button
		inst = create_button(_centerX - (_smallWidth/2) + 325, 150, _smallWidth, _height, "Graphics", scr_GUI_Graphics, self, oMenuButton, false);
		ds_list_add(buttonList, inst);
		
		// Control list
		inst = create_list(_centerX - 100, 250, _widthList, "Control settings:");
		add_list(inst, setting.controls);
		ds_list_add(buttonList, inst);
							
		#endregion
	break;
	
	#endregion
}

#region Ingame overlay

if(keyboard_check_pressed(vk_escape)) && inGame
{
	// Change
	menuOverlayToggle = !menuOverlayToggle;
			
	menuOverlayState = menu.inGame
			
	// Update Menu
	reset_menu();
}
	
#endregion
*/
#endregion

// Switch game type
if(keyboard_check_pressed(vk_f3))
{
	_gameSwitch = true;
	global.current_game_type = global.game_type_arr[game_type.free_for_all];
}
if(keyboard_check_pressed(vk_f4))
{
	_gameSwitch = true;
	global.current_game_type = global.game_type_arr[game_type.team_vs_team];
}
if(keyboard_check_pressed(vk_f5))
{
	_gameSwitch = true;
	global.current_game_type = global.game_type_arr[game_type.capture_the_flag];
}
if(keyboard_check_pressed(vk_f6))
{
	_gameSwitch = true;
	global.current_game_type = global.game_type_arr[game_type.gun_game];
}
if(keyboard_check_pressed(vk_f7))
{
	_gameSwitch = true;
	global.current_game_type = global.game_type_arr[game_type.test];
}
if(keyboard_check_pressed(vk_f8))
{
	_gameSwitch = true;
	global.current_game_type = global.game_type_arr[game_type.chaos];
}

// Reset Game board
if(_gameSwitch)
{
	// Make sure board is wiped
	instance_destroy(oTank);
	instance_destroy(oTank_Dead);
	instance_destroy(oObjective);
	
	audio_stop_all();
}
	
// Set rules for game type
switch(global.current_game_type)
{
	#region Free For All
	case global.game_type_arr[game_type.free_for_all]:
	
		if(_gameSwitch)
		{
			// Create leaderboards
			global.leaderboardList = [];
			
			timer = 4 * room_speed;
			
			var _randTank = global.tank_type_arr[irandom(array_length(global.tank_type_arr)-1)];
			var _inst = instance_create_layer(irandom(room_width), irandom(room_height), "Instances", oPlayer);
			
			with(_inst)
			{
				tankTypeSwitch(_randTank);
			}
			
			repeat(20)
			{
				_randTank = global.tank_type_arr[irandom(array_length(global.tank_type_arr)-1)];
				var _randPosX = irandom(room_width);
				var _randPosY = irandom(room_height);
			
				_inst = instance_create_layer(_randPosX, _randPosY, "Instances", oTank);
			
				with(_inst)
				{
					tankTypeSwitch(_randTank);
					
					team = "-1"
					view = -1;
				}
			}
		}
		
		timer--;
		
		// Constantly remake tanks
		if(timer <= 0 && instance_number(oTank) <= 35)
		{
			var _randTank = global.tank_type_arr[irandom(array_length(global.tank_type_arr)-1)];
			var _randPosX = irandom(room_width);
			var _randPosY = irandom(room_height);
			
			var _inst = instance_create_layer(_randPosX, _randPosY, "Instances", oTank);
			
			with(_inst)
			{
				tankTypeSwitch(_randTank);
				
				team = "-1"
				view = -1;
			}
			
			timer = 4 * room_speed;
		}
		
		break;
	#endregion
	#region Capture the Flag
	case global.game_type_arr[game_type.capture_the_flag]:
		if(_gameSwitch)
		{			
			timer = 2 * room_speed;
			
			// Make Player
			_randTank = global.tank_type_arr[choose(tank_type.Type95, tank_type.PZ4, tank_type.Tiger, tank_type.Panther)];
			_randPosX = irandom(room_width);
			_randPosY = room_height - irandom(room_height/6);
			
			_inst = instance_create_layer(_randPosX, _randPosY, "Instances", oPlayer);
				
			with(_inst)
			{
				tankTypeSwitch(_randTank);
			}
			
			// Make Objective
			instance_create_layer(room_width/2, room_height/2, "Instances", oObjective);
			
			// Draw Team Points
			draw_text(20, 20, "Team Germany: " + string(global.PointsGermany));
			draw_text(20, 40, "Team Russia: " + string(global.PointsRussia));
			
			// Make Initial Tanks
			repeat(20)
			{
				var _randTank = global.tank_type_arr[choose(tank_type.T26, tank_type.T34, tank_type.KV1, tank_type.KV2)];
				var _randPosX = irandom(room_width);
				var _randPosY = irandom(room_height/6);
			
				var _inst = instance_create_layer(_randPosX, _randPosY, "Instances", oTank);
				
				with(_inst)
				{
					tankTypeSwitch(_randTank);
				}
			
				_randTank = global.tank_type_arr[choose(tank_type.Type95, tank_type.PZ4, tank_type.Tiger, tank_type.Panther)];
				_randPosX = irandom(room_width);
				_randPosY = room_height - irandom(room_height/6);
			
				_inst = instance_create_layer(_randPosX, _randPosY, "Instances", oTank);
				
				with(_inst)
				{
					tankTypeSwitch(_randTank);
				}
			}
		}
			
		// Get the number of tanks in the capture radius for each team
		var _germanTanks = 0;
		var _russianTanks = 0;

		for(var i = 0; i < instance_number(oTank); i++)
		{
			switch instance_find(oTank, i).team
			{
				case "Germany":
					_germanTanks++;
					break;
				case "Russia":
					_russianTanks++;
					break;
			}
		
		}
		
		timer--;
		
		// Constantly remake tanks
		if(timer <= 0 && instance_number(oTank) <= 40)
		{
			if(_germanTanks > _russianTanks)
			{
				var _randTank = global.tank_type_arr[choose(tank_type.T26, tank_type.T34, tank_type.KV1, tank_type.KV2)];
				var _randPosX = irandom(room_width);
				var _randPosY = irandom(room_height/6);
			
				var _inst = instance_create_layer(_randPosX, _randPosY, "Instances", oTank);
			
				with(_inst)
				{
					tankTypeSwitch(_randTank);
				}
			}
			else
			{
				_randTank = global.tank_type_arr[choose(tank_type.Type95, tank_type.PZ4, tank_type.Tiger, tank_type.Panther)];
				_randPosX = irandom(room_width);
				_randPosY = room_height - irandom(room_height/6);
			
				_inst = instance_create_layer(_randPosX, _randPosY, "Instances", oTank);
			
				with(_inst)
				{
					tankTypeSwitch(_randTank);
				}
			}
			
			timer = 0.5 * room_speed;
		}
		break;
	#endregion
	#region Gun Game
	case global.game_type_arr[game_type.gun_game]:
	
		if(_gameSwitch)
		{			
			timer = 2 * room_speed;
			
			var _inst = instance_create_layer(irandom(room_width), irandom(room_height), "Instances", oPlayer);
			
			with(_inst)
			{
				tankType = 0;
				tankTypeSwitch(tankType);
				team = "-1"
			}
			
			repeat(35)
			{
				var _randPosX = irandom(room_width);
				var _randPosY = irandom(room_height);
			
				_inst = instance_create_layer(_randPosX, _randPosY, "Instances", oTank);
			
				with(_inst)
				{
					tankType = 0;
					tankTypeSwitch(tankType);
					team = "-1"
					view = -1;
				}
			}
		}
		
		timer--;
		
		// Constantly remake tanks
		if(timer <= 0 && instance_number(oTank) <= 45)
		{
			var _randPosX = irandom(room_width);
			var _randPosY = irandom(room_height);
			
			_inst = instance_create_layer(_randPosX, _randPosY, "Instances", oTank);
			
			with(_inst)
			{
				tankType = 0;
				tankTypeSwitch(tankType);
				team = "-1"
				view = -1;
			}
			
			timer = 1 * room_speed;
		}
	
		break;
	#endregion
	#region Team vs Team
	case global.game_type_arr[game_type.team_vs_team]:
		if(_gameSwitch)
		{			
			timer = 2 * room_speed;
			
			global.PointsGermany = 0;
			global.PointsRussia = 0;
			
			var _randTank = global.tank_type_arr[choose(tank_type.Type95, tank_type.PZ4, tank_type.Tiger, tank_type.Panther)];
			var _randPosX = irandom(room_width);
			var _randPosY = room_height - irandom(room_height/6);
			
			var _inst = instance_create_layer(_randPosX, _randPosY, "Instances", oPlayer);
			
			with(_inst)
			{
				tankTypeSwitch(_randTank);
			}
			
			repeat(20)
			{
				_randTank = global.tank_type_arr[choose(tank_type.T26, tank_type.T34, tank_type.KV1, tank_type.KV2)];
				_randPosX = irandom(room_width);
				_randPosY = irandom(room_height/6);
			
				_inst = instance_create_layer(_randPosX, _randPosY, "Instances", oTank);
				
				with(_inst)
				{
					tankTypeSwitch(_randTank);
					view = -1;
				}
			
				_randTank = global.tank_type_arr[choose(tank_type.Type95, tank_type.PZ4, tank_type.Tiger, tank_type.Panther)];
				_randPosX = irandom(room_width);
				_randPosY = room_height - irandom(room_height/6);
			
				_inst = instance_create_layer(_randPosX, _randPosY, "Instances", oTank);
				
				with(_inst)
				{
					tankTypeSwitch(_randTank);
					view = -1;
				}
			}
		}
		
		timer--;
		
		// Get the number of tanks in the capture radius for each team
		var _germanTanks = 0;
		var _russianTanks = 0;

		for(var i = 0; i < instance_number(oTank); i++)
		{
			switch instance_find(oTank, i).team
			{
				case "Germany":
					_germanTanks++;
					break;
				case "Russia":
					_russianTanks++;
					break;
			}
		
		}
		
		// Constantly remake tanks
		if(timer <= 0 && instance_number(oTank) <= 40)
		{
			// Make tanks for the losing team
			if(_germanTanks > _russianTanks)
			{
				var _randTank = global.tank_type_arr[choose(tank_type.T26, tank_type.T34, tank_type.KV1, tank_type.KV2)];
				var _randPosX = irandom(room_width);
				var _randPosY = irandom(room_height/6);
			
				var _inst = instance_create_layer(_randPosX, _randPosY, "Instances", oTank);
			
				with(_inst)
				{
					tankTypeSwitch(_randTank);
					view = -1;
				}
			}
			else
			{
				_randTank = global.tank_type_arr[choose(tank_type.Type95, tank_type.PZ4, tank_type.Tiger, tank_type.Panther)];
				_randPosX = irandom(room_width);
				_randPosY = room_height - irandom(room_height/6);
			
				_inst = instance_create_layer(_randPosX, _randPosY, "Instances", oTank);
			
				with(_inst)
				{
					tankTypeSwitch(_randTank);
					view = -1;
				}
			}
			
			timer = 2 * room_speed;
		}
		break;
	#endregion
	#region Test
	case global.game_type_arr[game_type.test]:
		if(_gameSwitch)
		{
			var _inst = instance_create_layer(room_width/2, room_height/8, "Instances", oPlayer);
			with(_inst)
			{
				tankTypeSwitch(tank_type.Panther);
				team = "-1"
				view = -1;
			}
		
			_inst = instance_create_layer(room_width/2 + 200, room_height/8, "Instances", oTank);
			with(_inst)
			{
				tankTypeSwitch(tank_type.PZ4);
				team = "-1"
				view = -1;
				turret_speed1 = 0;
				tank_turn_speed = 0;
				tank_move_speed = 0;
			}
		}
		break;
	#endregion
	#region Chaos
	case global.game_type_arr[game_type.chaos]:
		if(_gameSwitch)
		{			
			timer = 2 * room_speed;
			
			global.PointsGermany = 0;
			global.PointsRussia = 0;
			
			var _randTank = global.tank_type_arr[tank_type.Type95];
			var _randPosX = irandom(room_width);
			var _randPosY = room_height - room_height/3;
			
			var _inst = instance_create_layer(_randPosX, _randPosY, "Instances", oPlayer);
			
			with(_inst)
			{
				tankTypeSwitch(_randTank);
				tank_move_speed *= 2;
				tank_turn_speed /= 2;
				bullet_reload_time /= 2;
				tank_health *= 2;
			}
		}
		
		
		// Get the number of tanks in the capture radius for each team
		var _germanTanks = 0;
		var _russianTanks = 0;

		for(var i = 0; i < instance_number(oTank); i++)
		{
			switch instance_find(oTank, i).team
			{
				case "Germany":
					_germanTanks++;
					break;
				case "Russia":
					_russianTanks++;
					break;
			}
		
		}
		
		// Constantly remake tanks
		if(instance_number(oTank) <= 60)
		{
			// Make tanks for the losing team
			if(_germanTanks > _russianTanks)
			{
				var _randTank = global.tank_type_arr[tank_type.T26];
				var _randPosX = irandom(room_width);
				var _randPosY = room_height/3;
			
				var _inst = instance_create_layer(_randPosX, _randPosY, "Instances", oTank);
			
				with(_inst)
				{
					tankTypeSwitch(_randTank);
					view = -1;
					range = 400;
					tank_move_speed *= 2;
					tank_turn_speed /= 2;
				}
			}
			else
			{
				_randTank = global.tank_type_arr[tank_type.Type95];
				_randPosX = irandom(room_width);
				_randPosY = room_height - room_height/3;
			
				_inst = instance_create_layer(_randPosX, _randPosY, "Instances", oTank);
			
				with(_inst)
				{
					tankTypeSwitch(_randTank);
					view = -1;
					range = 400;
					tank_move_speed *= 2;
					tank_turn_speed /= 2;
				}
			}
		}
		break;
	#endregion
	default:
		if(_gameSwitch)
			instance_create_layer(room_width/2, room_height/8, "Instances", oPlayer);
}
	
show_debug_overlay(global.Debug);
global.Time++;