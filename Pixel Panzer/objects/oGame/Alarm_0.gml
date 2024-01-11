/// @description Create Clouds

repeat(irandom(2)+1)
{
	instance_create_layer(0, 0, "Clouds", oCloud);
}

alarm[0] = irandom_range(7, 18)*room_speed;