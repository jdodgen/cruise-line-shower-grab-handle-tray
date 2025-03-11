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
// when script is run from commandline override tray_type with: 

tray_type = "soap"; // "short", "long" ,"", "test", "soapmount", "loop", "shortmount"
make_tray();

/* 
tray_parms = [
0    lenght, 
1    height, 
2    ribs, 
3    tilt_up_angle, tilt_up_angle is a value in degrees to level the tray a bit in the mount
4    nesting, 
5    rounded, 
6    add_loop
7    inside_width
8    side_loops
] */
// library of trays
soap_tray =        [80, 20,  true,  -2, true,  true,   true, 72, true];
loop =             [0, 20,   false,  0, false, false,  true, 0];
soap_mount_tray =  [90, 20,  true,   0, true,  false,  false,72, true];
short_mount_tray = [130, 40, false, -2, false, false,  false, 92];
short_tray =       [130, 40, false, -2, false, true,   true, 72];
long_tray =        [192, 40, false, -2, false, true,   true, 72];
// end of library 

tray_parms = 
    tray_type == "soap"        ? soap_tray :
    tray_type == "soapmount"   ? soap_mount_tray :
    tray_type == "shortmount"  ? short_mount_tray :
    tray_type == "short"       ? short_tray :
    tray_type == "loop"        ? loop :
    tray_type == "long"        ? long_tray : false;
 
tray_lth = tray_parms[0];
tray_height = tray_parms[1];
tray_ribs = tray_parms[2];
drain_holes = true;
tilt_up_angle = tray_parms[3];
is_nesting = tray_parms[4];
rounded = tray_parms[5];
add_loop = tray_parms[6];
inside_width = tray_parms[7];
side_loops = tray_parms[8];

// common values
// razer loop
razer_legs = 20;
razer_width = 24;

tray_wall = 4;


tray_fillet_radius=15;

  // women like this for a razor
echo("is_nesting", is_nesting);
nesting_width = inside_width-(tray_wall*2);

filler_block_x=36;  // home of dovetail
filler_block_y=10.5;

dove_base = 2;
dove_mount_offset = 2;
// end of universal_mount.scad common numbers
raw_inside_width = is_nesting ? nesting_width : inside_width;
tray_width = raw_inside_width + tray_wall*2;


module make_tray(tray_width=tray_width, tray_lth=tray_lth, tray_height=tray_height, wall=tray_wall)
{
    if (tray_type == "test")
    {
    }
    else
    {
        /// total_lth = tray_lth + filler_block_y;
        difference() // outer mostly fillets
        {
            union()
            { 
                 // this is the attachment to the handle_mount
                if (tray_lth == 0) // this for the loop
                {
                    width = filler_block_x+12;
                    depth = filler_block_y;
                    translate([-width/2,-tray_lth/2+depth/2, 0])
                        tray_dovetail(width=width, height=tray_height-dove_base);
                }
                else
                {
                    translate([-filler_block_x/2,
                            -tray_lth/2-filler_block_y,0])
                        tray_dovetail();
                }
                make_inner();
                if (tray_lth > 0)
                {
                    // inside corners
                    translate([-tray_width/2+wall/2,-tray_lth/2+wall/2,
                            0])
                        fillet(0, tray_fillet_radius, tray_height, $fn=40);
                    translate([tray_width/2-tray_fillet_radius-wall/2,
                        -tray_lth/2+wall/2, 0])
                            fillet(90, tray_fillet_radius, tray_height,
                                $fn=40);
                    if (!rounded)
                    {
                        translate([-tray_width/2+wall/2,  
                            tray_lth/2-tray_fillet_radius-wall/2,
                            0])
                        fillet(-90, tray_fillet_radius, tray_height, $fn=40);
                        translate([tray_width/2-tray_fillet_radius-wall/2,
                        tray_lth/2-tray_fillet_radius-wall/2, 0])
                            fillet(180, tray_fillet_radius, tray_height,
                                $fn=40);
                    }
                }
            } // end union
            translate([-tray_width/2,-tray_lth/2,
                    0])
                fillet(0, tray_fillet_radius, tray_height, $fn=40);

            translate([tray_width/2-tray_fillet_radius,
                -tray_lth/2, 0])
                    fillet(90, tray_fillet_radius, tray_height, $fn=40);
            if (!rounded)
            {
                translate([-tray_width/2,  tray_lth/2-tray_fillet_radius,
                    0])
                fillet(-90, tray_fillet_radius, tray_height, $fn=40);

                translate([tray_width/2-tray_fillet_radius,
                  tray_lth/2-tray_fillet_radius, 0])
                    fillet(180, tray_fillet_radius, tray_height, $fn=40);
            }
        }
    }
    if (tray_ribs == true)
    {
        drain_slot_bumps(lth=tray_lth);
    }
}
//make_inner();
module make_inner(tray_width=tray_width, tray_lth=tray_lth, tray_height=tray_height, wall=tray_wall, support_base_thickness = 0.5)
{
    difference() // inner
    {
        union()
        {
            if (tray_lth > 0)
                rough_tray(tray_width=tray_width, lth=tray_lth,
                            tray_height=tray_height, z_offset=0);
            if (add_loop ==  true)
            {
                translate([0, (tray_lth/2)+33.5,
                    (tray_lth > 0) ? tray_height-5 : tray_height/2+2])
                {
                    make_loop(); 
                }
                translate([0,(tray_lth/2)+31,support_base_thickness/2])
                    support_base(support_base_thickness=support_base_thickness);
                
                
             }
             if (side_loops == true)
             {
                translate([(tray_width/2)+20, 8,
                    (tray_lth > 0) ? tray_height-5 : tray_height/2+2])
                    rotate([0,0,-90]) 
                        make_loop();
                translate([(-tray_width/2)-20, 8,
                    (tray_lth > 0) ? tray_height-5 : tray_height/2+2])
                    rotate([0,0,90]) 
                        make_loop();                
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
    } 
}
module support_base(x=49, y=29, support_base_thickness=1, tray_fillet_radius=tray_fillet_radius)
{
    difference()
    {
         color("purple")
         cube([x,y,support_base_thickness], 
                    center=true);
         translate([x/2-tray_fillet_radius,-0.5,
            -support_base_thickness])
            fillet(180, tray_fillet_radius,
                support_base_thickness*2, $fn=80);
         translate([-x/2,-0.5,-support_base_thickness])
            fillet(-90, tray_fillet_radius, support_base_thickness*2, $fn=80);
    }
}

module make_loop()
{
    round_loop(r=3, base=1.8, 
        lth=razer_width-7,
        legs=razer_legs, curved_end=false); 
} 
            
//tray_dovetail();
module tray_dovetail(width=filler_block_x,height=tray_height, depth=filler_block_y, round_corner_radius=2, , fillet_radius=tray_fillet_radius/4, tilt_x=tilt_up_angle)
{   
    cutout_height = height*1.5;
    difference()
    {
        cube([width,depth,height]);
        rotate([tilt_x,0,0])
        {
            translate([width/2,0,0])
                color("purple")
                    dovetail(height=cutout_height,clearance=true);
            translate([0,0,0])
                fillet(0, round_corner_radius, cutout_height, $fn=40);

            translate([width-round_corner_radius, 0, 0])
                fillet(90, round_corner_radius, cutout_height, $fn=40);
            translate([0,-depth,0])
                cube([width,depth,cutout_height]);
            if (tray_lth == 0)
            {
               translate([width-round_corner_radius, depth-round_corner_radius, 0])
                    fillet(180, round_corner_radius, cutout_height, $fn=40);
               translate([0,depth-round_corner_radius,0])
                    fillet(-90, round_corner_radius, cutout_height, $fn=40);
            }
        }
    }
    if (!rounded && tray_lth > 10) 
    {
        translate([width/2,tray_lth+depth,0])
        {
            dovetail(height=height);
            scale([1,0.7,1]) 
            cylinder(d=filler_block_x*0.9, h=dove_base, $fn=120);
        }
    }
    if (tray_lth > 0)
    {
        translate([-fillet_radius,depth-fillet_radius,0])
                fillet(-180, fillet_radius, tray_height, $fn=80);

        translate([width, depth-fillet_radius, 0])
                        fillet(-90, fillet_radius, tray_height, $fn=80);
    }
    else
    {
        
    }
}
drain_offset=12;
//drain_slot_cutter();
module drain_slot_cutter(lth=tray_lth)
{
    if (tray_lth > 0)
    {
        rows = tray_lth/12 + (rounded ? 0 : -1);
        drain_hole_d = 6;
        cutout_width = inside_width-10-drain_hole_d;
        cols = round(inside_width/(drain_offset+(drain_hole_d/2)));
        //echo("raw column holes", cols);
        columns = cols % 2 ? (cols/2)+1 : (cols/2);
        start = -columns/2;
        //echo("calculated columns", columns);
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
}

module drain_slot_bumps(lth=tray_lth)
{
    rows = tray_lth/12 + (rounded ? -1 : -2);
    bump_d = 6.1;
    bump_width = tray_width;
    cols = round(inside_width/(drain_offset+(bump_d/2)));
    //echo("raw bumps", cols);
    columns = cols % 2 ? (cols/2)+1 : (cols/2);
    start = -columns/2;
    //echo("calculated bumps columns", columns);
    for (y =[1:rows])
    {
        translate([-bump_width/2, -(lth/2.54)+drain_offset*y, bump_d/2])
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
    echo("rounded", rounded);
    if (rounded)
    { 
        translate([0,lth/2, z_offset])
        scale([1,.5,1])
            cylinder(d=tray_width, h=tray_height, $fn=120);
        echo("made rounded");
    }
}
