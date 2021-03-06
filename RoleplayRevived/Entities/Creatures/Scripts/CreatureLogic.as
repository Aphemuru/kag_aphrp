// Aphelion

void onInit( CBlob@ this )
{
    this.getSprite().ReloadSprites(this.getTeamNum(), 1); 
	
	this.getCurrentScript().runFlags |= Script::tick_moving;
	//this.getCurrentScript().runFlags |= Script::tick_blob_in_proximity;
	//this.getCurrentScript().runProximityTag = "player";
	//this.getCurrentScript().runProximityRadius = 320.0f;
}

void onTick( CBlob@ this )
{
	f32 x = this.getVelocity().x;
	
	if (Maths::Abs(x) > 1.0f)
	{
		this.SetFacingLeft(x < 0);
	}
	else
	{
		if (this.isKeyPressed(key_left))
			this.SetFacingLeft(true);
		else if (this.isKeyPressed(key_right))
			this.SetFacingLeft(false);
	}
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
    return this.hasTag("dead") || this.getTeamNum() == byBlob.getTeamNum();
}