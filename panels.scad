$fn=40;
front_panel();
//corner(solid=false);
stand_h = 5;
bottom_lock_w = 12;
side_lock_h = 70;
vent_edge = 20;

module front_panel(box_width=114, box_depth=220, box_height=160, t=2, r=4)
{
	difference() {
		union() {
    		// Bottom stands
    		translate([r,r,-stand_h]) {
        		translate([0,0,stand_h-t]) corner(h=t);
        		corner(h=stand_h+box_height,solid=false);
    		}
    		translate([box_width-r,r,-stand_h]) mirror([1,0,0]) {
        		translate([0,0,stand_h-t]) corner(h=t);
        		corner(h=stand_h+box_height,solid=false);
    		}

    		// Bottom locks
    		translate([3*r,0,t]) cube([bottom_lock_w, r, t]);
    		translate([box_width-bottom_lock_w-3*r,0,t]) cube([bottom_lock_w, r, t]);
			translate([(box_width-bottom_lock_w)/2, 0, -stand_h]) cube([bottom_lock_w, r, stand_h]);

			// Side locks
			translate([r,r,side_lock_h-t]) difference() {
				corner(h=box_height-side_lock_h-t);
				translate([-r,0,t])cube([t+0.2,2*r,box_height-side_lock_h]);
			}
			translate([box_width-r,r,side_lock_h-t])mirror([1,0,0]) difference() {
				corner(h=box_height-side_lock_h-t);
				translate([-r,0,t]) cube([t+0.2,2*r,box_height-side_lock_h]);
			}
			
    		// Top blocks
    		translate([r,-t,-stand_h])cube([box_width-2*r,t,box_height+stand_h]);

			// Snap-ins
			translate([box_width/2,r,box_height-4*r]) snap_in(h=4*r,w=bottom_lock_w);
			translate([(box_width-bottom_lock_w)/2, 0, box_height-4*r])
				cube([bottom_lock_w, r, t]);
		}
		translate([r,r,-stand_h]) cylinder(r=1.5,h=3*stand_h);
		translate([box_width-r,r,-stand_h]) cylinder(r=1.5,h=3*stand_h);
	}
    
}

module left_panel(box_width=114, box_depth=220, box_height=160, t=2, r=4)
{
	difference() {
		union() {
			translate([-t,0,t]) cube([t, box_depth-4*r, box_height-t]);
			translate([0,-r,side_lock_h]) cube([t,2*r,box_height-2*t-side_lock_h]);
			translate([-t,0,side_lock_h]) cube([2*t,r,box_height-2*t-side_lock_h]);
			translate([0,box_depth-5*r,side_lock_h]) cube([t,2*r,box_height-2*t-side_lock_h]);
			translate([-t,box_depth-5*r,side_lock_h]) cube([2*t,r,box_height-2*t-side_lock_h]);

			translate([0, (box_depth-bottom_lock_w-r)/2,box_height-4*r]) {
				translate([r,0,0]) rotate([0,0,-90]) snap_in(h=4*r,w=bottom_lock_w);
				translate([0,-bottom_lock_w/2,0])cube([r, bottom_lock_w, t]);
			}
		}
		translate([-2*t,vent_edge,(box_height-vent_edge)/2]) cube([3*t,box_depth-4*r-4*vent_edge,(box_height-vent_edge)/2]);
	}
	translate([-t,vent_edge,(box_height-vent_edge)/2])rotate([90,0,90]) grid(box_depth-4*r-4*vent_edge,(box_height-vent_edge)/2);
}

module cut_left_panel(box_width=114, box_depth=220, box_height=160, t=2, r=4)
{
	io_size = [3*t, 55, 16];
	io_p = [-2*t, box_depth-2-io_size[1], 20+r];

	difference() {
		translate([0,2*r,0]) left_panel(box_width=box_width, box_depth=box_depth, box_height=box_height);
		translate(io_p) cube(io_size);
	}
}

module cut_back_panel(box_width=114, box_depth=220, box_height=160, t=2, r=4)
{
	io_size = [3*t, 55, 16];
	io_p = [-2*t, box_depth-2-io_size[1], 20+r];
	pwr_size = [10, 3*t, 10];
	pwr_p = [32, box_depth-t, 39+r];
	rst_r = 2;
	rst_p = [74, box_depth+2*t, 43+r];
	hdmi_size = [16, 3*t, 7];
	hdmi_p = [47, box_depth-t, 20+r];
	wifi_p = [[box_width/2-2*r, box_depth+2*t, 65], [box_width/2+2*r, box_depth+2*t, 65]];
	wifi_r = 3;
	stand_p = [r,box_depth-r,-r];

	difference() {
		translate([0,box_depth,0]) mirror([0,1,0])
			front_panel(box_width=box_width, box_depth=box_depth, box_height=box_height);
		translate(stand_p) cylinder(r=3, h=2*r);
		translate(io_p) cube(io_size);
		translate(pwr_p) cube(pwr_size);
		translate(rst_p) rotate([90,0,0]) cylinder(h=3*t, r=rst_r);
		translate(hdmi_p) cube(hdmi_size);

		for(p=wifi_p) {
			translate(p) rotate([90,0,0]) cylinder(h=3*t, r=wifi_r);
			translate(p+[0,-1.5*t,0]) rotate([90,0,0]) cylinder(h=2*t, r=wifi_r+2.5);
		}
	}
}

module cut_right_panel(box_width=114, box_depth=220, box_height=160, t=2, r=4)
{
	fan_r = 50.2/2;
	fan_hr = 4/2;
	fan_size = [10, 2*fan_r, 2*fan_r];
	fan_p = [box_width-fan_size[0]+t/2, box_depth-fan_size[1]-3*r, t];
	fan_cp = fan_p + [fan_size[0]-t/2, fan_r, fan_r];
	fan_hp = [fan_cp + [0,20,20], fan_cp + [0,-20,20], fan_cp + [0,20,-20], fan_cp + [0,-20,-20]];

	difference() {
		translate([box_width,2*r,0]) mirror([1,0,0])
			left_panel(box_width=box_width, box_depth=box_depth, box_height=box_height);
		translate(fan_p) cube(fan_size);
		translate(fan_cp) rotate([0,90,0]) cylinder(r=fan_r-1.5, h=3*t);

		for(c=fan_hp) {
			translate(c) rotate([0,90,0]) cylinder(r=fan_hr, h=3*t);
		}
	}
	translate(fan_cp+[t/2,0,0]) rotate([0,90,0]) intersection() {
		translate([-fan_r,-fan_r,0]) grid(2*fan_r, 2*fan_r);
		cylinder(r=fan_r-1.2, h=t/2);
	}
}

module corner(r=4, h=8, t=2, solid=true)
{
    r = r+t;
    difference() {
        if(solid) {
            linear_extrude(height=h){
                union() {
                    circle(r=r);
                    translate([-r,0,0])square([2*r,r]);
                    translate([0,-r,0])square([r,2*r]);
                }
            }
        }
        else {
            linear_extrude(height=h) difference(){
                union() {
                    circle(r=r);
                    translate([-r,0,0])square([2*r,r]);
                    translate([0,-r,0])square([r,2*r]);
                }
                circle(r=r-t);
                translate([-r+t,0,0])square([2*r,r]);
                translate([0,-r+t,0])square([r,2*r]);
            }
        }
        
        translate([-2*r,r-t,-t])cube([4*r,2*t,h+2*t]);
        translate([r-t,-2*r,-t])cube([2*t,4*r,h+2*t]);
    }
}

module snap_in(h=10, w=8, t=2)
{
	ext_r=2*t;

	translate([w/2, 0, ext_r]) union() {
		rotate([-90,0,90]) linear_extrude(height=w) union() {
			intersection() {
				difference() {
					circle(r=ext_r);
					circle(r=t);
				}
				translate([0,0,0])square([5,5]);
			}
			translate([t,-h+ext_r, 0]) square([t, h-ext_r]);
		}
    	translate([-w,1.5*t,h-3*t]) linear_extrude(scale=[1,0.5],height=t) square([w,t]);
    }
}

module snap_in_old(h=8, w=4, t=2)
{
    translate([-w/2,0,0]) union() {
        translate([w,0,t])rotate([0,-90,0]) linear_extrude(height=w) difference(){
            union() {
                circle(r=t);
                square([t,t]);
            }
            translate([-t,-t]) square([2*t,t]);
            circle(r=t/2);
            square([t/2,t/2]);
            translate([0,-t/2]) square([2*t,t]);
        }
        translate([0,t/2,t]) cube([w,t/2,h-t]); 
        translate([0,t/2,h-t]) linear_extrude(scale=[1,0.5],height=t) square([w,t]);
    }
}

module grid(w,h,eye=2,wall=1,thickness=2,ext=0)
{
    x = floor((w-eye)/(eye+wall));
    y = floor((h-eye)/(eye+wall));
    
    mesh_w = eye*(x-1) + wall*(x);
    mesh_h = eye*(y-1) + wall*(y);
    
    offset = [(w-mesh_w)/4, (h-mesh_h)/4,0];
 
    union() {
        for(i=[0:x]){
            translate([offset[0]+i*(eye+wall),-ext,0]) cube([wall,h+2*ext,thickness]);
        }
        for(j=[0:y]){
            translate([-ext,offset[1]+j*(eye+wall),0]) cube([w+2*ext,wall,thickness]);
        }
    }
}


