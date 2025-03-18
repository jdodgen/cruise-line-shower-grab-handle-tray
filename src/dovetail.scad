// project dovetail defaults are used. change at risk

default_min_width = 15;
default_max_width = default_min_width*1.5;
default_depth = 15/2;
default_clearance = 0.5;  // was 1 and loose
default_height = 15;

// test examples
dovetail(text="20x50mm",text_title="DIAMETER HHHHHHHHHH"); //height=80);
//translate([0,-5/2,default_height/2])
//        cube([default_max_width*1.5, 5, default_height], center=true);
//translate([0,20,0]) 
//    difference() 
//    {
//        translate([0,default_min_width/2,default_height/2])
//        cube([default_max_width*1.5,
//            default_min_width,default_height], center=true);
//        dovetail(clearance=true);
//    }
// end test
module dovetail(max_width=default_max_width, min_width=default_min_width, 
                depth=default_depth, height=default_height, clearance=false,text=false,text_title=false) {
     clear = clearance ? default_clearance:0;
     d = default_max_width+clear;
     difference()
     { 
         linear_extrude(height=height, convexity=2)
            dovetail_2d(d,
                       min_width + clear,
                        depth);
         translate([0,0,height-6])
            rotate([-90,0,0])
            scale([1,0.7,1])
            difference()
             {
                 d = default_max_width+clear;
                 cylinder(h=default_depth, d=d*2, $fn=120);
                 cylinder(h=default_depth, d=d, $fn=120);
                 translate([0,d,default_depth/2])
                 cube([d*2,d*2,default_depth], center=true);
             }
         if (text) apply_text(text=text, height=height, depth=depth,text_title=text_title);
     }
}
//apply_text();
module apply_text(depth=default_depth, height=default_height, text=false, text_title=false)
{
    letter_height = 1;
    color("red")
    translate([0,depth-(letter_height*0.9), default_height/3])
    rotate([90,0,180])
        linear_extrude(height = letter_height, convexity = 10) 
            text(text, font = "Helvetica:style=Bold", size=3,halign="center" );
    if (text_title) 
        translate([0,depth-(letter_height*0.9), default_height/1.8])
            rotate([90,0,180])
            linear_extrude(height = letter_height, convexity = 10) 
            text(text_title, font = "Helvetica:style=Bold", size=3,halign="center" );  
}

module dovetail_2d(max_width=11, min_width=5, depth=5) {
	angle=atan((max_width/2-min_width/2)/depth);
	echo("angle: ", angle);
	polygon(paths=[[0,1,2,3,0]], points=[[-min_width/2,0], [-max_width/2,depth], 
        [max_width/2, depth], [min_width/2,0]]);
}