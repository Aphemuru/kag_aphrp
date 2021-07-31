
#include "RP_Classes.as";
#include "RP_Races.as";

void onInit(CBlob@ this)
{
	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	this.getCurrentScript().runFlags |= Script::tick_not_onladder;
	this.getCurrentScript().runFlags |= Script::tick_not_onground;
	this.getCurrentScript().removeIfTag = "dead";
}

void onTick(CBlob@ this)
{
    if(this.wasKeyPressed(key_down))
	    return;
		
	if(!isClassTypeMarksman(this) && !raceIs(this, RACE_ELVES))
	    return; // Only Archers can climb trees, with an exception for Elves.
	
    if (this.getMap().getSectorAtPosition( this.getPosition(), "tree" ) !is null)
        this.getShape().getVars().onladder = true;
}
