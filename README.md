# Shower grab handle tray
This is a [openSCAD](https://openscad.org/) design to create an accessory that attaches to the grab handle in the cruise ship shower.

The tray stores things normally on the floor and it also has a loop to hang a razor.   
There are scad "lists" for mount and tray versions. 

All/most variables are global and should be easy to customize. 

There are two scad files one for generating [tray](src/universal_tray.scad)s the other for the [mount](src/universal_mounts.scad) part. 
They are interconnected with a shared [dovetail](src/dovetail.scad). 

### current mount stl files
#### [20mm](/src/stl/20mm_mount.stl) grab handle
As found on Grand Princess and Discovery Princess   
I expect it is a pretty standard grab handle.
####  [25x50mm](/src/stl/25mm_mount.stl) shower handle pole 
As found on Discovery Princess 
#### [25mm](/src/stl/25mm_mount.stl) grab handle
not found on cruise ships yet but sort of standard.
#### [32.5mm](/src/stl/32mm_mount.stl) curved shower handle pole
as found on Discovery Princess wheelchair cabins
#### easy to customize
and add other mounts as they are measured

### current tray versions
#### [soap dish](src/stl/tray_short.stl)
ridges to help soap dry
#### [small holder](/src/stl/tray_small.stl)
Holds small/travel bottles of products
#### [large holder](/src/stl/tray_large.stl)
This needes a large printer
#### modular trays [small](src/stl/tray_shortmount.stl) [soap](rc/stl/tray_soapmount.stl) [loop](src/stl/tray_loop.stl)
That can be plugged together multiple ways

#### also easy to add other sizes

## Prototype history/log
first version test.        
A single part.
This was for the curved handle found on all the ships so far. I had to guess on the diameter and made it too big so it was rather sloppy and I had to heat it up to make it work. Learned that it was 20mm not ~1 inch.

second version test.     
New 20mm mount that worked but too fat and tall. needs to be smaller. 
The razor loop needs to be enlarged.

third version test.      
Still a single part.
Version fits nice. A little leaning due to "curve" elongating the lower clamp.
This ship has more places for storage and the shower is on a 25mm pole on a 50mm pole.

forth version test. 
now connecting mounts to trays with a dovetail
two mounts: 20mm and 25x50mm. two trays a "small" and a "soap"   
mount 20mm with "soap" tray   
mount 25x50mm with "small" tray   
All worked fine noticed that trays could be adjusted about 2 degrees up they would level out. Soap dish worked fine but needs ribs for drying.

fifth version test.   
"Tee" post test. the first cabin was assisted care with a different bathroom. It needed a 25mm curved mount.Second cabin tested the "Tee" post mount. It worked ok but a bit large.dovetails need tightening. 

sixth version test.   
Quite saggy, mount needs improvement, also when all is assembled it is a bit too long.  the product tray is too narrow and should be made shorter and wider.  Soap dish needs loops on the sides.   











