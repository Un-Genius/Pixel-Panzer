// Get the number of tanks in the capture radius for each team
germanTanks = 0;
russianTanks = 0;

var _instList = ds_list_create();
var _instListSize = collision_circle_list(x, y, captureRadius, oTank, false, true, _instList, false);

for(var i = 0; i < _instListSize; i++)
{
	switch ds_list_find_value(_instList, i).team
	{
		case "Germany":
			germanTanks++;
			break;
		case "Russia":
			russianTanks++;
			break;
	}
		
}

ds_list_destroy(_instList);

if (germanTanks > 0 && russianTanks == 0) {
    if (team != "Germany") {
        captureProgress += 1;
        if (captureProgress >= captureTime) {
            team = "Germany";
            captureProgress = 0;
        }
    }
} else if (russianTanks > 0 && germanTanks == 0) {
    if (team != "Russia") {
        captureProgress += 1;
        if (captureProgress >= captureTime) {
            team = "Russia";
            captureProgress = 0;
        }
    }
} else {
    captureProgress = 0;
}