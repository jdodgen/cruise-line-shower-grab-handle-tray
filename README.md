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
Handle diameter was estimated. it fit loose and required electrical tape to make it work. took mesurements.

second version test.     
Still a single part.
Nice fit on the pole but the base is too wide and had to be cut to fit. Razer did not fit. took measurments.

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

current version (5-JAN-2025).       
curve elongation problem is fixed by making lower clamp height changeable.    
Rounded sharp corners on the dovetail.    
Trays now are tilted up 2 degrees to level them out.    
Using less fillament, different shapes.   
"soap" now has ridges between the slots.
modular versions with dovetails on each end of the trays
A loop module is the terminator. check out the stl's
Also a feature to trim the base. 

27-feb-2025
current version is working good. the small and large trays could be wider up to 40mm more.









