// $Id$
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
		if (message == _MILLING)
		{
			llParticleSystem([
				PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_DROP,
				PSYS_PART_FLAGS, PSYS_PART_INTERP_SCALE_MASK,
				PSYS_SRC_ACCEL, <0.0, 0.0, -9.8>,
				PSYS_PART_START_SCALE, <0.5, 0.5, 0.0>,
				PSYS_PART_END_SCALE, <0.1, 0.1, 0.0>,
				PSYS_SRC_BURST_PART_COUNT, 500,
				PSYS_SRC_TEXTURE, "MO",
				PSYS_SRC_MAX_AGE, 30.0,
				PSYS_PART_START_COLOR, <1.0, 1.0, 1.0>
					]);
		}
		else
		{
			llParticleSystem([]);
		}
	}
}