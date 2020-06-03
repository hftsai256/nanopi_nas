use <panels.scad>

$fn=50;
show_all = true;

// Exterior frame
hdd_h =  26.1;
hdd_w  = 101.6;
hdd_l  = 147.0;

beam_w = 4;
beam_h = 2;

box_width = beam_w*6+hdd_w;
box_depth = 220;
box_height = 140;
vent_edge = 20;

cyl_p = [[beam_w, beam_w, 0],
         [box_width-beam_w, beam_w, 0],
         [box_width-beam_w, box_depth-beam_w, 0],
         [beam_w, box_depth-beam_w, 0]];

corner_cut_p = [[beam_w,beam_w,-beam_h],
                [box_width-beam_w,beam_w,-beam_h],
                [box_width-beam_w,box_depth-beam_w,-beam_h],
                [beam_w,box_depth-beam_w,-beam_h]];

// HDD Rack
hdd_spacer    =  5;
hdd_cl        =  8;
hdd_front_pad = 45.4;
hdd_back_pad  = 26.1;
hdd_screw_off = 6.35;
post_w = 16;
post_p = [16.9, 16.9+101.6];
snap_w = 8;
snap_h = 4;
snap_cutout = 0.5;
snap_offset = (post_w - snap_w)/2;
xc_offset = (box_width-(4*beam_w+hdd_w))/2;
hdd_snap_p = [[xc_offset+2*beam_w,hdd_cl+beam_w-snap_w/2+post_p[0],-beam_h],
              [xc_offset+2*beam_w,hdd_cl+beam_w-snap_w/2+post_p[1],-beam_h],
              [xc_offset+2*beam_w+hdd_w,hdd_cl+beam_w-snap_w/2+post_p[0],-beam_h],
              [xc_offset+2*beam_w+hdd_w,hdd_cl+beam_w-snap_w/2+post_p[1],-beam_h]];

// Pi Mount
t = beam_h;
pistand_h = beam_w;
screw_r0 = 3/2;
screw_r1 = 3;
screw_r2 = 4;
screw_edge = 4;
screw_sep_width = 51;
screw_sep_length = 80;
standoff_p = [[0,0,0], [0,screw_sep_width,0],[screw_sep_length,screw_sep_width,0], [screw_sep_length,0,0]];
pi_p = [beam_w, box_depth-screw_sep_width-screw_r2, 0];
pi_backplate_p = [beam_w,box_depth-screw_sep_width-2*screw_r2,0];

// Backboard
bottom_lock_w = 12;
backboard_snap_p = [(box_width-bottom_lock_w)/2, box_depth-2*beam_w, -beam_h];
frontboard_snap_p = [(box_width-bottom_lock_w)/2, beam_w+1, -beam_h];
snap_p = [[(box_width-bottom_lock_w)/2, box_depth-4*beam_h, -beam_h],
          [(box_width-bottom_lock_w)/2, 2.5*beam_h, -beam_h],
          [2.5*beam_h, (box_depth-bottom_lock_w)/2, -beam_h],
          [box_width-4*beam_h, (box_depth-bottom_lock_w)/2, -beam_h]];

display="";

if (display == "") assemble();
if (display == "base_board.stl") base_board();
if (display == "hdd_mount_left.stl") hdd_mount();
if (display == "hdd_mount_right.stl") mirror([1,0,0]) hdd_mount();
if (display == "front_panel.stl") front_panel(box_width=box_width, box_depth=box_depth, box_height=box_height);
if (display == "cut_back_panel.stl") cut_back_panel(box_width=box_width, box_depth=box_depth, box_height=box_height);
if (display == "cut_left_panel.stl") cut_left_panel(box_width=box_width, box_depth=box_depth, box_height=box_height);
if (display == "cut_right_panel.stl") cut_right_panel(box_width=box_width, box_depth=box_depth, box_height=box_height);
if (display == "top_board.stl") top_board();

module assemble() {
	display_offset = 25;
	color("red") base_board();
	color("green",0.8) translate([xc_offset+2*beam_w-0.5*beam_h,hdd_cl,beam_h+display_offset/2])
		hdd_mount();
	color("lightgreen",0.8) translate([xc_offset+2*beam_w+hdd_w+1.5*beam_h,hdd_cl,beam_h+display_offset/2]) mirror([1,0,0])
		hdd_mount();
	color("blue",0.8) translate([0,-display_offset,0])
		front_panel(box_width=box_width, box_depth=box_depth, box_height=box_height);
	color("blue",0.5) translate([0,display_offset,0])
		cut_back_panel(box_width=box_width, box_depth=box_depth, box_height=box_height);
	color("lightblue",0.8) translate([-display_offset,0,0])
		cut_left_panel(box_width=box_width, box_depth=box_depth, box_height=box_height);
	color("lightblue",0.8) translate([display_offset,0,0])
		cut_right_panel(box_width=box_width, box_depth=box_depth, box_height=box_height);
	color("orange",0.8) translate([0,0,box_height-4+display_offset]) top_board();
}

module base_board()
{
    difference() {
        union() {
            // Exterior frame
            difference(){
                hull(){
                    for(c=cyl_p){
                        translate(c) cylinder(r=beam_w,h=beam_h);
                    }
                }
                translate(pi_p-[-beam_w,-beam_w,t])
                    cube([screw_sep_length-2*beam_w,screw_sep_width-2*beam_w,3*beam_h]);
                translate([(box_width-screw_sep_length)/2, 3*beam_w, -t]) cube([screw_sep_length,hdd_l-4*beam_w, 3*beam_h]);
            }
            // Side panel suports
            translate([-t,2*screw_r2,0]) cube([2*t,box_depth-4*screw_r2,t]);
            translate([box_width-t,2*screw_r2,0]) cube([2*t,box_depth-4*screw_r2,t]);
            
            // HDD Rack      
            translate([(box_width-screw_sep_length)/2, 3*beam_w, 0]) grid(screw_sep_length,hdd_l-4*beam_w);
            
            // Pi Mount
            translate(pi_p)
                for(s=standoff_p){
                    translate(s) cylinder(r=screw_r2,h=pistand_h+t);
                }
            difference(){
                    translate(pi_backplate_p) cube([box_width-2*beam_w,screw_sep_width+2*screw_r2,beam_h]);
                    translate(pi_p-[0,0,t]) cube([screw_sep_length,screw_sep_width,3*beam_h]);
            }
            translate(pi_p) grid(screw_sep_length,screw_sep_width);
        }
    
    // Cutouts
        // HDD Rack
        for(s=hdd_snap_p){
            translate(s) cube([beam_h,snap_w,3*beam_h]);
        }
        
        // Pi Mount
        for(s=standoff_p){
            translate(pi_p+s+[0,0,-t])cylinder(r=screw_r1,h=pistand_h+t);
            translate(pi_p+s+[0,0,pistand_h-t]) cylinder(r=screw_r0,h=3*t);
        }
        
        for(c=corner_cut_p){
            translate(c) cylinder(r=screw_r0, h=pistand_h+t);
        }
    }
}

module top_board()
{
    difference() {
        union() {
            // Exterior frame
            difference(){
                hull(){
                    for(c=cyl_p){
                        translate(c) cylinder(r=beam_w,h=beam_h);
                    }
                }
                translate([vent_edge, vent_edge, -t]) cube([box_width-2*vent_edge,box_depth-2*vent_edge,3*beam_h]);
            }
            translate([vent_edge,vent_edge,0]) grid(box_width-2*vent_edge,box_depth-2*vent_edge);
        }
    
    // Cutouts
		translate(snap_p[0]) cube([bottom_lock_w,1.5*beam_h,3*beam_h]);
		translate(snap_p[1]) cube([bottom_lock_w,1.5*beam_h,3*beam_h]);
		translate(snap_p[2]) cube([1.5*beam_h,bottom_lock_w,3*beam_h]);
		translate(snap_p[3]) cube([1.5*beam_h,bottom_lock_w,3*beam_h]);
    }
}

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
    
    h = beam_w + (n-1)*(hdd_spacer+hdd_h) + hdd_h;
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
        
        screw_h = beam_w + hdd_spacer + hdd_screw_off;
        
        for(i=[0:n-1]) {
            translate([-t,w/2,screw_h+i*(hdd_spacer+hdd_h)]) rotate([0,90,0]) cylinder(r=1.5, h=3*t);
        }
    }
}

module hdd_mount(n=4, thickness=2)
{
    t = thickness;
    
    for(p=post_p) {
        translate([0,beam_w-post_w/2+p,0]) hdd_post(n=n,w=post_w,thickness=t);
    }

    for(i=[0:n-1]) {
        translate([0,beam_w,beam_w+i*(hdd_spacer+hdd_h)]) hdd_support();
    }
}
