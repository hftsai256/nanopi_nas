$fn=10;

angle_bracket(base=9, height=13);

module angle_bracket(base=12, height=12, width=12, thickness=3, hole_diameter=3)
{
    radius = min(base, height, width, thickness)/4;
    
    b = base - 2*radius;
    h = height - 2*radius;
    w = width - 2*radius;
    t = thickness - 2*radius;
    
    translate([radius, -w/2, -t-radius]) difference(){
        minkowski() {
            union(){
                cube([b, w, t]);
                cube([t, w, h]);
                translate([t, 0, t])
                    polyhedron(
                        points=[[0,0,0],[b-t,0,0],[0,0,h-t],
                                [0,t,0],[b-t,t,0],[0,t,h-t]],
                        faces=[[0,1,4,3],[2,0,3,5],[2,5,4,1],[2,1,0],[5,3,4]]
                    );
                translate([t, w-t, t])
                    polyhedron(
                        points=[[0,0,0],[b-t,0,0],[0,0,h-t],
                                [0,t,0],[b-t,t,0],[0,t,h-t]],
                        faces=[[0,1,4,3],[2,0,3,5],[2,5,4,1],[2,1,0],[5,3,4]]
                    );
            } // union()
            sphere(r=radius);
        } // minkowski()
        
        gap = min(base-thickness, height-thickness, width-thickness*2)/2;
        
        hull() {
            translate([-2*radius, w/2, -radius+thickness+gap])
                rotate([0,90,0]) cylinder(h=t+4*radius, r=hole_diameter/2);
            translate([-2*radius, w/2, height-radius-gap-hole_diameter/2])
                rotate([0,90,0]) cylinder(h=t+4*radius, r=hole_diameter/2);
        } // hull()
        echo(height-thickness-gap);
    }
}