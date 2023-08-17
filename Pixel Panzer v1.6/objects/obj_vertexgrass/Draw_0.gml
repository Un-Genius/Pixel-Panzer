/// @description
//Alpha test enable
gpu_set_alphatestenable(true);
if (bugfix) gpu_set_ztestenable(true);

//Shader
if (grass_animate){
	shader_set(sh_grass);
	
	shader_set_uniform_f(uni_time, current_time);
	shader_set_uniform_f(uni_dist, 0.02 * grass_wind);
	shader_set_uniform_f(uni_slow, 200 / grass_speed);
	shader_set_uniform_f(uni_spd, wind_hsp);
	shader_set_uniform_f(uni_patbool, grass_pattern);
	shader_set_uniform_f(uni_pattern, 0.1/pattern_size);
	
	//if (grass_player_collision!=noone){
	//	shader_set_uniform_f(uni_pl_pos, grass_player_collision.x, grass_player_collision.y);
	//}else{
	//	shader_set_uniform_f(uni_pl_pos, -1000, -1000);
	//}
	
	//shader_set_uniform_f(uni_bend, grass_bend_amount);
}

//Submit vertex buffer
vertex_submit(vbuff, pr_trianglelist, tex);

//Shader
if (grass_animate){
	shader_reset();	
}

gpu_set_alphatestenable(false);
if (bugfix) gpu_set_ztestenable(false);