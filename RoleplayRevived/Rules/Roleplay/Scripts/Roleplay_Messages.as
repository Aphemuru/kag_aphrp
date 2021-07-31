/* Roleplay_Messages.as
 * author: Aphelion3371
 */

#define CLIENT_ONLY

const u16 JOIN_MESSAGE_DELAY = 5 * 30;
const u16 MESSAGE_INTERVAL = 90 * 30;

const string[] messages = {
	
	// -- GAME INFO
	"Did you know?: You can access the Diplomacy system via; Esc -> Vote -> Diplomacy",
	"Did you know?: You can open the equipment menu by pressing the F key",
	"Did you know?: You can purchase food and potions from a market or make them yourself at a kitchen",
	"Did you know?: Humans specialize in magic, Dwarves in construction, Elves in archery, and Orcs in melee",
	"Did you know?: Zombies sometimes drop very rare scrolls and potions",
	"Did you know?: It is rumoured that an evil Necromancer named Noom lives deep underground in a dangerous dungeon",
	"Did you know?: Plants will grow faster when exposed to light and plants of the same type, though they don't like overcrowded areas",
	
	// -- MISC INFO
	"Did you know?: You can support us on patreon to keep the server online and support further development!\n" +
				   "http://patreon.com/aphelionsroleplay",
				   
	"Pledge $2 USD: Receive Donator status, a discord rank, and access to the Angel race (they can fly!)\n" +
	"Pledge $6 USD: Receive Sponsor status, a discord rank, a special builder skin, and access to the Undead race (take over the world!)",
	
	"Did you know?: If you have a custom head, you can toggle it by typing /togglehead",
	"Did you know?: If you have a custom skin, type /toggleskin to toggle it\n" +
	               "Custom builder skins are exclusive to some sponsors and veteran admins\n",
				   
	// -- RULES
	"Rule 1) You must Roleplay\nRule 2) Respect the rules",
    "Rule 3) Be respectful towards other players\nRule 4) All diplomacy actions must involve roleplay, don't use diplomacy for your own advantage",
    "Rule 4) All diplomacy actions must involve roleplay, don't use diplomacy for your own advantage\nRule 5) You must accept one term of any race you have lost a war against",
    "Rule 6) Do not grief/attack anyone you are not at war with. Do not steal from allies.\nRule 7) Do not perform hacking, spamming or impersonation of other players.",
    "Rule 8) Do not exploit bugs\nRule 9) Don't be an asshole and don't be toxic",
    "Rule 10) Do not spam wars (being an Orc isn't a reason for war!),\n every war needs a roleplaying reason. Don't bully weaker races!",
	
	// -- RULES
	/*"Rules 1-5\n" +
	"Rule 1) You must Roleplay\n" +
    "Rule 2) Respect the rules\n" +
    "Rule 3) Show respect towards other players (they are human too!) and treat people how you wish to be treated\n" +
    "Rule 4) All diplomacy actions must involve Roleplay (that includes Undead!)\n" +
    "Rule 5) You must accept one term of any race that you lost a war against\n",
	"Rules 6-10\n" +
    "Rule 6) Do not grief or take from teams that you are not at war with, unless it's a term of a war being won\n" +
    "Rule 7) Do not perform hacking, spamming or impersonation of other players\n" +
    "Rule 8) Do not build swastikas\n" +
    "Rule 9) Do not exploit bugs\n" +
    "Rule 10) Do not be a jackass/idiot/retard/dick/asshole (as determined by an admin)",
	*/
	
	// -- OTHER
	"Join the discord at https://discord.gg/SQDEfc9\n" +
	"Where you can report rule breakers, apply for administrator status, share your ideas, and learn how to donate."
};

bool just_joined = true;
int counter = 0;

void onTick( CRules@ this )
{
	const u32 time = getGameTime();
	
	if (just_joined && (time % JOIN_MESSAGE_DELAY) == 0)
	{
		client_AddToChat("Welcome to Aphelion's Roleplay Server!", SColor(255, 127, 0, 127));
		client_AddToChat("Join the discord at https://discord.gg/SQDEfc9", SColor(255, 127, 0, 127));
	    just_joined = false;
	}
	else if(time % MESSAGE_INTERVAL == 0)
	{
	    client_AddToChat(messages[counter++ % messages.length], SColor(255, 127, 0, 127));
	}
}
