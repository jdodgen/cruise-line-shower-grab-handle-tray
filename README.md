# Shower grab handle tray
This is a [openSCAD](https://openscad.org/) design to create an accessory that attaches to the grab handle in the cruise ship shower.

The tray stores things normally on the floor and it also has a place to hang a female razor.   
The code defines scad lists for mount and tray additions as I add them

All/most variables are global and should be easy to customize. 

There are two scad files one for generating [tray](src/universal_tray.scad)s the other for the [mount](src/universal_mounts.scad) part. 
They are interconnected with a shared [dovetail](src/dovetail.scad). 

### current mount stl files
#### [20mm](/src/stl/20mm_mount.stl) grabhandle
As found on Grand Princess and Discovery Princess   
I expect it is a pretty standard grab handle.
####  [25x50mm](/src/stl/25mm_mount.stl) shower handle pole 
As found on Discovery Princess 
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
#### also easy to add other sizes




