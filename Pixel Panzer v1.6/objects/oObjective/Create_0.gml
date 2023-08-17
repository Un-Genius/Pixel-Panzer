// Initialize variables
captureRadius = 192; // The radius of the flag capture area
captureTime = 8*room_speed; // The number of frames to capture the flag (60 frames = 1 second)
captureProgress = 0; // The current progress of capturing the flag (0 to captureTime)
team = "Neutral"; // The initial team of the flag
pointsPerSecond = 5; // The points awarded per second when the flag is not contested
alarm[0] = 60; // Set the alarm to trigger every second

depth = -bbox_bottom;
image_xscale = 0.75;
image_yscale = 0.75;