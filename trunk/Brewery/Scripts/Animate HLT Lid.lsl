//
// Make Tun lid transparent during relevant processes that involve it
//
//Header.ins
//Constants
string _INIT = "INIT";
string _INSTRUCT = "INSTRUCTIONS";
string _STOP = "STOP";
string _NEXT = "NEXT";
string _PREV = "PREV";
string _RESET = "RESET";
string _DETAILS = "DETAILS";

string _INSTRUCTIONS = "Instructions";
string _MILLING = "Milling";
string _MASHING = "Mashing";
string _MASH_REST = "Mash Rest";
string _LAUTERING = "Lautering";
string _SPARGING = "Sparging";
string _BOILING = "Boiling";
string _CHILLING = "Chilling";
string _FERMENTING = "Fermenting";
string _CLEARING = "Clearing";
string _SERVING = "Serving";
//End Header.ins
default
{
	state_entry()
	{
	}

	link_message(integer sender, integer num, string message, key id)
	{
		if (message == _MASHING)
		{
			llSetAlpha(0.1, ALL_SIDES);
		}
		else if (message == _SPARGING)
		{
			llSetAlpha(0.1, ALL_SIDES);
		}
		else
		{
			llSetAlpha(1.0, ALL_SIDES);
		}
	}
}