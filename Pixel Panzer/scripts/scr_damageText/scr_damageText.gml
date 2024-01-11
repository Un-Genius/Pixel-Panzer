function damageText(_x, _y, damage_type, damage_amount){
	var _inst = instance_create_layer(_x, _y, "Bullets", oDamageText)
	
	with(_inst)
	{
		damageAmount = damage_amount;
		
		switch(damage_type)
		{
			case "bounce":
				bounce = 2.5*room_speed;
				break;
			case "hit":
				hit = 2.5*room_speed;
				break;
			case "critical hit":
				criticalHit = 2.5*room_speed;
				break;
			default:
				otherCount = 2.5*room_speed;
				otherHit = damage_type;
		}
	}
}