// set movement
var move_h = 0;
var move_v = 0;

// Apply movement speed
var _speed = 0;
speed = 0;

// Apply image angle
image_angle = direction-90;

// Set Shooting
state_shoot = false;
optimizeTimer--;

if(enemyDist > view && view != -1)
	enemy_tank = -1;

if(optimizeTimer < 0 || (!instance_exists(enemy_tank) && enemy_tank != -1))
{
	#region Find Enemy

	// Check if exists
	if(instance_exists(oTank))
	{
		var _minDist = view;
	
		// Check through all tanks
		for(var i = 0; i < instance_number(oTank); i++)
		{
			// Find nearest baddy
			var _inst = instance_find(oTank, i);
	
			if((_inst.team != team || team == -1) && _inst != id)
			{
				var _dist = distance_to_object(_inst);
			
				if(_dist < _minDist || _minDist = -1)
				{
					_minDist = _dist;
					enemy_tank = _inst;
				}
			}
		}
	}
	else
		enemy_tank = -1;
	#endregion
	
	optimizeTimer = 10;
}

#region Enemy Variables
if(instance_exists(enemy_tank) && enemy_tank != -1)
{
	var _id = enemy_tank.id;
	
	enemyIntersectDir = intercept_course(id, _id, bullet_speed) - 180;
	
	enemyDist = distance_to_object(enemy_tank);
}
#endregion
else
#region Check Idle State
{
	enemy_tank = -1;

	if (state != AIStates.Wander && state != AIStates.Repair && state != AIStates.Follow && state != AIStates.Objective)
	{
		state = AIStates.Idle;
	}
}
#endregion

#region Audio based on camera

var _viewX = camera_get_view_x(view_camera[0]);
var _viewY = camera_get_view_y(view_camera[0]);
var _viewW = camera_get_view_width(view_camera[0]);
var _viewH = camera_get_view_height(view_camera[0]);

var centerX = _viewX + (_viewW/2);
var centerY = _viewY + (_viewH/2);

var _dist = point_distance(x, y, centerX, centerY);

var _volume = 0;

if _dist < 600 && global.zoomF-0.5 < 0.4
	_volume = (600 - _dist) / 1200;

// The closer to the center the louder you are
audio_sound_gain(ins_move, _volume, 500);

#endregion

// AI state maschine
switch(state)
{
	// Default states
	#region Idle
    case AIStates.Idle: // Sit and wait to be acted upon
		random_timer--;
		new_turret_direction1 = image_angle-90;
		
		#region Check Wander State
		if(point_distance(x, y, start_x, start_y) >= random_timer*8)
		{
			state = AIStates.Wander;
			start_x = x;
			start_y = y;
		}		
		#endregion
		#region Check Objective State
		if(instance_exists(oObjective))
		{
			state = AIStates.Objective;
		}
		#endregion
		#region Check React state
		// Check if bullets exist
		if(instance_exists(oBullet))
		{
			var _bullet = instance_nearest(x, y, oBullet);
			
			// Check if bullet is near
			if(distance_to_object(_bullet) < range*0.7)
			{
				if(instance_exists(enemy_tank)) // && distance_to_object(enemy_tank) < range*1.5)
				{
					// Switch state
					state = AIStates.React;
				}
			}
		}
		#endregion
		#region Check Enemy Detected state
		if(checkEnemyDetected())
		{
			state = AIStates.Aggro;
		}
		#endregion
		#region Check Follow State
		if(state == "idle")
		{
			if(instance_exists(oPlayer) && oPlayer.team == team && team != -1)
				state = AIStates.Follow;
		}
		#endregion
        break;
	#endregion
	#region Wander
    case AIStates.Wander: // Move randomly	
		// Set speed
		_speed = tank_move_speed;
		
		random_timer--;
		
		if(point_distance(x, y, start_x, start_y) == 0)
		{
			// Choose a random direction
			new_direction = new_direction + irandom_range(-95, 95);
			
			random_timer = random_range(3, 8)*room_speed;
			
			start_x += 1;
		}
		
		#region Check Idle State
		if(point_distance(x, y, start_x, start_y) >= random_timer*8)
		{
			state = AIStates.Idle;
			random_timer = random_range(3, 6)*room_speed;
			start_x = x;
			start_y = y;
		}
		#endregion
		#region Check React state
		// Check if bullets exist
		if(instance_exists(oBullet))
		{
			var _bullet = instance_nearest(x, y, oBullet);
			
			// Check if bullet is near
			if(distance_to_object(_bullet) < range*0.7)
			{
				if(instance_exists(enemy_tank)) // && distance_to_object(enemy_tank) < range*1.5)
				{
					// Switch state
					state = AIStates.React;
				}
			}
		}
		#endregion
		#region Check Enemy Detected state
		if(checkEnemyDetected())
		{
			state = AIStates.Aggro;
		}
		#endregion
		#region Check Follow State
		if(state == "idle")
		{
			if(instance_exists(oPlayer) && oPlayer.team == team && team != -1)
				state = AIStates.Follow;
		}
		#endregion
        break;
	#endregion
	#region Follow
	case AIStates.Follow: // Follow a team mate
	
		new_turret_direction1 = image_angle-90;
	
		if(instance_exists(oPlayer))
		{			
			if(following == -1)
			{
				var _follow_tank = oPlayer.followed_by;
				
				if(_follow_tank == -1)
				{
					oPlayer.followed_by = id;
					following = oPlayer;
				}
				else
				{
					while(following == -1)
					{
						
						if(_follow_tank.followed_by != -1)
							_follow_tank = _follow_tank.followed_by;
						else
						{
							_follow_tank.followed_by = id;
							following = _follow_tank;
						}
					}
				
					_follow_tank.followed_by = id;
					following = _follow_tank;
				}
			}
				
			new_direction = point_direction(x, y, following.x, following.y);
			
			if(distance_to_object(following) > 30)
			{
				_speed = tank_move_speed;
			}
		}
		else
		{
			state = AIStates.Idle;
			stopFollowState();
		}
	
		#region Check React state
		// Check if bullets exist
		if(instance_exists(oBullet))
		{
			// Check if bullet is near
			if(instance_nearest(x, y, oBullet) < range*0.8)
			{
				if(instance_exists(enemy_tank) && enemy_tank != -1 && instance_nearest(x, y, enemy_tank) < range*1.3)
				{
					// Switch state
					state = AIStates.React;
					stopFollowState();
				}
			}
		}
		#endregion
		#region Check Enemy Detected state
		if(checkEnemyDetected())
		{
			state = AIStates.Aggro;
			stopFollowState();
		}
		#endregion
		break;
	#endregion
	#region Objective
    case AIStates.Objective: // Move randomly	
		// Set speed
		_speed = tank_move_speed;
		
		new_turret_direction1 = image_angle-90;
		
		random_timer--;
		
		if(point_distance(x, y, start_x, start_y) == 0 || random_timer < 0)
		{
			var _objectiveDir = point_direction(x, y, oObjective.x, oObjective. y);
			
			new_direction = _objectiveDir + irandom_range(-45, 45);
			
			random_timer = random_range(3, 8)*room_speed;
			
			start_x += 1;
		}
		
		#region Check Enemy Detected state
		if(checkEnemyDetected())
		{
			state = AIStates.Aggro;
		}
		#endregion
		#region Check Follow State
		if(state == "idle")
		{
			if(instance_exists(oPlayer) && oPlayer.team == team && team != -1)
				state = AIStates.Follow;
		}
		#endregion
        break;
	#endregion
	
	// Behavioural states
	#region aggro
	case AIStates.Aggro:
		if(enemyDist < range)
			state_shoot = true;
		
		new_direction = point_direction(x, y, enemy_tank.x, enemy_tank.y);
		
		start_x = x;
		start_y = y;
		
		#region Check Retreat State
		if(tank_health <= tank_health_max/3)
		{
			state = AIStates.Retreat;
		}
		#endregion
		else
		if(enemyDist < range*0.2)
		{
			var _rand = irandom(1);
			switch _rand
			{
				case 0:
					state = AIStates.Retreat_Inch;
					break;
				case 1:
					state = AIStates.Retreat_Angle;
			}
		}
		else
		#region Check Circling State
		if(enemyDist <= 400 && tank_move_speed > 0.8)
		{
			state = AIStates.Attack_Circle;
		}
		#endregion
		else
		#region Check Weave State
		if(tank_move_speed > 1)
		{
			state = AIStates.Attack_Weave;
		}
		#endregion
		else
		#region Check Chase State
		if(enemyDist >= range*0.8)
		{
			state = AIStates.Attack_Chase;
		}
		#endregion
		else
		#region Check Inch / Angling Attack
		if(enemyDist > range*0.35)
		{
			var _rand = irandom(2);
			switch _rand
			{
				case 0:
					state = AIStates.Attack_Inch;
					break;
				case 1:
					state = AIStates.Attack_Angle;
					break;
				case 2:
					state = AIStates.Attack_Sit;
			}
		}
		#endregion
		else
		#region Check random states
		{
			state = AIStates.Attack_Sit;
		}
		#endregion
		break;
	#endregion
	#region React
	case AIStates.React: // Speed either left or right and use smoke
		// Set speed
		_speed = tank_move_speed*1.2;
		
		random_timer--;
		
		// Set a new direction to run to and make smoke granades
		if(point_distance(x, y, start_x, start_y) == 0)
		{
			// Set a specific new direction
			new_direction += choose(-irandom_range(50, 80), irandom_range(50, 80));
			new_turret_direction1 = new_direction - 90 + irandom_range(-25, 25);
			
			var _rand = irandom(10);
			if(_rand <= 2)
			{
				for(var i = -40; i <= 40; i += 20)
				{
					// Set distance and direction
					var _dir = turret_direction1+90+i;
		
					var _inst = instance_create_layer(x, y, "Bullets", oSmoke_granade);
				
					_inst.direction = _dir;
				}
			}
			
			random_timer = random_range(1, 3)*room_speed;
			
			start_x += 1;
		}
		
		if(random_timer <= 0)
		{
			if(tank_health < tank_health/2.5)
			{
				state = AIStates.Retreat;
			}
			else
			{
				var _rand = irandom(10)
				
				new_direction = point_direction(x, y, enemy_tank.x, enemy_tank.y);
				
				#region Check Weave State
				if(tank_move_speed > 1)
				{
					state = AIStates.Retreat_Weave;
				}
				#endregion
				else
				if(_rand < 5)
					state = AIStates.Retreat_Inch;
				else
					state = AIStates.Retreat_Weave;
			}
		}
		break;
	#endregion
	
	// Low health states
	#region Retreat
	case AIStates.Retreat: // Pull back while attacking
		// Set shooting
		if(enemyDist < range)
			state_shoot = true;
		
		random_timer--;
		
		_speed = -tank_move_speed*0.55;
		
		if(enemyDist < 600 - (_speed*50))
		{
			// Reverse Runaway
			new_direction = enemyIntersectDir - 180;
		}
		else
		{
			// Run away, full speed
			_speed = tank_move_speed*1.1;
			new_direction = enemyIntersectDir;
		}
		
		new_turret_direction1 = enemyIntersectDir;
		
		// Create smoke
		if(point_distance(x, y, start_x, start_y) == 0)
		{			
			random_timer = random_range(8, 14)*room_speed;
				
			start_x += 1;
			
			var _rand = irandom(10);
			
			if(_rand <= 2)
			{
				for(var i = -70; i <= 70; i += 40)
				{
					// Set distance and direction
					var _dir = turret_direction1+90+i;
		
					var _inst = instance_create_layer(x, y, "Bullets", oSmoke_granade);
				
					_inst.direction = _dir;
				}
			}
		}
			
		if(enemyDist > enemy_tank.range)
		{
			state = AIStates.Repair;
		}
		break;
	#endregion
	#region Repair
	case AIStates.Repair: // Become immobile and repair
		tank_health += 0.02;

		if(tank_health >= tank_health_max)
		{
			state = AIStates.Aggro;
		}
		
		if(instance_exists(enemy_tank) && enemy_tank != -1 && point_distance(x, y, enemy_tank.x, enemy_tank.y) < enemy_tank.range*1.2)
		{
			if(tank_health > tank_health_max/2)
			{
				state = AIStates.Aggro;
			}
			else
			{
				state = AIStates.Retreat;
				random_timer = random_range(6, 10)*room_speed;
			}
		}
		break;
	#endregion
	
	// aggro states
	#region Sit Attack
	case AIStates.Attack_Sit:
		if(enemyDist < range)
			state_shoot = true;
		random_timer--;
		
		new_turret_direction1 = enemyIntersectDir;
		
		// Set a new direction
		if(point_distance(x, y, start_x, start_y) <= 0.5)
		{
			// Set a specific new direction
			new_direction = point_direction(x, y, enemy_tank.x, enemy_tank.y);
			
			random_timer = irandom_range(3, 5) * room_speed;
			start_x += 1;
		}
		
		if(random_timer <= 0 || enemyDist < range*0.15 || tank_health <= tank_health_max/3)
		{
			state = AIStates.Aggro;
		}
		break;
	#endregion
	#region Chase Attack
	case AIStates.Attack_Chase: // Move directly towards enemy until close enough
		if(enemyDist < range)
			state_shoot = true;
		
		_speed = tank_move_speed;
		
		new_direction = enemyIntersectDir-180;
		new_turret_direction1 = enemyIntersectDir;
		
		if(enemyDist < range*0.85)
		{
			state = AIStates.Aggro
		}
		break;
	#endregion
	#region Weave Attack
	case AIStates.Attack_Weave: // Move towards enemy while turning left & right
		if(enemyDist < range)
			state_shoot = true;
		
		random_timer--;
		
		_speed = tank_move_speed;
		
		new_turret_direction1 = enemyIntersectDir;
		
		// Set a new direction
		if(random_timer <= 0)
		{
			var _offsetDir = choose(-irandom_range(25, 40), irandom_range(25, 40));
			// Set a specific new direction
			new_direction = enemyIntersectDir - 180 + _offsetDir;
			
			random_timer = 2 * room_speed;
			
			// Set a new direction
			if(enemyDist < range*0.5)
			{
				state = AIStates.Retreat_Weave;
			}
		}
		
		if(enemyDist <= 400)
		{
			state = AIStates.Attack_Circle;
			
			start_x = x;
			start_y = y;
		}
		break;
	#endregion
	#region Angling Attack
	case AIStates.Attack_Angle: // Angle armor while shooting
		if(enemyDist < range)
			state_shoot = true;
		random_timer--;
		
		if(can_shoot)
		{
			random_direction--;
			
			if(random_direction <= 0)
				if(enemyDist < range)
					state_shoot = true;
		}
		else
		{
			random_direction = 0.6 * room_speed;
			_speed = tank_move_speed*0.25;
			state_shoot = false;
		}
		
		if(!can_shoot)
			_speed = tank_move_speed;
		
		new_turret_direction1 = enemyIntersectDir;
		
		var _dif = angle_difference(new_turret_direction1, direction);
		
		// Set a new direction
		if(point_distance(x, y, start_x, start_y) <= 0.5)
		{
			var _offsetDir = choose(-irandom_range(35, 50), irandom_range(35, 50));
			// Set a specific new direction
			new_direction = enemyIntersectDir + _offsetDir;
			random_timer = irandom_range(5, 7) * room_speed;
			random_direction = 0.3 * room_speed;
		}
		
		if(random_timer <= 0 || checkHealth() || (_dif > 60 && random_timer < 4*room_speed))
		{
			state = AIStates.Aggro;
		}
		
		if(enemyDist < range*0.2)
		{
			state = AIStates.Attack_Circle;
		}
		break;
	#endregion
	#region Circling Attack
	case AIStates.Attack_Circle: // Circle an enemy while shooting
		if(enemyDist < range)
			state_shoot = true;
		random_timer--;
		
		_speed = tank_move_speed;
		
		// Choose random circle direction
		if(point_distance(x, y, start_x, start_y) == 0)
		{
			random_direction = choose(-90, 90);
			
			random_timer = irandom_range(15, 20) * room_speed;
		}
		
		new_turret_direction1 = enemyIntersectDir;
		
		var _circleStartDir = new_turret_direction1 + random_direction;
		
		var _newX = enemy_tank.x + lengthdir_x(800/tank_turn_speed, _circleStartDir);
		var _newY = enemy_tank.y + lengthdir_y(800/tank_turn_speed, _circleStartDir);
		
		// Set a specific new direction
		new_direction = point_direction(x, y, _newX, _newY);
		
		if(random_timer <= 0 || checkHealth())
		{
			state = AIStates.Aggro;
		}
		break;
	#endregion
	#region Inch Forward
	case AIStates.Attack_Inch: // why not
		random_timer--;
		
		if(can_shoot)
		{
			random_direction--;
			
			if(random_direction <= 0)
				if(enemyDist < range)
					state_shoot = true;
		}
		else
		{
			random_direction = 0.6 * room_speed;
			_speed = tank_move_speed*0.25;
			state_shoot = false;
		}
		
		new_turret_direction1 = enemyIntersectDir;
		
		// Set a new direction
		if(point_distance(x, y, start_x, start_y) == 0)
		{
			// Set a specific new direction
			new_direction = enemyIntersectDir-180;
			
			random_timer = irandom_range(10, 15) * room_speed;
			
			random_direction = 0.3 * room_speed;
			start_x += 1;
		}
		
		if(random_timer <= 0 || checkHealth())
		{
			state = AIStates.Aggro;
		}
		
		if(enemyDist < range*0.2)
		{
			state = AIStates.Attack_Circle;
		}
		break;
	#endregion
	
	// Retaliate states
	#region Inch Back
	case AIStates.Retreat_Inch: // Pull back while reloading	
		if(enemyDist < range)
			state_shoot = true;
		random_timer--;
		
		if(!can_shoot)
			_speed = -tank_move_speed/1.5;
		
		new_turret_direction1 = enemyIntersectDir;
		
		// Set a new direction
		if(point_distance(x, y, start_x, start_y) == 0)
		{
			// Set a specific new direction
			new_direction = point_direction(x, y, enemy_tank.x, enemy_tank.y);
			random_timer = irandom_range(3, 5) * room_speed;
		}
		
		if(random_timer <= 0 && checkHealth())
		{
			state = AIStates.Retreat;
			
			start_x = x;
			start_y = y;
		}
		else
		if(random_timer <= 0 && enemyDist > range*0.4)
		{
			state = AIStates.Aggro
		}
		break;
	#endregion
	#region Angling backward
	case AIStates.Retreat_Angle: // Pull back while reloading	
		if(enemyDist < range)
			state_shoot = true;
		random_timer--;
		
		if(can_shoot)
		{
			random_direction--;
			
			if(random_direction <= 0)
				if(enemyDist < range)
					state_shoot = true;
		}
		else
		{
			random_direction = 0.6 * room_speed;
			_speed = -tank_move_speed*0.50;
			state_shoot = false;
		}
		
		new_turret_direction1 = enemyIntersectDir;
		
		// Set a new direction
		if(point_distance(x, y, start_x, start_y) <= 0.5)
		{
			var _offsetDir = choose(-irandom_range(35, 50), irandom_range(35, 50));
			// Set a specific new direction
			new_direction = enemyIntersectDir + _offsetDir;
			
			random_timer = irandom_range(3, 5) * room_speed;
			random_direction = 0.6 * room_speed;
		}
		
		if(random_timer <= 0 && checkHealth())
		{
			state = AIStates.Retreat;
			
			start_x = x;
			start_y = y;
		}
		else
		if(random_timer <= 0 && enemyDist > range*0.5)
		{
			state = AIStates.Aggro
		}
		break;
	#endregion
	#region Weave backward
	case AIStates.Retreat_Weave: // Move towards enemy while turning left & right
		if(enemyDist < range)
			state_shoot = true;
		
		random_timer--;
		
		_speed = tank_move_speed;
		
		new_turret_direction1 = enemyIntersectDir;
		
		// Set a new direction
		if(random_timer <= 0)
		{
			var _offsetDir = choose(-irandom_range(25, 40), irandom_range(25, 40));
			// Set a specific new direction
			new_direction = enemyIntersectDir + _offsetDir;
			
			random_timer = 2 * room_speed;
			
			// Set a new direction
			if(enemyDist > range*0.8)
			{
				state = AIStates.Aggro;
			}
		}
		break;
	#endregion
}

#region Turn Turrets
#region Turret1
// Calculate the difference between the current and desired turret direction
var _new_turret_direction1 = angle_difference(turret_direction1+90, new_turret_direction1);
		
var turret_diff1 = sign(_new_turret_direction1) * min(abs(_new_turret_direction1), turret_speed1);
		
if (abs(_new_turret_direction1) > 179 - turret_speed1)
{
	turret_diff1 = 0;
}	
#endregion
#region Turret2
// Calculate the difference between the current and desired turret direction
var _new_turret_direction2 = angle_difference(turret_direction2+90, new_turret_direction2);
		
var turret_diff2 = sign(_new_turret_direction2) * min(abs(_new_turret_direction2), turret_speed2);
		
if (abs(_new_turret_direction2) > 180 - turret_speed2)
{
	turret_diff2 = 0;
}	
#endregion
#endregion

#region Turn Chassis
// Calculate the difference between the current and desired direction
var chassis_diff = angle_difference(direction, new_direction-180);

// calculate difference between current direction and wander direction
chassis_diff = sign(chassis_diff) * min(abs(chassis_diff), tank_turn_speed);
	
// if difference is greater than 180, rotate the tank to the wander direction
if (abs(chassis_diff) > 180 - tank_turn_speed)
{
	chassis_diff = 0;
}	
#endregion

#region Engine Smoke
smokeCounter++;

// Set smoke particles
var _random_offset = irandom_range(-6, 6);
var _engineSmoke_offsetx = x + lengthdir_x(-18, direction+irandom_range(-10, 10)) + _random_offset;
var _engineSmoke_offsety = y + lengthdir_y(-18, direction+irandom_range(-10, 10)) + _random_offset;

if(smokeCounter >= 8)
{
	smokeCounter = 0;


	part_type_direction(global.EngineSmoke, global.Wind_Direction-irandom_range(25, 35), global.Wind_Direction+irandom_range(25, 35), irandom_range(-2, 2), irandom_range(-2, 2));

	part_particles_create(global.P_System, _engineSmoke_offsetx, _engineSmoke_offsety, global.EngineSmoke, 1);
}
#endregion

#region Shooting
#region Turret 1
// Check if tank can shoot
if (state_shoot && turret_diff1 == 0 && can_shoot && (magazine_count <= bullet_magazine_size)) {
	// Check if enough time has passed since last shot
	if (current_time - last_shot_time >= bullet_fire_rate_delay) {
		// Calculate bullet direction based on turret direction
		bullet_direction = turret_direction1+90;
		
		// Lower accuracy while moving
		var _realtime_accuracy = bullet_accuracy;
		if (move_h != 0 || move_v != 0)
			_realtime_accuracy /= 1.3;
		
		// Flip value
		_realtime_accuracy = 1-_realtime_accuracy;
        
		// Calculate random deviation based on accuracy
		bullet_direction += random_range(-_realtime_accuracy*30, _realtime_accuracy*30);
        
		// Find barrel offset
		var _bullet_offsetx = x + lengthdir_x(16, turret_direction1+80);
		var _bullet_offsety = y + lengthdir_y(16, turret_direction1+80);
		
		// Set variables to hand off
		var _direction = bullet_direction;
		var _image_angle = bullet_direction+90;
		var _bullet_speed = bullet_speed;
		var _range = bullet_range;
		var _size = bullet_size;
		var _distance = point_distance(_bullet_offsetx, _bullet_offsety, enemy_tank.x, enemy_tank.y);
		var _accuracy = 1-_realtime_accuracy;
		var _penetration = bullet_penetration;
		var _damage = damage;
		var _shooter_id = id;

		// Create bullet object and set its stats
		var _bullet = instance_create_layer(_bullet_offsetx, _bullet_offsety, "Bullets", oBullet);
		
		with(_bullet)
		{
			direction = _direction;
			image_angle = _image_angle;
			speed = _bullet_speed;
			range = _range;
			size = _size;
			image_xscale = _size;
			image_yscale = _size;
			distance = _distance;
			accuracy = _accuracy;
			penetration = _penetration;
			damage = _damage;
			shooter_id = _shooter_id;
		}
        
		// Update shooting variables
		magazine_count += 1;
		burst_count += 1;
		last_shot_time = current_time;
		
		// Create camera shake
		shakeMag = 10;
		
		// Create sound
		_volume = 0.1;

		if _dist < 2000
			_volume = clamp((1500 - _dist) / 1400, 0, 0.7);
		
		audio_play_sound(snd_explosion_far1, 0, false, _volume, 0, random_range(0.4, 1.2));
		
		// Create particles for left and right
		var _bulletParticles_offsetx = x + lengthdir_x(32, turret_direction1+90);
		var _bulletParticles_offsety = y + lengthdir_y(32, turret_direction1+90);
		
		part_type_direction(global.shootSpark, turret_direction1, turret_direction1, 0, 0);
		part_particles_create(global.P_System, _bulletParticles_offsetx, _bulletParticles_offsety, global.shootSpark, 2);
		
		part_type_direction(global.shootSpark, turret_direction1, turret_direction1, 0, 0);
		part_particles_create(global.P_System, _bulletParticles_offsetx, _bulletParticles_offsety, global.shootSpark, 2);
		
		// Check if burst is complete
		if (burst_count >= bullet_burst_rate) {
		    burst_count = 0;
		    can_shoot = false;
		    bullet_reload_timer = bullet_burst_delay;
		}
		
		// Check if magazine is complete
		if (magazine_count >= bullet_magazine_size) {
		    magazine_count = 0;
			burst_count = 0;
		    can_shoot = false;
		    bullet_reload_timer = bullet_reload_time;
		}
	}
}

// Reload if necessary
if (!can_shoot)
{
	if(bullet_reload_timer >= 0)
		bullet_reload_timer--;
	else
		can_shoot = true;
}
#endregion
#region Turret 2
// Check if tank can shoot
if (state_shoot2 && turret_diff2 == 0 && can_shoot2 && (magazine_count2 <= bullet_magazine_size2)) {
	// Check if enough time has passed since last shot
	if (current_time - last_shot_time2 >= bullet_fire_rate_delay2) {
		// Calculate bullet direction based on turret direction
		bullet_direction2 = turret_direction2+90;
		
		// Lower accuracy while moving
		var _realtime_accuracy = bullet_accuracy2;
		if (move_h != 0 || move_v != 0)
			_realtime_accuracy /= 1.3;
		
		// Flip value
		_realtime_accuracy = 1-_realtime_accuracy;
        
		// Calculate random deviation based on accuracy
		bullet_direction2 += random_range(-_realtime_accuracy*30, _realtime_accuracy*30);
        
		// Find barrel offset
		var _bullet_offsetx = x + lengthdir_x(16, turret_direction2+80);
		var _bullet_offsety = y + lengthdir_y(16, turret_direction2+80);
		
		// Set variables to hand off
		var _direction = bullet_direction2;
		var _image_angle = bullet_direction2+90;
		var _bullet_speed = bullet_speed2;
		var _range = bullet_range2;
		var _size = bullet_size2;
		var _distance = point_distance(_bullet_offsetx, _bullet_offsety, enemy_tank.x, enemy_tank.y);
		var _accuracy = 1-_realtime_accuracy;
		var _penetration = bullet_penetration2;
		var _damage = damage2;
		var _shooter_id = id;

		// Create bullet object and set its stats
		var _bullet = instance_create_layer(_bullet_offsetx, _bullet_offsety, "Bullets", oBullet);
		
		with(_bullet)
		{
			direction = _direction;
			image_angle = _image_angle;
			speed = _bullet_speed;
			range = _range;
			size = _size;
			image_xscale = _size;
			image_yscale = _size;
			distance = _distance;
			accuracy = _accuracy;
			penetration = _penetration;
			damage = _damage;
			shooter_id = _shooter_id;
		}
        
		// Update shooting variables
		magazine_count2 += 1;
		burst_count2 += 1;
		last_shot_time2 = current_time;
		
		// Create particles for left and right
		var _bulletParticles_offsetx = x + lengthdir_x(32, turret_direction2+90);
		var _bulletParticles_offsety = y + lengthdir_y(32, turret_direction2+90);
		
		part_type_direction(global.shootSpark, turret_direction2, turret_direction2, 0, 0);
		part_particles_create(global.P_System, _bulletParticles_offsetx, _bulletParticles_offsety, global.shootSpark, 2);
		
		part_type_direction(global.shootSpark, turret_direction2, turret_direction1, 0, 0);
		part_particles_create(global.P_System, _bulletParticles_offsetx, _bulletParticles_offsety, global.shootSpark, 2);
		
		// Check if burst is complete
		if (burst_count2 >= bullet_burst_rate2) {
		    burst_count2 = 0;
		    can_shoot2 = false;
		    bullet_reload_timer2 = bullet_burst_delay2;
		}
		
		// Check if magazine is complete
		if (magazine_count2 >= bullet_magazine_size2) {
		    magazine_count2 = 0;
			burst_count2 = 0;
		    can_shoot2 = false;
		    bullet_reload_timer2 = bullet_reload_time2;
		}
	}
}

// Reload if necessary
if (!can_shoot2)
{
	if(bullet_reload_timer2 >= 0)
		bullet_reload_timer2--;
	else
		can_shoot2 = true;
}
#endregion
#endregion

#region Apply Movement and Rotation
audio_sound_pitch(ins_move, 0.3);

if (_speed != 0)
{
	// move the tank forward based on its direction
	//move_h = lengthdir_x(_speed, direction);
	//move_v = lengthdir_y(_speed, direction);
	
	speed = _speed;
	
	audio_sound_pitch(ins_move, abs(_speed)+0.5);

	part_particles_create(global.P_System, _engineSmoke_offsetx, _engineSmoke_offsety, global.EngineSmoke, 1);
}

if(chassis_diff > 0)
	audio_sound_pitch(ins_move, _speed+0.5);

// Apply Movement
x += move_h;
y += move_v;

// Update directions
direction += chassis_diff;

turret_direction1 += turret_diff1 + chassis_diff;
turret_direction1 += turret_diff1 + turret_diff2 + chassis_diff;
#endregion

// Emit smoke particles based on health
var _particleAmount = (((tank_health/tank_health_max)*5)-5)*-1;

if _particleAmount > round(_particleAmount)/2
{
	part_type_alpha2(global.DamagedSmoke, _particleAmount/10, 0.1);
	part_type_direction(global.DamagedSmoke, global.Wind_Direction-30, global.Wind_Direction+30, irandom_range(-2, 2), irandom_range(-2, 2));
	part_particles_create(global.P_System, x, y, global.DamagedSmoke, round(_particleAmount)/2);
}

// Check Health
if(tank_health <= 0)
{
	instance_destroy(self);
}