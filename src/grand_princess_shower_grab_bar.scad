//   grand princess shower grab bar
//  thus is for testing tray.scad

postd = 20;
total_height = 300-postd*2;
echo("total bar height",total_height);
from_wall= 64;
big_plate = 70;
big_plate_thickness = 15;
nut= 33;
nut_thickness = 27;
echo("calculated bar to nut", 
    from_wall-nut_thickness);
outside_bar_to_nut = 48;
center_bar_to_nut = outside_bar_to_nut - (postd/2);
echo("measured center_bar_to_nut", center_bar_to_nut);

fudge=0; //-27;
make_top_curve = false;
translate([0,15,0]) make_handle();

module make_handle()
{
    translate([0,0,postd])
    {
        bar();
        translate ([-from_wall,0,-postd+fudge]) 
            rotate([0,90,0])
                    mount();
    }
}
//translate([0,postd,0])bar();
module bar()
{
    translate([0,0,postd])
    {
        cylinder(d=postd, h=total_height, $fn = 120);
        color("blue") 
            curve();
        if (make_top_curve == true)
        {
            color("blue") 
                translate([0,0,total_height]) 
                    rotate([180,0,0]) 
                        curve();
        }
    }
}
//mount();
module mount()
{
    difference()
    {
        union()
        {
            cylinder(d= big_plate, h=big_plate_thickness, $fn = 120);
            cylinder(d= nut, h=nut_thickness, $fn = 20);
        }
        cylinder(d=postd, h=total_height, $fn = 120);
    }
        
}

module curve()
{
    {
        //cylinder(d=postd, h=total_height*2); // hole 
        adjust =  0;
        translate([-postd*2.0,0,0])
            rotate([-90,90,0])
                rotate_extrude(convexity = 10,angle=-90, $fn = 120)
                    translate([4*postd/2, 0, 0])
                        circle(r = postd/2,, $fn=120);
       translate([-postd*2,0,-postd*2])
            rotate([-90,90,90])
                cylinder(d=postd, h=from_wall-postd, $fn=120); 
    }   
}
