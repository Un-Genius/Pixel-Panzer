/// @description Create Smoke

part_type_direction(global.DeadTankSmoke, global.Wind_Direction-irandom_range(25, 35), global.Wind_Direction+irandom_range(25, 35), irandom_range(-2, 2), irandom_range(-2, 2));

part_particles_create(global.P_System, x, y, global.DeadTankSmoke, 1);

alarm[0] = 20;