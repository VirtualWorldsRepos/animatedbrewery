// 20101115 kim Allow random or sequential processing of ads
//              Give a notecard if a patron clicks the ad.
//
// constants
float _TIME_DELAY = 15.0;
integer running = TRUE;

// What sequence do we want to show ads in?
integer _RANDOM = 0;
integer _SEQ = 1;
integer mode = _RANDOM;

integer n;
integer current;
string  txtr;

default
{
	state_entry()
	{
		llSetTimerEvent(_TIME_DELAY);
		llListen(6907, "", llGetOwner(), "");
		n = llGetInventoryNumber(INVENTORY_TEXTURE);
		current = n - 1;
	}

	timer()
	{
		if (mode == _RANDOM)
		{
			current = (integer) llFrand(n);
		}
		else if (mode == _SEQ)
		{
			if (current-- < 0)
			{
				current = n - 1;
			}
		}
			
		txtr = llGetInventoryName(INVENTORY_TEXTURE, current);
		llSetTexture(txtr, 0);
	}

	listen(integer channel, string name, key id, string message)
	{
		if (message == "random")
		{
			mode = _RANDOM;
		}
		else if (message == "seq")
		{
			mode = _SEQ;
			current = n - 1;
		}
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
				llSetText("", <1.0, 0.0, 0.0>, 1.0);
				running = TRUE;
			}
		}
		else
		{
			while (a--)
			{
				llGiveInventory(llDetectedKey(a), "NC_" + txtr);
			}
		}
	}

	changed(integer change)
	{
		if (change & CHANGED_INVENTORY)
		{
			llOwnerSay("Inventory Changed, resetting script");
			llResetScript();
		}
	}
}