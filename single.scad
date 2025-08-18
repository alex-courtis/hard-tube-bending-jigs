$fn = 200;

// outer
tube_radius = 8; // [4:1:10]

// to tube centre
bend_radius = 20; // [10:0.01:100]

// tube
bend_angle = 90; // [0:1:180]

// distance between centres of bends
straight_l = 80; // [10:1:1000]

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
text_height = 8; // [4:1:50]

// inset
text_depth = 0.6; // [0:0.1:10]

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

include <lib.scad>

module extrude_bend(top) {

  difference() {
    union() {
      // body
      color(c="lightgray")
        rotate_extrude(angle=180 - bend_angle)
          children();

      // brace
      color(c="royalblue")
        rotate_extrude(angle=180 - bend_angle)
          cross_section_brace(flange_inner=false, flange_outer=top);
    }

    // bolt hole near end
    rotate(a=(180 - bend_angle) / 2)
      translate(v=[channel_width / 2 + wall_width, 0, 0])
        bolt_hole(top=top);
  }
}

module straight_text(text, text_mirror) {
  dy = -(wall_width + channel_width + wall_width + tube_radius + wall_width) / 2;

  rotate(a=90, v=[0, 0, 1])
    translate(v=[0, dy, 0])
      linear_extrude(height=text_depth, center=false)
        mirror(v=[0, 1]) // text facing inwards
          mirror(v=[text_mirror ? 1 : 0, 0]) // optional for mirrorred straight
            text(size=text_height, text=text, halign="center", valign="center");
}

// text implies top
module extrude_straight(text, text_mirror) {

  brace_y = max(bolt_inset_diameter, nut_inset_diameter) + wall_width;

  brace_hole_dy = -straight_l / 2 + brace_y;

  difference() {

    union() {

      rotate(a=90, v=[1, 0, 0]) {

        // body
        color(c="gray")
          linear_extrude(height=straight_l, center=true)
            children();

        // bolt brace
        color(c="darkblue")
          translate(v=[0, 0, -brace_hole_dy])
            linear_extrude(height=brace_y, center=true)
              cross_section_brace(flange_inner=text, flange_outer=text);
      }
    }

    // bend info
    if (text)
      straight_text(text=text, text_mirror=text_mirror);

    // bolt hole
    translate(v=[wall_width + channel_width / 2, brace_hole_dy, 0])
      bolt_hole(top=text);
  }
}

module top() {
  extrude_bend(top=true)
    cross_section_top();

  translate(v=[0, -straight_l / 2, 0])
    extrude_straight(str("R", bend_radius, "   ", bend_angle, "°"), text_mirror=false)
      cross_section_top();

  rotate(a=180 - bend_angle, v=[0, 0, 1])
    translate(v=[0, straight_l / 2, 0])
      mirror([0, 1, 0])
        extrude_straight(text=str("ø", tube_radius * 2, "   L", straight_l), text_mirror=true)
          cross_section_top();
}

module bottom() {
  extrude_bend()
    cross_section_bottom();

  translate(v=[0, -straight_l / 2, 0])
    extrude_straight()
      cross_section_bottom();

  rotate(a=180 - bend_angle, v=[0, 0, 1])
    translate(v=[0, straight_l / 2, 0])
      mirror([0, 1, 0])
        extrude_straight()
          cross_section_bottom();
}

render() {
  top();

  translate(v=[straight_l + bend_radius + wall_width, straight_l + bend_radius + wall_width, 0])
    bottom();
}
