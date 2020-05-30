$fn=40;
hdd_mount_35();
//hdd_post();
//snap_in();

module hdd_support(w=9,h=5,l=140.7)
{
    polyhedron(
        points=[[0,0,h],[0,0,0],[w,0,h],[0,l,h],[0,l,0],[w,l,h]],
        faces=[[0,1,4,3],[2,0,3,5],[2,5,4,1],[2,1,0],[5,3,4]]
    );
}

module snap_in(w=8, thickness=2)
{
    t = thickness;
    union() {
        translate([0,0,-t/2])cube([t/2,w,2*t]);
        hull() {
            cube([t,w,0.01]);
            translate([0,0,-t]) cube([t/2,w,0.01]);
        }
    }
}

module hdd_post(n=4, w=16, thickness=2)
{
    hdd_h =  26.1;
    hdd_w = 101.6;
    hdd_l = 147.0;
    hdd_spacer    =  5;
    hdd_clear     = 10;
    hdd_front_pad = 45.4;
    hdd_back_pad  = 26.1;
    hdd_screw_off = 6.35;
    
    snap_w = 8;
    snap_h = 10;
    snap_cutout = 0.5;
    
    h = hdd_clear + (n-1)*(hdd_spacer+hdd_h) + hdd_h;
    w = w;
    t = thickness;
    d = (w-snap_w-snap_cutout)/2;
    
    difference () {
        union() {
            cube([t,w,h]);
            translate([t,(w-snap_w)/2,-t]) mirror([1,0]) snap_in(w=snap_w, thickness=t);
        }
        
        translate([-t/2,t,-t/2]) cube([t,w-2*t,h+2*t]);
        hull() {
            translate([-t/2,d,snap_h]) rotate([0,90,0]) cylinder(r=snap_cutout/2, h=2*t);
            translate([-t/2,d,0]) rotate([0,90,0]) cylinder(r=snap_cutout/2, h=2*t);
        }
        hull() {
            translate([-t/2,w-d,snap_h]) rotate([0,90,0]) cylinder(r=snap_cutout/2, h=2*t);
            translate([-t/2,w-d,0]) rotate([0,90,0]) cylinder(r=snap_cutout/2, h=2*t);
        }
        
        screw_h = hdd_clear + hdd_spacer + hdd_screw_off;
        
        for(i=[0:n-1]) {
            translate([-t,w/2,screw_h+i*(hdd_spacer+hdd_h)]) rotate([0,90,0]) cylinder(r=1.5, h=3*t);
        }
    }
}

module hdd_mount_35(n=4, thickness=2)
{
    t = thickness;
    post_w = 16;
    post_p = [26.1, 127,7];
    
    hdd_spacer =  5;
    hdd_clear = 10;
    hdd_h =  26.1;
    hdd_w = 101.6;
    hdd_l = 147.0;
    
    for(i=[0:1]) {
        translate([0,-post_w/2+post_p[i],0]) hdd_post(n=n,w=post_w,thickness=t);
    }
    
    for(i=[0:1]) {
        translate([hdd_w+2*t+1,-post_w/2+post_p[i],0]) mirror([1,0,0]) hdd_post(n=n,w=post_w,thickness=t);
    }

    for(i=[0:n-1]) {
        translate([0,0,hdd_clear+i*(hdd_spacer+hdd_h)]) hdd_support();
    }
    
    for(i=[0:n-1]) {
        translate([hdd_w+2*t+1,0,hdd_clear+i*(hdd_spacer+hdd_h)]) mirror([1,0,0]) hdd_support();
    }
}