// generic character head script

#include "RP_Common.as";
#include "RP_Classes.as";
#include "RP_Races.as";

#include "Spoofy.as";
#include "EquipmentCommon.as";

// TODO: fix double includes properly, added the following line temporarily to fix include issues
#include "PaletteSwap.as"
#include "PixelOffsets.as"
#include "RunnerTextures.as"
#include "Accolades.as"

const s32 NUM_HEADFRAMES = 4;
const s32 NUM_UNIQUEHEADS = 30;
const int FRAMES_WIDTH = 8 * NUM_HEADFRAMES;

const string blowjob_path = "../Mods/" + RP_NAME + "/Entities/Characters/Sprites/PlayerHeads_01/";
const int blowjob_size = 1024;

//handling Heads pack DLCs

int getHeadsPackIndex(int headIndex)
{
	if (headIndex > 255) {
		if ((headIndex % 256) >= NUM_UNIQUEHEADS) {
			return Maths::Min(getHeadsPackCount() - 1, Maths::Floor(headIndex / 256.0f));
		}
	}
	return 0;
}

bool doTeamColour(int packIndex)
{
	switch(packIndex) {
		case 1: //FOTW
			return false;
	}
	//otherwise
	return true;
}

bool doSkinColour(int packIndex)
{
	switch(packIndex) {
		case 1: //FOTW
			return false;
	}
	//otherwise
	return true;
}

int getCustomHeadFrame( CBlob@ blob )
{
	bool disabled = false;

	if (disabled)
	{
		return -1;
	}
	
    CPlayer@ player = blob.getPlayer();
	if      (player !is null)
	{
	    string username = player.getUsername();
	    
		if(isSpoofing(getRules(), player))
			username = getSpoofedPlayer(getRules(), player);
		
		if (username == "Aphelion")
			return 0;
		else if(username == "Sohkyo")
		    return 4;
		else if(username == "MadRaccoon")
		    return 8;
		else if(username == "LazarusTheGreat")
		    return 12;
		else if(username == "PalladiumGirl")
		    return 16;
		else if(username == "pmattep99")
		    return 24;
		else if(username == "bokkusu")
		    return 28;
		else if(username == "CodeRedAlert")
		    return 32;
	}
	return -1;
}

int getHeadFrame(CBlob@ blob, int headIndex, bool default_pack)
{
	if(headIndex < NUM_UNIQUEHEADS)
	{
		return headIndex * NUM_HEADFRAMES;
	}

	//special heads logic for default heads pack
	if(default_pack && (headIndex == 255 || headIndex < NUM_UNIQUEHEADS))
	{
		CRules@ rules = getRules();
		bool holidayhead = false;
		if(rules !is null && rules.exists("holiday"))
		{
			const string HOLIDAY = rules.get_string("holiday");
			if(HOLIDAY == "Halloween")
			{
				headIndex = NUM_UNIQUEHEADS + 43;
				holidayhead = true;
			}
			else if(HOLIDAY == "Christmas")
			{
				headIndex = NUM_UNIQUEHEADS + 61;
				holidayhead = true;
			}
		}

		//if nothing special set
		if(!holidayhead)
		{
			string config = blob.getConfig();
			if(config == "builder")
			{
				headIndex = NUM_UNIQUEHEADS;
			}
			else if(config == "knight")
			{
				headIndex = NUM_UNIQUEHEADS + 1;
			}
			else if(config == "archer")
			{
				headIndex = NUM_UNIQUEHEADS + 2;
			}
			else if(config == "migrant")
			{
				Random _r(blob.getNetworkID());
				headIndex = 69 + _r.NextRanged(2); //head scarf or old
			}
			else
			{
				// default
				headIndex = NUM_UNIQUEHEADS;
			}
		}
	}

	return (((headIndex - NUM_UNIQUEHEADS / 2) * 2) +
	        (blob.getSexNum() == 0 ? 0 : 1)) * NUM_HEADFRAMES;
}

string getHeadTexture(int headIndex)
{
	return getHeadsPackByIndex(getHeadsPackIndex(headIndex)).filename;
}

void onPlayerInfoChanged(CSprite@ this)
{
	LoadHead(this, this.getBlob().getHeadNum());
}

CSpriteLayer@ LoadHead(CSprite@ this, int headIndex)
{
	CBlob@ blob = this.getBlob();
	CPlayer@ player = blob.getPlayer();

	// strip old head
	this.RemoveSpriteLayer("head");

	// get dlc pack info
	int headsPackIndex = getHeadsPackIndex(headIndex);
	HeadsPack@ pack = getHeadsPackByIndex(headsPackIndex);
	string texture_file = pack.filename;

	bool override_frame = false;

	//get the head index relative to the pack index (without unique heads counting)
	int headIndexInPack = (headIndex - NUM_UNIQUEHEADS) - (headsPackIndex * 256);

	//(has default head set)
	bool defaultHead = (headIndex == 255 || headIndexInPack < 0 || headIndexInPack >= pack.count);
	if(defaultHead)
	{
		//accolade custom head handling
		//todo: consider pulling other custom head stuff out to here
		if (player !is null && !player.isBot())
		{
			Accolades@ acc = getPlayerAccolades(player.getUsername());
			if (acc.hasCustomHead())
			{
				texture_file = acc.customHeadTexture;
				headIndex = acc.customHeadIndex;
				headsPackIndex = 0;
				override_frame = true;
			}
		}
	}
	else
	{
		//not default head; do not use accolades data
	}

	int team = doTeamColour(headsPackIndex) ? blob.getTeamNum() : 0;
	int skin = doSkinColour(headsPackIndex) ? blob.getSkinNum() : 0;
	
	s32 headFrame;
	if (getEquipmentSlotItem(blob, SLOT_ARMOUR) == "dragon_chestplate")
	{
		texture_file = "../Mods/" + RP_NAME + "/Entities/Characters/Sprites/DragonHelmet.png";
		headFrame = 0;
	}
	else if (headsPackIndex == 0)
	{
		CPlayer@ player = blob.getPlayer();
		
		int customFrame = getCustomHeadFrame(blob);
		if (customFrame > -1 && player !is null && !getRules().hasTag("head disabled " + player.getUsername()))
		{
			texture_file =
			   blob.getTeamNum() == RACE_DWARVES ?  "../Mods/" + RP_NAME + "/Entities/Characters/Sprites/CustomDwarfHeads.png" :
			   blob.getTeamNum() == RACE_ELVES   ?  "../Mods/" + RP_NAME + "/Entities/Characters/Sprites/CustomElfHeads.png" :
			   blob.getTeamNum() == RACE_ORCS    ?  "../Mods/" + RP_NAME + "/Entities/Characters/Sprites/CustomOrcHeads.png" :
			   blob.getTeamNum() == RACE_ANGELS  ?  "../Mods/" + RP_NAME + "/Entities/Characters/Sprites/CustomAngelHeads.png" :
			   blob.getTeamNum() == RACE_UNDEAD  ?  "../Mods/" + RP_NAME + "/Entities/Characters/Sprites/CustomUndeadHeads.png" :
													"../Mods/" + RP_NAME + "/Entities/Characters/Sprites/CustomHumanHeads.png";
													
			headFrame = customFrame;
		}
		else
		{
			texture_file =
			   blob.getTeamNum() == RACE_DWARVES ?  "../Mods/" + RP_NAME + "/Entities/Characters/Sprites/DwarfHeads.png" :
			   blob.getTeamNum() == RACE_ELVES   ?  "../Mods/" + RP_NAME + "/Entities/Characters/Sprites/ElfHeads.png" :
			   blob.getTeamNum() == RACE_ORCS    ?  "../Mods/" + RP_NAME + "/Entities/Characters/Sprites/OrcHeads.png" :
			   blob.getTeamNum() == RACE_UNDEAD  ?  "../Mods/" + RP_NAME + "/Entities/Characters/Sprites/UndeadHeads.png" :
													"../Mods/" + RP_NAME + "/Entities/Characters/Sprites/HumanHeads.png";
													
			headFrame = getHeadFrame(blob, headIndex, true);
		}
	}
	else
	{
		//
		headIndex = headIndex % 256; // wrap DLC heads into "pack space"
	
		// figure out head frame
		headFrame = override_frame ?
			(headIndex * NUM_HEADFRAMES) :
			getHeadFrame(blob, headIndex, headsPackIndex == 0);
	}

	//add new head
	CSpriteLayer@ head = this.addSpriteLayer("head", texture_file, 16, 16, team, skin);
	if (head !is null)
	{
		Animation@ anim = head.addAnimation("default", 0, false);
		anim.AddFrame(headFrame);
		anim.AddFrame(headFrame + 1);
		anim.AddFrame(headFrame + 2);
		head.SetAnimation(anim);

		head.SetFacingLeft(blob.isFacingLeft());
	}

	//setup gib properties
	blob.set_s32("head index", headFrame);
	blob.set_string("head texture", texture_file);
	blob.set_s32("head team", team);
	blob.set_s32("head skin", skin);

	return head;
}

void onGib(CSprite@ this)
{
	if (g_kidssafe)
	{
		return;
	}

	CBlob@ blob = this.getBlob();
	if (blob !is null && blob.getName() != "bed")
	{
		int frame = blob.get_s32("head index");
		int framex = frame % FRAMES_WIDTH;
		int framey = frame / FRAMES_WIDTH;

		Vec2f pos = blob.getPosition();
		Vec2f vel = blob.getVelocity();
		f32 hp = Maths::Min(Maths::Abs(blob.getHealth()), 2.0f) + 1.5;
		makeGibParticle(
			blob.get_string("head texture"),
			pos, vel + getRandomVelocity(90, hp , 30),
			framex, framey, Vec2f(16, 16),
			2.0f, 20, "/BodyGibFall", blob.getTeamNum()
		);
	}
}

void onTick(CSprite@ this)
{
	CBlob@ blob = this.getBlob();

	ScriptData@ script = this.getCurrentScript();
	if (script is null)
		return;

	if (blob.getShape().isStatic())
	{
		script.tickFrequency = 60;
	}
	else
	{
		script.tickFrequency = 1;
	}

	// head animations
	CSpriteLayer@ head = this.getSpriteLayer("head");

	// load head when player is set or it is AI
	if (head is null && (blob.getPlayer() !is null || (blob.getBrain() !is null && blob.getBrain().isActive()) || blob.getTickSinceCreated() > 3))
	{
		@head = LoadHead(this, blob.getHeadNum());
	}
	
	/*
	if (getGameTime() % 45 == 0 && (blob.get_string("head texture") != getSpritePath(this)))
	{
		@head = LoadHead(this, blob.getHeadNum());
	}
	*/

	if (head !is null)
	{
		Vec2f offset;

		// pixeloffset from script
		// set the head offset and Z value according to the pink/yellow pixels
		int layer = 0;
		Vec2f head_offset = getHeadOffset(blob, -1, layer);

		// behind, in front or not drawn
		if (layer == 0)
		{
			head.SetVisible(false);
		}
		else
		{
			head.SetVisible(this.isVisible());
			head.SetRelativeZ(layer * 0.25f);
		}

		offset = head_offset;

		// set the proper offset
		Vec2f headoffset(this.getFrameWidth() / 2, -this.getFrameHeight() / 2);
		headoffset += this.getOffset();
		headoffset += Vec2f(-offset.x, offset.y);
		headoffset += Vec2f(0, -2);
		head.SetOffset(headoffset);

		if (blob.hasTag("dead") || blob.hasTag("dead head"))
		{
			head.animation.frame = 2;

			// sparkle blood if cut throat
			if (getNet().isClient() && getGameTime() % 2 == 0 && blob.hasTag("cutthroat"))
			{
				Vec2f vel = getRandomVelocity(90.0f, 1.3f * 0.1f * XORRandom(40), 2.0f);
				ParticleBlood(blob.getPosition() + Vec2f(this.isFacingLeft() ? headoffset.x : -headoffset.x, headoffset.y), vel, SColor(255, 126, 0, 0));
				if (XORRandom(100) == 0)
					blob.Untag("cutthroat");
			}
		}
		else if (blob.hasTag("attack head"))
		{
			head.animation.frame = 1;
		}
		else
		{
			head.animation.frame = 0;
		}
	}
}
