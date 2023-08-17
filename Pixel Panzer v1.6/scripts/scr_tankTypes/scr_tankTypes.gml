#region Tank Type
function tankTypeSwitch(_tankType)
{
	if(!is_string(_tankType))
	{
		_tankType = global.tank_type_arr[_tankType];
	}
	
	switch(_tankType)
	{
		case global.tank_type_arr[tank_type.Panther]:
			tankStats_Panther();
			break;
		case global.tank_type_arr[tank_type.Tiger]:
			tankStats_Tiger();
			break;
		case global.tank_type_arr[tank_type.PZ4]:
			tankStats_PZ4();
			break;
		case global.tank_type_arr[tank_type.Type95]:
			tankStats_Type95()
			break;
		case global.tank_type_arr[tank_type.KV1]:
			tankStats_KV1();
			break;
		case global.tank_type_arr[tank_type.KV2]:
			tankStats_KV2();
			break;
		case global.tank_type_arr[tank_type.T26]:
			tankStats_T26();
			break;
		case global.tank_type_arr[tank_type.T34]:
			tankStats_T34();
			break;
		case global.tank_type_arr[tank_type.M60A3]:
			tankStats_T34();
			break;
	}
	
	// Set Team
	if(global.current_game_type == global.game_type_arr[game_type.team_vs_team]
	|| global.current_game_type == global.game_type_arr[game_type.capture_the_flag]
	|| global.current_game_type == global.game_type_arr[game_type.chaos])
	{
		switch(_tankType)
		{
			case global.tank_type_arr[tank_type.Panther]:
				team = "Germany";
				break;
			case global.tank_type_arr[tank_type.Tiger]:
				team = "Germany";
				break;
			case global.tank_type_arr[tank_type.PZ4]:
				team = "Germany";
				break;
			case global.tank_type_arr[tank_type.Type95]:
				team = "Germany";
				break;
			default:
				team = "Russia";
		}
	}
	
	// Clean Up Event
	if (surface_exists(damageMask)) {
	    surface_resize(damageMask, sprite_width, sprite_height)
	}
	else
		damageMask = surface_create(sprite_width, sprite_height);
		
	surface_set_target(damageMask);
		draw_clear_alpha(c_black, 0);
	surface_reset_target();
}
#endregion

#region Germany
function tankStats_Type95()
{
	// Set Tank Type
	tankType = tank_type.Type95;

	// Set Health
	tank_health = 40;
	tank_health_max = tank_health;
	
	#region Sprites Stats
	tank = "Type95";
	tank_string = "sTank_" + tank + "_";
	sprite_index = asset_get_index(tank_string + "Bottom");
	#endregion
	#region Movement Stats
	tank_move_speed = 1.8;
	tank_turn_speed = 1.7;
	#endregion
	#region Turret Stats
	turret_sprite1 = asset_get_index(tank_string + "Top1");
	turret_speed1 = 0.8;
	#endregion
	#region Armor Stats
	armor_front = 20;
	armor_side = 10;
	armor_back = 5;
	armor_weaknesses = 20;
	#endregion
	#region Gun Stats
	bullet_accuracy = 0.90; // off out of 1
	bullet_reload_time = 340; // milliseconds
	bullet_magazine_size = 16;
	bullet_burst_rate = 4;
	bullet_burst_delay = 35;
	bullet_fire_rate_delay = 80;
	bullet_size = 0.2; // mm
	bullet_penetration = 45;
	bullet_speed = 17; // m/s
	damage = 3;
	range = irandom_range(1000, 1400);
	
	magazine_count = 0;
	burst_count = 0;
	#endregion
	#region Value
	// Set Value
	pointValue = 10;

	#endregion
}
function tankStats_PZ4()
{
	// Set Tank Type
	tankType = tank_type.PZ4;
		
	// Set Health
	tank_health = 70;
	tank_health_max = tank_health;
	
	#region Sprites Stats
	tank = "PZ4";
	tank_string = "sTank_" + tank + "_";
	sprite_index = asset_get_index(tank_string + "Bottom");
	#endregion
	#region Movement Stats
	tank_move_speed = 0.85;
	tank_turn_speed = 0.65;
	#endregion
	#region Turret Stats
	turret_sprite1 = asset_get_index(tank_string + "Top1");
	turret_speed1 = 0.8;
	#endregion
	#region Armor Stats
	armor_front = 40;
	armor_side = 20;
	armor_back = 10;
	armor_weaknesses = 11;
	#endregion
	#region Gun Stats
	bullet_accuracy = 0.95; // off out of 1
	bullet_reload_time = 200; // milliseconds
	bullet_magazine_size = 1;
	bullet_burst_rate = 1;
	bullet_burst_delay = 6;
	bullet_fire_rate_delay = 1;
	bullet_size = 0.3; // mm
	bullet_penetration = 80;
	bullet_speed = 18; // m/s
	damage = 15;
	range = irandom_range(650, 950);
	
	magazine_count = 0;
	burst_count = 0;
	#endregion
	#region Value
	// Set Value
	pointValue = 30;

	#endregion
}
function tankStats_Tiger()
{
	// Set Tank Type
	tankType = tank_type.Tiger;

	// Set Health
	tank_health = 100;
	tank_health_max = tank_health;
	
	#region Sprites Stats
	tank = "Tiger";
	tank_string = "sTank_" + tank + "_";
	sprite_index = asset_get_index(tank_string + "Bottom");
	#endregion
	#region Movement Stats
	tank_move_speed = 0.5;
	tank_turn_speed = 0.4;
	#endregion
	#region Turret Stats
	turret_sprite1 = asset_get_index(tank_string + "Top1");
	turret_speed1 = 0.5;
	#endregion
	#region Armor Stats
	armor_front = 60;
	armor_side = 30;
	armor_back = 15;
	armor_weaknesses = 11;
	#endregion
	#region Gun Stats
	bullet_accuracy = 0.95; // off out of 1
	bullet_reload_time = 300; // milliseconds
	bullet_magazine_size = 1;
	bullet_burst_rate = 1;
	bullet_burst_delay = 6;
	bullet_fire_rate_delay = 1;
	bullet_size = 0.35; // mm
	bullet_penetration = 105;
	bullet_speed = 18; // m/s
	damage = 20;
	
	magazine_count = 0;
	burst_count = 0;
	#endregion
	#region Value
	// Set Value
	pointValue = 55;

	#endregion
}
function tankStats_Panther()
{
	// Set Tank Type
	tankType = tank_type.Panther;

	// Set Health
	tank_health = 100;
	tank_health_max = tank_health;
	
	#region Sprites Stats
	tank = "Panther";
	tank_string = "sTank_" + tank + "_";
	sprite_index = asset_get_index(tank_string + "Bottom");
	#endregion
	#region Movement Stats
	tank_move_speed = 0.75;
	tank_turn_speed = 0.4;
	#endregion
	#region Turret Stats
	turret_sprite1 = asset_get_index(tank_string + "Top1");
	turret_speed1 = 0.35;
	#endregion
	#region Armor Stats
	armor_front = 70;
	armor_side = 35;
	armor_back = 15;
	armor_weaknesses = 9;
	#endregion
	#region Gun Stats
	// Define bullet stats
	bullet_accuracy = 1; // off out of 1
	bullet_reload_time = 280; // milliseconds
	bullet_magazine_size = 1;
	bullet_burst_rate = 1;
	bullet_burst_delay = 6;
	bullet_fire_rate_delay = 1;
	bullet_size = 0.35; // mm
	bullet_penetration = 115;
	bullet_speed = 20; // m/s
	damage = 20;
	range = irandom_range(1000, 1400);
	
	magazine_count = 0;
	burst_count = 0;
	#endregion
	#region Value
	// Set Value
	pointValue = 75;

	#endregion
}
#endregion
#region Russia
function tankStats_T26()
{
	// Set Tank Type
	tankType = tank_type.T26;
	
	// Set Health
	tank_health = 40;
	tank_health_max = tank_health;
	
	#region Sprites Stats
	tank = "T26";
	tank_string = "sTank_" + tank + "_";
	sprite_index = asset_get_index(tank_string + "Bottom");
	#endregion
	#region Movement Stats
	tank_move_speed = 2;
	tank_turn_speed = 1.8;
	#endregion
	#region Turret Stats
	turret_sprite1 = asset_get_index(tank_string + "Top1");
	turret_speed1 = 1;
	#endregion
	#region Armor Stats
	armor_front = 20;
	armor_side = 15;
	armor_back = 5;
	armor_weaknesses = 15;
	#endregion
	#region Gun Stats
	bullet_accuracy = 0.90; // off out of 1
	bullet_reload_time = 180; // milliseconds
	bullet_magazine_size = 5;
	bullet_burst_rate = 5;
	bullet_burst_delay = 0;
	bullet_fire_rate_delay = 80;
	bullet_size = 0.235; // mm
	bullet_penetration = 45;
	bullet_speed = 18; // m/s
	damage = 4;
	range = irandom_range(1000, 1400);
	
	magazine_count = 0;
	burst_count = 0;
	#endregion
	#region Value
	// Set Value
	pointValue = 10;

	#endregion
}
function tankStats_T34()
{
	// Set Tank Type
	tankType = tank_type.T34;

	// Set Health
	tank_health = 70;
	tank_health_max = tank_health;
	
	#region Sprites Stats
	tank = "T34";
	tank_string = "sTank_" + tank + "_";
	sprite_index = asset_get_index(tank_string + "Bottom");
	#endregion
	#region Movement Stats
	tank_move_speed = 0.9;
	tank_turn_speed = 1;
	#endregion
	#region Turret Stats
	turret_sprite1 = asset_get_index(tank_string + "Top1");
	turret_speed1 = 1.1;
	#endregion
	#region Armor Stats
	armor_front = 40;
	armor_side = 20;
	armor_back = 10;
	armor_weaknesses = 12;
	#endregion
	#region Gun Stats
	bullet_accuracy = 0.95; // off out of 1
	bullet_reload_time = 150; // milliseconds
	bullet_magazine_size = 1;
	bullet_burst_rate = 1;
	bullet_burst_delay = 6;
	bullet_fire_rate_delay = 1;
	bullet_size = 0.3; // mm
	bullet_penetration = 80;
	bullet_speed = 18; // m/s
	damage = 15;
	range = irandom_range(650, 950);
	
	magazine_count = 0;
	burst_count = 0;
	#endregion
	#region Value
	// Set Value
	pointValue = 25;

	#endregion
}
function tankStats_KV1()
{
	// Set Tank Type
	tankType = tank_type.KV1;

	// Set Health
	tank_health = 100;
	tank_health_max = tank_health;
	
	#region Sprites Stats
	tank = "KV1";
	tank_string = "sTank_" + tank + "_";
	sprite_index = asset_get_index(tank_string + "Bottom");
	#endregion
	#region Movement Stats
	tank_move_speed = 0.6;
	tank_turn_speed = 0.6;
	#endregion
	#region Turret Stats
	turret_sprite1 = asset_get_index(tank_string + "Top1");
	turret_speed1 = 0.8;
	#endregion
	#region Armor Stats
	armor_front = 60;
	armor_side = 30;
	armor_back = 15;
	armor_weaknesses = 11;
	#endregion
	#region Gun Stats
	bullet_accuracy = 0.98; // off out of 1
	bullet_reload_time = 190; // milliseconds
	bullet_magazine_size = 1;
	bullet_burst_rate = 1;
	bullet_burst_delay = 6;
	bullet_fire_rate_delay = 1;
	bullet_size = 0.35; // mm
	bullet_penetration = 108;
	bullet_speed = 18; // m/s
	damage = 20;
	range = irandom_range(650, 950);
	
	magazine_count = 0;
	burst_count = 0;
	#endregion
	#region Value
	// Set Value
	pointValue = 40;

	#endregion
}
function tankStats_KV2()
{
	// Set Tank Type
	tankType = tank_type.KV2;
	
	// Set Health
	tank_health = 100;
	tank_health_max = tank_health;
	
	#region Sprites Stats
	tank = "KV2";
	tank_string = "sTank_" + tank + "_";
	sprite_index = asset_get_index(tank_string + "Bottom");
	#endregion
	#region Movement Stats
	tank_move_speed = 0.3;
	tank_turn_speed = 0.2;
	#endregion
	#region Turret Stats
	turret_sprite1 = asset_get_index(tank_string + "Top1");
	turret_speed1 = 0.5;
	#endregion
	#region Armor Stats
	armor_front = 65;
	armor_side = 30;
	armor_back = 15;
	armor_weaknesses = 10;
	#endregion
	#region Gun Stats
	bullet_accuracy = 0.75; // off out of 1
	bullet_reload_time = 500; // milliseconds
	bullet_magazine_size = 1;
	bullet_burst_rate = 1;
	bullet_burst_delay = 6;
	bullet_fire_rate_delay = 1;
	bullet_size = 0.50; // mm
	bullet_penetration = 120;
	bullet_speed = 12; // m/s
	damage = 25;
	range = irandom_range(650, 950);
	
	magazine_count = 0;
	burst_count = 0;
	#endregion
	#region Value
	// Set Value
	pointValue = 45;

	#endregion
}
#endregion
#region America
function tankStats_M60A3()
{
	// Set Tank Type
	tankType = tank_type.M60A3;
	
	// Set Health
	tank_health = 120;
	tank_health_max = tank_health;
	
	#region Sprites Stats
	tank = "M60A3";
	tank_string = "sTank_" + tank + "_";
	sprite_index = asset_get_index(tank_string + "Bottom");
	#endregion
	#region Movement Stats
	tank_move_speed = 0.75;
	tank_turn_speed = 0.4;
	#endregion
	#region Turret Stats
	turret_sprite1 = asset_get_index(tank_string + "Top1");
	turret_speed1 = 0.35;
	
	turret_sprite2 = asset_get_index(tank_string + "Top2");
	turret_speed2 = 0.50;
	#endregion
	#region Armor Stats
	armor_front = 80;
	armor_side = 60;
	armor_back = 35;
	armor_weaknesses = 9;
	#endregion
	#region Gun Stats
	// Define bullet stats
	bullet_accuracy = 1; // off out of 1
	bullet_reload_time = 280; // milliseconds
	bullet_magazine_size = 1;
	bullet_burst_rate = 1;
	bullet_burst_delay = 6;
	bullet_fire_rate_delay = 1;
	bullet_size = 0.35; // mm
	bullet_penetration = 115;
	bullet_speed = 20; // m/s
	damage = 12;
	range = irandom_range(1000, 1400);
	
	magazine_count = 0;
	burst_count = 0;
	#endregion
	#region Value
	// Set Value
	pointValue = 75;

	#endregion
}
#endregion