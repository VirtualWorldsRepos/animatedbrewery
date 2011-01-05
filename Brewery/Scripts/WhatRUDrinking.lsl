// $Id$
//

list names = [];
list drinks = [];

update_text()
{
    integer i = 0;
    string  text = "";

    for(i=0; i < llGetListLength(names);i++)
    {
        text += "\n" + llList2String(names, i) + " is drinking " + llList2String(drinks, i);
    }
    llSetText(text, <1.0, 0.0, 0.0>, 1.0);
}

remove_from_list(integer i)
{
    if (llGetListLength(names) > 1)
    {
        names = llList2List(names, i+1, i-1);
        drinks = llList2List(drinks, i+1, i-1);
    }
    else
    {
        names = [];
        drinks = [];
    }
}

default
{
    state_entry()
    {
        names = [];
        drinks = [];

        llListen(6906, "", "", "");
        llSensorRepeat("", "", AGENT, 30.0, PI, 60.0);
        update_text();
    }

    listen(integer channel, string name, key id, string message)
    {
        integer i = 0;

        i = llListFindList(names, (list) name);
        if (i == -1)
        {
            // new person to append to list
            names += (list) name;
            drinks += (list) message;
        }
        else if (message == "XXXX")
        {
            // remove from list
            remove_from_list(i);
        }
        else
        {
            // change an existing person's drink
            drinks = llListReplaceList(drinks, (list) message, i, i);
        }
        update_text();
    }

    sensor(integer total_number)
    {
        integer i = 0;
        list locals = [];

        while (total_number--)
        {
            locals += (list) llDetectedName(total_number);
        }
        //        llOwnerSay("Locals " + (string) locals);
        for (i=0; i < llGetListLength(names);i++)
        {
            //            llOwnerSay("Name " + (string) llList2List(names, i, i));
            if ((llListFindList(locals, llList2List(names, i, i)) == -1))
            {
            // remove from list
            remove_from_list(i);
            }
        }
        update_text();
    }

    touch_start(integer total_number)
    {
        while (total_number--)
        {
            llInstantMessage(llDetectedKey(total_number),"To set your drink on the board, chat it to channel 6906\nFor example chat /6906 Rodenbach Grande Cru\nTo change your drink just chat the new one to 6906.\nTo remove yourself from the list chat XXXX to 6906, /6906 XXXX");
        }
    }
}