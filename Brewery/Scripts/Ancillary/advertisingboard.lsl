string mytext = "";

default
{
	state_entry()
	{
		llSetTimerEvent(10.0);
	}

	timer()
	{
		integer    n = llGetInventoryNumber(INVENTORY_TEXTURE);
		integer    m;
		string     txtr;

		m = (integer) llFrand(n) + 1;
		txtr = llGetInventoryName(INVENTORY_TEXTURE, m);
		llSetText((string) m + " " + (string) txtr, <1.0, 1.0, 1.0>, 1.0);
		llSetTexture(txtr, 0);
	}

	touch_start(integer total_number)
	{
		if (llDetectedKey(0) == llGetOwner())
		{
			if (mytext == "")
			{
				mytext = "Stopped";
				llSetTimerEvent(0.0);
			}
			else
			{
				mytext = "";
				llSetTimerEvent(10.0);
			}
			llSetText(mytext,<1.0, 0.0, 0.0>, 1.0);
		}
	}
}