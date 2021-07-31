
#include "RP_Common.as";
#include "RP_Races.as";

#include "Spoofy.as";
#include "MageCommon.as";
#include "PixelOffsets.as"
#include "RunnerTextures.as"

const string skin_tag = "skin disabled";

void onInit(CSprite@ this)
{
	LoadSprites(this);
}

void onPlayerInfoChanged(CSprite@ this)
{
	LoadSprites(this);
}

void LoadSprites( CSprite@ this )
{
	if(this.getBlob().getTeamNum() == RACE_HUMANS)
		ensureCorrectRunnerTexture(this, "mage_dwarf", "HumanMage");
	else if(this.getBlob().getTeamNum() == RACE_ELVES)
		ensureCorrectRunnerTexture(this, "mage_elf", "ElfMage");
	else if(this.getBlob().getTeamNum() == RACE_ORCS)
		ensureCorrectRunnerTexture(this, "mage_orc", "OrcMage");
	else if(this.getBlob().getTeamNum() == RACE_ANGELS)
		ensureCorrectRunnerTexture(this, "mage_angel", "AngelMage");
	else if(this.getBlob().getTeamNum() == RACE_UNDEAD)
		ensureCorrectRunnerTexture(this, "mage_undead", "UndeadMage");
	else
		ensureCorrectRunnerTexture(this, "mage", "StandardMage");
}

void onTick( CSprite@ this )
{
    CBlob@ blob = this.getBlob();
	
	if (blob.hasTag("dead"))
    {
	   	if(this.animation.name != "dead")
		{
		    blob.Tag("dead head");
			this.SetAnimation("dead");
		}
        return;
    }    
    
   	const bool inair = (!blob.isOnGround() && !blob.isOnLadder());
	const bool left = blob.isKeyPressed(key_left);
	const bool right = blob.isKeyPressed(key_right);
	const bool up = blob.isKeyPressed(key_up);
	const bool down = blob.isKeyPressed(key_down);
	
	if (inair)
	{
		this.SetAnimation("fall");
		Vec2f vel = blob.getVelocity();
		f32 vy = vel.y;
		this.animation.timer = 0;

		if (vy < -1.5 || up) {
			this.animation.frame = 0;
		}
		else {
			this.animation.frame = 1;
		}
	}
	else if (left || right || (blob.isOnLadder() && (up || down)))
	{
		this.SetAnimation("run");
	}
	else if (down)
	{
		this.SetAnimation("crouch");
	}
	else if(blob.isKeyPressed(key_action1) && hasRunes(blob, getRuneType(blob)))
	{
		blob.Tag("attack head");
        blob.Untag("dead head");
		this.SetAnimation("fire");
	} 
	else
	{        
	    blob.Untag("attack head");
        blob.Untag("dead head");
	    this.SetAnimation("default");
	}
}

void onGib(CSprite@ this)
{
    if (g_kidssafe) {
        return;
    }

    CBlob@ blob = this.getBlob();
    Vec2f pos = blob.getPosition();
    Vec2f vel = blob.getVelocity();
	vel.y -= 3.0f;
    f32 hp = Maths::Min(Maths::Abs(blob.getHealth()), 2.0f) + 1.0;
	const u8 team = blob.getTeamNum();
    CParticle@ Body     = makeGibParticle( "Entities/Characters/Mage/MageGibs.png", pos, vel + getRandomVelocity( 90, hp , 80 ), 0, 0, Vec2f (16,16), 2.0f, 20, "/BodyGibFall", team );
    CParticle@ Arm1     = makeGibParticle( "Entities/Characters/Mage/MageGibs.png", pos, vel + getRandomVelocity( 90, hp - 0.2 , 80 ), 1, 0, Vec2f (16,16), 2.0f, 20, "/BodyGibFall", team );
    CParticle@ Arm2     = makeGibParticle( "Entities/Characters/Mage/MageGibs.png", pos, vel + getRandomVelocity( 90, hp - 0.2 , 80 ), 1, 0, Vec2f (16,16), 2.0f, 20, "/BodyGibFall", team );
    CParticle@ Staff   = makeGibParticle( "Entities/Characters/Mage/MageGibs.png", pos, vel + getRandomVelocity( 90, hp , 80 ), 2, 0, Vec2f (16,16), 2.0f, 0, "Sounds/material_drop.ogg", team );
    CParticle@ Something    = makeGibParticle( "Entities/Characters/Mage/MageGibs.png", pos, vel + getRandomVelocity( 90, hp + 1 , 80 ), 3, 0, Vec2f (16,16), 2.0f, 0, "/BodyGibFall", team );
}
