/// @description Recreate Player

// Inherit the parent event
event_inherited();

audio_stop_sound(ins_move);
audio_stop_sound(ins_turret);

if(tank_health < tank_health_max)
{
	// Set rules for game type
	switch(global.current_game_type)
	{
		#region Free For All
		case global.game_type_arr[game_type.free_for_all]:
			var _randTank = global.tank_type_arr[irandom(array_length(global.tank_type_arr)-1)];
			var _inst = instance_create_layer(irandom(room_width), irandom(room_height), "Instances", oPlayer);
			
			with(_inst)
			{
				tankTypeSwitch(_randTank);
			}
			break;
		#endregion
		#region Capture the Flag
		case global.game_type_arr[game_type.capture_the_flag]:
			// Make Player
			_randTank = global.tank_type_arr[choose(tank_type.PZ4, tank_type.Tiger, tank_type.Panther)];
			_randPosX = irandom(room_width);
			_randPosY = room_height - irandom(room_height/6);
			
			_inst = instance_create_layer(_randPosX, _randPosY, "Instances", oPlayer);
				
			with(_inst)
			{
				tankTypeSwitch(_randTank);
			}
			break;
		#endregion
		#region Gun Game
		case global.game_type_arr[game_type.gun_game]:
			var _inst = instance_create_layer(irandom(room_width), irandom(room_height), "Instances", oPlayer);
			
			with(_inst)
			{
				tankType = 0;
				tankTypeSwitch(tankType);
				team = "-1";
			}
			break;
		#endregion
		#region Team vs Team
		case global.game_type_arr[game_type.team_vs_team]:
			var _randTank = global.tank_type_arr[choose(tank_type.PZ4, tank_type.Tiger, tank_type.Panther)];
			var _randPosX = irandom(room_width);
			var _randPosY = room_height - irandom(room_height/6);
			
			var _inst = instance_create_layer(_randPosX, _randPosY, "Instances", oPlayer);
			
			with(_inst)
			{
				tankTypeSwitch(_randTank);
			}
			break;
		#endregion
		#region Chaos
		case global.game_type_arr[game_type.chaos]:
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
			break;
		#endregion
		default:
			instance_create_layer(room_width/2, room_height/2, "Instances", oPlayer);
	}
}