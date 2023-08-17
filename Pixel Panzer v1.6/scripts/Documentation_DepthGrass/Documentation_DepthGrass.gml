function Documentation_DepthGrass() {
	/*
	**********************************
	Depth-Based Grass + Wind
		--by matharoo
	**********************************

	An easy and super-fast method of drawing grass with depth. Also comes with a wind effect.
	
	**USAGE INSTRUCTIONS**
	To use, place `obj_vertexgrass` inside the room where you want the grass.

	To set up the grass, open its Create event. The first region contains the variables that you can customize. It has explanations for all variables, except `grass_mode` which is in this doc.

	That's it. When you run the game, the grass will be there!

	**GRASS_MODE**
	There are three grass modes: 0, 1 and 2.

	0: The whole room will be filled with grass.
	1: The grass will be created around the object inside a specified radius. This way you can place multiple objects inside a room to create different regions of grass.
	2: Same as 2, but this creates the grass in a rectangle around the object instead of a circle.

	Note: For Mode 0, the grass_number will need to be large, depending on the size of the room.

	**DEPTH**
	To enable depth on other objects, use `depth = -y` in their End Step events and make sure their sprite origins are set at the bottom.

	**SPRITE**
	You can use any sprite for the grass, but make sure its origin is set to top-left to avoid any unexpected problems.

	**GRASS ANIMATION NOTE**
	To make sure the grass animates properly (if you've enabled it), make sure that:

		1. There is enough empty space to the left and right of the grass inside its sprite
		2. "Automatically Crop" is DISABLED inside Tools > Texture Groups
	
	**RANDOMIZATION NOTE**
	To make sure each run has different/randomized grass, use `randomize()` at the start of your game. Otherwise, the grass that appears will be the same each time the game is played.

	**A SPECIFIC BUG**
	You might face a specific bug with the z-buffer. Maybe you'll experience some unexpected graphical glitch or just see a black screen. To try fixing it, you'll first have to enable the
	"bigfix" variable in the object.

	If that fixes your bug, it probably messed up the depth. To fix that, you'll have to use this function before drawing things that have depth:

	gpu_set_ztestenable(true)

	And this when you're done drawing:

	gpu_set_ztestenable(false)

	This will make sure that those sprites work with the grass depth. You can also use them with draw_self().
	*/


}
