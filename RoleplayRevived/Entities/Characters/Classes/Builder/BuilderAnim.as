// Builder animations

#include "RP_Common.as";
#include "RP_Races.as";

#include "Sponsors.as";
#include "Spoofy.as";

#include "BuilderCommon.as"
#include "FireCommon.as"
#include "Requirements.as"
#include "RunnerAnimCommon.as"
#include "RunnerCommon.as"
#include "Knocked.as"
#include "PixelOffsets.as"
#include "RunnerTextures.as"
#include "Accolades.as"

const string skin_tag = "skin disabled";

void onInit(CSprite@ this)
{
	LoadSprites(this);

	this.getCurrentScript().runFlags |= Script::tick_not_infire;
}

void onPlayerInfoChanged(CSprite@ this)
{
	LoadSprites(this);
}

void LoadSprites(CSprite@ this)
{
	if(raceIs(this.getBlob(), RACE_DWARVES))
		ensureCorrectRunnerTexture(this, "builder_dwarf", "DwarfBuilder");
	else if(raceIs(this.getBlob(), RACE_ELVES))
		ensureCorrectRunnerTexture(this, "builder_elf", "ElfBuilder");
	else if(raceIs(this.getBlob(), RACE_ORCS))
		ensureCorrectRunnerTexture(this, "builder_orc", "OrcBuilder");
	else if(raceIs(this.getBlob(), RACE_UNDEAD))
		ensureCorrectRunnerTexture(this, "builder_undead", "UndeadBuilder");
	else
		ensureCorrectRunnerTexture(this, "builder", "Builder");
}

void onTick(CSprite@ this)
{
	// store some vars for ease and speed
	CBlob@ blob = this.getBlob();

	// not efficient, but it works
	CPlayer@ player = blob.getPlayer();
	if      (player !is null && getGameTime() % 30 == 0)
    {
	    string username = isSpoofing(getRules(), player) ? getSpoofedPlayer(getRules(), player) : player.getUsername();
		string skin = getSkin(blob, player, username);
		if    (skin != "")
		{
		    if (isSkinEnabled(blob, username))
				ensureCorrectRunnerTexture(this, "builder_" + skin, skin);
			else
				LoadSprites(this);
		}
	}
	
	if (blob.hasTag("dead"))
	{
		this.SetAnimation("dead");
		Vec2f vel = blob.getVelocity();

		if (vel.y < -1.0f)
		{
			this.SetFrameIndex(0);
		}
		else if (vel.y > 1.0f)
		{
			this.SetFrameIndex(2);
		}
		else
		{
			this.SetFrameIndex(1);
		}
		return;
	}
	// animations

	const u8 knocked = getKnocked(blob);
	const bool action2 = blob.isKeyPressed(key_action2);
	const bool action1 = blob.isKeyPressed(key_action1);

	if (!blob.hasTag(burning_tag)) //give way to burning anim
	{
		const bool left = blob.isKeyPressed(key_left);
		const bool right = blob.isKeyPressed(key_right);
		const bool up = blob.isKeyPressed(key_up);
		const bool down = blob.isKeyPressed(key_down);
		const bool inair = (!blob.isOnGround() && !blob.isOnLadder());
		Vec2f pos = blob.getPosition();

		RunnerMoveVars@ moveVars;
		if (!blob.get("moveVars", @moveVars))
		{
			return;
		}

		if (knocked > 0)
		{
			if (inair)
			{
				this.SetAnimation("knocked_air");
			}
			else
			{
				this.SetAnimation("knocked");
			}
		}
		else if (blob.hasTag("seated"))
		{
			this.SetAnimation("crouch");
		}
		else if (action2 || (this.isAnimation("strike") && !this.isAnimationEnded()))
		{
			this.SetAnimation("strike");
		}
		else if (action1  || (this.isAnimation("build") && !this.isAnimationEnded()))
		{
			this.SetAnimation("build");
		}
		else if (inair)
		{
			RunnerMoveVars@ moveVars;
			if (!blob.get("moveVars", @moveVars))
			{
				return;
			}
			Vec2f vel = blob.getVelocity();
			f32 vy = vel.y;
			if (vy < -0.0f && moveVars.walljumped)
			{
				this.SetAnimation("run");
			}
			else
			{
				this.SetAnimation("fall");
				this.animation.timer = 0;

				if (vy < -1.5)
				{
					this.animation.frame = 0;
				}
				else if (vy > 1.5)
				{
					this.animation.frame = 2;
				}
				else
				{
					this.animation.frame = 1;
				}
			}
		}
		else if ((left || right) ||
		         (blob.isOnLadder() && (up || down)))
		{
			this.SetAnimation("run");
		}
		else
		{
			// get the angle of aiming with mouse
			Vec2f aimpos = blob.getAimPos();
			Vec2f vec = aimpos - pos;
			f32 angle = vec.Angle();
			int direction;

			if ((angle > 330 && angle < 361) || (angle > -1 && angle < 30) ||
			        (angle > 150 && angle < 210))
			{
				direction = 0;
			}
			else if (aimpos.y < pos.y)
			{
				direction = -1;
			}
			else
			{
				direction = 1;
			}

			defaultIdleAnim(this, blob, direction);
		}
	}

	//set the attack head

	if (knocked > 0)
	{
		blob.Tag("dead head");
	}
	else if (action2 || blob.isInFlames())
	{
		blob.Tag("attack head");
		blob.Untag("dead head");
	}
	else
	{
		blob.Untag("attack head");
		blob.Untag("dead head");
	}
}

void DrawCursorAt(Vec2f position, string& in filename)
{
	position = getMap().getAlignedWorldPos(position);
	if (position == Vec2f_zero) return;
	position = getDriver().getScreenPosFromWorldPos(position - Vec2f(1, 1));
	GUI::DrawIcon(filename, position, getCamera().targetDistance * getDriver().getResolutionScaleFactor());
}

// render cursors

const string cursorTexture = "Entities/Characters/Sprites/TileCursor.png";

void onRender(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	if (!blob.isMyPlayer())
	{
		return;
	}
	if (getHUD().hasButtons())
	{
		return;
	}

	// draw tile cursor

	if (blob.isKeyPressed(key_action1) || this.isAnimation("strike"))
	{

		HitData@ hitdata;
		blob.get("hitdata", @hitdata);
		CBlob@ hitBlob = hitdata.blobID > 0 ? getBlobByNetworkID(hitdata.blobID) : null;

		if (hitBlob !is null) // blob hit
		{
			if (!hitBlob.hasTag("flesh"))
			{
				hitBlob.RenderForHUD(RenderStyle::outline);
			}
		}
		else// map hit
		{
			DrawCursorAt(hitdata.tilepos, cursorTexture);
		}
	}
}

void onGib(CSprite@ this)
{
	if (g_kidssafe)
	{
		return;
	}

	CBlob@ blob = this.getBlob();
	Vec2f pos = blob.getPosition();
	Vec2f vel = blob.getVelocity();
	vel.y -= 3.0f;
	f32 hp = Maths::Min(Maths::Abs(blob.getHealth()), 2.0f) + 1.0;
	const u8 team = blob.getTeamNum();
	CParticle@ Body     = makeGibParticle("Entities/Characters/Builder/BuilderGibs.png", pos, vel + getRandomVelocity(90, hp , 80), 0, 0, Vec2f(16, 16), 2.0f, 20, "/BodyGibFall", team);
	CParticle@ Arm1     = makeGibParticle("Entities/Characters/Builder/BuilderGibs.png", pos, vel + getRandomVelocity(90, hp - 0.2 , 80), 1, 0, Vec2f(16, 16), 2.0f, 20, "/BodyGibFall", team);
	CParticle@ Arm2     = makeGibParticle("Entities/Characters/Builder/BuilderGibs.png", pos, vel + getRandomVelocity(90, hp - 0.2 , 80), 1, 0, Vec2f(16, 16), 2.0f, 20, "/BodyGibFall", team);
	CParticle@ Shield   = makeGibParticle("Entities/Characters/Builder/BuilderGibs.png", pos, vel + getRandomVelocity(90, hp , 80), 2, 0, Vec2f(16, 16), 2.0f, 0, "Sounds/material_drop.ogg", team);
	CParticle@ Sword    = makeGibParticle("Entities/Characters/Builder/BuilderGibs.png", pos, vel + getRandomVelocity(90, hp + 1 , 80), 3, 0, Vec2f(16, 16), 2.0f, 0, "Sounds/material_drop.ogg", team);
}

string getSkin( CBlob@ blob, CPlayer@ player, string username )
{
    string skin = "";
    
	// -- ADMIN
	if (username == "Aphelion")
		skin = "Nus";
	else if (username == "MadRaccoon")
		skin = blob.getTeamNum() == 5 ? "ZombieRaccoon" :
		                                "Raccoon";
	else if (username == "stabborazz")
		skin = blob.getSexNum() == 0 ? "Barry" :
		                               "ImpureEvil";
	else if(username == "Sohkyo")
		skin = "Backpack";
	else if (username == "Alpha_Penguin" || username == "mutasm_saad")
		skin = "Penguin";
	else if (username == "LazarusTheGreat")
		skin = "Laz";
	else if (username == "pmattep99")
		skin = blob.getSexNum() == 0 ? "Blob" :
		                               "TwinDemonSpirit";
	else if (username == "bokkusu")
		skin = blob.getSexNum() == 0 ? "Cardboard" :
		                               "TwinDemonBox";
	
	// -- ASCENDED
	else if (username == "CodeRedAlert")
		skin = "CodeRedAlert";
	else if (username == "Mr_Gest")
		skin = "LusiadDwarf";
	else if (username == "MrsLusiad")
		skin = "MrsLusiad";
	else if (username == "Moderm")
		skin = "ModernDwarf";
	
	// -- SPONSOR
	else if (isSponsor(player))
	    //skin = "Claus";
		skin = "Backpack";
	
	return skin;
}

bool isSkinEnabled( CBlob@ blob, string username )
{
    return !getRules().hasTag(skin_tag + " " + blob.getPlayer().getUsername()) && (blob.getTeamNum() != RACE_UNDEAD || (username == "MadRaccoon" || username == "CodeRedAlert"));
}
