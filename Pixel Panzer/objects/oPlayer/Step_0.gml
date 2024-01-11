#region Movement & Repair

var key_w = keyboard_check(ord("W"));
var key_s = keyboard_check(ord("S"));
var key_a = keyboard_check(ord("A"));
var key_d = keyboard_check(ord("D"));

var key_ctrl = keyboard_check(vk_control);
var key_shift = keyboard_check(vk_shift);
var key_r = keyboard_check(ord("R"));

// set movement
var move_h = 0;
var move_v = 0;

// Set smoke particles
var _random_offset = irandom_range(-6, 6);
var _engineSmoke_offsetx = x + lengthdir_x(-22, direction+irandom_range(-15, 15)) + _random_offset;
var _engineSmoke_offsety = y + lengthdir_y(-22, direction+irandom_range(-15, 15)) + _random_offset;

part_type_direction(global.EngineSmoke, global.Wind_Direction-irandom_range(25, 35), global.Wind_Direction+irandom_range(25, 35), irandom_range(-2, 2), irandom_range(-2, 2));

part_particles_create(global.P_System, _engineSmoke_offsetx, _engineSmoke_offsety, global.EngineSmoke, 1);

// Apply movement speed
var _speed = 0;
var _turn_speed = tank_turn_speed;

// Move the tank forward based on its direction
if (key_w)
{
    move_v = lengthdir_x(_speed, direction);
    move_h = lengthdir_y(_speed, direction);
	
	_speed = tank_move_speed;
	
	part_particles_create(global.P_System, _engineSmoke_offsetx, _engineSmoke_offsety, global.EngineSmoke, 2);
	
	/*
	repeat(20)
	{
		var _dir = choose(-1, 1);
		
		var _dirtX = x + lengthdir_x(sprite_width/2, direction - (90*_dir));
		var _dirtY = y + irandom_range(-sprite_height/2, sprite_height/2) + lengthdir_y(sprite_width/2, direction - (90*_dir));
		
		_dir = direction - (90*_dir);
		
		part_type_direction(global.Dirt, _dir - 30, _dir + 30, 0, 0);

		_dirtX = x + lengthdir_x(sprite_width/2 * cos(degtorad(direction)), (direction+90* cos(degtorad(direction)) - (90*_dir)));
		_dirtY = y + lengthdir_y(sprite_width/2 * cos(degtorad(direction)), (direction+90* cos(degtorad(direction)) - (90*_dir)));
		
		part_particles_create(global.P_System, _dirtX, _dirtY, global.Dirt, 1);
	}
	*/
}

// Move the tank backwards
if (key_s)
{
    move_v = lengthdir_x(_speed/2, direction)*-1;
    move_h = lengthdir_y(_speed/2, direction)*-1;
	
	_speed = -tank_move_speed / 2;
	
	part_particles_create(global.P_System, _engineSmoke_offsetx, _engineSmoke_offsety, global.EngineSmoke, 2);
}

// Repair
if(key_r)
{
	if(tank_health < tank_health_max)
		tank_health += 0.05;
	
	_speed = 0;
	_turn_speed = 0;
}

// Rotate the tank left
if (key_a)
{
    direction += _turn_speed;
	turret_direction1 += _turn_speed;
	_speed = _speed/1.3;
}

// Rotate the tank right
if (key_d)
{
    direction -= _turn_speed;
	turret_direction1 -= _turn_speed;
	_speed = _speed/1.3;
}

// Move Fast
if (key_shift && boostEnabled) {
    _speed *= boostSpeed;
	part_particles_create(global.P_System, _engineSmoke_offsetx, _engineSmoke_offsety, global.EngineSmoke, 1);
}
	
// Move Slow
if (key_ctrl) {
    _speed /= 2.5;
}
	
if(key_w + key_s + key_a + key_d > 0)
{
	audio_sound_pitch(ins_move, abs(_speed)+0.5);
}
else
	audio_sound_pitch(ins_move, 0.3);
	
//if(keyboard_check_pressed(mb_left))
	//audio_play_sound()

image_angle = direction-90;

speed = _speed;

#endregion

#region Camera

var _viewX = camera_get_view_x(view_camera[0]);
var _viewY = camera_get_view_y(view_camera[0]);
var _viewW = camera_get_view_width(view_camera[0]);
var _viewH = camera_get_view_height(view_camera[0]);

#region Audio based on camera

var centerX = _viewX + (_viewW/2);
var centerY = _viewY + (_viewH/2);

var _dist = point_distance(x, y, centerX, centerY);

var _volume = 0;

if _dist < 600 && global.zoomF-0.5 < 0.4
	_volume = (600 - _dist) / 1200;

// The closer to the center the louder you are
audio_sound_gain(ins_move, _volume, 500);

#endregion

var _gotoX = x - (move_v*-(_speed*10)) - (_viewW * 0.5);
var _gotoY = y - (move_h*-(_speed*10)) - (_viewH * 0.5);

#region Camera Shake

if shakeMag > 0.1
{
shakeMag -= shakeMag / 5;
}
else shakeMag = 0;
{
	_gotoX += -shakeMag*10 + random(shakeMag  * 20)
	_gotoY += -shakeMag*10 + random(shakeMag  * 20)
}

#endregion

// Mouse Wheel Zoom
var _mouseW = mouse_wheel_down() - mouse_wheel_up();

var _newX = lerp(_viewX, _gotoX, 0.1);
var _newY = lerp(_viewY, _gotoY, 0.1);

var _factor = 0.3;
// Here, instead of adding mouse wheel change directly, we add or subtract 0.5.
if (_mouseW > 0) global.zoomF = min(global.zoomF + 0.5, 2);
if (_mouseW < 0) global.zoomF = max(global.zoomF - 0.5, _factor);
//var _mouseW = mouse_wheel_down() - mouse_wheel_up();
global.zoomF = clamp(global.zoomF + (_mouseW * _factor), _factor, 2);

var _z = global.zoomF-0.5;

if(_mouseW != 0)
{
	with(oCloud)
		image_alpha = clamp(_z/2, 0, 0.4);
	
	if (_z >= 0.4)
		with(oPlane)
			image_alpha = 1;
	else
		with(oPlane)
			image_alpha = 0;
}

// then, when setting the view size:
var _lerpH = lerp(_viewH, global.zoomF * 540*2, _factor);
//var _lerpH = lerp(_viewH, global.zoomF * 540*2, _factor);
var _newH = clamp(_lerpH, 0, room_height);
var _newW = _newH * (960 / 540);
camera_set_view_size(view_camera[0], _newW, _newH);

var _offsetX = _newX - (_newW - _viewW) * 0.5;
var _offsetY = _newY - (_newH - _viewH) * 0.5;
_newX = clamp(_offsetX, 0, room_width - _newW);
_newY = clamp(_offsetY, 0, room_height - _newH);

#region Binoculars
if (mouse_check_button(mb_right))
{
	var _newBinocularsX = device_mouse_x_to_gui(0);
	var _newBinocularsY = device_mouse_y_to_gui(0);
	
	var _guiW = display_get_gui_width();
	var _guiH = display_get_gui_height();
	
	var ax = (_guiW/2 - _newBinocularsX)*-1
	
	var ay = (_guiH/2 - _newBinocularsY)*-1
	
	_offsetX += ax;
	_offsetY += ay;
}
else
{
	var _newBinocularsX = device_mouse_x_to_gui(0);
	var _newBinocularsY = device_mouse_y_to_gui(0);
	
	var _guiW = display_get_gui_width();
	var _guiH = display_get_gui_height();
	
	var ax = (_guiW/2 - _newBinocularsX)*-1
	
	var ay = (_guiH/2 - _newBinocularsY)*-1
	
	_offsetX += ax/10;
	_offsetY += ay/10;
}
#endregion

camera_set_view_pos(view_camera[0], _offsetX, _offsetY);

#endregion

#region turrets
#region Turret 1
// Calculate the desired turret direction
var desired_turret_direction1 = point_direction(x, y, mouse_x, mouse_y) + 90;

// Calculate the difference between the current and desired turret direction
var new_turret_rotation1 = angle_difference(turret_direction1, desired_turret_direction1);

// Calculate the difference between the new turret direction and the old direction
var delta_turret_rotation1 = sign(new_turret_rotation1) * min(abs(new_turret_rotation1), turret_speed1);

snd_turret_delay--;

// Stop rotating the turret if it's pointing in the desired direction
if abs(new_turret_rotation1) > 180 - turret_speed1 {
    delta_turret_rotation1 = 0;
	
	if snd_turret_toggle
	{
		snd_turret_toggle = false;
		audio_sound_gain(ins_turret, 0, 500);
	}
}
else
	if !snd_turret_toggle
	{
		snd_turret_toggle = true;
		audio_sound_gain(ins_turret, 0.2, 1500);
	}

#endregion
#region Turret 2
// Calculate the desired turret direction
var desired_turret_direction2 = point_direction(x, y, mouse_x, mouse_y) + 90;

// Calculate the difference between the current and desired turret direction
var new_turret_rotation2 = angle_difference(turret_direction2, desired_turret_direction2);

// Calculate the difference between the new turret direction and the old direction
var delta_turret_rotation2 = sign(new_turret_rotation2) * min(abs(new_turret_rotation2), turret_speed2);

// Stop rotating the turret if it's pointing in the desired direction
if abs(new_turret_rotation2) > 180 - turret_speed2 {
    delta_turret_rotation2 = 0;
}
#endregion
#endregion

#region Smoke Granades

if(keyboard_check_pressed(ord("G")))
	for(var i = -40; i <= 40; i += 20)
	{
		// Set distance and direction
		var _dir = turret_direction1+90+i;
		
		var _inst = instance_create_layer(x, y, "Bullets", oSmoke_granade);
				
		_inst.direction = _dir;
	}

#endregion

#region Switch Tanks
// Switch game type
if(keyboard_check_pressed(ord("1")))
	tankStats_PZ4();
if(keyboard_check_pressed(ord("2")))
	tankStats_Tiger();
if(keyboard_check_pressed(ord("3")))
	tankStats_Panther();
if(keyboard_check_pressed(ord("4")))
	tankStats_T26();
if(keyboard_check_pressed(ord("5")))
	tankStats_T34();
if(keyboard_check_pressed(ord("6")))
	tankStats_KV1();
if(keyboard_check_pressed(ord("7")))
	tankStats_KV2();
#endregion

// Update following variable
if(!instance_exists(followed_by))
	followed_by = -1;

// Update the turret direction
turret_direction1 += delta_turret_rotation1;
turret_direction2 += delta_turret_rotation1 + delta_turret_rotation2;

#region Shooting
#region Turret 1
var _shoot1 = mouse_check_button(mb_left);

newBulletAcc = bullet_accuracy;

if (key_w + key_s > 0)
	if (key_ctrl > 0)
		newBulletAcc /= 1.15;
	else
		if (key_shift > 0)
			newBulletAcc /= 1.35;
		else
			newBulletAcc /= 1.25;
			
if (key_a + key_d > 0)
	newBulletAcc /= 1.2;
	
// Flip value
newBulletAcc = 1-newBulletAcc;

// Check if tank can shoot
if (_shoot1 && can_shoot && (magazine_count <= bullet_magazine_size)) {
    // Check if enough time has passed since last shot
    if (current_time - last_shot_time >= bullet_fire_rate_delay) {
        // Calculate bullet direction based on turret direction
        bullet_direction = turret_direction1+90;
        
        // Calculate random deviation based on accuracy
        bullet_direction += random_range(-newBulletAcc*30, newBulletAcc*30);
        
		// Find barrel offset
		var _bullet_offsetx = x + lengthdir_x(16, turret_direction1+80);
		var _bullet_offsety = y + lengthdir_y(16, turret_direction1+80);
		
		// Set variables to hand off
		var _direction = bullet_direction;
		var _image_angle = bullet_direction+90;
		var _bullet_speed = bullet_speed;
		var _range = bullet_range;
		var _size = bullet_size;
		var _distance = point_distance(_bullet_offsetx, _bullet_offsety, mouse_x, mouse_y);
		var _accuracy = 1-newBulletAcc;
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
		_volume = 0.3;

		if _dist < 1500
			_volume = clamp((2000 - _dist) / 400, 0, 1);
		
		audio_play_sound(snd_explosion_light, 0, false, _volume, 0, random_range(0.4, 1.2));
		
		// Create particles for left and right
		var _bulletParticles_offsetx = x + lengthdir_x(32, turret_direction1+90);
		var _bulletParticles_offsety = y + lengthdir_y(32, turret_direction1+90);
		
		part_type_direction(global.shootSpark, turret_direction1-180, turret_direction1-180, 0, 0);
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
var _shoot2 = keyboard_check(vk_space);
newBulletAcc2 = bullet_accuracy2;

if (key_w + key_s > 0)
	if (key_ctrl > 0)
		newBulletAcc2 /= 1.15;
	else
		if (key_shift > 0)
			newBulletAcc2 /= 1.35;
		else
			newBulletAcc2 /= 1.25;
			
if (key_a + key_d > 0)
	newBulletAcc2 /= 1.2;
	
// Flip value
newBulletAcc2 = 1-newBulletAcc2;

// Check if tank can shoot
if (_shoot2 && can_shoot2 && (magazine_count2 <= bullet_magazine_size2)) {
    // Check if enough time has passed since last shot
    if (current_time - last_shot_time2 >= bullet_fire_rate_delay2) {
        // Calculate bullet direction based on turret direction
        bullet_direction2 = turret_direction2+90;
        
        // Calculate random deviation based on accuracy
        bullet_direction2 += random_range(-newBulletAcc2*30, newBulletAcc2*30);
        
		// Find barrel offset
		var _bullet_offsetx = x + lengthdir_x(16, turret_direction2+80);
		var _bullet_offsety = y + lengthdir_y(16, turret_direction2+80);
		
		// Set variables to hand off
		var _direction = bullet_direction2;
		var _image_angle = bullet_direction2+90;
		var _bullet_speed = bullet_speed2;
		var _range = bullet_range2;
		var _size = bullet_size2;
		var _distance = point_distance(_bullet_offsetx, _bullet_offsety, mouse_x, mouse_y);
		var _accuracy = 1-newBulletAcc2;
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
		
		// Create camera shake
		shakeMag = 10;
		
		// Create particles for left and right
		var _bulletParticles_offsetx = x + lengthdir_x(32, turret_direction2+90);
		var _bulletParticles_offsety = y + lengthdir_y(32, turret_direction2+90);
		
		part_type_direction(global.shootSpark, turret_direction2-180, turret_direction2-180, 0, 0);
		part_particles_create(global.P_System, _bulletParticles_offsetx, _bulletParticles_offsety, global.shootSpark, 2);
		
		part_type_direction(global.shootSpark, turret_direction2, turret_direction2, 0, 0);
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

// Check Health
if(tank_health <= 0)
{
	instance_destroy(self);
}