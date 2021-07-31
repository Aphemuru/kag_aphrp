/* Roleplay_UndeadCap.as
 */

#define CLIENT_ONLY

#include "Roleplay_UndeadCapCommon.as";
#include "TeamColour.as";

const string title = "Undead";
const Vec2f dimensions(300, 55);

bool show = false;

void onRender(CRules@ this)
{
    CPlayer@ player = getLocalPlayer();
	if (player is null)
		return;
		
	if (player.getTeamNum() != 255 && !show)
		return;
		
	Vec2f tl = Vec2f(getScreenWidth() / 2 - dimensions.x / 2, getScreenHeight() - dimensions.y - 24 - 160);
	Vec2f br = Vec2f(tl.x + dimensions.x, tl.y + dimensions.y);
	Vec2f text_dim;
	
	GUI::DrawPane(tl, br, SColor(0x80ffffff));
	
	GUI::GetTextDimensions(title, text_dim);
	GUI::DrawText(title, tl + Vec2f(dimensions.x / 2 - text_dim.x / 2, 5), getTeamColor(5));
	
	int numUndead = getNumUndead(this);
	int undeadCap = getUndeadCap(this);
	
	string text = numUndead + "/" + undeadCap;
	SColor color = color_white;
	
	if (numUndead < undeadCap)
	{
		color = SColor(255, 64, 255, 64);
		
		string extra_text = "Noom is in need of servants";
		GUI::GetTextDimensions(extra_text, text_dim);
		GUI::DrawText(extra_text, tl + Vec2f(dimensions.x / 2 - text_dim.x / 2, 5) + Vec2f(0, 30), color);
	}
	
	GUI::GetTextDimensions(text, text_dim);
	GUI::DrawText(text, tl + Vec2f(dimensions.x / 2 - text_dim.x / 2, 5) + Vec2f(0, 20), color);
}

void ShowTeamMenu(CRules@ this)
{
	show = true;
}

void onCommand( CRules@ this, u8 cmd, CBitStream @params )
{
    if (cmd == this.getCommandID("pick teams"))
    {
		show = false;
    }
    else if (cmd == this.getCommandID("pick spectator"))
    {
		show = false;
	}
	else if (cmd == this.getCommandID("pick none"))
	{
		show = false;
	}
}
