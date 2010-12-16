// www.lsleditor.org  by Alphons van der Heijden (SL: Alphons Jano)

integer _INFO_CHAN = 6907;
list menu_choices = [ "Landmark", "Freebies", "Package Deal", "Run Brewery", "Page Kim", "Join Group", "Welcome Card" ];

default
{
	state_entry()
	{
		llListen(_INFO_CHAN, "", "", "");
	}
	
	touch_start(integer total_number)
	{
		while (total_number--)
		{
			llDialog(llDetectedKey(total_number), "Please select an option from those below", menu_choices, _INFO_CHAN);
		}
	}

	listen(integer channel, string name, key id, string message)
	{
		if (message == "Welcome Card")
		{
			llGiveInventory(id, "Welcome Card");
		}
		else if (message == "Landmark")
		{
			llGiveInventory(id, "Second Runnings Brewery and Bar LM");
		}
		else if (message == "Freebies")
		{
			//TODO: change once we have freebies (shirt, beer bottle :)
			llInstantMessage(id, "Sorry, nothing to give yet :(");
		}
		else if (message == "Package Deal")
		{
			llGiveInventory(id, "Welcome Card");
			llGiveInventory(id, "Second Runnings Brewery and Bar LM");
			//TODO: change once we have freebies (shirt, beer bottle :)
			llInstantMessage(id, "Sorry, nothing to give yet :(");
		}
		else if (message == "Run Brewery")
		{
			//TODO: Better if we can chat a start command to the brewery
			llInstantMessage(id, "Touch the brewery to start the process running.");
		}
		else if (message == "Page Kim")
		{
			llInstantMessage(id, "Paging Kim via IM, if she is offline an e-mail will be sent.");
			llInstantMessage(llGetOwner(), name + " is paging you from " + llList2String(llGetParcelDetails(llGetPos(), [ PARCEL_DETAILS_NAME ]), 0));
			llInstantMessage(llGetOwner(), name + " is paging you from " + llList2String(llGetParcelDetails(llGetPos(), [ PARCEL_DETAILS_NAME ]), 0));
			llInstantMessage(llGetOwner(), name + " is paging you from " + llList2String(llGetParcelDetails(llGetPos(), [ PARCEL_DETAILS_NAME ]), 0));
		}
		else if (message == "Join Group")
		{
			llInstantMessage(id, "Please join our group at secondlife:///app/group/" + (string) llList2String(llGetObjectDetails(llGetKey(), [OBJECT_GROUP]), 0) + "/about");
		};
		llDialog(llDetectedKey(total_number), "Please select an option from those below, [Ignore] to finish.", menu_choices, _INFO_CHAN);


	}
}