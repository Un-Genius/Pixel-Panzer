if (team != "Neutral" && (germanTanks != russianTanks || germanTanks + russianTanks == 0)) {
    if (team == "Germany") {
        global.PointsGermany += pointsPerSecond;
    } else if (team == "Russia") {
        global.PointsRussia += pointsPerSecond;
    }
}
alarm[0] = 60; // Reset the alarm