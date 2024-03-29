////////////////////////////////////////////////////////////////////
// Please leave any credits intact in any script you use or publish.
// Please contribute your changes to the Internet Script Library at 
// http://www.free-lsl-scripts.com  
//
// Script Name: Hot_Food_Steamming_Mist.lsl
// Category: Particles
// Description: Hot Food Steamming Mist.lsl
// Comment: Hot Food Steamming Mist.lsl
//
// Downloaded from : http://www.free-lsl-scripts.com/freescripts.plx?ID=944
//
// From the Internet LSL Script Database & Library of Second Life� scripts.
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
// DESCRIPTION:Hot Food Steamming Mist.lsl
// ARCHIVED BY:Ferd Frederix

integer active = TRUE;


// Particle System 1.0




StartSteam()
{
                                // MASK FLAGS: set  to "TRUE" to enable
integer glow = TRUE;                                // Makes the particles glow
integer bounce = FALSE;                             // Make particles bounce on Z plane of objects
integer interpColor = TRUE;                         // Color - from start value to end value
integer interpSize = TRUE;                          // Size - from start value to end value
integer wind = FALSE;                               // Particles effected by wind
integer followSource = FALSE;                       // Particles follow the source
integer followVel = TRUE;                           // Particles turn to velocity direction



                                                    // Choose a pattern from the following:
                                                    // PSYS_SRC_PATTERN_EXPLODE
                                                    //PSYS_SRC_PATTERN_DROP
                                                    // PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY
                                                    // PSYS_SRC_PATTERN_ANGLE_CONE
                                                    // PSYS_SRC_PATTERN_ANGLE
    integer pattern = PSYS_SRC_PATTERN_ANGLE_CONE;

                                                    // Select a target for particles to go towards
                                                    // "" for no target, "owner" will follow object owner 
                                                    //    and "self" will target this object
                                                    //    or put the key of an object for particles to go to
    key target;
    

                            // Particle paramaters
                            
    float age = 10;                                  // Life of each particle
    float maxSpeed = 1.05;                          // Max speed each particle is spit out at
    float minSpeed = 0.2;                           // Min speed each particle is spit out at
    string texture = "Water Particle - Mist";                     // Texture used for particles, default used if blank
    float startAlpha = .25;                         // Start alpha (transparency) value
    float endAlpha = 0.2;                           // End alpha (transparency) value
    vector startColor = <.0,1.99,.0>;                // Start color of particles <R,G,B>
    vector endColor = <.0,1.99,.0>;                      // End color of particles <R,G,B> (if interpColor == TRUE)
    vector startSize = <1.1, 1.1, 1.1>;               // Start size of particles 
    vector endSize = <.7,.7,.7>;                       // End size of particles (if interpSize == TRUE)
    vector push = <0,0,0.1>;                        // Force pushed on particles

                            // System paramaters
                            
    float rate = 0.3;                               // How fast (rate) to emit particles
    float radius = .05;                             // Radius to emit particles for BURST pattern
    integer count = 20;                             // How many particles to emit per BURST 
    float outerAngle = 0.1;                         // Outer angle for all ANGLE patterns
    float innerAngle = 0.65;                        // Inner angle for all ANGLE patterns
    vector omega = <0,0,0>;                         // Rotation of ANGLE patterns around the source
    float life = 0;                                 // Life in seconds for the system to make particles

                            // Script variables
                            
    integer flags; 


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

StopSteam()
{
    llParticleSystem([]);   
}



default
{
    touch_start(integer num)
    {
        if (active == TRUE)
            StartSteam();
        else
            StopSteam();
            
        active = !active;
        
        llOwnerSay((string)active);
    }

}

// END //



// Look for updates at : http://www.free-lsl-scripts.com/freescripts.plx?ID=944
// __END__


