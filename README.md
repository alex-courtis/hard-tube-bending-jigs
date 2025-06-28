# hard-tube-bending-jigs

## Single Bends

Generate `.stl` with [openscad](https://openscad.org) or similar:

1. Set parameters in `single.scad`
2. Set `top = false`
3. Generate `bottom.stl`
4. Set `top = true`
5. Generate `top.stl`

Print with:
1. No infill: the walls are small and the tube groove must be smooth
2. Concentric top surface pattern: smooth bending surface
3. ABS or similar high temperature: avoid sticking to the tube

