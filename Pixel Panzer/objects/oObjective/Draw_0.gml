// Draw the capture radius
draw_circle_color(x, y, captureRadius, c_white, c_white, true);

// Draw the flag sprite depending on the team
if (team == "Germany") {
    draw_sprite(sGermany, 0, x, y);
} else if (team == "Russia") {
    draw_sprite(sRussia, 0, x, y);
} else {
    draw_sprite(sNeutral, 0, x, y);
}

// Draw the health bar to show capture progress
var barWidth = 64;
var barHeight = 8;
var barX = x - barWidth / 2;
var barY = y - 72;
var progress = captureProgress / captureTime;
draw_healthbar(barX, barY, barX + barWidth, barY + barHeight, progress * 100, c_lime, c_yellow, c_red, 1, c_white, c_white);

// Blend the flag color from white to the team color based on capture progress
if (team != "Neutral") {
    var blendColor = (team == "Germany") ? sGermany : sRussia;
    draw_sprite_ext(blendColor, 0, x, y, 1, 1, 0, c_white, 1 - progress);
}