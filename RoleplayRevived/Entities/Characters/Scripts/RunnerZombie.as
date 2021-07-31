#define SERVER_ONLY

#include "Hitters.as";

const f32 heal_rate = 0.075f; // 0.15 hearts per second

void onInit( CBlob@ this )
{
	this.getCurrentScript().tickFrequency = 30;
}

void onTick( CBlob@ this )
{
	CMap@ map = getMap();
	
	Vec2f pos = this.getPosition();
	float dayTime = map.getDayTime();
	bool day = dayTime >= 0.15f && dayTime <= 0.85f;
	u16 tile = map.getTile(this.getPosition()).type;

	if (day && tile != CMap::tile_ground_back && (tile == CMap::tile_empty || (pos.y < map.tilemapheight * map.tilesize * 0.80f && !map.rayCastSolid(pos, Vec2f(pos.x, pos.y - 96.0f)))))
	{
		this.add_u8("sun_seconds", 1);
		u8 sun_seconds = this.get_u8("sun_seconds");
		
		f32 sun_damage = Maths::Min(sun_seconds * (0.003125f), 0.025f);
		if (sun_damage >= 0.01f)
		{
			this.server_Hit(this, this.getPosition(), this.getVelocity(), sun_damage, Hitters::fire);
		}
		
	    //this.server_Heal(heal_rate / 4);
		return;
	}
	
	this.set_u8("sun_seconds", 0);
	this.server_Heal(heal_rate);
}
