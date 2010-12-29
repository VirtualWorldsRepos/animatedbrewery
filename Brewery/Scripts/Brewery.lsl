// $Id$
// 20101220 kim Add demo mode.
//
//!Animate Brewery.lsl
// Brewery Controller
//
// Written by Kim Minuet, October 2010
//
// Move from state to state in the brewing process presenting the menu, desriptions
// and details and pass messages to the linked components to animate the steps.
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
string _DEMO_ON = "DEMO ON";
string _DEMO_OFF = "DEMO OFF";

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

string _INSTRUCTIONS_DESC = "Instructions\nPress RESET to reset the brewery to it's initial view.\nPress NEXT to see the next brewing step.\nPress PREV to review the previous step.\nPress DETAILS for detailed information in a Notecard.\nYou may want to stand on the walkways for a better view inside the tuns.";
string _MILLING_DESC = "Milling\nMalted grain (mostly barley, but also wheat, rye, oats, corn or others may be used) are cracked to expose the kernel and put in the mash tun.  Different types and roasts of grain contribute the various flavours and colours to beer.";
string _MASHING_DESC = "Mashing\nHot water is added to the Mash Tun in order to set the wet grain (called the Mash) to specific temperature.";
string _MASH_REST_DESC = "Mash Rest\nThe Mash sits at specific rest temperature/s for various periods of time.  Different enzymes work during these these rests to break down starches in the grain to sugars.";
string _LAUTERING_DESC = "Lautering\nThe 'sweet liquor' (first runnings) is run off ('Lautered') from the Mash and into the Kettle.";
string _SPARGING_DESC = "Sparging\nThe remaining grain bed is rinsed ('Sparged') of the sugars it contains using hot water (the second runnings).";
string _BOILING_DESC = "Boiling\nThe Sweet liquor is boilied for 1 or more hours to flavour, colour and sterilise the wort.  Hops are added during this phase to add bitterness and seasoning.";
string _WHIRLPOOLING_DESC = "Whirlpooling\nThe boiled wort is whirlpooled to draw solid matter into the middle and help clarify the wort.  Hops are sometimes added at this step to add aroma and some flavour with minimal bitterness impact.";
string _CHILLING_DESC = "Chilling\nAt the completion of the boil the wort is rapidly chilled and transferred to the fermentation tanks in preparation for addition of the yeast.";
string _FERMENTING_DESC = "Fermentation\nYeast is added to the wort (officially making it 'beer') and these creatures digest most of the sugars in the beer and produce alcohol, carbon dioxide and other flavouring compounds.";
string _CLEARING_DESC = "Clearing\nMany, but not all, beers are racked to a 'Bright Tank' for further clarification prior to serving.  Breweries with bottling/kegging lines may instead filter at this stage, but again many beers are unfiltered.";
string _SERVING_DESC = "Serving\nHere in the brew pub we serve from the Bright Tanks, but most production breweries will bottle or keg their beer prior to shipping.  Most beer is not meant to be served icy cold - each beer will have an ideal temperature which will best present it's flavours and aromas to the drinker.";

integer _MENU_CHAN = 6901;
integer _MT_CHAN = 6902;
integer _KT_CHAN = 6903;
integer _HLT_CHAN = 6904;

//End Header.ins

//Global Variables
key user_key = NULL_KEY;
string user_name = "";

integer current_process = 0;
list processes = [];
list process_descs = [];
list menu_first = [];
list menu_normal = [];
list menu_last = [];

// 5 minute (300 second) countdown for a user to control the brewery
integer user_timer = 300;
//in demo mode 30 seconds per step;
integer	demo_timer = 30;
integer demo_interupted = FALSE;

my_init()
{
	// my_init is called once only at default state entry
	
	// you cannot initiate list contents in global space, so initialise them here
	processes += [ _INSTRUCTIONS, _MILLING, _MASHING, _MASH_REST, _LAUTERING, _SPARGING, _BOILING, _WHIRLPOOLING, _CHILLING, _FERMENTING, _CLEARING, _SERVING ];
	process_descs += [_INSTRUCTIONS_DESC, _MILLING_DESC, _MASHING_DESC, _MASH_REST_DESC, _LAUTERING_DESC, _SPARGING_DESC, _BOILING_DESC, _WHIRLPOOLING_DESC, _CHILLING_DESC, _FERMENTING_DESC, _CLEARING_DESC, _SERVING_DESC];

	menu_first += [ _RESET, _STOP, _NEXT, _DETAILS ];
	menu_normal += [ _RESET, _PREV, _NEXT, _DETAILS ];
	menu_last += [ _RESET, _PREV, _STOP, _DETAILS ];
	llSetTimerEvent(demo_timer);
}

my_reset()
{
	// tell all associated objects we're resetting
	llMessageLinked(LINK_ALL_OTHERS, 0, _RESET, "");
	// some objects are not linked as we require them to move so we communicate via chat with them
	llSay(_MT_CHAN,_RESET);
	llSay(_KT_CHAN,_RESET);
	llSay(_HLT_CHAN,_RESET);

	if (demo_interupted)
	{
		llOwnerSay("Setting Demo Mode ON");
		llSetText("The Brewery is currently operating in automated demonstration mode\nTouch the brewery to run it interactively", <1.0, 0.0, 0.0>, 0.25);
		user_name = "Demo Mode";
		user_key = llGetOwner();
		current_process = 1;

		message_all_links();

		// give user 5 more minutes to use then reset to allow next user
		user_timer = 300;
		
		my_show_dialog(user_key);
	}
	else
	{
		llResetScript();
	}
	// [TODO: does llResetScript set user back to NULL_KEY ??  If not insert code here to do it]
	// [TODO: Ditto does it turn the timer off? ]
	// user_key = NULL_KEY;
	// llSetTimerEvent(0.0);
}

my_show_dialog(key id)
{
	// the first menu has no PREV option, then last menu has no NEXT option.
	// this code also stops them stepping past the first or last process.
	
	if (current_process <= 0)
	{
		current_process = 0;
		llDialog(user_key, llList2String(process_descs,current_process), menu_first, _MENU_CHAN);
	}
	else if (current_process >= llGetListLength(processes) - 1)
	{
		current_process = llGetListLength(processes) - 1;
		llDialog(user_key, llList2String(process_descs,current_process), menu_last, _MENU_CHAN);
	}
	else
	{
		llDialog(user_key, llList2String(process_descs,current_process), menu_normal, _MENU_CHAN);
	}
}

message_all_links()
{
		// now instruct all linked (and related unlinked) objects of process change
		llMessageLinked(LINK_ALL_OTHERS, current_process, llList2String(processes,current_process), user_key);
		llSay(_MT_CHAN, llList2String(processes,current_process));
		llSay(_KT_CHAN, llList2String(processes,current_process));
		llSay(_HLT_CHAN, llList2String(processes,current_process));
}

default
{
	state_entry ()
	{
		my_init();

		// [TODO: what is this next line for ?? ]
		llMessageLinked(LINK_ALL_OTHERS, 0, llList2String(processes,current_process), "");
		// and if it's necessary, then do I not also need to tell unattached objects
		llSay(_MT_CHAN, llList2String(processes,current_process));
		llSay(_KT_CHAN, llList2String(processes,current_process));
		llSay(_HLT_CHAN, llList2String(processes,current_process));

		// [TODO: use the Name or Id param here to only listen to chat from myself? ]
		llListen(_MENU_CHAN, "", "", "");
	}

	touch_start(integer total_number)
	{
		integer toucher;
		
		if (user_key == NULL_KEY || user_name == "Demo Mode")
		{
			if (user_name == "Demo Mode")
			{
				demo_interupted = TRUE;
				llOwnerSay("Auto Demo mode interupted by " + llDetectedName(0));
			}
			// first user touching takes control of the brewery
			user_key = llDetectedKey(0);
			user_name = llDetectedName(0);
			llSay(0,user_name + " is now operating the Brewery.  If they are idle for 5 minutes the Brewery will reset for the next user.");
			llSetText(user_name + " is now operating the Brewery.", <1.0, 0.0, 0.0>, 0.25);
			
			// give user 5 minutes to use then reset to allow next user
			user_timer = 300;
			// start them from the intro menu
			current_process = 0;
			// now give them the control menu
			my_show_dialog(user_key);
		}
		else
		{
			// inform subsequent touchers brewery is in use ...
			// [TODO: maybe look and see if user still in brewery and if not reset here? ]
			for (toucher = 0;toucher < total_number;toucher++)
			{
				llInstantMessage(llDetectedKey(toucher), "The brewery is currently in use by " + user_name + ".  They have " + (string) (user_timer / 60) + " minutes and " + (string) (user_timer % 60) + " seconds left. Please wait for them to finish and then try again.");
			}
		}
	}

	listen(integer _MENU_CHAN, string name, key id, string message)
	{
		// [TODO: protect here to make sure msg is coming from within not chat]
		// [TODO: allow owner (me) to operate from chat line tho :)
		// [TODO: are we sure we know what diff RESET and STOP are intended to be ? ]
		if (message == _RESET)
		{
			my_reset();
		}
		else if (message == _STOP)
		{
			user_key = NULL_KEY;
			current_process = 0;
		}
		else if (message == _NEXT)
		{
			current_process++;
		}
		else if (message == _PREV)
		{
			current_process--;
		}
		else if (message == _DETAILS)
		{
			llGiveInventory(user_key, llList2String(processes, current_process));
		}
		else if (message == _DEMO_ON && id == llGetOwner())
		{
			llOwnerSay("Setting Demo Mode ON");
			llSetText("The Brewery is currently operating in automated demonstration mode\nTouch the brewery to run it interactively", <1.0, 0.0, 0.0>, 0.25);
			user_name = "Demo Mode";
			user_key = llGetOwner();
			current_process = 0;
		}
		else if (message == _DEMO_OFF)
		{
			llOwnerSay("Setting Demo Mode OFF");
			llSetText("The Brewery is currently idle\nTouch the brewery to run it interactively", <1.0, 0.0, 0.0>, 0.25);
			user_name = "";
			user_key = NULL_KEY;
			current_process = 0;
		}

		message_all_links();

		// give user 5 more minutes to use then reset to allow next user
		user_timer = 300;
		
		my_show_dialog(user_key);
	}

	timer()
	{
		// if we're in demo mode mode to next step
		if (user_name == "Demo Mode")
		{
			if (current_process++ >= llGetListLength(processes) - 1)
			{
				current_process = 1;
			}
			message_all_links();
			llSay(0, "Brewing Demo, " + llList2String(processes, current_process));
			llSetText("The Brewery is currently operating in automated demonstration mode in the " + llList2String(processes, current_process) + " step.\nTouch the brewery to run it interactively", <1.0, 0.0, 0.0>, 0.25);
		}
		//else if a user is in control, decrement their time left and reset if past
		else if (user_name)
		{
			user_timer-=demo_timer;
			if (user_timer < 0)
			{
				llSay(0, "It has been 5 minutes since " + user_name + " has interacted with the Brewery.  Now resetting for others' use.");
				llSetText("",<1.0, 0.0, 0.0>, 1.0);
				// if timer event triggers it means the brewery operator has been idle for 5 minutes ... reset
				my_reset();
				// [TODO: or, did we want to just "STOP" here ]
			}
		}
	}
}