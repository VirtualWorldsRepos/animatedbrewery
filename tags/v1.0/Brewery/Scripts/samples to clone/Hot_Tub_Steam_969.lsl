////////////////////////////////////////////////////////////////////
// Please leave any credits intact in any script you use or publish.
// Please contribute your changes to the Internet Script Library at 
// http://www.free-lsl-scripts.com  
//
// Script Name: Hot_Tub_Steam.lsl
// Category: Particles
// Description: Hot Tub Steam.lsl
// Comment: Hot Tub Steam.lsl
//
// Downloaded from : http://www.free-lsl-scripts.com/freescripts.plx?ID=945
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
// CATEGORY:Particles
// DESCRIPTION:Hot Tub Steam.lsl
// ARCHIVED BY:Ferd Frederix


//  UUID for smoke particles
key SMOKE_SPRITE = "b85073b6-d83f-43a3-9a89-cf882b239488";       
//  How large (meters) should the sprites be?
float SPRITE_SIZE = 5.0;
//  What is the lifetime of the system in seconds?
float LIFETIME = 10.0;
//  How many sprites/particles should be made?
integer NUM_PARTICLES = 40;
//  What initial velocity magnitude should particles have (in meters/s)?
float SPRITE_VELOCITY = 1;
//  Width of cone (in Radians) about the object's Z axis where particle will be directed
float ARC = 2;
//  Offset distance from the object center to generate the system
vector OFFSET = <0,0,2>;

default {
    state_entry() {
        //  Set a timer to check every few seconds whether to make a 
        //  new particle system. 
        llSetTimerEvent(2.0);
    }
    timer() {
        //  Make a random test (75% prob) to decide whether to 
        //  make a new particle system.
        if (llFrand(1.0) < 0.75) {
            //  Make some steam
            vector our_scale = llGetScale();
            float  x_rand_pos = llFrand(our_scale.x);
            float  y_rand_pos = llFrand(our_scale.y);
            
            OFFSET.x = (our_scale.x / 2) - x_rand_pos;
            OFFSET.y = (our_scale.y / 2) - y_rand_pos;
            
            llMakeSmoke( NUM_PARTICLES, 1.0, SPRITE_VELOCITY, 
                        LIFETIME, ARC, SMOKE_SPRITE, OFFSET);
        }    
    }        
}
// END //



// Look for updates at : http://www.free-lsl-scripts.com/freescripts.plx?ID=945
// __END__


