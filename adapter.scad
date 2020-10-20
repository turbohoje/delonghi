$fn = 100;

thickness = 3;

railW = 85;
railH = thickness - 0.5;
railD = 64; // 47 + 17

bodyW = 79;
bodyH = 3;

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
                                cylinder(r=potRad-2, h=5);
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
                        translate([0, railD + thickness - filterRad, 0]) {
                            cylinder(r=filterRad, h=bodyH);
                        }
                        for(offset=[-padW / 2:20:padW/2]) {
                            translate([0, offset, 0]) {
                                rotate([0, 0, 45]) {
                                    translate([-padW / 2, 0, 0]) {
                                        cube([padW, 0.1, bodyH]);
                                    }
                                }
                            }
                        }
                        for(offset=[-padW / 2:20:padW/2]) {
                            translate([0, offset, 0]) {
                                rotate([0, 0, -45]) {
                                    translate([-padW / 2, 0, 0]) {
                                        cube([padW, 0.1, bodyH]);
                                    }
                                }
                            }
                        }
                    }
                    translate([0, railD + thickness - filterRad, -1]) {
                        cylinder(r=filterRad - 1, h=bodyH + 2);
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
}