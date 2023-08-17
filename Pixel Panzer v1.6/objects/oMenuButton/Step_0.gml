var _x2 = x + width;
var _y2 = y + height;

var _hover = get_hover(x, y, _x2, _y2);
var _click = _hover && mouse_check_button_pressed(mb_left);

if _hover
{
	global.mouseUI = true;
	alarm[0] = 4;
}

// Hover
hover = lerp(hover, _hover, 0.1);
y = lerp(y, ystart - _hover * 3, 0.125);

// Click
if(_click && script >= 0)
{
	script_execute(script);
	audio_play_sound(snd_ButtonClick, 1, false);
}