// bullet object create event
range = 1; // in meters
size = 0; // in millimeters
distance = 100;
distance_travelled = 0;
accuracy = 0;
random_accuracy = random(1);
penetration = 0;
damage = 0;

shooter_id = -1;

collisionTank = -1;

through_smoke = 1;

image_xscale = size;
image_yscale = size;

collisionList = ds_list_create();