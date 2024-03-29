// $Id$
// Animate Tun Contents
// Change global list definitions for which tun
// This is the: MASH TUN version.
//
//Header.ins
//Constants
//
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

integer _MENU_CHAN = 6901;
integer _MT_CHAN = 6902;
integer _KT_CHAN = 6903;
integer _HLT_CHAN = 6904;

//End Header.ins

string _GRAIN = "MT Level";
string _WORT = "Kettle Level";
string _HOTL = "Hot Liquor";
vector _FULL_LVL = <0.0, 0.0, 1.8>;
vector _HALF_LVL = <0.0, 0.0, 0.9>;
vector _EMPTY_LVL = <0.0, 0.0, 0.0>;

// Mask Flags - set to TRUE to enable
integer glow = TRUE;            // Make the particles glow
integer bounce = TRUE;          // Make particles bounce on Z plan of object
integer interpColor = TRUE;     // Go from start to end color
integer interpSize = TRUE;      // Go from start to end size
integer wind = FALSE;           // Particles effected by wind
integer followSource = FALSE;    // Particles follow the source
integer followVel = TRUE;       // Particles turn to velocity direction

// Choose a pattern from the following:
// PSYS_SRC_PATTERN_EXPLODE
// PSYS_SRC_PATTERN_DROP
// PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY
// PSYS_SRC_PATTERN_ANGLE_CONE
// PSYS_SRC_PATTERN_ANGLE
integer pattern = PSYS_SRC_PATTERN_EXPLODE;

// Select a target for particles to go towards
// "" for no target, "owner" will follow object owner
//    and "self" will target this object
//    or put the key of an object for particles to go to
key target = "";

// Particle paramaters
float age = 3;                  // Life of each particle
float maxSpeed = .1;            // Max speed each particle is spit out at
float minSpeed = .1;            // Min speed each particle is spit out at
string texture;                 // Texture used for particles, default used if blank
float startAlpha = 0.1;           // Start alpha (transparency) value
float endAlpha = 0.01;           // End alpha (transparency) value
vector startColor = <1,1,1>;    // Start color of particles <R,G,B>
vector endColor = <1,1,1>;      // End color of particles <R,G,B> (if interpColor == TRUE)
vector startSize = <.5,.5,.7>;     // Start size of particles
vector endSize = <.1,.1,.1>;       // End size of particles (if interpSize == TRUE)
vector push = <0,0,.1>;          // Force pushed on particles

// System paramaters
float rate = .05;            // How fast (rate) to emit particles
float radius = .5;          // Radius to emit particles for BURST pattern
integer count = 100;        // How many particles to emit per BURST
float outerAngle = 1.54;    // Outer angle for all ANGLE patterns
float innerAngle = 1.55;    // Inner angle for all ANGLE patterns
vector omega = <0,0,10>;    // Rotation of ANGLE patterns around the source
float life = 0;             // Life in seconds for the system to make particles

// Script variables
integer flags;

steam_on(integer big)
{
	if (big)
	{
		age = 10;
	}
	else
	{
		age = 3;
	}
	
    flags = 0;
    if (target == "owner") target = llGetOwner();
    if (target == "self") target = llGetKey();
    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (interpColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (interpSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind) flags = flags | PSYS_PART_WIND_MASK;
    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "") flags = flags | PSYS_PART_TARGET_POS_MASK;

    llParticleSystem([  PSYS_PART_MAX_AGE,age,
        PSYS_PART_FLAGS,flags,
        PSYS_PART_START_COLOR, startColor,
        PSYS_PART_END_COLOR, endColor,
        PSYS_PART_START_SCALE,startSize,
        PSYS_PART_END_SCALE,endSize,
        PSYS_SRC_PATTERN, pattern,
        PSYS_SRC_BURST_RATE,rate,
        PSYS_SRC_ACCEL, push,
        PSYS_SRC_BURST_PART_COUNT,count,
        PSYS_SRC_BURST_RADIUS,radius,
        PSYS_SRC_BURST_SPEED_MIN,minSpeed,
        PSYS_SRC_BURST_SPEED_MAX,maxSpeed,
        PSYS_SRC_TARGET_KEY,target,
        PSYS_SRC_INNERANGLE,innerAngle,
        PSYS_SRC_OUTERANGLE,outerAngle,
        PSYS_SRC_OMEGA, omega,
        PSYS_SRC_MAX_AGE, life,
        PSYS_SRC_TEXTURE, texture,
        PSYS_PART_START_ALPHA, startAlpha,
        PSYS_PART_END_ALPHA, endAlpha
            ]);
}

steam_off()
{
    llParticleSystem([]);
}

//constants
string  _EMPTY   = "EMPTY";
string  _HALF    = "HALF";
string  _FULL    = "FULL";

list half_processes;
list full_processes;

list big_steam_processes;
list little_steam_processes;

list whirlpool_processes; // processes where we whirlpool the object
list wort_processes; // processes where contents texture is wort
list grain_processes; // processes where contents texture is grain (else it's mash)

vector  starting_pos;
integer chan;

default
{
	state_entry()
	{
		string  my_name = llGetObjectName();
		
		starting_pos = llGetPos();
		if (my_name == _GRAIN)
		{
			chan = _MT_CHAN;
			half_processes += [ _MILLING, _LAUTERING, _BOILING ];
			full_processes += [ _MASHING, _MASH_REST, _SPARGING ];
			little_steam_processes += [_MASHING, _MASH_REST, _LAUTERING, _SPARGING ];
			big_steam_processes = [];
			whirlpool_processes = [];
			wort_processes = [];
			grain_processes = [ _MILLING ];
		}
		else if (my_name == _WORT)
		{
			chan = _KT_CHAN;
			half_processes += [ _LAUTERING ];
			full_processes += [ _SPARGING, _BOILING, _WHIRLPOOLING, _CHILLING ];
			big_steam_processes += [ _BOILING ];
			little_steam_processes = [ _LAUTERING, _SPARGING ];
			whirlpool_processes = [_WHIRLPOOLING];
			wort_processes = [ _BOILING, _WHIRLPOOLING, _CHILLING ];
			grain_processes = [];
		}
		else if (my_name == _HOTL)
		{
			chan = _HLT_CHAN;
			half_processes += [ _MASHING, _SPARGING ];
			full_processes += [ _RESET, _INSTRUCTIONS, _MILLING, _MASH_REST, _LAUTERING, _BOILING, _CHILLING, _FERMENTING, _CLEARING, _SERVING ];
			little_steam_processes = [ _RESET, _INSTRUCTIONS, _MASHING, _SPARGING, _RESET, _MILLING, _MASH_REST, _LAUTERING, _BOILING, _CHILLING, _FERMENTING, _CLEARING, _SERVING ];
			big_steam_processes = [];
			whirlpool_processes = [];
		}
		else
		{
			llSay(PUBLIC_CHANNEL, "PANIC!!");
		}

		// [TODO: listen only to brewery, perhaps using llGetOwner() ??]
		llListen(chan,"","","");
	}

	listen(integer ch, string name, key id, string cmd)
	{
		if (id == id) // make sure it's the brewery talking to us!
		{
			//			llOwnerSay("CHANNEL, ID and NAME are: " + (string) ch + " " + (string) id + " " + name);

			// Level of tun contents ...
			if (llListFindList(full_processes, (list) cmd) != -1)
			{
				llSetPos(starting_pos + _FULL_LVL);
			}
			else if (llListFindList(half_processes, (list) cmd) != -1)
			{
				llSetPos(starting_pos + _HALF_LVL);
			}
			else
			{
				llSetPos(starting_pos);
			};
			// Amount of Steam from contents
			if (llListFindList(big_steam_processes, (list) cmd) != -1)
			{
				steam_on(TRUE);
			}
			else if (llListFindList(little_steam_processes, (list) cmd) != -1)
			{
				steam_on(FALSE);
			}
			else
			{
				steam_off();
			};
			// Whirlpool animation of contents
			if (llListFindList(whirlpool_processes, (list) cmd) != -1)
			{
				llTargetOmega(<0.0, 0.0, 1.0>, PI_BY_TWO, 1.0);
			}
			else
			{
				llTargetOmega(ZERO_VECTOR, 0.0, 0.0);
			};

			// Change grain/mash Texture if required
			if (grain_processes)
			{
				if (llListFindList(grain_processes, (list) cmd) != -1)
				{
					llSetTexture("MO", ALL_SIDES);
				}
				else
				{
					llSetTexture("Mash", ALL_SIDES);
				}
			}

			// Change Wort/Water Texture if required
			if (wort_processes)
			{
				if (llListFindList(wort_processes, (list) cmd) != -1)
				{
					llSetTexture("Wort", ALL_SIDES);
					llSetColor(<1.0, 1.0, 1.0>, ALL_SIDES);
				}
				else
				{
					llSetTexture("Water", ALL_SIDES);
					llSetColor(<0.5, 0.5, 0.5>, ALL_SIDES);
				}
			}
		}
	}
}