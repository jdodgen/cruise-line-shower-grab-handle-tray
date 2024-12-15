// project dovetail defaults are used. change at risk
default_min_width = 15;
default_max_width = default_min_width*1.5;
default_depth = 15/2;
default_clearance = 0.7;
default_height = 15;

// test examples
dovetail();
translate([0,-5/2,default_height/2])
        cube([default_max_width*1.5, 5, default_height], center=true);
translate([0,20,0]) 
    difference() 
    {
        translate([0,default_min_width/2,default_height/2])
        cube([default_max_width*1.5,
            default_min_width,default_height], center=true);
        dovetail(clearance=true);
    }
// end test
module dovetail(max_width=default_max_width, min_width=default_min_width, 
                depth=default_depth, height=default_height, clearance=false) {
	linear_extrude(height=height, convexity=2)
		dovetail_2d(max_width +
                   (clearance ? default_clearance:0),
                   min_width+
                   (clearance ? default_clearance:0),
                    depth);
}

module dovetail_2d(max_width=11, min_width=5, depth=5) {
	angle=atan((max_width/2-min_width/2)/depth);
	echo("angle: ", angle);
	polygon(paths=[[0,1,2,3,0]], points=[[-min_width/2,0], [-max_width/2,depth], 
        [max_width/2, depth], [min_width/2,0]]);
}