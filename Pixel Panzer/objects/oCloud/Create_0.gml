x = random(room_width);
y = -1000;

image_index = random(image_number);
image_speed = 0;
image_xscale = random_range(10, 15);
image_yscale = random_range(10, 15);
image_blend = c_white;
image_alpha = 0.4;
speed = random_range(0.2, 0.4);
direction = global.Wind_Direction + random_range(-15, 15);