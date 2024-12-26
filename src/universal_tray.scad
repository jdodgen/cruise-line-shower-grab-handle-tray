/*
MIT licence, copyright 2024,2025 Jim Dodgen
cruise line shower "grab handle" tray
this is the tray part, universal_tray.scad look at universal_mount.scad for mounts 
it is designed to hold items that do not fit on shevles in the shower. 
in it simplist form it is a soap tray with a hanger for a razer
*/
use <rounded_loop.scad>;
use <fillet.scad>;
use <dovetail.scad>;
//
tray_type = "soap"; // "short", "long" ,"soap", "test"

add_loop = true;  // women like this for a razor
drain_holes = true;  // testing set to false
// tilt_up_angle is a value in degrees to level the tray a bit in the mount
// tray_parms = [lenght, height, ribs, tilt_up_angle] 
soap_tray = [85, 17, true,-2]; 
short_tray = [120, 35, false,-2];
long_tray = [192, 35, false,-2];

tray_parms = 
    tray_type == "soap" ? soap_tray :
    tray_type == "short" ? short_tray :
    tray_type == "long" ? long_tray : false;
    
razer_legs = 20;
razer_width = 24;

inside_width = 72;
tray_wall = 3;
tray_width = inside_width + tray_wall*2;
tray_lth = tray_parms[0];
tray_height = tray_parms[1];
tray_ribs = tray_parms[2];
tilt_up_angle = tray_parms[3];
tray_fillet_radius=4;

filler_block_x=40;  // home of dovetail
filler_block_y=15; 

dove_base = 2;
dove_mount_offset = 2;
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
                            {
                                round_loop(r=3, base=1.8, 
                                    lth=razer_width-7,
                                    legs=razer_legs, curved_end=false);
                            support_base_thickness = 0.5;
                            translate([0,0,
                                support_base_thickness/2-tray_height+5]) 
                                color("purple")
                                cube([52,30,support_base_thickness], 
                                    center=true);
                            }
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

                translate([-filler_block_x/2,-tray_lth/2-filler_block_y,
                            0])
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
    if (tray_ribs == true)
    {
        drain_slot_bumps(lth=tray_lth);
    }
}

// tray_dovetail();
module tray_dovetail(width=filler_block_x,height=tray_height, round_corner_radius=2, , fillet_radius=8, tilt_x=tilt_up_angle)
{   
    cutout_height = height*1.5;
    difference()
    {
        cube([width,filler_block_y,height]);
        rotate([tilt_x,0,0])
        {
        translate([width/2,0,0])
            color("purple")
                dovetail(height=cutout_height,clearance=true);
        translate([0,0,0])
            fillet(0, round_corner_radius, cutout_height, $fn=40);

        translate([width-round_corner_radius, 0, 0])
            fillet(90, round_corner_radius, cutout_height, $fn=40);
        translate([0,-filler_block_y,0])
            cube([width,filler_block_y,cutout_height]);
        }
    }
    if (fillet_radius > 0)
    {
        translate([-fillet_radius,filler_block_y-fillet_radius,0])
                fillet(-180, fillet_radius, tray_height, $fn=80);

        translate([width, filler_block_y-fillet_radius, 0])
                        fillet(-90, fillet_radius, tray_height, $fn=80);
    }
}
drain_offset=12;
//drain_slot_cutter();
module drain_slot_cutter(lth=tray_lth)
{
    rows = tray_lth/12;
    
    drain_hole_d = 6;
    cutout_width = inside_width-10-drain_hole_d;
    cols = round(inside_width/(drain_offset+(drain_hole_d/2)));
    echo("raw column holes", cols);
    columns = cols % 2 ? (cols/2)+1 : (cols/2);
    start = -columns/2;
    echo("calculated columns", columns);
    for (y =[1:rows])
    {
        translate([-cutout_width/2, -(lth/2)+drain_offset*y, 0])
            cube([cutout_width, drain_hole_d, tray_wall*2]);
        translate([-cutout_width/2, 
            -(lth/2)+drain_offset*y+drain_hole_d/2, 0])
            cylinder(d=drain_hole_d,h =tray_wall*2, $fn=20);
        translate([cutout_width/2, 
            -(lth/2)+drain_offset*y+drain_hole_d/2, 0])
            cylinder(d=drain_hole_d,h =tray_wall*2, $fn=20);
    }
}

module drain_slot_bumps(lth=tray_lth)
{
    rows = tray_lth/12-1;
    bump_d = 4;
    bump_width = tray_width;
    cols = round(inside_width/(drain_offset+(bump_d/2)));
    echo("raw bumps", cols);
    columns = cols % 2 ? (cols/2)+1 : (cols/2);
    start = -columns/2;
    echo("calculated bumps columns", columns);
    for (y =[1:rows])
    {
        translate([-bump_width/2, -(lth/2.55)+drain_offset*y, bump_d/2])
        rotate([0,90,0])    
        difference()
            {  
                scale([2,1,1])    
                    cylinder(d=bump_d, h=bump_width, $fn=60);
                translate([0, -bump_d/2, 0])
                    cube([bump_d, bump_d, bump_width]); 
            }
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
