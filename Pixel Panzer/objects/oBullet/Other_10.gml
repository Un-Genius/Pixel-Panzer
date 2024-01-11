/// @description Hit Tank

// Accuracy check
if (accuracy > random_accuracy*clamp(through_smoke/10, 1, 10))
{
	// Distance check
	if (distance > 50 && (distance_travelled > distance-100 && distance_travelled < distance+100))
	{
		var _x = x;
		var _y = y;
		var _bulletDir = direction;
		var _id = id;
		var _pen = penetration - (distance_travelled*0.05);
		var _acc = accuracy;
		var _dam = damage;
		var _potentialDam = 0;
		var _shooter_id = shooter_id;
		
		#region Audio based on camera

		var _viewX = camera_get_view_x(view_camera[0]);
		var _viewY = camera_get_view_y(view_camera[0]);
		var _viewW = camera_get_view_width(view_camera[0]);
		var _viewH = camera_get_view_height(view_camera[0]);

		var centerX = _viewX + (_viewW/2);
		var centerY = _viewY + (_viewH/2);

		var _dist = point_distance(_x, _y, centerX, centerY);
			
		// Set volume
		var _volume = 0.3;
		
		// Choose sound
		var _snd = noone;

		#endregion
		
		with (collisionTank)
		{
			#region Find which side was hit
			var hit_side = "";
			
			var _frontY = lengthdir_y(20, direction);
			var _frontX = lengthdir_x(20, direction);

			var _backY = -lengthdir_y(26, direction);
			var _backX = -lengthdir_x(26, direction);

			var _rightY = -lengthdir_y(14, direction+90);
			var _rightX = -lengthdir_x(14, direction+90);

			var _leftY = lengthdir_y(14, direction+90);
			var _leftX = lengthdir_x(14, direction+90);
			
			var _posFrontLeftX = (_x-(x+_frontX-_leftX)) * cos(degtorad(direction));
			var _posFrontRightX = (_x-(x+_frontX-_rightX)) * cos(degtorad(direction));
			
			var _posFrontLeftY = (_y-(y+_frontY-_leftY)) * sin(degtorad(direction));
			var _posFrontRightY = (_y-(y+_frontY-_rightY)) * sin(degtorad(direction));
			
			var _posBackLeftX = (_x-(x+_backX-_leftX)) * cos(degtorad(direction));
			var _posBackRightX = (_x-(x+_backX-_rightX)) * cos(degtorad(direction));
			
			var _posBackLeftY = (_y-(y+_backY-_leftY)) * sin(degtorad(direction));
			var _posBackRightY = (_y-(y+_backY-_rightY)) * sin(degtorad(direction));
			
			var _lineFront = (_posFrontLeftX-_posFrontLeftY) + (_posFrontRightX-_posFrontRightY);
			var _lineBack = (_posBackLeftX-_posBackLeftY) + (_posBackRightX-_posBackRightY);

			if (_lineFront > 0) {
			    // Bullet hit the front of the tank
			    hit_side = "front";
			} else if (_lineBack < 0) {
			    // Bullet hit the back of the tank
			    hit_side = "back";
				_dam *= 2
			} else {
			    // Bullet hit the right side of the tank
			    hit_side = "side";
			}
			#endregion
			
			#region Find where to mark bullet hit
				var hitX = abs(x - _x);
				var hitY = abs(y - _y);

				// Create bullet mark
				surface_set_target(damageMask);
					draw_circle(hitX, hitY, 3, true);
				surface_reset_target();

				// Calculate the distance and angle from the center of the tank to the hit position
				var _distMark = point_distance(0, 0, hitX, hitY);
				var _angleMark = point_direction(0, 0, hitX, hitY);

				// Rotate the hit position around the center of the tank by the negative of the tank's direction
				_angleMark -= direction;
				hitX = (sprite_width / 2) + lengthdir_x(_distMark, _angleMark);
				hitY = (sprite_height / 2) + lengthdir_y(_distMark, _angleMark);
				
				// Clamp the hit position to stay within the sprite dimensions
				hitX = clamp(hitX, 8, sprite_width-8);
				hitY = clamp(hitY, 8, sprite_height-8);
				

			#endregion

			#region Calculate effective thickness
			var armor_thickness = 0;
			var _dir = direction;

			if (hit_side == "front") {
			    armor_thickness = armor_front;
				_dir += 180;
			} else if (hit_side == "back") {
			    armor_thickness = armor_back;
			} else {
			    armor_thickness = armor_side;
				_dir += 90;
			}

			var angle_diff = abs(angle_difference(_bulletDir, _dir));

			var effective_thickness = abs(armor_thickness / cos(degtorad(angle_diff)));
			#endregion

			#region Compare thickness to penetration
			if (effective_thickness < _pen) {
			    // Hit a weak point, do damage
			    _potentialDam += _dam;
				
				#region Set volume and audio for hit
				if global.zoomF-0.5 < 0.4
				{
					if _dist < 1000
					{
						_volume = clamp((2000 - _dist) / 800, 0, 0.8);
						_snd = snd_explosion_light;
					}
					else
					{
						if _dist > 1000
						{
							_volume = clamp((2000 - _dist) / 800, 0, 0.8);
							_snd = choose(snd_explosion_far1, snd_explosion_far2, snd_explosion_far3);
						}
					}
				}
				#endregion
				
				part_particles_create(global.P_System, _x, _y, global.ExplosionSmoke, random(5)+2);
				instance_destroy(_id);
			}
			else
			{
			    // Bullet did not penetrate the armor
			    if (_acc > 0.75) {
			        var roll = irandom(100);
			        if (roll <= armor_weaknesses) {
			            // Hit a weak point, do damage
			            _potentialDam += _dam*1.2;
						
						#region Set volume and audio for hit
						if global.zoomF-0.5 < 0.4
						{
							if _dist < 1000
							{
								_volume = clamp((2000 - _dist) / 800, 0, 0.8);
								_snd = snd_explosion_light;
							}
							else
							{
								if _dist > 1000
								{
									_volume = clamp((2000 - _dist) / 800, 0, 0.8);
									_snd = choose(snd_explosion_far1, snd_explosion_far2, snd_explosion_far3);
								}
							}
						}
						#endregion
						
						part_particles_create(global.P_System, x, y, global.ExplosionSmoke, random(5)+2);
						instance_destroy(_id);
			        }
					else
					{
						var _newDir = _bulletDir + _dir-90;
						
						// Create bullet mark
						surface_set_target(damageMask);
						    draw_ellipse_color(hitX, hitY, hitX+2, hitY+5, c_dkgray, c_dkgray, false);
						surface_reset_target();
						
						var partEmit = part_emitter_create(global.P_System);
						part_type_direction(global.pixelPartType, _newDir-60, _newDir+60, 0, 0);
						part_emitter_region(global.P_System, partEmit, x-5, x+5, y-5, y+5, ps_shape_ellipse, ps_distr_linear);
						part_emitter_burst(global.P_System, partEmit, global.pixelPartType, 5);

						// Remember to destroy the emitter after the burst so it doesn't keep emitting
						part_emitter_destroy(global.P_System, partEmit);
					
						_id.direction -= _newDir*2;
						_id.image_angle -= _newDir*2;
						_id.accuracy /= 2;
					}
			    }
				else
				{
					damageText(_x, _y, choose("bounce", "bounce", "boink", "bump", "doink"), 0);
					
					var _newDir = _bulletDir + _dir-90;
					
					_id.direction -= _newDir*2;
					_id.image_angle -= _newDir*2;
					_id.accuracy /= 2;
				}
			}
			#endregion
			
			#region Distribute Points & Bonus damage
			
			if(_potentialDam > 0)
			{
				tank_health -= _potentialDam;
				
				var partEmit = part_emitter_create(global.P_System);
				part_type_direction(global.pixelPartType, _bulletDir+120, _bulletDir+240, 0, 0);
				part_emitter_region(global.P_System, partEmit, x-5, x+5, y-5, y+5, ps_shape_ellipse, ps_distr_linear);
				part_emitter_burst(global.P_System, partEmit, global.pixelPartType, _potentialDam*1.5); // Burst 50 particles at once

				// Remember to destroy the emitter after the burst so it doesn't keep emitting
				part_emitter_destroy(global.P_System, partEmit);
				
				// Create bullet mark
				surface_set_target(damageMask);
				    draw_circle_color(hitX, hitY, random_range(2, 3), c_black, c_dkgray, false); // Draws a black circle to represent the damage
				surface_reset_target();
				
				if(_potentialDam > _dam || hit_side == "back")
					damageText(_x, _y, "critical hit", _potentialDam);
				else
					damageText(_x, _y, "hit", _potentialDam);
				
				// If Dies, add points
				if(tank_health <= 0)
				{
					// Make a death noise
					_snd = choose(snd_explosion_farDead1, snd_explosion_farDead2);
					
					// Set points depending on game type
					switch(global.current_game_type)
					{
						case global.game_type_arr[game_type.free_for_all]:
							if(instance_exists(_shooter_id) && _shooter_id != -1)
							{
								_shooter_id.pointsScored += pointValue;
								
								if(_shooter_id.object_index == oPlayer)
									add_score("Player", pointValue);
								else
								{
									var _idName = string(_shooter_id.id);
									var _numName = string_delete(_idName, 1, 7);
									add_score(_shooter_id.tank + "_" + _numName, pointValue);
								}
							}
							else
								show_debug_message("Shooter does not exist");
							break;
						case global.game_type_arr[game_type.capture_the_flag]:
							break;
						case global.game_type_arr[game_type.gun_game]:
							if(instance_exists(_shooter_id) && _shooter_id != -1)
							{
								with(_shooter_id)
								{
									if(tankType < array_length(global.tank_type_arr)-1)
									{
										tankType++;
										tankTypeSwitch(tankType);
									}
								}
							}
							else
								show_debug_message("Shooter does not exist");
							break;
						case global.game_type_arr[game_type.team_vs_team]:
							// Add points
							switch(team)
							{
								case "Russia":
									global.PointsGermany += pointValue;
									break;
								case "Germany":
									global.PointsRussia += pointValue;
							}
							break;
					}
				}
			}
			
			#endregion
			
		}
		
		if _snd != noone
			audio_play_sound(_snd, 0, false, _volume, 0, random_range(0.4, 1));
	}
}