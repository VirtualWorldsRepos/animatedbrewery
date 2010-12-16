// $Id$
// constants
float _TIME_DELAY = 15.0;
integer running = TRUE;

default
{
	state_entry()
	{
		llSetTimerEvent(_TIME_DELAY);
	}

	timer()
	{
		integer    n = llGetInventoryNumber(INVENTORY_TEXTURE);
		integer    m;
		string     txtr;

		m = (integer) llFrand(n);
		txtr = llGetInventoryName(INVENTORY_TEXTURE, m);
		llSetTexture(txtr, 0);
	}

	touch_start(integer a)
	{
		if (llDetectedKey(0) == llGetOwner())
		{
			if (running)
			{
				llSetTimerEvent(0);
				llSetText("Stopped", <1.0, 0.0, 0.0>, 1.0);
				running = FALSE;
			}
			else
			{
				llSetTimerEvent(_TIME_DELAY);
				llSetText("Rent Advertising space here, contact KIm Minuet for details", <1.0, 0.0, 0.0>, 1.0);
				running = TRUE;
			}
		}
	}
}