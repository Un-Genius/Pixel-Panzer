function add_score(_name, player_score)
{
	var _exists = false;
	for(var i = 0; i < array_length(global.leaderboardList); i++)
	{
		if(global.leaderboardList[i].name == _name)
		{
			global.leaderboardList[i].pointsScored = global.leaderboardList[i].pointsScored + player_score;
			_exists = true;
			break;
		}
	}
	
	if(!_exists)
	{
		array_push(global.leaderboardList, {
			name: _name,
			pointsScored: player_score
		});
	}
	
	array_sort(global.leaderboardList, function(a, b) {
		return b.pointsScored - a.pointsScored;
	});
	
	/*
	if (array_length(global.leaderboardList) > 5) {
		array_pop(global.leaderboardList);
	}
	*/
}

function remove_score(_name)
{	
	for(var i = 0; i < array_length(global.leaderboardList); i++)
	{
		if(global.leaderboardList[i].name == _name)
		{
			array_delete(global.leaderboardList, i, 1);
			break;
		}
	}
}