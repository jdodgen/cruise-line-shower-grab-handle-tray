/*
MIT licence, copyright 2024,2025 Jim Dodgen
cruise line shower "grab handle" tray
this is the tray part, universal_tray.scad look at universal_mount.scad for mounts 
it is designed to hold items that do not fin on shevles in the shower. 
in it simplist form it is a soap tray with a hanger for a razer
*/
use <rounded_loop.scad>;
use <fillet.scad>;
use <dovetail.scad>;
//
tray_type = "soap"; // "short", "long" ,"soap", "test"
add_loop = true;
drain_holes = true;  // testing set to false

razer_legs = 20;
razer_width = 24;

inside_width = 72;
tray_wall = 3;
tray_width = inside_width + tray_wall*2;
tray_lth = tray_type == "long"
        ? 192:
    tray_type == "short" ? 120:
    tray_type == "soap" ? 85:30;

tray_height = tray_type == "soap" ?  15: 30;  // shallow for soap thicker for bottles

tray_fillet_radius=4;

filler_block_x=40;  // home of dovetail
filler_block_y=15; 
// dovetail varibles shared with universal_mount.scad 
// CHANGE IN BOTH PLACES if you modify
dove_base = 2;
dove_mount_offset = 2;
//dove_width = 15;
//dove_clearance = 0.5;
//dove_thickness = filler_block_y/2;
// end of universal_mount.scad common numbers

make_tray();

module make_tray(tray_width=tray_width, tray_lth=tray_lth, tray_height=tray_height, wall=tray_wall)
{
    if (tray_type == "test")
    {
    }
    else
    {
    total_lth = tray_lth + filler_block_y;
        difference() // outer mostly fillets
        {
            union()
            {
                difference() // inner
                {
                    union()
                    {
                        rough_tray(tray_width=tray_width, lth=tray_lth,
                            tray_height=tray_height, z_offset=0);
                        if (add_loop ==  true)
                        {
                            translate([0,(tray_lth/2)+35,tray_height-5])
                                round_loop(r=3, base=1.8, lth=razer_width-7,
                                    legs=razer_legs, curved_end=false);
                        }

                    }
                    translate([-150,0,tray_height]) // trim top of tray
                        cube([300,300,100]);
                    // remove insides
                    translate([0,0,0])
                    {
                        color("red") rough_tray(tray_width=tray_width-wall, lth=tray_lth-wall,
                            tray_height=tray_height-wall, z_offset=wall);
                    }

                    //tray_holes_columns
                    if (drain_holes == true)
                    {
                        drain_slot_cutter(lth=tray_lth);
                    }
                } // end inner diff
                 // this is the attachment to the handle_mount

                translate([-filler_block_x/2,-tray_lth/2-filler_block_y,0])
                    tray_dovetail();
                // inside corners
                translate([-tray_width/2+wall/2,-tray_lth/2+wall/2,
                        0])
                    fillet(0, tray_fillet_radius, tray_height, $fn=40);
                translate([tray_width/2-tray_fillet_radius-wall/2,
                    -tray_lth/2+wall/2, 0])
                        fillet(90, tray_fillet_radius, tray_height, $fn=40);
            } // end union
            translate([-tray_width/2,-tray_lth/2,
                    0])
                fillet(0, tray_fillet_radius, tray_height, $fn=40);

            translate([tray_width/2-tray_fillet_radius,
                -tray_lth/2, 0])
                    fillet(90, tray_fillet_radius, tray_height, $fn=40);
        }
    }
    support_base_thickness = 0.5;
    translate([0,tray_lth-7,support_base_thickness/2]) 
        cube([52,30,support_base_thickness], center=true);
}

//tray_dovetail(tray_width/2,tray_height/2,fillet_radius=0);
module tray_dovetail(width=filler_block_x,height=tray_height, round_corner_radius=2, , fillet_radius=8)
{   
    difference()
    {
        cube([width,filler_block_y,height]);
        translate([width/2,0,0])
            color("purple")
                dovetail(height=tray_height,clearance=true);
        translate([0,0,0])
            fillet(0, round_corner_radius, tray_height, $fn=40);

        translate([width-round_corner_radius, 0, 0])
                    fillet(90, round_corner_radius, tray_height, $fn=40);
    }
    if (fillet_radius > 0)
    {
        translate([-fillet_radius,filler_block_y-fillet_radius,0])
                fillet(-180, fillet_radius, tray_height, $fn=80);

        translate([width, filler_block_y-fillet_radius, 0])
                        fillet(-90, fillet_radius, tray_height, $fn=80);
    }
}

// common dovetail a duplicate of this exists in universal_mounts.scad 
// CHANGE IN BOTH PLACES
//
////dovetail(30,15,10,40);
//module dovetail(max_width=11, min_width=5, depth=5, height=30) {
//	linear_extrude(height=height, convexity=2)
//		dovetail_2d(max_width,min_width,depth);
//}
//
//module dovetail_2d(max_width=11, min_width=5, depth=5) {
//	angle=atan((max_width/2-min_width/2)/depth);
//	echo("angle: ", angle);
//	polygon(paths=[[0,1,2,3,0]], points=[[-min_width/2,0], [-max_width/2,depth], 
//        [max_width/2, depth], [min_width/2,0]]);
//}
//// end of common devetail

//drain_slot_cutter();
module drain_slot_cutter(lth=tray_lth)
{
    rows = tray_lth/12;
    offset=12;
    drain_hole_d = 6;
    cutout_width = inside_width-10-drain_hole_d;
    cols = round(inside_width/(offset+(drain_hole_d/2)));
    echo("raw column holes", cols);
    columns = cols % 2 ? (cols/2)+1 : (cols/2);
    start = -columns/2;
    echo("calculated columns", columns);
    for (y =[1:rows])
    {
        translate([-cutout_width/2, -(lth/2)+offset*y, 0])
            cube([cutout_width, drain_hole_d, tray_wall*2]);
        translate([-cutout_width/2, -(lth/2)+offset*y+drain_hole_d/2, 0])
            cylinder(d=drain_hole_d,h =tray_wall*2, $fn=20);
        translate([cutout_width/2, -(lth/2)+offset*y+drain_hole_d/2, 0])
            cylinder(d=drain_hole_d,h =tray_wall*2, $fn=20);
    }
}

//rough_tray(lth=40);
module rough_tray(tray_width=tray_width, lth=tray_lth, tray_height=tray_height, z_offset=0)
{
    translate([0,0,z_offset+(tray_height/2)])
        cube([tray_width,lth,tray_height], center=true);
    translate([0,lth/2, z_offset])
        scale([1,.5,1])
            cylinder(d=tray_width, h=tray_height, $fn=120);
}
