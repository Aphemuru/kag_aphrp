/* RunnerWings.as
 * author: Aphelion
 *
 * The script that handles flying mechanics of wings.
 */
 
#include "RP_Races.as";

#include "EquipmentCommon.as";
 
const f32 wing_force_x = 5.0f;
const f32 wing_force_y = -30.0f;

void onInit(CSprite@ this)
{
	LoadSprites(this);
}

void onPlayerInfoChanged(CSprite@ this)
{
	LoadSprites(this);
}

void LoadSprites(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	CPlayer@ player = blob.getPlayer();
    string wings_sprite = "AngelWings.png";
	
	if (getEquipmentSlotItem(blob, SLOT_ARMOUR) == "dragon_chestplate")
	{
		wings_sprite = "DragonWings.png";
	}
	else if (player !is null)
	{
		string username = player.getUsername();
		if (username == "zhuum")
			wings_sprite = "TeamDragonWings.png";
		else if (username == "stabborazz" && blob.getSexNum() == 0)
			wings_sprite = "BarryWings.png";
		else if (username == "pmattep99" && blob.getSexNum() == 0)
			wings_sprite = "SpiritWings.png";
		else if ((username == "pmattep99" || username == "bokkusu") && blob.getSexNum() == 1)
			wings_sprite = "FallenWings.png";
	}
	
	this.RemoveSpriteLayer("wings");
    CSpriteLayer@ wings = this.addSpriteLayer("wings", wings_sprite, 64, 64, this.getBlob().getTeamNum(), this.getBlob().getSkinNum());
	
	if (wings !is null)
	{
        Animation@ anim = wings.addAnimation( "default", 0, false );
        anim.AddFrame(0);
		
        Animation@ fly = wings.addAnimation( "fly", 3, true );
        fly.AddFrame(1);
        fly.AddFrame(2);
        fly.AddFrame(3);
        fly.AddFrame(4);
		
        Animation@ glide = wings.addAnimation( "glide", 6, true );
        glide.AddFrame(1);
        glide.AddFrame(2);
        glide.AddFrame(3);
        glide.AddFrame(4);
		
		wings.SetRelativeZ(-10.0f);
	    wings.SetVisible(false);
	}
}

void onTick( CSprite@ this )
{
    CBlob@ blob = this.getBlob();
    CSpriteLayer@ wings = this.getSpriteLayer("wings");
	
	if (blob.hasTag("dead"))
    {
		this.RemoveSpriteLayer("wings");
		return;
	}
	
	if (wings !is null)
	{
        if (hasWings(blob))
	    {
	        wings.SetVisible(true);
	        
            if (isInAir(blob))
	        {
	            if(blob.isKeyPressed(key_up))
			    {
			        wings.SetAnimation("fly");
			    }
				else if(!blob.isKeyPressed(key_down))
				{
				    wings.SetAnimation("glide");
				}
				else
				{
	            	wings.SetAnimation("default");
				}
	        }
			else
			{
	            wings.SetAnimation("default");
			}
	    }
	    else
	    {
	        wings.SetVisible(false);
	    }
	}
}

void onInit( CBlob@ this )
{
	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().runFlags |= Script::tick_not_onladder;
	this.getCurrentScript().runFlags |= Script::tick_not_onground;
	this.getCurrentScript().removeIfTag = "dead";
}

void onTick( CBlob@ this )
{
	if (hasWings(this))
    {
	    if (this.isKeyPressed(key_up))
		{
		    Vec2f vel = this.getVelocity();
			if   (vel.y > 0)
			{
				this.setVelocity(Vec2f(vel.x, vel.y - 1));
			}
			
	        this.AddForce(Vec2f(this.isKeyPressed(key_left) ? -wing_force_x : this.isKeyPressed(key_right) ? wing_force_x : 0.0f, wing_force_y));
		}
		else if(!this.isKeyPressed(key_down))
		{
		    this.AddForce(Vec2f(0.0f, wing_force_y / 2));
		}
	}
}

bool isInAir( CBlob@ this )
{
    return !this.isOnGround() && !this.isOnLadder();
}

bool hasWings( CBlob@ this )
{
    CPlayer@ player = this.getPlayer();
	if      (player !is null && this.getTeamNum() != RACE_UNDEAD)
	{
	    string username = player.getUsername();
		if   ((username == "Aphelion" || username == "zhuum" || (username == "stabborazz" && this.getSexNum() == 0) || username == "pmattep99" || username == "bokkusu") && !getRules().hasTag("skin disabled " + username))
		    return true;
	}
	
    return this.getTeamNum() == RACE_ANGELS || getEquipmentSlotItem(this, SLOT_ARMOUR) == "dragon_chestplate" ||
	                                           getEquipmentSlotItem(this, SLOT_ARMOUR) == "armadyl_chainmail" ||
											   getEquipmentSlotItem(this, SLOT_ARMOUR) == "aura_flight";
}
