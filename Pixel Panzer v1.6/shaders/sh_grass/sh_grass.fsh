//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec2 uv_start;
varying vec2 uv_end;
varying vec4 v_vColour;
varying vec2 room_pos;

uniform float time;

uniform float wave_dist;
uniform float slow;

uniform float wind_spd;

uniform float patbool;
uniform float pattern;

//uniform vec2 pl_pos;
//uniform float bend;

void main()
{
    //gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	//Distance to player
	//vec2 pl_dist = pl_pos - room_pos;
	
	//float dist = sqrt(pl_dist.x*pl_dist.x + pl_dist.y*pl_dist.y);
	
	////Bend value
	//vec2 cur_bend;
	//cur_bend.x = max(0.0, bend - abs(pl_dist.x)) * sign(pl_dist.x);
	//cur_bend.y = max(0.0, bend - abs(pl_dist.y)) * sign(pl_dist.y);
	
	////Out of range
	//if (dist > bend){
	//	cur_bend = vec2(0.0, 0.0);	
	//}
	
	//Normalize
	vec2 Texcoord = v_vTexcoord;
	
	Texcoord = vec2((Texcoord-uv_start) * (1.0/uv_end));
	
	//Sin wave (time + pattern.y)
	float offset = (sin((time/slow) + (room_pos.y*pattern*patbool)) * wave_dist) * (1.0-Texcoord.y);
	
	//Wind
	float wind = (wind_spd/20.0) * (1.0-Texcoord.y);
	
	//Final texcoords
	vec2 txc = v_vTexcoord + vec2(offset - wind, 0);
	
	//Apply
	gl_FragColor = v_vColour * texture2D(gm_BaseTexture, txc);
	
	//Alpha testing
	if (gl_FragColor.a==0.0 || txc.x < uv_start.x || txc.x > uv_start.x + uv_end.x || txc.y < uv_start.y || txc.y > uv_start.y + uv_end.y){
		discard;	
	}
}
