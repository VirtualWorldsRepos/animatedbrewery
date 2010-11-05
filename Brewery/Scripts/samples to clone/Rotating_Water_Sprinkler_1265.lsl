////////////////////////////////////////////////////////////////////
// Please leave any credits intact in any script you use or publish.
// Please contribute your changes to the Internet Script Library at
// http://www.free-lsl-scripts.com
//
// Script Name: Rotating_Water_Sprinkler.lsl
// Category: Particles
// Description: water sprinkler effect
// Comment: The script
//
// Downloaded from : http://www.free-lsl-scripts.com/freescripts.plx?ID=1241
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
// This script is from http://xahlee.org/sl/ .
// Copyright © 2007 Xah Lee.
// Permission is granted for use or modification provided this note is intact.

// a rotating water springler for lawns

partyOn(){
	llParticleSystem([
		PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE,

		PSYS_SRC_MAX_AGE, 0.0,

		PSYS_SRC_BURST_RATE, .3,
		PSYS_SRC_BURST_PART_COUNT, 50,

		PSYS_SRC_BURST_RADIUS, .2,
		PSYS_SRC_BURST_SPEED_MIN, 1.0,
		PSYS_SRC_BURST_SPEED_MAX, 5.0,
		PSYS_SRC_ACCEL, <0.0,0.0,-1.0>,

		PSYS_SRC_ANGLE_BEGIN, 0.9,
		PSYS_SRC_ANGLE_END, 1.0,
		PSYS_SRC_OMEGA, <0.0,0.0,1.0>,

		PSYS_PART_MAX_AGE, 4.0,

		PSYS_PART_START_COLOR, <1,1,1>,
		PSYS_PART_END_COLOR, <1,1,1>,

		PSYS_PART_START_ALPHA, .7,
		PSYS_PART_END_ALPHA, 0.1,

		PSYS_PART_START_SCALE, <.08,.8,0>,
		PSYS_PART_END_SCALE, <.05,.1,0>,

		PSYS_PART_FLAGS
			, 0
				| PSYS_PART_INTERP_COLOR_MASK
		| PSYS_PART_INTERP_SCALE_MASK
		| PSYS_PART_FOLLOW_VELOCITY_MASK
		| PSYS_PART_WIND_MASK
		]);
}

default { state_entry() { partyOn(); } }