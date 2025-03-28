/*
MIT license, copyright 2024,2025 Jim Dodgen
cruise line shower "grab handle" tray
this is the tray part, universal_tray.scad look at universal_mount.scad for mounts 
it is designed to hold items that do not fit on shelf in the shower. 
in its simplest form it is just a loop to hang a razor
*/
use <rounded_loop.scad>;
use <fillet.scad>;
use <dovetail.scad>;
//
// when script is run from commandline override tray_type with: 

tray_type = "longmount"; // "short", "long" ,"", "test", "soapmount", "loop", "shortmount",longmount"
make_tray();

/* 
tray_parms = [
0    length, 
1    height, 
2    ribs, 
3    tilt_up_angle, tilt_up_angle is a value in degrees to level the tray a bit in the mount
4    nesting, can it fit inside inside width
5    rounded, 
6    add_loop
7    inside_width  see nesting for shrinkage
8    side_loops
9    Y_dovetail
10   loop Y adjustment
11   mount_offset 
] */
// library of trays 0   1     2      3     4     5       6     7   8      9     10    11
soap_tray =        [90, 20,  true,  -2, true,  false,   true, 72, true, false, 24.5,   0];
loop =             [0, 20,   false,  0, false, false,  true, 0, false, false,  30,     0];
soap_mount_tray =  [90, 20,  true,   0, false,  false,  false,72, true, true,    0,    0];
short_mount_tray = [110, 40, false, -2, false, false,  false, 92, false, true,   0,    0];
short_tray =       [130, 40, false, -2, false, true,   true, 72, false, false,   0,    0];
long_tray =        [180, 40, false, -2, false, true,   false, 63, true, false, 23.4,  0.5];
long_mount_tray = [180, 40, false, -2, false, false,  false, 63, false, true,    0,    0];
// end of library 

tray_parms = 
    tray_type == "soap"        ? soap_tray :
    tray_type == "soapmount"   ? soap_mount_tray :
    tray_type == "shortmount"  ? short_mount_tray :
    tray_type == "longmount"  ? long_mount_tray :
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
y_dovetail = tray_parms[9];
loop_y_adj = tray_parms[10];
mount_offset = tray_parms[11];

// common values
// razer loop
razer_legs = 15;
razer_width = 24;

tray_wall = 4;
tray_floor = tray_wall/2;

tray_fillet_radius=15;

// shring tray width so It fits inside another tray
echo("is_nesting", is_nesting);
nesting_width = inside_width-(tray_wall*2);

filler_block_x=36;  // home of dovetail
filler_block_y=10.5;

dove_base = 2;
dove_mount_offset = 2;
// end of universal_mount.scad common numbers
raw_inside_width = is_nesting ? nesting_width : inside_width;
tray_width = raw_inside_width + tray_wall*2;



module make_tray(tray_width=tray_width, tray_lth=tray_lth, tray_height=tray_height, wall=tray_wall, tray_floor=tray_floor)
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
module make_inner(tray_width=tray_width, tray_lth=tray_lth, tray_height=tray_height, wall=tray_wall, tray_floor=tray_floor, support_base_thickness = 0.5)
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
                echo("loop_y_adj", loop_y_adj);
                translate([0, (tray_lth/2)+loop_y_adj, 0])
                    //(tray_lth > 0) ? tray_height-5 : tray_height/2+2])
                {
                    make_loop(); 
                }
                // translate([0,(tray_lth/2)+31,support_base_thickness/2])
                    // support_base(support_base_thickness=support_base_thickness);
                
                
             }
             if (side_loops == true)
             {
                translate([(tray_width/2)+14.5, 0,0])
                    //(tray_lth > 0) ? tray_height-5 : tray_height/2+2])
                    rotate([0,0,-90]) 
                        make_loop();
                translate([(-tray_width/2)-14.5, 0,0])
                    //(tray_lth > 0) ? tray_height-5 : tray_height/2+2])
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
                tray_height=tray_height-tray_floor, z_offset=tray_floor);
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
    difference()
    {
        scale([1,1,2])
            round_loop(r=3, base=1.6, 
                        lth=razer_width-7,
                        legs=razer_legs, curved_end=false); 
        translate([0,0,-25]) cube([400,400,50],center=true);
    }
} 
            
// tray_dovetail();
module tray_dovetail(width=filler_block_x,height=tray_height, depth=filler_block_y, round_corner_radius=2, fillet_radius=tray_fillet_radius/4, tilt_x=tilt_up_angle)
{   
    cutout_height = height*1.5;
    translate([0,mount_offset,0])
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
    if (y_dovetail) 
    {
        translate([width/2, tray_lth+depth, 0])
        {
            dovetail(height=height);
            scale([1,0.7,1])
              difference()
               { 
                    cylinder(d=filler_block_x*0.9, h=dove_base, $fn=120);
                    translate([0, -filler_block_x/2,dove_base/2])
                    color("red") cube([filler_block_x,filler_block_x,
                        dove_base], center=true);
               }
        }
    }
    if (tray_lth > 0)
    {
        translate([-fillet_radius, depth-fillet_radius+mount_offset, 0])
                fillet(-180, fillet_radius, tray_height, $fn=80);

        translate([width, depth-fillet_radius+mount_offset, 0])
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
//drain_slot_bumps(lth=tray_lth);
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
        translate([-bump_width/2, -(lth/2.5)+drain_offset*y, tray_floor-0.01])
          rotate([0,90,0])    
            difference()
                {  
                    scale([1.5,1,1])    
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
