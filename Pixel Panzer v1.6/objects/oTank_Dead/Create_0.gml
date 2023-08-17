// Set up sprite origins and angles
tank = "-1";
tank_string = "sTank_" + tank + "_";
tank_sprite = asset_get_index(tank_string + "Bottom");
turret_sprite1 = asset_get_index(tank_string + "Top");
turret_direction1 = direction-90;
tank_health = -1;

image_alpha = c_black;

alarm[0] = 8;
alarm[1] = 30 * room_speed;

// Armor
armor_front = 65;
armor_side = 45;
armor_back = 35;

armor_weaknesses = 0;

team = "-1";