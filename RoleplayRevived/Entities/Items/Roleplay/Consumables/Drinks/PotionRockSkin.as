/* PotionRockSkin.as
 * author: Aphelion
 */

const u16 EFFECT_DURATION = 15 * 30;

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	if (cmd == this.getCommandID("activate"))
	{
		CBlob@ carrier = this.getCarriedBlob();
		if    (carrier !is null)
		{
			carrier.set_u32("potion_rockskin_end", getGameTime() + EFFECT_DURATION);
			carrier.AddScript( "/PotionRockSkinEffect.as" );
			
			this.getSprite().PlaySound("/PotionDrink.ogg");
			
			if(getNet().isServer())
			{
			    this.server_Die();
			}
		}
    }
}
