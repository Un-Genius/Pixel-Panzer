//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;               // (u,v)
attribute vec2 in_TextureCoord0;              // GML: vertex_format_add_custom(vertex_type_float2, vertex_usage_texcoord);
attribute vec2 in_TextureCoord1;              // GML: vertex_format_add_custom(vertex_type_float2, vertex_usage_texcoord);
attribute vec2 in_room_pos;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 uv_start;
varying vec2 uv_end;
varying vec2 room_pos;

void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
	uv_start = in_TextureCoord0;
	uv_end = in_TextureCoord1;
	room_pos = in_room_pos;
}
