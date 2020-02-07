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
holderDiam=61;
clampDepth=3;
clampWidth=3;
notchDeg = 37;

holderRad = holderDiam / 2;
notchSize = holderRad + clampWidth;
cylSize = notchSize + clampWidth;

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