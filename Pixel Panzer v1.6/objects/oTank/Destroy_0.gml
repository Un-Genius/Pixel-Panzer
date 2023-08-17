/// @description If Dead

// Create Explosion
part_particles_create(global.P_System, x, y, global.ExplosionSmoke, irandom_range(8, 15));

var _idName = string(id);
var _numName = string_delete(_idName, 1, 7);
remove_score(string(tank) + "_" + _numName); 

#region Update Follow State Variables
if(followed_by != -1 && instance_exists(followed_by))
{
	followed_by.following = -1;
	followed_by = -1;
}
else
	followed_by = -1;
	
if(following != -1 && instance_exists(following))
{
	following.followed_by = -1;
	following = -1;
}
else
	following = -1;
#endregion

#region Create Corpse
// Create Corpse
var _corpse = instance_create_layer(x, y, "Instances", oTank_Dead);

_corpse.tank = tank;
_corpse.tank_string = tank_string;
_corpse.tank_sprite = asset_get_index(tank_string + "Bottom");
_corpse.turret_sprite1 = asset_get_index(tank_string + "Top");
_corpse.turret_direction1 = turret_direction1;
_corpse.direction = direction-90;
_corpse.depth = -bbox_bottom;
_corpse.team = team;

// Armor
_corpse.armor_front = 65;
_corpse.armor_side = 45;
_corpse.armor_back = 35;

_corpse.armor_weaknesses = 0;
#endregion