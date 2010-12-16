// $Id$
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
string _WHIRLPOOLING = "Whirlpooling";
string _CHILLING = "Chilling";
string _FERMENTING = "Fermenting";
string _CLEARING = "Clearing";
string _SERVING = "Serving";
//End Header.ins
// List tuns here that this script will operate on
string _HLT = "HLT Lid";
string _MT  = "MT Lid";
string _KT  = "Kettle Lid";

// list will be populated with processes relevant to the particular tun
list   transparent_procs = [];

default
{
	state_entry()
	{
// add an extra 'else if' to add more tuns ...
		if (llGetObjectName() == _HLT)
		{
			transparent_procs = [_MASHING, _SPARGING];
		}
		else if (llGetObjectName() == _MT)
		{
			transparent_procs = [_MILLING, _MASHING, _MASH_REST, _LAUTERING, _SPARGING];
		}
		else if (llGetObjectName() == _KT)
		{
			transparent_procs = [_LAUTERING, _SPARGING, _BOILING, _WHIRLPOOLING, _CHILLING];
		}
	}

	link_message(integer sender, integer num, string message, key id)
	{
		// if the current process is relevant for this tun make the lid transparent so we can watch
		if (llListFindList(transparent_procs, (list) message) != -1)
		{
			llSetAlpha(0.1, ALL_SIDES);
		}
		else
		{
			llSetAlpha(1.0, ALL_SIDES);
		}
	}
}