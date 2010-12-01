// $Id $
// 20101122 kim Webboard.lsl read a notcard of websites and display, allow user to scroll between them ...
integer locked = TRUE;
integer    _WEB_CHAN = 6907;
string  notecard_name = "Config";
key     notecard_key  = NULL_KEY;
integer iLine = 0;
key     kQuery;
list    sites = [ "http://www.thebrewingnetwork.com",
	"http://www.bjcp.org",
	"http://www.babbrewers.com",
	"http://brookstonbeerbulletin.com",
	"http://www.youtube.com/watch?v=emnxl32OsvA"
		];
list    menu_lables = [ "The Brewing Network",
	"BJCP",
	"BABB",
	"Brookston Beer Bulletin",
	"Trumer Beer Machine"
		];

integer status = 0;

default
{
	state_entry()
	{
		//        notecard_key = llGetInventoryKey(notecard_name);
		//        kQuery       = llGetNotecardLine(notecard_name, iLine);
		status = llSetPrimMediaParams(0, [
			PRIM_MEDIA_CONTROLS, PRIM_MEDIA_CONTROLS_MINI,
			PRIM_MEDIA_AUTO_PLAY, TRUE,
			PRIM_MEDIA_AUTO_ZOOM, TRUE, 
			PRIM_MEDIA_CURRENT_URL, llList2String(sites, 0)
				]);
		llOwnerSay("Status = " + (string) status);
		llListen(_WEB_CHAN, "", "", "");
	}

	//    dataserver(key requested, string data)
	//    {
	//        if (requested == kQuery)
	//        {
	//            if (data == EOF)
	//            {
	//                llOwnerSay("Completed reading Configuration data.");
	//            }
	//            else
	//            {
	//                sites = [data] + sites;
	//                kQuery = llGetNotecardLine(notecard_name, iLine);
	//            }
	//        }
	//    }
	//
	touch_start(integer a)
	{
		llOwnerSay("Touched " + (string) llDetectedTouchFace(0));
		if (llDetectedKey(0) == llGetOwner())
		{
			if (locked)
			{
				llSetText("", <1.0, 0.0, 0.0>, 0.2);
				locked = FALSE;
			}
			else
			{
				llSetText("Locked", <1.0, 0.0, 0.0>, 0.2);
				locked = TRUE;
			}
		}
		if (!locked)
		{
			llDialog(llDetectedKey(0), "Select the website you would like to view", menu_lables, _WEB_CHAN);
		}
	}

	listen(integer channel, string name, key id, string message)
	{
		llOwnerSay(llList2String(sites, llListFindList(menu_lables, (list) message)));
		llSetPrimMediaParams(0, [
			PRIM_MEDIA_CONTROLS, PRIM_MEDIA_CONTROLS_MINI,
			PRIM_MEDIA_AUTO_PLAY, TRUE,
			PRIM_MEDIA_AUTO_ZOOM, TRUE, 
			PRIM_MEDIA_CURRENT_URL, llList2String(sites, llListFindList(menu_lables, (list) message))
				]);
	}
}