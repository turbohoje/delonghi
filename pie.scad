// PieTest

/**
* @author: Marcel Jira

 * This module generates a pie slice in OpenSCAD. It is inspired by the
 * [dotscad](https://github.com/dotscad/dotscad)
 * project but uses a different approach.
 * I cannot say if this approach is worse or better.

 * @param float radius Radius of the pie
 * @param float angle  Angle (size) of the pie to slice
 * @param float height Height (thickness) of the pie
 * @param float spin   Angle to spin the slice on the Z axis
 */
module pie(radius, angle, height, spin=0) {
	// calculations
	ang = angle % 360;
	absAng = abs(ang);
	halfAng = absAng % 180;
	negAng = min(ang, 0);

	// submodules
	module pieCube() {
		translate([-radius - 1, 0, -1]) {
			cube([2*(radius + 1), radius + 1, height + 2]);
		}
	}

	module rotPieCube() {
		rotate([0, 0, halfAng]) {
			pieCube();
		}
	}

	if (angle != 0) {
		if (ang == 0) {
			cylinder(r=radius, h=height);
		} else {
			rotate([0, 0, spin + negAng]) {
				intersection() {
					cylinder(r=radius, h=height);
					if (absAng < 180) {
						difference() {
							pieCube();
							rotPieCube();
						}
					} else {
						union() {
							pieCube();
							rotPieCube();
						}
					}
				}
			}
		}
	}
}

/**
 * When used as a module (statement "use <pie.scad>") the example below will not
 * render. If you run this file alone, it will :)
 */
holderDiam=64;
clampDepth=3;
clampWidth=5;
notchDeg = 37;

holderRad = holderDiam / 2;
notchSize = holderRad + clampWidth;
cylSize = notchSize + 3;

thickness = 3;

railW = 85;
railH = thickness - 0.5;
railD = 64; // 47 + 17

bodyW = 79;
bodyH = 10;

voidW = 74;

padW = 200;

cutD = 8;

gapH = thickness + 0.5;

filterRad = 25;
potRad = 55;

// rails
union() {
    difference() {
        union() {
            difference() {
                // solid block of everything
                union() {
                    translate([-railW / 2, 0, 0]) {
                        cube([railW, railD, railH + gapH + bodyH]);
                    }
                    // cylinder
                    translate([0, railD - 38, 0]) {
                        difference() {
                            cylinder(r=potRad, h=bodyH);
                            translate([0,0,-1]) {
                                cylinder(r=potRad-2, h=bodyH+2);
                            }
                        }
                    }
                }
               
                // cut out rail void
                translate([-voidW / 2, -1, bodyH]) {
                    cube([voidW, railD + 2, railH + gapH + 1]);
                }
                
                // cut out inside void
                translate([-voidW / 2, thickness, -1]) {
                    cube([voidW, railD - thickness, railH + gapH + bodyH + 2]);
                }

                // Cut out snap detent
                translate([-voidW / 2 - 1, railD - cutD, bodyH]) {
                    cube([voidW + 2, cutD + 1, padW]);
                }

                // cut front of rails
                translate([-padW / 2, railD - 2, bodyH]) {
                    cube([padW, padW, padW]);
                }
                
                // make ramp in rails
                translate([-padW / 2, railD - 2, gapH + bodyH]) {
                    rotate([60, 0, 0]) {
                        cube([padW, padW, padW]);
                    }
                }
            }    

            // ring
            intersection() {
                difference() {
                    union() {
                        translate([0, railD + thickness - filterRad - 1, 0]) {
                            cylinder(r=filterRad+2, h=bodyH);
                        }
                        for(offset=[-padW / 2:20:padW/2]) {
                            translate([0, offset, 0]) {
                                rotate([0, 0, 45]) {
                                    translate([-padW / 2, 0, 0]) {
                                        cube([padW, 0.5, bodyH]);
                                    }
                                }
                            }
                        }
                        for(offset=[-padW / 2:20:padW/2]) {
                            translate([0, offset, 0]) {
                                rotate([0, 0, -45]) {
                                    translate([-padW / 2, 0, 0]) {
                                        cube([padW, 0.5, bodyH]);
                                    }
                                }
                            }
                        }
                    }
                    translate([0, railD + thickness - filterRad - 1, -1]) {
                        cylinder(r=filterRad + 1, h=bodyH + 2);
                    }
                }
                translate([0, railD - 38, 0]) {
                    cylinder(r=potRad, h=bodyH);
                }
            }
        }

        // Cut out everything past plane
        translate([-padW / 2, -padW, -padW / 2]) {
            cube([padW, padW, padW]);
        }
        
        // cut out from left rail
        translate([-bodyW / 2 - padW, -1, -1]) {
            cube([padW, padW, bodyH + gapH + 1]);
        }

        // cut out from right rail
        translate([bodyW / 2, -1, -1]) {
            cube([padW, padW, bodyH + gapH + 1]);
        }

    }

    translate([0, railD + thickness - filterRad - 1, -clampDepth * 4]) {
        rotate([0, 0, notchDeg]) {
            union() {
                // pass through
                difference() {
                    cylinder(clampDepth, cylSize, cylSize);

                    translate([0, 0, -clampDepth]) {
                        cylinder(clampDepth * 3, holderRad, holderRad);
                    }

                    for(ang=[0:3]) {
                        difference() {
                            translate([0, 0, -clampDepth]) {
                                pie(notchSize, notchDeg, clampDepth * 3, spin=ang*360/3);
                            }
                        }
                    }
                }
                
                // holder
                translate([0, 0, clampDepth]) {
                    difference() {
                        cylinder(clampDepth * 2, cylSize, cylSize);

                        translate([0, 0, -clampDepth]) {
                            cylinder(clampDepth * 4, holderRad, holderRad);
                        }

                        for(ang=[0:3]) {
                            difference() {
                                translate([0, 0, -clampDepth]) {
                                    pie(notchSize, notchDeg*2, clampDepth * 4, spin=ang*360/3);
                                }
                            }
                        }
                    }
                }
                
                translate([0, 0, clampDepth * 3]) {
                    difference() {
                        cylinder(clampDepth, cylSize, cylSize);

                        translate([0, 0, -1]) {
                            cylinder(clampDepth + 2, 26, 26);
                        }
                    }
                }
            }
        }
    }
}
