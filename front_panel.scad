$fn=40;
front_panel();
//corner(solid=false);

module front_panel(box_width=114, box_depth=220, box_height=160, t=2, r=4)
{
    // Global parameters
    stand_h = 5;
    bottom_lock_w = 12;
    
    // Bottom stands
    translate([r,r,-stand_h]) {
        corner(h=stand_h);
        corner(h=stand_h+box_height,solid=false);
    }
    translate([box_width-r,r,-stand_h]) mirror([1,0,0]) {
        corner(h=stand_h);
        corner(h=stand_h+box_height,solid=false);
    }

    // Bottom locks
    translate([3*r,0,t]) cube([bottom_lock_w, 2*r, t]);
    translate([box_width-bottom_lock_w-3*r,0,t]) cube([bottom_lock_w, 2*r, t]);
    translate([(box_width-bottom_lock_w)/2,0,t]) cube([bottom_lock_w, 2*r, t]);


    // Top blocks
    translate([r,r,box_height-2*t-1.5*stand_h]) corner(h=1.5*stand_h);
    translate([box_width-r,r,box_height-2*t-1.5*stand_h])mirror([1,0,0]) corner(h=1.5*stand_h);
    translate([r,-t,-stand_h])cube([box_width-2*r,t,box_height+stand_h]);
    
    // Snap-in
    snap_h = 8;
    translate([r,2*r,-snap_h+2*t]) snap_in(h=snap_h);
    translate([box_width-r,2*r,-snap_h+2*t]) snap_in(h=snap_h);
    translate([r,2*r,box_height-snap_h]) snap_in(h=snap_h);
    translate([box_width-r,2*r,box_height-snap_h]) snap_in(h=snap_h);

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

module snap_in(h=8, w=4, t=2)
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
        translate([0,t/2,h-t]) linear_extrude(scale=[1,0.5],height=t) #square([w,t]);
    }
}
