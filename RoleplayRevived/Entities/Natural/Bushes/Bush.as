// Bush logic

#include "Roleplay_SeasonsCommon.as";
#include "canGrow.as";

void onInit( CBlob@ this )
{
    this.set_bool("grown", true);
	this.getCurrentScript().runFlags |= Script::remove_after_this;
	this.Tag("builder always hit");
}

void onInit( CSprite@ this )
{
	CBlob@ blob = this.getBlob();
	u16 netID = blob.getNetworkID();
    this.animation.frame = (netID % this.animation.getFramesCount());
    this.SetFacingLeft( ((netID % 13) % 2) == 0 );
	this.SetZ(10.0f);
}

void onDie( CBlob@ this )
{
	if (getNet().isServer())
	{
		int amount = 1 + XORRandom(2);

		for (int i = 0; i < amount; i++)
		{
			CBlob@ leaf = server_CreateBlob("leaf", this.getTeamNum(), this.getPosition() + Vec2f(0, -12));
			
			if (leaf !is null)
			{
				leaf.setVelocity(Vec2f(XORRandom(5) - 2.5f, XORRandom(5) - 2.5f));
			}
		}
	}
}