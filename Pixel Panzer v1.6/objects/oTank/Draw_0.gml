var _viewX = camera_get_view_x(view_camera[0]);
var _viewY = camera_get_view_y(view_camera[0]);
var _viewW = camera_get_view_width(view_camera[0]);
var _viewH = camera_get_view_height(view_camera[0]);

// Only whats in view
if (x > _viewX && x < (_viewX + _viewW))
&& (y > _viewY && y < (_viewY + _viewH))
{
	draw_self();
	
	// Calculate the position of the top-left corner of the tank sprite
	var cornerX = x - sprite_width / 2;
	var cornerY = y - sprite_height / 2;

	// Calculate the distance and angle from the center of the tank to the top-left corner
	var distance = point_distance(x, y, cornerX, cornerY);
	var angle = point_direction(x, y, cornerX, cornerY);

	// Rotate the corner position around the center of the tank by the tank's direction, minus 90 degrees
	angle += direction - 90;
	cornerX = x + lengthdir_x(distance, angle);
	cornerY = y + lengthdir_y(distance, angle);

	// Draw the damage mask at the rotated corner position, minus 90 degrees
	draw_surface_ext(damageMask, cornerX, cornerY, image_xscale, image_yscale, direction - 90, c_white, image_alpha);
	
	//draw_surface_ext(damageMask, cornerX+50, cornerY, image_xscale, image_yscale, direction - 90, c_white, image_alpha);

	// Draw the turret sprite with the new direction
	draw_sprite_ext(turret_sprite1, 0, x, y, image_xscale, image_yscale, turret_direction1, image_blend, 1);
	
	// Draw the turret sprite with the new direction
	if turret_sprite2 != -1
		draw_sprite_ext(turret_sprite2, 0, x, y, 1, 1, turret_direction2, image_blend, image_alpha);
	
	// Draw repair symbol
	if (state = AIStates.Repair)
		draw_sprite_ext(sRepair, 0, x-24, y-24, 0.35, 0.35, sin(current_time * 0.01)*50, image_blend, image_alpha);
	
	var _alpha = global.zoomF - 1;
	var _zm = global.zoomF-1.3;

	switch team
	{
		case "Russia":
			draw_sprite_ext(sRussia, 0, x, y, 1*_zm, 1*_zm, 0, image_blend, _alpha);
			break;
		case "Germany":
			draw_sprite_ext(sGermany, 0, x, y, 1*_zm, 1*_zm, 0, image_blend, _alpha);
			break;
		default:
			draw_sprite_ext(sPirate, 0, x, y, 1*_zm, 1*_zm, 0, image_blend, _alpha);
	}


	if(global.zoomF <= 0.4)
	{		
		// Draw repair symbol
		if (state = AIStates.Repair)
		{
			draw_sprite_ext(sRepair, 0, x-24, y-24, 0.35, 0.35, sin(current_time * 0.01)*50, image_blend, image_alpha);
			draw_healthbar(x-18, y-18, x+24, y-24, tank_health / tank_health_max * 100, c_black, c_red, c_green, 0, false, true);
		}

		if (global.Debug)
		{
			draw_line_color(x, y, x + lengthdir_x(50, new_direction), y + lengthdir_y(50, new_direction), c_lime, c_lime);
			draw_line_color(x, y, x + lengthdir_x(500, turret_direction1+90), y + lengthdir_y(500, turret_direction1+90), c_blue, c_blue);
			draw_line_color(x, y, x + lengthdir_x(500, new_turret_direction1-180), y + lengthdir_y(500, new_turret_direction1-180), c_red, c_red);
			draw_text(x, y+30, "Name: " + tank_string + string(id));
			draw_text(x, y+45, "HP: " + string(tank_health));
			draw_text(x, y+60, "State: " + string(state));
		}
	}
}