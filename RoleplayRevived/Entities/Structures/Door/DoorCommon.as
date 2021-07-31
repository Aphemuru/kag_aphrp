//common functionality for door-like objects

bool canOpenDoor(CBlob@ this, CBlob@ blob)
{
	if (this is null || blob is null)
		return false;
	
	if ((blob.getShape().getConsts().collidable) && //solid              // vvv lets see
	        (blob.getRadius() > 5.0f) && //large
	        (this.getTeamNum() == 255 || isTeamFriendly(this.getTeamNum(), blob.getTeamNum())) &&
	        (blob.hasTag("player") || blob.hasTag("vehicle") || blob.hasTag("migrant"))) //tags that can open doors
	{
		Vec2f direction = Vec2f(0, -1);
		direction.RotateBy(this.getAngleDegrees());

		Vec2f doorpos = this.getPosition();
		Vec2f playerpos = blob.getPosition();

		if (blob.isKeyPressed(key_left) && playerpos.x > doorpos.x && Maths::Abs(playerpos.y - doorpos.y) < 11) return true;
		if (blob.isKeyPressed(key_right) && playerpos.x < doorpos.x && Maths::Abs(playerpos.y - doorpos.y) < 11) return true;
		if (blob.isKeyPressed(key_up) && playerpos.y > doorpos.y && Maths::Abs(playerpos.x - doorpos.x) < 11) return true;
		if (blob.isKeyPressed(key_down) && playerpos.y < doorpos.y && Maths::Abs(playerpos.x - doorpos.x) < 11) return true;
	}
	return false;
}

bool isTeamFriendly( u8 team, u8 team_other )
{
    return team == team_other || getDisposition(getRules(), team, team_other) == 1;
}

int getDisposition( CRules@ rules, int team, int team_compare )
{
    if(team == team_compare)
	    return 1;
	
    u8 disposition = rules.get_u8("disposition_" + team + "_" + team_compare);
	return disposition;
}