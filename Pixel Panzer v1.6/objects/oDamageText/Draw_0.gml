if(bounce > 0)
{
	draw_text_color(x, y, "Bounce", c_white, c_white, c_white, c_white, bounce/10 + 0.2);
	bounce--;
}


if(hit > 0)
{
	draw_text_color(x, y, "Hit: " + string(damageAmount), c_red, c_red, c_red, c_red, hit/10 + 0.2);
	hit--;
}

if(criticalHit > 0)
{
	draw_text_color(x, y, "Crit: " + string(damageAmount), c_yellow, c_yellow, c_red, c_red, criticalHit/10 + 0.2);
	criticalHit--;
}

if(otherCount > 0)
{
	draw_text_color(x, y, otherHit, c_white, c_white, c_white, c_white, otherCount/10 + 0.2);
	otherCount--;
}