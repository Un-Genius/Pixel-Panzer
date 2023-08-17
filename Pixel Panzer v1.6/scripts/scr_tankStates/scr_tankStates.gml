function checkEnemyDetected()
{
	if(global.Time % 15 == 1)
	{
	    if (instance_exists(enemy_tank) && enemy_tank != -1)
		{
	        for (var i = 0; i <= 360; i += 5)
			{
	            // Set distance and direction
	            var _dist = range * 0.7;
	            var _dir = direction + i;

	            var _angleDif = angle_difference(turret_direction1, direction) + 90;

	            // Extra view for driver
	            if (i > 335 || i < 25)
	                _dist = range * 1.1
	            else
					if (i > _angleDif - 25 && i < _angleDif + 25) // Extra view for gunner
						_dist = range * 1.1;

	            // Get new direction
	            var _x = x + lengthdir_x(_dist, _dir);
	            var _y = y + lengthdir_y(_dist, _dir);

	            var _list = ds_list_create();
	            var _num = collision_line_list(x, y, _x, _y, oTank, false, true, _list, false);

	            for (var o = 0; o < _num; o++)
				{
	                var _nextInst = ds_list_find_value(_list, o);
	                if ((_nextInst.team != team || team == -1))
					{
						ds_list_destroy(_list);
						return true;
	                }
	            }

	            ds_list_destroy(_list);
	        }
	    }
	}
	return false;
}

function checkHealth()
{
	if(tank_health < tank_health_max/3)
		return true;
	else
		return false;
}

function stopFollowState()
{
    if (followed_by != -1 && instance_exists(followed_by) || followed_by == id) {
        followed_by.following = -1;
        followed_by = -1;
    } else
        followed_by = -1;

    if (following != -1 && instance_exists(following) || following == id) {
        following.followed_by = -1;
        following = -1;
    } else
        following = -1;
}