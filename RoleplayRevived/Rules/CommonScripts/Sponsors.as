/* Sponsor.as
 * author: Aphelion
 */

shared bool isSponsor(CPlayer@ player)
{
    if (getSecurity().checkAccess_Feature(player, "sponsor"))
	    return true;
	
	/*
	// TEMPORARY 
    else if (getSecurity().checkAccess_Feature(player, "admin")) // admin
	{
		u32 month = Time_Month();
		u32 day = Time_MonthDate();
		
		if (month == 5 && day >= 9 && day <= 11)
		    return true;
	}
	// --
	*/
	
	string[] sponsors = {

		// -- SUPER ADMINS
		"Aphelion",
		"Sohkyo",
		"Duke_Jordan",
		"MadRaccoon",
		"zhuum",
		
		// -- ADMIN VETERANS
		"kaggit",
		"stabborazz",
		"Rspwn",
		"toffie0",
		"yamin",
		
		// -- ADMIN SPONSORS
		"AgentHightower",
		"bokkusu",
		"pmattep99",
		"bbpolkagal",
		"Alpha-Penguin",
		"LazarusTheGreat",
		"PalladiumGirl",
		"carlospaul",
		"DeathSmurfxD",
		"WuppieF",
	};
	
	for(int i = 0; i < sponsors.length; i++)
	{
		string sponsor = sponsors[i];
		if    (sponsor == player.getUsername())
			return true;
	}
	return false;
}
