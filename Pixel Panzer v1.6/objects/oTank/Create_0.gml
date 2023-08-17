// Tank movement variables
tank_move_speed = 0;
tank_turn_speed = 0;

// Tank health variables
tank_health = 1;
tank_health_max = tank_health;

// Tank sprite setup
tankType = -1;
tank = "-1";
tank_string = "sTank_" + tank + "_";
image_index = asset_get_index(tank_string + "Bottom");

image_xscale = 1;
image_yscale = 1;

// Turret sprite setup
turret_sprite1 = -1;
turret_speed1 = 0;

turret_sprite2 = -1;
turret_speed2 = 0;

turret_direction1 = direction - 90;
new_turret_direction1 = turret_direction1;

turret_direction2 = direction - 90;
new_turret_direction2 = turret_direction2;

// Random movement direction
random_direction = 0;

// Armor values
armor_front = 65;
armor_side = 45;
armor_back = 35;
armor_weaknesses = 0;

#region Turret 1
state_shoot = false;

// Bullet statistics
bullet_range = 0;               // pixels
bullet_accuracy = 0.8;           // off out of 1
bullet_reload_time = 150;        // milliseconds
bullet_magazine_size = 1;
bullet_burst_rate = 1;
bullet_burst_delay = 6;
bullet_fire_rate_delay = 1;
bullet_size = 88;               // mm
bullet_penetration = 75;
bullet_speed = 18;              // m/s
bullet_direction = turret_direction1;

// Tank damage, range, and view
damage = 10;
range = irandom_range(650, 850);
view = 1000;

// Shooting variables
can_shoot = true;              // whether the tank can currently shoot
magazine_count = 0;
burst_count = 0;               // number of bullets fired in current burst
last_shot_time = 0;            // time in milliseconds of last shot
bullet_reload_timer = 0;
#endregion
#region Turret 2
state_shoot2 = false;

// Bullet statistics
bullet_range2 = 0;               // pixels
bullet_accuracy2 = 1;           // off out of 1
bullet_reload_time2 = 350;        // milliseconds
bullet_magazine_size2 = 65;
bullet_burst_rate2 = 25;
bullet_burst_delay2 = 10;
bullet_fire_rate_delay2 = 30;
bullet_size2 = 0.2;               // mm
bullet_penetration2 = 15;
bullet_speed2 = 16;              // m/s
bullet_direction2 = turret_direction2;

// Tank damage
damage2 = 1;

// Shooting variables
can_shoot2 = true;              // whether the tank can currently shoot
magazine_count2 = 0;
burst_count2 = 0;               // number of bullets fired in current burst
last_shot_time2 = 0;            // time in milliseconds of last shot
bullet_reload_timer2 = 0;
#endregion

// AI state variables
enum AIStates {
    Idle,
    Wander,
    Follow,
    Objective,
    React,
    Aggro,
	Retreat,
	Repair,
	Attack_Sit,
	Attack_Chase,
	Attack_Weave,
	Attack_Angle,
	Attack_Circle,
	Attack_Inch,
	Retreat_Inch,
	Retreat_Angle,
	Retreat_Weave
}

state = AIStates.Idle;
team = "-1";

// Movement control
new_direction = 0;
start_x = x;
start_y = y;
random_timer = -1;

// Smoke effect counter
smokeCounter = 0;

// Optimization timer
optimizeTimer = 0;

// Enemy tank info
enemy_tank = -1;
enemyDist = 0;
enemyIntersectDir = 0;

// Tank value and scoring
pointValue = 25;
pointsScored = 0;
score = 0;

// Follower/following variables
followed_by = -1;
following = -1;

// Set alarm
alarm[0] = 1;

ins_move = audio_play_sound(snd_move, 100, true);
audio_sound_gain(ins_move, 0, 0);
audio_sound_gain(ins_move, 0.05, 1000);

// Mask
damageMask = surface_create(50, 50);
surface_set_target(damageMask);
	draw_clear_alpha(c_black, 0);
surface_reset_target();