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
        if (llListFindList( [ _LAUTERING, _SPARGING ], (list) message) != -1 )
		{
			llSetTexture("Water", ALL_SIDES);
			llSetTextureAnim(ANIM_ON | SMOOTH | LOOP , ALL_SIDES, 1, 1, 1.0, 1.0, 0.5);
		}
		else if (llListFindList( [ _CHILLING ], (list) message) != -1 )
		{
			// Components that need to run in reverse have the string "Reverse" imbedded in their name
			if (llSubStringIndex(llGetObjectName(), "Reverse") != -1)
			{
				llSetTexture("Water", ALL_SIDES);
				llSetTextureAnim(ANIM_ON | SMOOTH | LOOP | REVERSE , ALL_SIDES, 1, 1, 1.0, 1.0, 0.5);
			}
		}
		else
		{
			llSetTexture("SS", ALL_SIDES);
			llSetTextureAnim(FALSE, ALL_SIDES, 0, 0, 0.0, 0.0, 1.0);
		}
	}
}