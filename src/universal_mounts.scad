/*
cruise line shower "grab handle" tray
MIT licence, copyright 2024 Jim Dodgen
both:
20mm shower grab handle on the "Grand Princess", Discovery Princess, as well as most others.
royal class ships have a "shower head post" 25mm teed into 50mm round stub.
they are all can be used right or left of the post and lock on as to not piviot
The tray can be any lenght that you can print. It has a loop at the end for things like razors.
*/
use <fillet.scad>;
use <dovetail.scad>;

make_mount();

// typical stuff to change
vert_handle_d = 25+1; // 25+1;  // normal 20mm + 0.8 some 25mm + 1 
horz_handle_d = 50+2; //50+2;
curved_mount = horz_handle_d == vert_handle_d ? true : false; 

//
// Other things that are rarely changed
//
clamp_seperation = 50;   // space between post "clamps"
top_clamp_thickness = 20;
top_clamp_tab_lth = 8;
bottom_clamp_thickness = 30;
total_height = clamp_seperation+top_clamp_thickness+bottom_clamp_thickness;
center_cutout_height = total_height - top_clamp_thickness-bottom_clamp_thickness;
height_to_top_clamp = center_cutout_height+bottom_clamp_thickness;

// 50 = 1.5 20 = 2.2 horz_handle_d
vert_handle_d_outside = horz_handle_d+28;  // horz is larger or equal, 2.? is just a guess
echo("horz_handle_d", horz_handle_d);
echo("vert_handle_d_outside", vert_handle_d_outside);
top_handle_mount_adj = 0.8; //0.8; 

top_d_outside = vert_handle_d*1.4;
mid_d_outside = top_d_outside*1.6;
echo("top_d_outside", top_d_outside);
echo("mid_d_outside", mid_d_outside);

curve_offset = bottom_clamp_thickness*0.3; //*.4;
dove_base = 2;  // keeps tray from falling
dove_mount_offset = 2; // adds some material between horz part
//
// logic below
//
module make_mount()
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
           {
               cut_handle_curve();
               mirror([1,0,0])
               translate([-0,0,0])
                cut_handle_curve();
           }
        }
    }
    mount_dovetail();
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

module cutoff_dove_mount()
{
    big_cube = 100;
    translate([0, big_cube/2+horz_handle_d/2+dove_mount_offset ,big_cube/2+dove_base])
        cube([big_cube,big_cube,big_cube], center=true);
}

//color("red") teed_base();
module teed_base()
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
                            circle(d = vert_handle_d, $fn=120);
                            translate([0,30,0])
                                circle(d = vert_handle_d, $fn=120);
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
////mount_support();
//module mount_support()
//{
//    base_y = 5;
//    offset_y = -vert_handle_d/3;
//    support_height = height_to_top_clamp;
//    vert_x = vert_handle_d-6;
//    x_side = 20;
//    *translate([0,offset_y,base_y/2])
//        cube([vert_handle_d_outside,horz_handle_d/2,base_y], center=true);
//    translate([0,offset_y,height_to_top_clamp/2])
//        cube([vert_x, horz_handle_d/2,support_height], center=true);
//   translate([-x_side/2-vert_x/2, offset_y+10, support_height-horz_handle_d/4])
//   {
//        difference()
//       {
//            translate([6,0,-horz_handle_d/4])
//                cylinder(d=horz_handle_d/2+5, h=horz_handle_d/2);
//            //cube([x_side, horz_handle_d/2,horz_handle_d/2], center=true);
//            rotate([45,0,0])
//
//           translate([0,0,-50]) cube([x_side,100,100], center=true);
//       }
//   }
//
//}

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
                    color("green") cylinder(
                            d1=mid_d_outside,
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

//translate([0,0,0]) mount_dovetail();
module mount_dovetail()
{
    translate([0,dove_mount_offset+horz_handle_d/2,0])
    color("blue")
        dovetail(height=bottom_clamp_thickness);
}