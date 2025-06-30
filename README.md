# hard-tube-bending-jigs

## Printing

1. No infill: the walls are small and the tube groove must be smooth
2. Concentric top surface pattern: smooth bending surface
3. ABS or similar high temperature: avoid sticking to the tube

## Single Bends

Generate `.stl` with [openscad](https://openscad.org) or similar:

1. Set parameters in `single.scad`
2. Set `top = false`
3. Generate `bottom.stl`
4. Set `top = true`
5. Generate `top.stl`

Print with:

## TODO

* Remove top half of lip due to printing issues, merging skirt and lip radius into one
* Bolt holes: reduce height slightly to avoid the need to trim
* Move bolt holes to assistive bend centres
* Add variable angle to assistive bend. Likely requires removal of top.

