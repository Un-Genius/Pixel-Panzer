if(global.zoomF <= 0.8)
{
	// Draw Reload Pie
	draw_circular_bar(x, y, bullet_reload_timer, bullet_reload_time, c_white, 42, 0.6, 6);

	// Draw Health Pie
	draw_pie(x, y, tank_health, tank_health_max, c_olive, 32, 0.6);
}

/*/ Draw Event
shader_set(shdTankDamage);
	texture_set_stage(u_sprite, sprite_get_texture(sprite_index, image_index));
	texture_set_stage(u_mask, surface_get_texture(damageMask));
	draw_self();
shader_reset();*/

draw_self();
/*
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
*/
// Draw the turret sprite with the new direction
draw_sprite_ext(turret_sprite1, 0, x, y, image_xscale, image_yscale, turret_direction1, image_blend, image_alpha);

if turret_sprite2 != -1
	draw_sprite_ext(turret_sprite2, 0, x, y, image_xscale, image_yscale, turret_direction2, image_blend, image_alpha);

#region Draw repair symbol
if(keyboard_check(ord("R")))
{
	draw_sprite_ext(sRepair, 0, x-24, y-24, 0.35, 0.35, sin(current_time * 0.01)*50, image_blend, image_alpha);
}
#endregion

#region Draw Circle Target
draw_circle(mouse_x, mouse_y, newBulletAcc*30*3, true);

// Draw Reload Pie
draw_circular_bar(mouse_x+1, mouse_y+1, bullet_reload_timer, bullet_reload_time, c_white, (newBulletAcc*30*3) + 8, 0.75, 4);
#endregion

if(global.Debug)
{
	draw_text(x, y+30, tank_health);
	draw_text(x, y+45, global.zoomF);
	draw_text(x, y+60, -bbox_bottom);
}