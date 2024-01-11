if (global.Debug)
{
	draw_text(x, y+45, "State: Dead");
}

if(image_index != -1)
	draw_sprite_ext(tank_sprite, 0, x, y, 1, 1, direction, c_dkgray, 1);

// Draw the turret sprite with the new direction
if(turret_sprite1 != -1)
	draw_sprite_ext(turret_sprite1, 0, x, y, 1, 1, turret_direction1, c_dkgray, 1);

// Draw symbol if zoomed out
var _alpha = global.zoomF - 1;
var _zm = global.zoomF-1.3;
	
switch team
{
	case "Russia":
		draw_sprite_ext(sRussia, 0, x, y, 1*_zm, 1*_zm, 0, c_dkgray, _alpha);
		break;
	case "Germany":
		draw_sprite_ext(sGermany, 0, x, y, 1*_zm, 1*_zm, 0, c_dkgray, _alpha);
		break;
}