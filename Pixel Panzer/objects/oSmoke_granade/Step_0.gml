life_span--;

image_angle = current_time*0.3;

// Explode
if(life_span <= 0)
{
	if !dispense_smoke
	{
		for(var i = 0; i < 8; i++)
		{
			part_type_alpha3(global.GranadeSmoke, random_range(0.4,0.7), random_range(0.1,0.3), 0);
			part_type_direction(global.GranadeSmoke, global.Wind_Direction-irandom_range(25, 35), global.Wind_Direction+irandom_range(25, 35), irandom_range(-2, 2), irandom_range(-2, 2));
			part_particles_create(global.P_System, x + irandom_range(-50, 50), y + irandom_range(-50, 50), global.GranadeSmoke, 1);
		}
		
		speed = 0;
		sprite_index = noone;
		
		dispense_smoke = true;
	}
	
	if(global.Time % 10 == 1)
	{
		var _collision_list = ds_list_create();
		var _collision = collision_circle_list(x, y, 90, oBullet, false, true, _collision_list, false);
	
		if(_collision)
		{
			for(var i = 0; i <= ds_list_size(_collision_list); i++)
			{
				with(ds_list_find_value(_collision_list, i))
				{
					through_smoke++;
				}
			}
		}
	}
	
	if life_span < -7.5*room_speed
		instance_destroy(self);
}