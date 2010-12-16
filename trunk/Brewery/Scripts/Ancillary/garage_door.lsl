// $Id$
default
{
	state_entry()
	{
		//        llSay(0, "Hello, Avatar!");
		state closed;
	}
}

state open
{
	touch_start(integer total_number)
	{
		if (llDetectedKey(0) == llGetOwner())
		{
			//            llSay(0, "Touched: "+(string)total_number);
			llSetPos(llGetPos() - <0.0, 0.0, 3.8>);
			state closed;
		}
	}
}

state closed
{
	touch_start(integer total_number)
	{
		if (llDetectedKey(0) == llGetOwner())
		{
			//            llSay(0, "Touched: "+(string)total_number);
			llSetPos(llGetPos() + <0.0, 0.0, 3.8>);
			state open;
		}
		else
		{
			while (total_number--)
			{
				llInstantMessage(llDetectedKey(total_number),"Sorry, we're not open right now.  Please IM Kim Minuet for information :) ");
			}
		}
	}
}