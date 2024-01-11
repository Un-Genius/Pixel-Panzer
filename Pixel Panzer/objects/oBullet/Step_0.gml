part_particles_create(global.P_System, x, y, global.BulletTrail, 1);

distance_travelled += speed;
accuracy -= 0.01

if (distance_travelled > distance+50)
	accuracy -= 0.005
	
if (accuracy <= 0)
	instance_destroy(self);

// If it hits tank
for(var i = 0; i <= speed; i++)
{
	var _x = x + lengthdir_x(i, direction);
	var _y = y + lengthdir_y(i, direction);
	collisionTank = collision_point(_x, _y, oTank, false, true);
	
	if collisionTank != noone
	{
		x = _x;
		y = _y;

		if(collisionList != -1 && ds_list_find_index(collisionList, collisionTank) == -1)
		{
			ds_list_add(collisionList, collisionTank);
			event_user(0);
		}
		
		break;
	}
}

