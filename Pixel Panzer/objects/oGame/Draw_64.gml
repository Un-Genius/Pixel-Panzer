var i = 5;
var o = 20;

draw_text(10, i, "WASD, Shift, CTRL, G, LMB, RMB, 1-6"); i+=o;
draw_text(10, i, "Esc: Quite"); i+=o;
draw_text(10, i, "F1: FullScreen"); i+=o;
draw_text(10, i, "F2: DebugMode"); i+=o;
draw_text(10, i, "F3: FreeForAll"); i+=o;
draw_text(10, i, "F4: TeamVSTeam"); i+=o;
draw_text(10, i, "F5: CaptureTheFlag"); i+=o;
draw_text(10, i, "F6: GunGame"); i+=o;
draw_text(10, i, "F7: Test"); i+=o;

var screenMiddle = 425;
var screenRight = 800;


// Draw depending on the game type
switch(global.current_game_type)
{
	#region Free For All
	case global.game_type_arr[game_type.free_for_all]:
	
		draw_text(screenMiddle, 20, "Free for All");

		var i = 0;
		var _length = array_length(global.leaderboardList);
		repeat _length
		{
			var _text = global.leaderboardList[i].name + " -> " + string(global.leaderboardList[i].pointsScored);
		    draw_text_ext_color(screenRight, 20 + (15*i), _text, 5, 300, c_white, c_white, c_white, c_white, 1-(i/10));
		    ++i;
			
			if i > 5
				break;
		}
		break;
	#endregion
	#region Capture the Flag
	case global.game_type_arr[game_type.capture_the_flag]:
		draw_text(screenMiddle, 20, "Capture the Flag");
		
		// Draw Team Points
		draw_text(screenRight, 20, "Team Germany: " + string(global.PointsGermany));
		draw_text(screenRight, 40, "Team Russia: " + string(global.PointsRussia));
		break;
	#endregion
	#region Gun Game
	case global.game_type_arr[game_type.gun_game]:
		draw_text(screenMiddle, 20, "Gun Game");
		break;
	#endregion
	#region Team Vs Team
	case global.game_type_arr[game_type.team_vs_team]:
	
		draw_text(screenMiddle, 20, "Team VS Team");
		
		// Draw Team Points
		draw_text(screenRight, 20, "Team Germany: " + string(global.PointsGermany));
		draw_text(screenRight, 40, "Team Russia: " + string(global.PointsRussia));
		break;
	#endregion
	#region Chaos
	case global.game_type_arr[game_type.chaos]:
	
		draw_text(screenMiddle, 20, "Chaos");
		
		// Draw Team Points
		draw_text(screenRight, 20, "Team Germany: " + string(global.PointsGermany));
		draw_text(screenRight, 40, "Team Russia: " + string(global.PointsRussia));
		break;
	#endregion
}