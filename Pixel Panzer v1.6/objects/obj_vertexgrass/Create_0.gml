/// @description CUSTOMIZE HERE
#region VARIABLES
//You can customize these variables, but only here - you cannot modify these elsewhere
grass_mode = 1; //Grass mode. Explanation inside the documentation (in scripts)

//Mode 1 variables
grass_radius = 250; //Radius around the object for creating the grass
//----------------

//Mode 2 variables (Size of the imaginary rectangle in which the grass is filled)
grass_rect_hor = 96; //Horizontal (x) size of rectangle
grass_rect_ver = 48; //Vertical (y) size of rectangle
//----------------

//General variables
grass_number = 400; //Number of grass sprites inside the room
grass_sprite = spr_depthgrass; //Sprite used for the grass

grass_random_image = true; //Can the grass use any sub-image from the sprite, at random? 
						   //If false, it'll only use the first one.

grass_animate = true; //Whether to use a wind shader to animate the grass
grass_pattern = true; //Whether the grass should sway in a pattern

//These variables can also be changed later
grass_wind = 0.1; //Power of the grass swaying
grass_speed = 0.3; //Speed of the grass animation
wind_hsp = 0; //Extra horizontal speed of the wind
			  //Positive: Rightwards, Negative: Leftwards
			  
pattern_size = 3; //Sway pattern size

//Other
bugfix = false; // Enable this if facing a specific bug (see Docs)

//DISCARDED
//grass_player_collision = noone;
//grass_bend_amount = 5;
#endregion

#region DO NOT TWEAK
//Debug
//show_debug_overlay(true);

//Shader
if (grass_animate){
	uni_time = shader_get_uniform(sh_grass, "time");
	uni_dist = shader_get_uniform(sh_grass, "wave_dist");
	uni_slow = shader_get_uniform(sh_grass, "slow");
	uni_spd = shader_get_uniform(sh_grass, "wind_spd");
	uni_patbool = shader_get_uniform(sh_grass, "patbool");
	uni_pattern = shader_get_uniform(sh_grass, "pattern");
	//uni_pl_pos = shader_get_uniform(sh_grass, "pl_pos");
	//uni_bend = shader_get_uniform(sh_grass, "bend");
}

//depth
gpu_set_ztestenable(true);

//vformat
vertex_format_begin();

vertex_format_add_position_3d();
vertex_format_add_texcoord();

//uv start and end
vertex_format_add_custom(vertex_type_float2, vertex_usage_texcoord);
vertex_format_add_custom(vertex_type_float2, vertex_usage_texcoord);

//room pos
vertex_format_add_custom(vertex_type_float2, vertex_usage_texcoord);

vertex_format_add_color();

var format = vertex_format_end();

//vbuff
vbuff = vertex_create_buffer();

vertex_begin(vbuff, format);

repeat(grass_number){
	//image index
	var im_ind = 0;
	if (grass_random_image) im_ind = irandom(sprite_get_number(grass_sprite)-1);
	
	//sprite/texture
	tex = sprite_get_texture(grass_sprite, im_ind);

	var uvs = sprite_get_uvs(grass_sprite, im_ind);

	var uv_left = uvs[0];
	var uv_top = uvs[1];
	var uv_right = uvs[2];
	var uv_bottom = uvs[3];
	
	//spr size
	var spr_w = sprite_get_width(grass_sprite);
	var spr_h = sprite_get_height(grass_sprite);
	
	//main coords
	if (grass_mode==0){
	    var left = random_range(-spr_w, room_width);
	    var top = random_range(-spr_h, room_height);
	}else if (grass_mode==1){
		var rand_dist = random(grass_radius);
		var rand_dir = random(360);
		
		var left = x + lengthdir_x(rand_dist, rand_dir);
		var top = y + lengthdir_y(rand_dist, rand_dir);
	}else if (grass_mode==2){
		var left = random_range(x, x + grass_rect_hor);
		var top = random_range(y, y + grass_rect_ver);
	}
	
	//other coords
    var right = left + spr_w;
    var bottom = top + spr_h;
	
	//center
	var xx = left + spr_w/2;
	var yy = top + spr_h/2;
    
    //depth
    var dep = -bottom;
	
    //triangle 1
    vertex_position_3d(vbuff, left, top, dep);
    vertex_texcoord(vbuff, uv_left, uv_top);
	vertex_texcoord(vbuff, uv_left, uv_top);
	vertex_texcoord(vbuff, uv_right - uv_left, uv_bottom - uv_top);
	vertex_texcoord(vbuff, xx, yy);
    vertex_colour(vbuff, c_white, 1);
    
    vertex_position_3d(vbuff, right, top, dep);
    vertex_texcoord(vbuff, uv_right, uv_top);
	vertex_texcoord(vbuff, uv_left, uv_top);
	vertex_texcoord(vbuff, uv_right - uv_left, uv_bottom - uv_top);
	vertex_texcoord(vbuff, xx, yy);
    vertex_colour(vbuff, c_white, 1);
    
    vertex_position_3d(vbuff, left, bottom, dep);
    vertex_texcoord(vbuff, uv_left, uv_bottom);
	vertex_texcoord(vbuff, uv_left, uv_top);
	vertex_texcoord(vbuff, uv_right - uv_left, uv_bottom - uv_top);
	vertex_texcoord(vbuff, xx, yy);
    vertex_colour(vbuff, c_white, 1);
    
    //triangle 2
    vertex_position_3d(vbuff, right, top, dep);
    vertex_texcoord(vbuff, uv_right, uv_top);
	vertex_texcoord(vbuff, uv_left, uv_top);
	vertex_texcoord(vbuff, uv_right - uv_left, uv_bottom - uv_top);
	vertex_texcoord(vbuff, xx, yy);
    vertex_colour(vbuff, c_white, 1);
    
    vertex_position_3d(vbuff, right, bottom, dep);
    vertex_texcoord(vbuff, uv_right, uv_bottom);
	vertex_texcoord(vbuff, uv_left, uv_top);
	vertex_texcoord(vbuff, uv_right - uv_left, uv_bottom - uv_top);
	vertex_texcoord(vbuff, xx, yy);
    vertex_colour(vbuff, c_white, 1);
    
    vertex_position_3d(vbuff, left, bottom, dep);
    vertex_texcoord(vbuff, uv_left, uv_bottom);
	vertex_texcoord(vbuff, uv_left, uv_top);
	vertex_texcoord(vbuff, uv_right - uv_left, uv_bottom - uv_top);
	vertex_texcoord(vbuff, xx, yy);
    vertex_colour(vbuff, c_white, 1);
}

vertex_end(vbuff);
vertex_freeze(vbuff);
if (bugfix) gpu_set_ztestenable(false);
#endregion