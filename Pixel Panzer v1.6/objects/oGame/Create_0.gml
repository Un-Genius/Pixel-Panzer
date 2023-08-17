randomize();

#region Camera Setup

// Initialise Viewports
view_enabled = true;
view_visible[0] = true;

view_xport[0] = 0;
view_yport[0] = 0;
view_wport[0] = 1920;
view_hport[0] = 1080;

view_camera[0] = camera_create_view(0, 0, view_wport[0], view_hport[0], 0, noone, -1, -1, -1, -1);

// Camera Zoom
global.zoomF = 1;

/*	
var _dwidth = display_get_width();
var _dheight = display_get_height();
var _xpos = (_dwidth / 2) - 480;
var _ypos = (_dheight / 2) - 270;
window_set_rectangle(_xpos, _ypos, 960, 540);
*/

surface_resize(application_surface, 1920, 1080);
window_set_size(1920, 1080);

#endregion

// Set up points
global.PointsRussia = 0;
global.PointsGermany = 0;

global.Debug = -1;
global.Time = 0;

// Create Clouds & Planes
alarm[0] = 1;
alarm[1] = 1;

// Set timer
timer = 0;

audio_group_set_gain(audiogroup_default, 0.1, 0);

// Create leaderboards
global.leaderboardList = [];

// Create Particles
global.Wind_Direction = 270;
global.P_System = part_system_create_layer("Particles", false);
global.Clouds_System = part_system_create_layer("Clouds", false);

#region Menu enum

enum menu
{
	home,
	inGame,
	public,
	joinPage,
	hostPage,
	loadingPage,
	optionsPage,
	controlsPage,
	graphicsPage,
	soundsPage
}

#endregion

#region Manage Menu

// Create list for buttons
buttonList = ds_list_create();
ds_list_clear(buttonList);

// Create list for public lobby buttons
buttonListDynamic = ds_list_create();
ds_list_clear(buttonListDynamic);

// Set current menuOverlayState
menuOverlayState = menu.home;
menuStatePrev = menuOverlayState;

// Hold in game menu on/off
menuOverlayToggle = false;

#endregion

#region Game Types

/*
0 - Free For All
1 - Team VS Team
2 - Capture The Flag
3 - Gun Game
*/

enum game_type
{
	free_for_all,
	team_vs_team,
	capture_the_flag,
	gun_game,
	test,
	chaos
}

global.game_type_arr[game_type.free_for_all] = "Free For All";
global.game_type_arr[game_type.team_vs_team] = "Team VS Team";
global.game_type_arr[game_type.capture_the_flag] = "Capture The Flag";
global.game_type_arr[game_type.gun_game] = "Gun Game";
global.game_type_arr[game_type.test] = "Test";
global.game_type_arr[game_type.chaos] = "Chaos";

global.current_game_type = -1;

#endregion

#region Tank Types

enum tank_type
{
	T26,
	Type95,
	T34,
	PZ4,
	KV1,
	Tiger,
	KV2,
	Panther,
	M60A3
}

global.tank_type_arr[tank_type.Panther] = "Panther";
global.tank_type_arr[tank_type.Tiger] = "Tiger";
global.tank_type_arr[tank_type.PZ4] = "PZ4";
global.tank_type_arr[tank_type.Type95] = "Type95";
global.tank_type_arr[tank_type.KV1] = "KV1";
global.tank_type_arr[tank_type.KV2] = "KV2";
global.tank_type_arr[tank_type.T26] = "T26";
global.tank_type_arr[tank_type.T34] = "T34";
global.tank_type_arr[tank_type.M60A3] = "M60A3";

#endregion

// Create Clouds
repeat(25)
{
	var _cloud = instance_create_layer(0, 0, "Clouds", oCloud);
	_cloud.y = irandom(room_height)-500;
}

#region Pixel Particles
global.pixelPartType = part_type_create();

// Set particle properties
part_type_shape(global.pixelPartType, pt_shape_square);
part_type_size(global.pixelPartType, 0.01, 0.025, 0, 0); // Adjust to your pixel size
part_type_color1(global.pixelPartType, c_white); // Change color as needed
part_type_speed(global.pixelPartType, 1.8, 2.5, -0.01, 0); // Change speed as needed
part_type_gravity(global.pixelPartType, 0.05, 270); // Gravity pulling particles down
part_type_life(global.pixelPartType, room_speed * 0.3, room_speed*0.5); // Lasts between 0.5 to 1 second
#endregion

#region Damaged smoke
global.DamagedSmoke = part_type_create();

// Set particle properties
part_type_shape(global.DamagedSmoke, pt_shape_cloud);
part_type_size(global.DamagedSmoke, 0.4, 0.6, -0.001, 0); // Change size as needed
part_type_color1(global.DamagedSmoke, c_black); // Change color as needed for smoke
part_type_speed(global.DamagedSmoke, 1, 2, 0, 0); // Change speed as needed
part_type_direction(global.DamagedSmoke, global.Wind_Direction-30, global.Wind_Direction+30, irandom_range(-2, 2), irandom_range(-2, 2));
part_type_gravity(global.DamagedSmoke, 0.05, 270); // Gravity pulling particles down
part_type_life(global.DamagedSmoke, room_speed * 0.1, room_speed * 0.2); // Lasts between 2 to 3 seconds
#endregion

#region Engine Smoke
global.EngineSmoke = part_type_create();
part_type_shape(global.EngineSmoke, pt_shape_pixel);
part_type_size(global.EngineSmoke, 0.2, 0.3, 0.1, 0.0025);
part_type_color2(global.EngineSmoke, c_dkgray, c_gray);
part_type_alpha2(global.EngineSmoke, 0.5, 0.07);
part_type_speed(global.EngineSmoke, 0.2, 0.5, -0.005, 0.01);
part_type_direction(global.EngineSmoke, global.Wind_Direction-30, global.Wind_Direction+30, irandom_range(-2, 2), irandom_range(-2, 2));
part_type_blend(global.EngineSmoke, false);
part_type_life(global.EngineSmoke, 50, 120);
#endregion

#region Shoot Smoke
global.shootSpark = part_type_create();
part_type_shape(global.shootSpark, pt_shape_explosion);
part_type_size(global.shootSpark, 0.09, 0.17, -0.001, 0);
part_type_color3(global.shootSpark, c_orange, c_dkgray, c_grey);
part_type_alpha3(global.shootSpark, 0.7, 0.4, 0.1);
part_type_speed(global.shootSpark, 0.5, 0.8, -0.03, 0.01);
part_type_direction(global.shootSpark, 0, 0, 0, 0);
part_type_blend(global.shootSpark, true);
part_type_life(global.shootSpark, 75, 100);
#endregion

#region Bullet Trail
global.BulletTrail = part_type_create();
part_type_shape(global.BulletTrail, pt_shape_smoke);
part_type_size(global.BulletTrail, 0.05, 0.1, 0, -0.0002);
part_type_color1(global.BulletTrail, c_gray);
part_type_alpha3(global.BulletTrail, 0.9, 0.5, 0.2);
part_type_life(global.BulletTrail, 20, 50);
#endregion

#region Bullet Explosion
global.ExplosionSmoke = part_type_create();
part_type_shape(global.ExplosionSmoke, pt_shape_explosion);
part_type_size(global.ExplosionSmoke, 0.08, 0.15, -0.005, 0.5);
part_type_color3(global.ExplosionSmoke, c_yellow, c_orange, c_dkgray);
part_type_alpha3(global.ExplosionSmoke, 1, 0.8, 0.6);
part_type_speed(global.ExplosionSmoke, 0.4, 1.4, -0.01, 0);
part_type_direction(global.ExplosionSmoke, 0, 359, irandom_range(-2, 2), irandom_range(-2, 2));
part_type_blend(global.ExplosionSmoke, false);
part_type_life(global.ExplosionSmoke, 10, 24);
#endregion

#region Smoke Granade
global.GranadeSmoke = part_type_create();
part_type_shape(global.GranadeSmoke, pt_shape_smoke);
part_type_size(global.GranadeSmoke, 2, 3, 0, 0);
part_type_color1(global.GranadeSmoke, c_white);
part_type_alpha2(global.GranadeSmoke, 0.8, 0.6);
part_type_speed(global.GranadeSmoke, 0.001, 0.01, 0, 0);
part_type_direction(global.GranadeSmoke, global.Wind_Direction-30, global.Wind_Direction+30, 0.2, irandom_range(-2, 2));
part_type_blend(global.GranadeSmoke, false);
part_type_life(global.GranadeSmoke, 12*room_speed, 14*room_speed);
#endregion

#region Dead Tank Smoke
global.DeadTankSmoke = part_type_create();
part_type_shape(global.DeadTankSmoke, pt_shape_smoke);
part_type_size(global.DeadTankSmoke, 0.25, 0.75, 0.0035, 0.0025);
part_type_color2(global.DeadTankSmoke, c_black, c_dkgray);
part_type_alpha2(global.DeadTankSmoke, 0.2, 0.05);
part_type_speed(global.DeadTankSmoke, 0.3, 0.5, 0, 0);
part_type_direction(global.DeadTankSmoke, global.Wind_Direction-30, global.Wind_Direction+30, irandom_range(-2, 2), irandom_range(-2, 2));
part_type_blend(global.DeadTankSmoke, false);
part_type_life(global.DeadTankSmoke, 8*room_speed, 12*room_speed);
#endregion

#region Dirt
global.Dirt = part_type_create();
part_type_shape(global.Dirt, pt_shape_pixel);
part_type_size(global.Dirt, 1, 2, 0, 0);
part_type_scale(global.Dirt, 1, 1);
part_type_color2(global.Dirt, #A52A2A, c_orange);
part_type_alpha2(global.Dirt, 1, 0);
part_type_speed(global.Dirt, 1, 3, 0, 0);
part_type_direction(global.Dirt, 0, 359, 0, 0);
part_type_gravity(global.Dirt, 0.1, 270);
part_type_life(global.Dirt, 30, 60);
part_type_blend(global.Dirt, true);
#endregion

// Example Particle
/*
global.Particle1 = part_type_create();
part_type_shape(global.Particle1, pt_shape_flare);
part_type_size(global.Particle1, 0.01, 0.05, 0, 0.5);
part_type_color3(global.Particle1, c_aqua, c_lime, c_red);
part_type_alpha3(global.Particle1, 0.5, 1, 0);
part_type_speed(global.Particle1, 2, 5, -0.10, 0);
part_type_direction(global.Particle1, 0, 359, 0, 20);
part_type_blend(global.Particle1, true);
part_type_life(global.Particle1, 30, 60);

part_particles_create(global.P_System, mouse_x, mouse_y, global.Particle1, 50);
/*

// Example Emitter
/*
global.Emitter1 = part_emitter_create(global.P_System);
global.Emitter2 = part_emitter_create(global.P_System);
part_emitter_region(global.P_System, global.Emitter1, 0, room_width, 0, room_height, ps_shape_rectangle, ps_distr_invgaussian);
part_emitter_region(global.P_System, global.Emitter2, mouse_x - 50, mouse_x + 50, mouse_y - 25, mouse_y + 25, ps_shape_ellipse, ps_distr_gaussian);
part_emitter_stream(global.P_System, global.Emitter1, global.Particle1, 10);
alarm[0] = room_speed;

part_emitter_region(global.P_System, global.Emitter2, mouse_x - 50, mouse_x + 50, mouse_y - 25, mouse_y + 25, ps_shape_ellipse, ps_distr_gaussian);
part_emitter_burst(global.P_System, global.Emitter2, global.Particle1, 10);
alarm[0] = room_speed;
*/