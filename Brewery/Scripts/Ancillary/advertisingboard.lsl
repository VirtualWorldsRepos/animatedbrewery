// 20101115 kim Allow random or sequential processing of ads
//              Give a notecard if a patron clicks the ad.
//
// constants
float _TIME_DELAY = 15.0;

// What sequence do we want to show ads in?
integer _SEQ = 0;
integer _RANDOM = 1;
integer _STOP = 2;
// default is _SEQ
integer mode = _SEQ;

integer n;
integer current;
string  txtr;
string  notecard_name;

default
{
	state_entry()
	{
		llSetTimerEvent(_TIME_DELAY);
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
		else
		{
			llOwnerSay("Unexpected mode " + (string) mode);
		}

		txtr = llGetInventoryName(INVENTORY_TEXTURE, current);
		llSetTexture(txtr, 0);

		notecard_name = "NC_" + txtr;
		llSetText("Touch for a Notecard from this vendor", <1.0, 0.0, 0.0>, 0.5);

		if (!~llGetInventoryType(notecard_name))
		{
			notecard_name = "";
			llSetText("", <1.0, 0.0, 0.0>, 1.0);
		}
	}

	touch_start(integer a)
	{
		if (llDetectedKey(0) == llGetOwner())
		{
			if (++mode > _STOP)
			{
				mode = 0;
			}

			if (mode == _STOP)
			{
				llSetTimerEvent(0);
				llSetText("Stopped", <1.0, 0.0, 0.0>, 1.0);
			}
			else
			{
				llSetTimerEvent(_TIME_DELAY);
				llSetText("", <1.0, 0.0, 0.0>, 1.0);
			}
		}
		else
		{
			if (notecard_name)
			{
				while (a--)
				{
					llGiveInventory(llDetectedKey(a), notecard_name);
				}
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