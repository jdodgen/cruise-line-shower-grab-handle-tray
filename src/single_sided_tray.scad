/*
cruise line shower "grab handle" tray
MIT licence, copyright 2024 Jim Dodgen
This one was developed using grab handle on the "Grand Princess"
it has a 2cm diameter handle
This is the first style and only fits one way and must be built "mirrored" to go right
*/
use <rounded_loop.scad>;
use <fillet.scad>;
//use <grand_princess_shower_grab_bar.scad>;  // for testing
//
// typical stuff to change
postd = 20.5;   // handle diameter + some clearance     
wall_side_clamp_to_nut = 35;
add_loop = true;
drain_holes = true;
tray_type = "short"; // "short", "long" ,"soap", "test" (default render faster)
//
// Other things that are rarely changed
//
tray_width = 60;  // making this large will require some other changes
tray_holes_columns = 5;  // change this if changing tray_width

tray_wall = 3;

tray_lth = tray_type == "long" ? 192: 
    tray_type == "short" ? 120:
    tray_type == "soap" ? 85:30;
tray_holes_rows = tray_lth/12;

postd_wall =  postd/3;
postd_outside = postd + postd_wall;
razer_legs = 20;
razer_width = 24;
clamp_seperation = 60;   // space between post "clamps"
top_clamp_thickness = 20;
top_clamp_tab_lth = 8;
bottom_clamp_thickness = 60;

tray_height = 58;

total_height = clamp_seperation+top_clamp_thickness+bottom_clamp_thickness;
make_groove=true;
groove_depth=1.5;
groove_thickness = 8.2;
round_radius=4;

curve_offset = bottom_clamp_thickness*0.25; //*.4;

//color("silver") translate([0,0,curve_offset]) make_handle(); // used during testing  
//mirror([0,180,0]) // this flips to left side of handle
   make_it();
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
                    post_hook(thickness=total_height);
                    translate([-wall_side_clamp_to_nut+tray_width/2,
                            0,0]) 
                        tray(tray_width=tray_width, lth=tray_lth, 
                            tray_height=tray_height, wall=tray_wall);
                    wall_side_clamp();
                    
                }
                center_cutout();
                slant_cutout();
                cut_off_lower_mount_half();
                cut_off_upper_mount_half();
                drill_post_hole();
                round_inner_side();
                round_outer_side();
            } 
        }
        translate([0,0,curve_offset]) cut_curve();
    }
    tab_extention();
}

module drill_post_hole()
{
    color("red") 
    translate([0,0,-total_height/2]) 
        cylinder(d=postd, h=total_height*2, $fn=120); 
}



//round_inner_side();

module round_inner_side()
{
    lth=clamp_seperation+top_clamp_thickness;
    translate([postd/2,(postd_outside/2)-round_radius,
            bottom_clamp_thickness])
        fillet(270, round_radius, lth+round_radius, $fn=40);
    
}

//round_outer_side();

module round_outer_side()
{
    lth=total_height-top_clamp_thickness;
    translate([postd/2,-(postd_outside/2),
            0])
        fillet(0, round_radius, lth, $fn=40);
    
}
module cut_off_lower_mount_half()
{
    lower_mount_cut_y = 100;
    color("green") 
    translate([0,-lower_mount_cut_y/2,
        -100/2+bottom_clamp_thickness])
        cube([postd, lower_mount_cut_y, 100],
            center=true); 
}

module cut_off_upper_mount_half()
{
    color("orange") 
    translate([-postd_wall/2, postd_outside/2,
                (total_height-top_clamp_thickness/2)])
        cube([postd_outside, postd_outside, top_clamp_thickness],
                        center=true);
}
//tab_extention();
module tab_extention()
{
    length = (postd_outside/2)-(postd_wall);
    translate([-(postd/2)-(postd_wall/4), length/2,
                (total_height-top_clamp_thickness/2)])
    {
        cube([postd_wall/2,length,top_clamp_thickness],
            center=true);
        translate([0,length/2,-top_clamp_thickness/2])
            cylinder(d=postd_wall/2, h=top_clamp_thickness, $fn=60);
    }
}
//color("red") center_cutout();
module center_cutout()
{
    cutout_height = total_height - top_clamp_thickness-bottom_clamp_thickness;
    translate([-postd_wall/2,0,bottom_clamp_thickness]) // cutout
        translate([0,0,cutout_height/2]) // move cube up
            cube([postd_outside, postd_outside, 
                                cutout_height], center=true);
}

//cut_curve();
module cut_curve()
{   
    translate([0,0,postd*1.5])   {
        postr = postd/2;
        x=4*postr;
        difference()
        {
        union()
         {   
        translate([-x, 0, postd/2]) 
        //hull()

            rotate([-90,90,0])
                rotate_extrude(convexity = 10,angle=-90, $fn = 120)
                    translate([x, 0, 0])
                    rotate([0,0,-90]) 
                    hull()
                    {
                        circle(d = postd,, $fn=120);
                        translate([0,30,0])
                            circle(d = postd,, $fn=120);
                    } 

        // this is in a loop to remove the lumps left behind
        // when done only once 
        translate([0,0,-(postd+postr)]) //-postd/2+adjust])
            rotate([-90,90,90])
            {
                cylinder(d=postd, h=total_height, $fn=120);
                translate([0,-postd/2,0]) 
                    cube([total_height,postd,total_height]);
            }
        } 
         translate([50,0,0])  cube([100,100,200], center=true);
        }
       
    }   
}

//wall_side_clamp();
module wall_side_clamp()
{
    wall_side_clamp_lth=postd_outside;
    fatRadius = round_radius*2;
    overall_lth = wall_side_clamp_lth+fatRadius;
    translate([-wall_side_clamp_to_nut/2,-round_radius,bottom_clamp_thickness/2])
    difference()
    {
        cube([wall_side_clamp_to_nut, overall_lth,
                bottom_clamp_thickness], center=true);
        // wall side
        translate([-wall_side_clamp_to_nut/2,
        -(overall_lth)/2,-bottom_clamp_thickness/2])
            fillet(0, fatRadius, bottom_clamp_thickness, $fn=40);
        // post side
        translate([(wall_side_clamp_to_nut/2)-fatRadius-(postd/2),
        -(overall_lth)/2,-bottom_clamp_thickness/2])
            fillet(90, fatRadius, bottom_clamp_thickness, $fn=40);
        
        // tray side
        if (tray_height < bottom_clamp_thickness)
        {
            translate([-wall_side_clamp_to_nut/2,
                overall_lth/2-round_radius,
                bottom_clamp_thickness/2])
            rotate([0,90,0])
               fillet(270, round_radius, wall_side_clamp_to_nut, $fn=40);   
}

    }
}

//color("red") slant_cutout();
module slant_cutout()
{
    fudge=4;
    translate([0,0,5])
    difference()
    {
        rotate([0,-7,0])
        {
            translate([(postd_outside/2)+fudge,0,
                bottom_clamp_thickness+groove_thickness])
            {
                //translate([0,0,tray_height])
                    outerd = postd_outside*2+20; 
                    difference()
                    {
                        cylinder(d=outerd, 
                            h=clamp_seperation*2,
                            $fn=120); 
                        cylinder(d=postd_outside+10,
                             h=clamp_seperation*2,
                            $fn=120);
                        translate([-outerd/2,0,50]) 
                            cube([outerd, postd_outside*3,200], 
                                center=true);
                    }
            }
        }
        translate([0,0,-50+bottom_clamp_thickness]) 
          cube([200,200,100], center=true);
    }
}

//top_post_hook_tab();
module top_post_hook_tab()  // make hook a bit longer
{
    translate([(-postd_outside/2)+(postd_wall/4), top_clamp_tab_lth/2,
                            (total_height-top_clamp_thickness/2)])
    {
        cube_lth = top_clamp_tab_lth-postd_wall/2;
        cube([postd_wall/2,cube_lth,
            top_clamp_thickness],
            center=true);
        translate([0,cube_lth/2,-top_clamp_thickness/2])
            cylinder(d=postd_wall/2, h=top_clamp_thickness, $fn=60);
    }
    
}

// post_hook(thickness=total_height);
module post_hook(thickness=top_clamp_thickness)
{
    translate([0,0,0])
    { 
        difference()
        {
            cylinder(d=postd_outside, h=thickness, $fn=120);
            tie_groove();
        }
        translate([postd_outside/2,0,0])
            difference()
            {
                cylinder(d=postd_outside, h=thickness, $fn=120);
                tie_groove();
            }
    
            difference()
            {
                translate([postd_outside/2/2,0,thickness/2])
                    color("blue") 
                        cube([postd_outside/2,postd_outside,
                                thickness], center=true);
                translate([postd_outside/2/2,0,0])
                    color("purple") tie_groove(type="cube");
            }
        
   } 
}

//tie_groove();
module tie_groove(type="cyl", groove_depth = groove_depth)
{
    if (make_groove == true)
   { 
       if (type == "cyl")
       {
           translate([0,0,bottom_clamp_thickness])
           difference()
           {  
               cylinder(d=postd_outside, h=groove_thickness, $fn=120);
               cylinder(d=postd_outside-groove_depth,
                    h=groove_thickness,
                    $fn=120);
           }
       }
       else
       {
           translate([0,-postd_outside/2,
                bottom_clamp_thickness+groove_thickness/2])
               cube([postd_outside,groove_depth,groove_thickness],
                    center=true);
           translate([0,postd_outside/2,
                bottom_clamp_thickness+groove_thickness/2])
               cube([postd_outside,groove_depth,groove_thickness],
                    center=true);
       }
   } 
    
}

module tray(tray_width=tray_width, lth=tray_lth, tray_height=tray_height, wall=tray_wall)
{
    translate([0,postd/2,0])
    {
        difference()
        {
            union()
            {
                rough_tray(tray_width=tray_width, lth=lth, tray_height=tray_height, z_offset=0);
                if (add_loop ==  true)  // testing
                {
                    translate([0,lth+10+razer_legs,tray_height-5])
                        round_loop(r=3, base=1.8, lth=razer_width-7, 
                            legs=razer_legs, curved_end=false);
                }
                
            }
            translate([-150,0,tray_height]) // trim top of tray
                cube([300,300,100]);
            translate([0,wall/2,0])
            {
                rough_tray(tray_width=tray_width-wall, lth=lth-wall, 
                    tray_height=tray_height-wall, z_offset=wall);
            }
            offset= 12;
            drain_hole_d = 6;
            if (drain_holes == true)
            {
                for (x =[-2:tray_holes_columns-2])
                for (y =[1:tray_holes_rows])
                {
                    translate([offset*x,offset*y,0])
                        cylinder(d=drain_hole_d,h =wall*2, $fn=20);
                }
            }
        }
        filler_block_y=10;
        filler_offset_y = 2;
        translate([0,filler_offset_y,tray_height/2]) 
            cube([tray_width,filler_block_y,tray_height], center=true); 
        translate([-tray_width/2+wall/2,filler_offset_y+filler_block_y/2,0]) 
            fillet(0, round_radius, tray_height, $fn=40);
        translate([tray_width/2-round_radius-wall/2,
            filler_offset_y+filler_block_y/2, 0]) 
                fillet(90, round_radius, tray_height, $fn=40);
    }
}

//rough_tray();
module rough_tray(tray_width=tray_width, lth=tray_lth, tray_height=tray_height, z_offset=0)
{
    
    hull()
    {
        translate([-tray_width/2,0,z_offset])
            cube([tray_width,tray_width,tray_height]);
        translate([0,lth,z_offset])
            scale([1,.5,1])
                cylinder(d=tray_width, h=tray_height, $fn=120);  
        }  
}