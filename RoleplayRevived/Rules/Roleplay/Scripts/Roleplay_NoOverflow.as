/* Roleplay_NoOverflow.as
 * author: Aphelion
 *
 * Keeps the total number of blobs below a certain amount, which is just about the amount that causes the infinite loading bug.
 */
 
#define SERVER_ONLY;
 
const u32 TICK_INTERVAL = 60 * getTicksASecond();
const u16 MAX_BLOBS = 2250; //1750
const u16 MIN_TO_DELETE = 100;

const string[] NAMES_TO_DELETE = {
	"firefly",
	"fishy",
	"cactus",
    "leaf",
	"egg",
	"flowers",
	"bush",
    "chicken",
	"heart",
};

void onTick( CRules@ this )
{
    const u32 gametime = getGameTime();
	if      ((gametime % TICK_INTERVAL) == 0)
	{
        CBlob@[]  blobs;
        getBlobs(@blobs);
	    
	    if (blobs.length >= MAX_BLOBS)
	    {
		    int    cleared = 0;
		    for(uint i = 0; i < blobs.length; i++)
		    {
		        if(cleared >= MIN_TO_DELETE)
			        break;
			
		        CBlob@ blob = blobs[i];
			    if    (blob !is null && NAMES_TO_DELETE.find(blob.getName()) != -1)
			    {
				    blob.server_Die();
				    cleared++;
			    }
		    }
	    }
		
		/*
		int cleared = 0;
		for(uint n = 0; n < NAMES_TO_DELETE.length; n++)
		{
			CBlob@[] blobs;
			getBlobsByName(NAMES_TO_DELETE[n], @blobs);
			
			for(uint i = 0; i < blobs.length; i++)
			{
				if(cleared >= MIN_TO_DELETE)
					break;
				
				if (blob !is null)
				{
				    blob.server_Die();
				    cleared++;
				}
			}
		}
		*/
	}
}
