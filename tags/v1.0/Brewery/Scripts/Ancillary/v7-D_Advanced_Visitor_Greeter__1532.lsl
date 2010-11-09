////////////////////////////////////////////////////////////////////
// Please leave any credits intact in any script you use or publish.
// Please contribute your changes to the Internet Script Library at
// http://www.free-lsl-scripts.com
//
// Script Name: v7-D_Advanced_Visitor_Greeter_.lsl
// Category: Greeter
// Description:   Features:
//
//    * Reduced Spam
//    * Easily Modified
//    * Multiple Configurations
// Comment: The Script
//
// Downloaded from : http://www.free-lsl-scripts.com/freescripts.plx?ID=1424
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
//( v7-D Advanced Avatar Greeter v1.4 )//

//-- NOTE:
// Remove Any Instances Of "(gLstAvs = []) + " Or "(gLstTms = []) + " When Compiling This
// Script To MONO. They Are Provided For LSO Memory Preservation And Do Nothing In MONO
//

list    gLstAvs;        //-- List Of Avatars Keys Greeted --//
list    vLstChk;        //-- List Of Av Key Being Checked During Sensor Processing --//
integer vIdxLst;        //-- Index Of Checked Item In List (reused) --//
integer gIntMax = 500;  //-- Maximum Number of Names To Store --//
//-- Previous Code Line PreSet to Ease Removing Dynamic Memory Limitation Code --//

//-- Next Code Line  Belongs to Dynamic Memory Limitation Section --//
integer int_MEM = 1000; //-- memory to preserve for safety--//

//-- Start Av Culling Section --//
integer gIntPrd = 604800; //-- Number Of Seconds After Detection To Store Av --//
integer vIntNow;          //-- Integer To Store Current Time During Sensor Processing --//
list    gLstTms;          //-- List Of Most Recent Times Avs Were Greeted At --//
list    vLstTmt;          //-- List To Store Timeout During Sensor Processing --//
//-- End Av Culling Section --//


my_message(string name, key id)
{
	key group_id = llList2String(llGetObjectDetails(llGetKey(), [OBJECT_GROUP]), 0);

	llInstantMessage(id, "Please join our group at secondlife:///app/group/" + (string) group_id + "/about");
	llGiveInventory(id, "Welcome Card");
}

default{
	state_entry(){
		//-- Next Code Line Belongs To Dynamic Memory Limitation Section --//
		gIntMax = 1000;                      //-- Intial list Max --//
		llSensor( "", "", AGENT, 95.0, PI ); //-- Pre-Fire Sensor For Immediate Results --//
		llSetTimerEvent( 30.0 );             //-- Sensor Repeat Frequency --//
		llListen(101, "", llGetOwner(), "List");
	}

	listen(integer channel, string name, key id, string message)
	{
		integer end = llGetListLength(gLstAvs);

		while (end--)
		{
			llOwnerSay((string) llGetUnixTime());
			llOwnerSay(llKey2Name(llList2String(gLstAvs, end)) + " " + (string) ((llGetUnixTime() - llList2Integer(gLstTms, end) + gIntPrd)/60));
			llOwnerSay(llKey2Name(llList2String(gLstAvs, end)) + " " + (string) llList2Integer(gLstTms, end));
		}
	}
	
	timer(){
		llSensor( "", "", AGENT, 95.0, PI ); //-- Look For Avatars --//
	}

	sensor( integer vIntTtl ){
		//-- Save Current Timer to Now, Then Add Period and Save To Timeout--//
		vLstTmt = (list)(gIntPrd + (vIntNow = llGetUnixTime()));
		//-- Previous Code Line Belongs to Av Culling Section --//
		@Building;{
			//-- Is This Av Already In Our List? --//
			if (~(vIdxLst = llListFindList( gLstAvs, (vLstChk = (list)llDetectedKey( --vIntTtl )) ))){
				//-- Delete The Old Entries & Add New Entries to Preserve Order --//
				gLstAvs = llDeleteSubList(  gLstAvs, vIdxLst, vIdxLst ) + vLstChk;
				//-- Next Code Line Belongs to Av Culling Section --//
				gLstTms = llDeleteSubList(  gLstTms, vIdxLst, vIdxLst ) + vLstTmt;
			}
			else{
				//-- Oo Goody, Hi New Av! Add Them To The Lists & Preserve Max List Size--//
				llInstantMessage( (string)vLstChk, "Hello " + llDetectedName( vIntTtl ) );
				my_message(llDetectedName( vIntTtl ), llDetectedKey( vIntTtl));
				gLstAvs = llList2List(  vLstChk + gLstAvs, 0, gIntMax );
				//-- Next Code Line Belongs to Av Culling Section --//
				gLstTms = llList2List(  vLstTmt + gLstTms, 0, gIntMax );
			}
		}if (vIntTtl) jump Building;

		//-- Start Dynamic Memory Limitation Section --//
		//-- Only lower Max List Size Once For Saftey --//
		if (int_MEM == gIntMax){
			//-- do we have plenty of room in the script? --//
			if (int_MEM > llGetFreeMemory()){
				//-- running out of room, set the Max list size lower --//
				gIntMax = ~([] != gLstAvs);
			}
		}
		//-- End Dynamic Memory Limitation Section --//

		//-- Start Av Culling Section --//
		//-- do we have keys? --//
		if (vIdxLst = llGetListLength( gLstTms )){
			//-- Do Any Need Culled? --//
			if (vIntNow > llList2Integer( gLstTms, --vIdxLst )){
				//-- Find The Last Index that hasn't hit timeout status --//
				@TheirBones; if (--vIdxLst) if (vIntNow > llList2Integer( gLstTms, vIdxLst )) jump TheirBones;
				//-- Thin the herd --//
				gLstAvs = llList2List(  gLstAvs, 0, vIdxLst );
				gLstTms = llList2List(  gLstTms, 0, vIdxLst );
			}
		}
		//-- End Av Culling Section --//
	}
}

//--                           License Text                           --//
//  Free to copy, use, modify, distribute, or sell, with attribution.   //
//    (C)2009 (CC-BY) [ http://creativecommons.org/licenses/by/3.0 ]    //
//   Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //
//  All usages must contain a plain text copy of the previous 2 lines.  //
//--                                                                  --//


// Look for updates at : http://www.free-lsl-scripts.com/freescripts.plx?ID=1424
// __END__


