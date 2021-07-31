const int min_cap = 2;
const int max_cap = 5;

int getNumUndead(CRules@ rules)
{
	int players = 0;
	for(int i = 0; i < getPlayersCount(); i++)
	{
		CPlayer@ player = getPlayer(i);
		if (player.getTeamNum() == 5)
			players++;
	}
	
	return players;
}

int getUndeadCap(CRules@ rules)
{
    if (rules.get_bool("nocap"))
		return 100;
	
	int players = getPlayersCount();
	return Maths::Min(min_cap + Maths::Max(0, players - 8) / 4, max_cap);
}