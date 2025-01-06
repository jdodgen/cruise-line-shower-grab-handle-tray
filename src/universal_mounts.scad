/*
cruise line shower "grab handle" mount 
MIT license, copyright 2024, 2025 Jim Dodgen
*/
use <fillet.scad>;
use <dovetail.scad>;
mount_type = "25x50mm"; // "20mm" "25mm" "32mm" "25x50mm"
make_mount();
//full_curve_cutout();  // test curve cutout used to set curved_y_offset

//clamp_seperation needs to be at least vert_handle_d+clearance
/* version list is:[
        0   vert_handle_d, // note: add a clearance value
        1   horz_handle_d, 
        2   curved mount // true/false, 
        3   base_diameter_adjustment,
        4   bottom_clamp_thickness,
        5   clamp_seperation,
        6   dovetail_height_factor  // used to shorten it
        7   trim      // trims x sharp parts
        8   manual alignment of extruded curve to straight tube
            ]
*/
//                              curved         clamp
// current mounts: 0        1      2     3   4   5    6      7     8
20mmGrab =      [20+0.8, 20+0.8, true,  27, 35, 22, 1.0, false, -5.3]; // grab bar 20mm x 20mm with curved mount
25x50mmShower = [25+1,     50+2, false, 23, 30, 28, 0.85, 0.65, 0]; // shower head bar 25mm x 50mm tee mount
32mmShower =    [32.5+2, 32.5+2, true,  40, 60, 40, 0.8, false, 0]; // curved shower head bar (wheelchair) cabin about 1.25 inches
25mmGrab=       [25+1,   25+1,   true,  36, 50, 27, 1.0, false, -6]; // pretty common curved metric grab bar about 1 inch

this_one = mount_type ==  "20mm"    ? 20mmGrab :
           mount_type ==  "25x50mm" ? 25x50mmShower :
           mount_type ==  "25mm"    ? 25mmGrab :
           mount_type ==  "32mm"    ? 32mmShower : false;
                
vert_handle_d =            this_one[0]; 
horz_handle_d =            this_one[1];
curved_mount =             this_one[2];
base_diameter_adjustment = this_one[3]; 
bottom_clamp_thickness =   this_one[4];
clamp_seperation =         this_one[5];
dovetail_height_factor =   this_one[6];
trim =                     this_one[7];
curved_y_offset =          this_one[8];

//
// Other things that are rarely changed
//
vert_handle_d_outside = horz_handle_d+base_diameter_adjustment;
lower_dome_height = 6;
top_clamp_thickness = 8;
top_clamp_tab_lth = 8;
total_height = clamp_seperation+lower_dome_height+top_clamp_thickness+bottom_clamp_thickness;
center_cutout_height = total_height - top_clamp_thickness-bottom_clamp_thickness;
height_to_top_clamp = center_cutout_height+bottom_clamp_thickness;

// 50 = 1.5 20 = 2.2 horz_handle_d
//vert_handle_d_outside = horz_handle_d+28;  // horz is larger or equal, 2.? is just a guess
echo("horz_handle_d", horz_handle_d);
echo("vert_handle_d_outside", vert_handle_d_outside);
top_handle_mount_adj = 0.8; //0.8; 

top_d_outside = vert_handle_d*1.4;
mid_d_outside = top_d_outside*1.2;
echo("top_d_outside", top_d_outside);
echo("mid_d_outside", mid_d_outside);

curve_offset = bottom_clamp_thickness*0.4; //*.4;
dove_base = 2;  // keeps tray from falling
dove_mount_offset = 2; // adds some material between horz part
//
// logic below
//
module make_mount()
{

    union()
    {         
        difference()
        {
            union()
            {
                difference()
                {
                    handle_mount();
                    cut_off_upper_mount_half();
                    drill_post_hole();
                    cutoff_dove_mount();
                }
            }
            if (curved_mount == false)
            {
                teed_base();
            }
            else // this allows for mount to follow curved handles
            {
               translate([0,0,curve_offset])
                   full_curve_cutout();
            }
        }
        mount_dovetail();
    }   
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
//cut_off_upper_mount_half();
module cut_off_upper_mount_half()
{
    block_size = 100;
    cutout_height = top_clamp_thickness*3;
    translate([0, block_size/2,
                (total_height)])
        cube([vert_handle_d, block_size, cutout_height],
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
//color("red") cutoff_dove_mount();
module cutoff_dove_mount()
{
    big_cube = 100;
    translate([0, big_cube/2+horz_handle_d/2+dove_mount_offset ,big_cube/2+dove_base])
        cube([big_cube,big_cube,big_cube], center=true);
}

//color("red") teed_base();
module teed_base()
{
    cutout_width = vert_handle_d_outside+20;
    translate([cutout_width/2,0,0]) //-vert_handle_d/2+adjust])
    rotate([-90,90,90])
    {
        cylinder(d=horz_handle_d, h=cutout_width, $fn=120);
        translate([0,-(horz_handle_d/2)-0.25,0])
            cube([total_height,horz_handle_d+0.5,cutout_width]);
    }
}
// full_curve_cutout();
module full_curve_cutout(curved_y_offset=curved_y_offset)
{
    cut_handle_curve(curved_y_offset=curved_y_offset);
    rotate([0,0,180]) cut_handle_curve(curved_y_offset=curved_y_offset);
}

//cut_handle_curve();
module cut_handle_curve(curved_y_offset=curved_y_offset)
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
            translate([-x, 0, vert_handle_d/4])
                rotate([-90,90,0])
                    rotate_extrude(convexity = 10,angle=-90, $fn = 120)
                        translate([x, 0, 0])
                        rotate([0,0,-90])
                        hull()
                        {
                            circle(d = vert_handle_d, $fn=120);
                            translate([0,30,0])
                                circle(d = vert_handle_d, $fn=120);
                        }
            color("blue")
            translate([0,0,-(vert_handle_d+postr)+curved_y_offset]) //-vert_handle_d/2+adjust])
                rotate([-90,90,90])
                {
                    translate([0,0,-250]) cylinder(d=vert_handle_d+0.5, h=500, $fn=120);
                    translate([0,-(vert_handle_d/2)-0.25,-250])
                        cube([total_height,vert_handle_d+0.5,500]);
                }
            }
         translate([250,0,-80])  color("green") cube([500,100,200], center=true);
        }
    }
}

//handle_mount();
module handle_mount(vert_handle_d_outside=vert_handle_d_outside,
        top_d_outside=top_d_outside, total_height=total_height,sphere_scale=0.3,bottom_clamp_thickness=bottom_clamp_thickness, vert_handle_d=vert_handle_d)
{
    // three parts
    //
    bottom_h = vert_handle_d*0.8;
    mid_h = bottom_clamp_thickness -  bottom_h;
    top_h = total_height - bottom_clamp_thickness;
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
                            h=bottom_h, $fn=120);
                        translate([0,0,bottom_h])
                            color("purple") cylinder(
                                    d1=vert_handle_d_outside,
                                    d2=mid_d_outside,
                                    h=mid_h,
                                    $fn=120);
                        translate([0,0,bottom_clamp_thickness])
                            color("orange") cylinder(
                                    d1=mid_d_outside,
                                    d2=top_d_outside,
                                    h=top_h,
                                    $fn=120);
                        translate([0,0,total_height])
                            scale([1,1,sphere_scale])
                            sphere(d=top_d_outside, $fn=120);
                    }
                center_cutout();
            }
            translate([0,0,bottom_clamp_thickness])
                scale([1,1,sphere_scale])
                sphere(d=mid_d_outside, $fn=120);
       }
       cut_off_lower_mount_half();
       if (trim)
       {
           echo("trim", trim);
           offset = vert_handle_d_outside/2*trim;
           translate([offset,-vert_handle_d_outside/2,0])
             cube([vert_handle_d_outside,vert_handle_d_outside,total_height]);
           translate([-vert_handle_d_outside-offset,-vert_handle_d_outside/2,0])
             cube([vert_handle_d_outside,vert_handle_d_outside,total_height]);
       }
   }
}

//translate([0,0,0]) mount_dovetail();
module mount_dovetail()
{
    translate([0,dove_mount_offset+horz_handle_d/2,0])
    color("blue")
        dovetail(height=bottom_clamp_thickness*dovetail_height_factor);
}