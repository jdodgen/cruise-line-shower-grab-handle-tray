/*
cruise line shower "grab handle" tray
MIT licence, copyright 2024 Jim Dodgen
both:
20mm shower grab handle on the "Grand Princess", Discovery Princess, as well as most others.
royal class ships have a "shower head post" 25mm teed into 50mm round stub.
they are all can be used right or left of the post and lock on as to not piviot
The tray can be any lenght that you can print. It has a loop at the end for things like razors
*/
use <rounded_loop.scad>;
use <fillet.scad>;
//use <grand_princess_shower_grab_bar.scad>;  // for testing
//
tray_type = "soap"; // "short", "long" ,"soap", "test" (default render faster)
shower_post = true; // false for grab 20mm grab handle true for 25mm/50mm shower post
make_it();
// typical stuff to change
vert_handle_d = shower_post == true ? 25+0.9 : 20+0.8;  // handle diameter + some clearance  
horz_handle_d = shower_post == true ? 50 + 1.2 : vert_handle_d;
center_bar_to_nut = horz_handle_d+8; //center_bar_to_nut(); //  38;
echo("center_bar_to_nut", center_bar_to_nut);
add_loop = true;
drain_holes = true;

//
// Other things that are rarely changed
//
nut_clearance = 12;

top_d_outside = vert_handle_d*1.4;
scale_vert_handle_d_outside = 1 ;  // squeeze ratio
echo("vert_handle_d_outside", vert_handle_d_outside);
razer_legs = 20;
razer_width = 24;
clamp_seperation = 50;   // space between post "clamps"
top_clamp_thickness = 20;
top_clamp_tab_lth = 8;
bottom_clamp_thickness = 30;
total_height = clamp_seperation+top_clamp_thickness+bottom_clamp_thickness;
center_cutout_height = total_height - top_clamp_thickness-bottom_clamp_thickness;
height_to_top_clamp = center_cutout_height+bottom_clamp_thickness; 
inside_width = 72;
tray_wall = 3;
tray_width = inside_width + tray_wall*2;  
// tray_holes_columns = 5;  // change this if changing tray_width
vert_handle_d_outside = shower_post == false ? (center_bar_to_nut*2) - nut_clearance:tray_width*0.9;
top_handle_mount_adj = shower_post == false ? 1 : 0.8;
tray_lth = tray_type == "long" 
        ? 192: 
    tray_type == "short" ? 120:
    tray_type == "soap" ? 85:30;

tray_height = tray_type == "soap" ?  15: bottom_clamp_thickness;



make_groove=true;
groove_depth=1.5;
groove_thickness = 8.2;
round_radius=4;

curve_offset = bottom_clamp_thickness*0.3; //*.4;

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
                        tray();
                }
                // center_cutout();
                // cut_off_lower_mount_half();
                cut_off_upper_mount_half();
                drill_post_hole();            
            } 
        }
        if (shower_post == true)
        {
            cut_fat_base();
        }
        else
        {
            translate([0,0,curve_offset])
           {
               cut_handle_curve();
               mirror([1,0,0]) 
               translate([-0,0,0]) 
                cut_handle_curve();
           }
        }
    }
}

testing_drill_post_hole = false; 
if (testing_drill_post_hole)
    difference(0)
    {
        cylinder(d=vert_handle_d+7,h=10, $fn=120);
        drill_post_hole();
    }
//color("red") drill_post_hole();
module drill_post_hole()
{
    color("red") 
    translate([0,0,-total_height/2]) 
        cylinder(d=vert_handle_d, h=total_height*2, $fn=120); 
}

//color("red") cut_off_lower_mount_half();
module cut_off_lower_mount_half()
{
    translate([0,-height_to_top_clamp/2,height_to_top_clamp/2])
        cube([vert_handle_d, height_to_top_clamp, height_to_top_clamp],
            center=true); 
}

module cut_off_upper_mount_half()
{
    block_size = 100;
    translate([0, block_size/2,
                (total_height-top_clamp_thickness/2)])
        cube([vert_handle_d, block_size, top_clamp_thickness],
                        center=true);
}
//color("red") center_cutout();
module center_cutout()
{
    translate([-(vert_handle_d_outside/2)+(vert_handle_d/2),0,bottom_clamp_thickness]) // cutout
        translate([0,0,center_cutout_height/2]) // move cube up
            cube([vert_handle_d_outside, vert_handle_d_outside, 
                                center_cutout_height], center=true);
}

//color("red") cut_fat_base();
module cut_fat_base()
{
    color("orange")
    translate([total_height/2,0,0]) //-vert_handle_d/2+adjust])
    rotate([-90,90,90])
    {
        cylinder(d=horz_handle_d, h=total_height, $fn=120);
        translate([0,-(horz_handle_d/2)-0.25,0]) 
            cube([total_height,horz_handle_d+0.5,total_height]);
    }
} 
//cut_handle_curve();
module cut_handle_curve()
{   
    postr = vert_handle_d/2;
    translate([0,0,vert_handle_d]) //vert_handle_d*1.5])
    {
        x=4*postr;
        difference()
        {
            union()
            { 
            color("orange")  
            translate([-x, 0, vert_handle_d/2]) 
                rotate([-90,90,0])
                    rotate_extrude(convexity = 10,angle=-90, $fn = 120)
                        translate([x, 0, 0])
                        rotate([0,0,-90]) 
                        hull()
                        {
                            circle(d = vert_handle_d,, $fn=120);
                            translate([0,30,0])
                                circle(d = vert_handle_d,, $fn=120);
                        } 
            color("blue")
            translate([0,0,-(vert_handle_d+postr)]) //-vert_handle_d/2+adjust])
                rotate([-90,90,90])
                {
                    cylinder(d=vert_handle_d+0.5, h=total_height, $fn=120);
                    translate([0,-(vert_handle_d/2)-0.25,0]) 
                        cube([total_height,vert_handle_d+0.5,total_height]);
                }
            } 
         translate([50,0,0])  cube([100,100,200], center=true);
        } 
    }   
}
//mount_support();
module mount_support()
{
    base_y = 5;
    offset_y = -vert_handle_d/3;
    support_height = height_to_top_clamp;
    vert_x = vert_handle_d-6;
    x_side = 20;
    *translate([0,offset_y,base_y/2]) 
        cube([vert_handle_d_outside,horz_handle_d/2,base_y], center=true);
    translate([0,offset_y,height_to_top_clamp/2]) 
        cube([vert_x, horz_handle_d/2,support_height], center=true);
   translate([-x_side/2-vert_x/2, offset_y+10, support_height-horz_handle_d/4])
   { 
        difference()
       {
            translate([6,0,-horz_handle_d/4]) 
                cylinder(d=horz_handle_d/2+5, h=horz_handle_d/2);
            //cube([x_side, horz_handle_d/2,horz_handle_d/2], center=true);
            rotate([45,0,0])   
           
           translate([0,0,-50]) cube([x_side,100,100], center=true);
       }
   }

}

// handle_mount();
module handle_mount(vert_handle_d_outside=vert_handle_d_outside, 
        top_d_outside=top_d_outside, total_height=total_height,sphere_scale=0.3)
{
    // scale([1,scale_vert_handle_d_outside,1])
    curve_height = top_d_outside*sphere_scale;
    difference()
    {
        union()
        {
        difference()
        {
        union()
            {  
                color("white") cylinder(d=vert_handle_d_outside,
                    h=bottom_clamp_thickness, $fn=120);
                
                translate([0,0,bottom_clamp_thickness])
                    color("green") cylinder(d1=vert_handle_d_outside*top_handle_mount_adj,
                                d2=top_d_outside, 
                                h=total_height-bottom_clamp_thickness-curve_height,
                                    $fn=120);
                translate([0,0,total_height-curve_height])
                    scale([1,1,sphere_scale])
                    sphere(d=top_d_outside, $fn=120);                        
             }
        center_cutout();
     }
        translate([0,0,bottom_clamp_thickness])
            scale([1,1,sphere_scale])
            sphere(d=vert_handle_d_outside, $fn=120);
    }
cut_off_lower_mount_half();
} 

}

//tray();

module tray(tray_width=tray_width, tray_lth=tray_lth, tray_height=tray_height, wall=tray_wall)
{
    if (tray_type == "test")
    {
    }
    else
    {
    filler_block_y=10;
    translate([0,tray_lth/2+filler_block_y+horz_handle_d/2-2,0])// vert_handle_d_outside
    {
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
                    drain_hole_driller(lth=tray_lth);
                }
            } // end inner diff
             // this is the attachment to the handle_mount
            filler_block_x=vert_handle_d_outside*0.9;
            translate([0,-(filler_block_y/2)-(tray_lth/2),tray_height/2]) 
                cube([filler_block_x,filler_block_y,tray_height],
                        center=true); 
            // inside corners
            translate([-tray_width/2+wall/2,-tray_lth/2+wall/2,
                    0]) 
                fillet(0, round_radius, tray_height, $fn=40);
            translate([tray_width/2-round_radius-wall/2,
                -tray_lth/2+wall/2, 0]) 
                    fillet(90, round_radius, tray_height, $fn=40);
        } // end union
            translate([-tray_width/2,-tray_lth/2,
                    0]) 
                fillet(0, round_radius, tray_height, $fn=40);
            
            translate([tray_width/2-round_radius,
                -tray_lth/2, 0]) 
                    fillet(90, round_radius, tray_height, $fn=40);
        
    }
} 
}
    
}

//drain_hole_driller();
module drain_hole_driller(lth=tray_lth)
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
    //for (x =[-start:columns-start+1])
        
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
