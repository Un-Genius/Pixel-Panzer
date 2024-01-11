/// @description Create Planes

var _randY = 200 + random(room_width - 400);
var _randDir = global.Wind_Direction + random_range(-50, 50);


for(var i = 0; i <= choose(1, choose(2, choose(3, 6))); i++)
{
	var _plane = instance_create_layer(0, 0, "Clouds", oPlane);
	
	with(_plane)
	{
		x = _randY + (i*75) + random_range(-10, 10);
		y = -200 + (i*75) + random_range(-10, 10);
		direction = _randDir;
		image_angle = direction-90;
	}
}

alarm[1] = irandom_range(4, 12)*room_speed;