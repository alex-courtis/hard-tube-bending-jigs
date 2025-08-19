part = "single"; // ["single", "double"]

// global
$fn = 200; // [0:1:1000]

// outer
tube_radius = 8; // [4:1:10]

// to tube centre
bend_radius = 20; // [10:0.01:100]

// of tube, left to right
bend_angle = [60, 120]; // [-180:1:180]

// distance between centres of bends, left to right
straight_l = [80, 70, 90]; // [10:1:1000]

// skirt, top and sides thickness, lip radii
wall_width = 1.6; // [0:0.1:5]

// of tube radius in addition to bend_radius
skirt_radius_multiplier = 2; // [1:0.1:3]

// default M3
bolt_diameter = 3; // [2:0.1:10]

// bolt hole size multiplier
bolt_radius_multiplier = 1.02; // [0:0.01:2]

// optional bolt head inset
bolt_inset_diameter = 6; // [0:0.1:10]

// optional bolt head inset
bolt_inset_depth = 2.5; // [0:0.1:10]

// default M3
nut_width = 5.5; // [1:0.1:10]

// nut hole width multiplier
nut_inset_multiplier = 1.03; // [1:0.01:2]

// nut depth, default M3
nut_depth = 4.5; // [0:0.1:20]

// above channel, applied to wall width
flange_height_multiplier = 0.5; // [0:0.1:1]

// applied to wall width
flange_width_multiplier = 1; // [0:0.1:5]

// size
text_height = 5; // [3:1:50]

// inset
text_depth = 0.6; // [0:0.1:10]

font= "Hack Nerd Font Mono";

// derived
skirt_radius = bend_radius + tube_radius * skirt_radius_multiplier;
bolt_hole_diameter = bolt_diameter * bolt_radius_multiplier;
nut_inset_diameter = nut_width * nut_inset_multiplier * 2 / sqrt(3);

channel_width = bend_radius - tube_radius - 2 * wall_width;
channel_height = tube_radius - wall_width;

echo(skirt_radius=skirt_radius);
echo(bolt_hole_diameter=bolt_hole_diameter);
echo(bolt_inset_diameter=bolt_inset_diameter);
echo(nut_inset_diameter=nut_inset_diameter);

echo(channel_width=channel_width);
echo(channel_height=channel_height);

// conditional inclusion is not possible
include <bends-single.scad>
// include <bends-double.scad>

render() if (part == "double")
  bends_double();
else if (part == "single")
  bends_single();
