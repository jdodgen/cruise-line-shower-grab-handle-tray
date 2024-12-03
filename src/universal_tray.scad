/*
cruise line shower "grab handle" tray
MIT licence, copyright 2024 Jim Dodgen
This was developed using grab handle on the "Grand Princess"
Which has a 2cm diameter handle. 
universal veraion can be used right or left of the handle
*/
use <rounded_loop.scad>;
use <fillet.scad>;
use <grand_princess_shower_grab_bar.scad>;  // for testing
//
make_it();
// typical stuff to change
handle_d = 20+0.8;   // handle diameter + some clearance     
center_bar_to_nut = center_bar_to_nut(); //  38;
echo("center_bar_to_nut", center_bar_to_nut);
add_loop = true;
drain_holes = true;
tray_type = "short"; // "short", "long" ,"soap", "test" (default render faster)
//
// Other things that are rarely changed
//
nut_clearance = 12;
handle_d_outside = (center_bar_to_nut*2) - nut_clearance;
scale_handle_d_outside = 0.50 ;  // squeeze ratio
echo("handle_d_outside", handle_d_outside);
razer_legs = 23;
razer_width = 15;
clamp_seperation = 50;   // space between post "clamps"
top_clamp_thickness = 20;
top_clamp_tab_lth = 8;
bottom_clamp_thickness = 60;
top_clamp_clip_reduction_scale = 0.45;   // left side of cone only affeacting the clip

inside_width = 72;
tray_wall = 4;
tray_width = inside_width + tray_wall*2;  
// tray_holes_columns = 5;  // change this if changing tray_width

tray_lth = tray_type == "long" ? 192: 
    tray_type == "short" ? 120:
    tray_type == "soap" ? 85:30;

tray_height = tray_type == "soap" ? 15 : bottom_clamp_thickness;

total_height = clamp_seperation+top_clamp_thickness+bottom_clamp_thickness;
make_groove=true;
groove_depth=1.5;
groove_thickness = 8.2;
round_radius=4;

curve_offset = bottom_clamp_thickness*0.42; //*.4;

//color("silver") translate([0,0,curve_offset]) make_handle(); // used during testing  
//make_it();
//
// nothing but code below
//
module make_it()
{
    difference()
    {
        union()
        {
            difference()
            {
                union()
                {
                    handle_mount();
                    translate([0,0,0]) 
                        tray(tray_width=tray_width, lth=tray_lth, 
                            tray_height=tray_height, wall=tray_wall);
                     
                }
               
                center_cutout();
                cut_off_lower_mount_half();
                cut_off_upper_mount_half();
                drill_post_hole();            
            } 
        }
        translate([0,0,curve_offset])
       {
           cut_handle_curve();
           mirror([1,0,0]) translate([-0,0,0]) cut_handle_curve();
       }
    }
}

testing_drill_post_hole = false; 
if (testing_drill_post_hole)
    difference(0)
    {
        cylinder(d=handle_d+7,h=10, $fn=120);
        drill_post_hole();
    }
module drill_post_hole()
{
    color("red") 
    translate([0,0,-total_height/2]) 
        cylinder(d=handle_d, h=total_height*2, $fn=120); 
}

module cut_off_lower_mount_half()
{
    block_size = 100;
    color("green") 
    translate([0,-block_size/2,
        -block_size/2+bottom_clamp_thickness])
        cube([handle_d, block_size, block_size],
            center=true); 
}

module cut_off_upper_mount_half()
{
    block_size = 100;
    translate([0, block_size/2,
                (total_height-top_clamp_thickness/2)])
        cube([handle_d, block_size, top_clamp_thickness],
                        center=true);
}
//color("red") center_cutout();
module center_cutout()
{
    cutout_height = total_height - top_clamp_thickness-bottom_clamp_thickness;
    
    translate([-(handle_d_outside/2)+(handle_d/2),0,bottom_clamp_thickness]) // cutout
        translate([0,0,cutout_height/2]) // move cube up
            cube([handle_d_outside, handle_d_outside, 
                                cutout_height], center=true);
}

//cut_handle_curve();
module cut_handle_curve()
{   
    translate([0,0,handle_d]) //handle_d*1.5])
    {
        postr = handle_d/2;
        x=4*postr;
        difference()
        {
        union()
         { 
        color("orange")  
        translate([-x, 0, handle_d/2]) 
            rotate([-90,90,0])
                rotate_extrude(convexity = 10,angle=-90, $fn = 120)
                    translate([x, 0, 0])
                    rotate([0,0,-90]) 
                    hull()
                    {
                        circle(d = handle_d,, $fn=120);
                        translate([0,30,0])
                            circle(d = handle_d,, $fn=120);
                    } 
        color("blue")
        translate([0,0,-(handle_d+postr)]) //-handle_d/2+adjust])
            rotate([-90,90,90])
            {
                cylinder(d=handle_d+0.5, h=total_height, $fn=120);
                translate([0,-(handle_d/2)-0.25,0]) 
                    cube([total_height,handle_d+0.5,total_height]);
            }
        } 
         translate([50,0,0])  cube([100,100,200], center=true);
        } 
    }   
}

//handle_mount(top_clamp_clip_reduction_scale=0.5);
module handle_mount(top_clamp_clip_reduction_scale=top_clamp_clip_reduction_scale)
{
    scale([1,scale_handle_d_outside,1])
    union()
    {  
        cylinder(d=handle_d_outside,
            h=bottom_clamp_thickness, $fn=120);
        translate([0,0,bottom_clamp_thickness])
            {
                difference() // x side is correct
                {
                    cone_height = total_height-bottom_clamp_thickness;
                    scale([top_clamp_clip_reduction_scale,1,1])
                    cylinder(d1=handle_d_outside,
                        d2=handle_d+40, h=cone_height,
                            $fn=120);
                    translate([handle_d_outside/2,0,0])
                         cube([handle_d_outside,handle_d_outside, cone_height*2], center=true);
                }
                difference() // -x side is correct
                {
                    cone_height = total_height-bottom_clamp_thickness;
                    // no scaling needed here scale([top_clamp_clip_reduction_scale,1,1])
                    cylinder(d1=handle_d_outside,
                        d2=handle_d+40, h=cone_height,
                            $fn=120);
                    translate([-handle_d_outside/2,0,0])
                         cube([handle_d_outside,handle_d_outside, cone_height*2], center=true);
                }
            }  
   } 
}

//tray(lth=200);

module tray(tray_width=tray_width, lth=tray_lth, tray_height=tray_height, wall=tray_wall)
{
    filler_block_y=20;
    translate([0,lth/2+filler_block_y,0])
    {
        difference() // outer mostly fillets
        {
            union()
            {
            difference() // inner
            {
                union()
                {
                    rough_tray(tray_width=tray_width, lth=lth,
                        tray_height=tray_height, z_offset=0);
                    if (add_loop ==  true)
                    {
                        translate([0, (lth/2)+38, tray_height-5])
                            round_loop(r=3, base=1.3, lth=razer_width, 
                                legs=razer_legs, curved_end=false);
                    }
                    
                }
                translate([-150,0,tray_height]) // trim top of tray
                    cube([300,300,100]);
                // remove insides
                translate([0,wall/2,0])
                {
                    rough_tray(tray_width=tray_width-wall, lth=lth-wall, 
                        tray_height=tray_height-wall, z_offset=wall);
                }
               
                //tray_holes_columns
                if (drain_holes == true)
                {
                    drain_hole_driller(lth=lth);
                }
            } // end inner diff
             // this is the attachment to the handle_mount
            filler_block_x=handle_d_outside*0.7;
            translate([0,-(filler_block_y/2)-(lth/2),tray_height/2]) 
                cube([filler_block_x,filler_block_y,tray_height],
                        center=true); 
            // inside corners
            translate([-tray_width/2+wall/2,-lth/2+wall,
                    0]) 
                fillet(0, round_radius, tray_height, $fn=40);
            translate([tray_width/2-round_radius-wall/2,
                -lth/2+wall, 0]) 
                    fillet(90, round_radius, tray_height, $fn=40);
            // attachment block only needed some times 
            *translate([-(filler_block_x/2)-round_radius,
                -(lth/2)-round_radius,0]) 
                fillet(180, round_radius, tray_height, $fn=40);
            
            *translate([+(filler_block_x/2),
                -(lth/2)-round_radius, 0]) 
                    fillet(-90, round_radius, tray_height, $fn=40);
        } // end union
            translate([-tray_width/2,-lth/2,
                    0]) 
                fillet(0, round_radius, tray_height, $fn=40);
            
            translate([tray_width/2-round_radius,
                -lth/2, 0]) 
                    fillet(90, round_radius, tray_height, $fn=40);
        
    }
} 
    
}
// make_it();
//drain_hole_driller(lth=72);
module drain_hole_driller(lth=30)
{
    rows = tray_lth/12;
    offset=12;
    drain_hole_d = 6;
    cols = round(inside_width/(offset+(drain_hole_d/2)));
    echo("raw column holes", cols);
 
    columns = cols % 2 ? (cols/2)+1:(cols/2);
    start = columns/2;
    echo("calculated columns", columns);
    for (x =[-start:columns-start+1])
        for (y =[1:rows])
        {
            translate([(offset*x)-drain_hole_d/2, -(lth/2)+offset*y, 0])
                cylinder(d=drain_hole_d,h =tray_wall*2, $fn=20);
        }
}

//rough_tray(lth=40);
module rough_tray(tray_width=tray_width, lth=tray_lth, tray_height=tray_height, z_offset=0)
{
    
    //hull()
    {
        translate([0,0,z_offset+(tray_height/2)])
            //scale([1,.5,1])
                //cylinder(d=tray_width, h=tray_height, $fn=120); 
            cube([tray_width,lth,tray_height], center=true);
        translate([0,lth/2, z_offset])
            scale([1,.5,1])
                cylinder(d=tray_width, h=tray_height, $fn=120);  
        }  
}
