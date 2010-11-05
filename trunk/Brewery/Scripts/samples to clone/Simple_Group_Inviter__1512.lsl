////////////////////////////////////////////////////////////////////
// Please leave any credits intact in any script you use or publish.
// Please contribute your changes to the Internet Script Library at 
// http://www.free-lsl-scripts.com  
//
// Script Name: Simple_Group_Inviter_.lsl
// Category: Group Inviter
// Description: Simple Group Inviter. Touch it to get an invite
// Comment: The Script
//
// Downloaded from : http://www.free-lsl-scripts.com/freescripts.plx?ID=1405
//
// From the Internet LSL Script Database & Library of Second Life™ scripts.
// http://www.free-lsl-scripts.com  by Ferd Frederix
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the license information included in each script
// by the original author.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
//
//
////////////////////////////////////////////////////////////////////

// group id, you can determine this by doing a search in the new search. every group has a page and at the bottom it shows the id within a link, for example if it say "Link to this page: http://world.secondlife.com/group/Groups UUID". Pick your id and replace the one below
string group_id = "Your UUID Here";

// message to be shown before the link
string message = "Click here to join:";

default
{
    touch_start(integer total_number)
    {
        llInstantMessage(llDetectedKey(0), message + " secondlife:///app/group/" + group_id + "/about");
    }
}


// Look for updates at : http://www.free-lsl-scripts.com/freescripts.plx?ID=1405
// __END__


