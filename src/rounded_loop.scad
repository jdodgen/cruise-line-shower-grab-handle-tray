// rounded loop handle
// Jim Dodgen 2019, 2022 jim@dodgen.us
// released to the public domain.

//round_loop(r=5, $fn=80, curved_end=true);
//round_loop(r=8,lth=1,legs=3, curved_end=true, $fn=80);
//clip_loop(legs=10);

//clip_loop(legs=4, base=1.8, y_scale=1.5, curved_end=false, rounded_end=false);

module clip_loop(legs=4, base=1.8, y_scale=1.5, curved_end=false, rounded_end=false) {
	wide_enough_for_clip=8;
	thick_enough_for_clip=1.4;
	scale([1,1,y_scale]) 
		round_loop(r=thick_enough_for_clip, lth=wide_enough_for_clip, base=base, legs=legs, curved_end=curved_end, rounded_end=rounded_end, $fn=80);
}

//round_loop(r=3, lth=8,legs=2, base=1, curved_end=true);
module round_loop(r=20, lth=40, legs=20, base=1, curved_end=false, rounded_end=false, $fn=80) {
    translate([-lth/2,0,0])
    {
        //left
        translate([lth,0,0])
        {
            rotate_extrude(convexity = 10,angle=90)
                        translate([3*r, 0, 0])
                        circle(r = r);            
            translate([r+r*2,0,0])  // leg
                rotate([90,0,0])
                cylinder(r1=r,r2=r*base,h=legs);
            if (curved_end == true) {
              // curved end
              translate([r*6,-legs,0])
              rotate([0,0,180]) {
              rotate_extrude(angle=90)
                          translate([3*r, 0, 0])
                          circle(r = r*base);
                        }
             }   
             if (rounded_end == true) {
              // rounded end
              translate([r+r*2,-legs,0])
                sphere(r=r*base);
            }
        }
        //center
        translate([0,r+r*2,0])
            rotate([90,0,90])
            cylinder(r=r,h=lth);
        //right

        rotate([0,180,0]) {
            rotate_extrude(convexity = 10,angle=90)
                translate([3*r, 0, 0])
                circle(r = r);
            translate([r+r*2,0,0])  //leg
                rotate([90,0,0])
                cylinder(r1=r,r2=r*base,h=legs);
            if (curved_end == true) {
              // curved end
              translate([r*6,-legs,0])
              rotate([0,0,-180]) {
              rotate_extrude(convexity = 10,angle=90)
                          translate([3*r, 0, 0])
                          circle(r = r*base);
                        }
			 }
             if (rounded_end == true) {
              // rounded end
              translate([r+r*2,-legs,0])
                sphere(r=r*base);
             }
        }
    }
}
