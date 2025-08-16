$fn = 200;

piece = "both"; // ["both", "top", "bottom"]

// outer
tube_radius = 8; // [4:1:10]

// to tube centre
bend_radius = 20; // [10:0.01:100]

// tube
bend_angle = 90; // [0:1:180]

// distance between centres of bends
straight_l = 80;

// skirt, top and sides thickness, lip radii
wall_width = 1.5; // [0:0.1:5]

// of bend radius
skirt_radius_multiplier = 2; // [1:0.1:3]

// default M3
bolt_diameter = 3; // [2:0.1:10]

// bolt hole size multiplier
bolt_radius_multiplier = 1.02; // [0:0.01:2]

// optional bolt head inset
bolt_head_diameter = 6; // [0:0.1:10]

// optional bolt head inset
bolt_head_depth = 2.5; // [0:0.1:10]

// default M3
nut_width = 5.5; // [1:0.1:10]

// nut hole width multiplier
nut_hole_multiplier = 1.03; // [1:0.01:2]

// nut depth, default M3
nut_depth = 4.5; // [0:0.1:20]

// above channel, applied to wall width
flange_height_multiplier = 0.5; // [0:0.1:1]

// applied to wall width
flange_width_multiplier = 1; // [0:0.1:5]

// size
text_pt = 7; // [4:1:50]

// inset
text_depth = 1; // [0:0.1:10]

// derived
skirt_radius = bend_radius * skirt_radius_multiplier;
bolt_hole_diameter = bolt_diameter * bolt_radius_multiplier;
nut_hole_diameter = nut_width * nut_hole_multiplier * 2 / sqrt(3);

channel_width = bend_radius - tube_radius - 2 * wall_width;
channel_height = tube_radius - wall_width;

echo(skirt_radius=skirt_radius);
echo(bolt_hole_diameter=bolt_hole_diameter);
echo(nut_hole_diameter=nut_hole_diameter);

echo(channel_width=channel_width);
echo(channel_height=channel_height);

// entire piece
render() if (piece != "bottom") {

  extrude_bend()
    cross_section_top();

  translate(v=[0, -straight_l / 2, 0])
    extrude_straight(str(bend_angle, "° ", bend_radius, "mm"))
      cross_section_top();

  rotate(a=180 - bend_angle, v=[0, 0, 1])
    translate(v=[0, straight_l / 2, 0])
      extrude_straight(text=str("ø ", tube_radius * 2, "mm"))
        cross_section_top();
}

render() if (piece != "top") {

  translate(v=[straight_l + bend_radius + wall_width, straight_l + bend_radius + wall_width, 0]) {
    extrude_bend()
      cross_section_bottom();

    translate(v=[0, -straight_l / 2, 0])
      extrude_straight()
        cross_section_bottom();

    rotate(a=180 - bend_angle, v=[0, 0, 1])
      translate(v=[0, straight_l / 2, 0])
        extrude_straight()
          cross_section_bottom();
  }
}

module cross_section_bottom() {

  // bottom skirt
  square([skirt_radius, wall_width], center=false);

  // bottom lip
  translate(v=[skirt_radius, 0, 0]) {
    intersection() {
      square([wall_width, wall_width], center=false);

      circle(r=wall_width);
    }
  }

  // body
  difference() {
    square([bend_radius, wall_width + tube_radius], center=false);

    // hollow
    translate(v=[wall_width, wall_width, 0])
      square([channel_width, channel_height + wall_width], center=false);

    // tube hollow
    translate(v=[bend_radius, wall_width + tube_radius, 0])
      circle(r=tube_radius);
  }
}

module cross_section_top() {

  // top lip
  translate(v=[bend_radius, 0, 0]) {
    intersection() {
      square([wall_width, wall_width], center=false);
      circle(r=wall_width);
    }
  }

  difference() {

    // outer
    square([bend_radius, tube_radius + wall_width], center=false);

    // channel
    translate(v=[wall_width, wall_width, 0])
      square([channel_width, channel_height + wall_width], center=false);

    // tube hollow
    translate(v=[bend_radius, tube_radius + wall_width, 0])
      circle(r=tube_radius);
  }
}

module bolt_hole(top) {

  // hole
  color(c="black")
    cylinder(h=wall_width * 2 + tube_radius, d=bolt_hole_diameter, center=false);

  if (top) {
    // bolt sink
    color(c="brown")
      cylinder(h=bolt_head_depth, d=bolt_head_diameter, center=false);
  } else {
    // captive nut
    color(c="tan")
      cylinder(h=nut_depth, d=nut_hole_diameter, center=false, $fn=6);
  }
}

module straight_text(text) {
  translate(v=[tube_radius + wall_width, 0, text_depth])
    rotate(a=90, v=[0, 0, 1])
      rotate(a=180, v=[1, 0, 0])
        linear_extrude(height=text_depth, center=false)
          text(size=tube_radius, text=text, halign="center", valign="center");
}

module extrude_bend() {

  // body
  color(c="lightgray")
    rotate_extrude(angle=180 - bend_angle)
      children();
}

module shaft(y, dy, flange) {
  translate(v=[wall_width, dy, wall_width]) {
    cube([channel_width, y, channel_height], center=false);

    if (flange) {
      x = wall_width * flange_width_multiplier;
      z = channel_height + wall_width * (1 + flange_height_multiplier);

      cube([x, y, z], center=false);

      translate(v=[channel_width - wall_width * flange_width_multiplier, 0, 0])
        cube([x, y, z], center=false);
    }
  }
}

// text implies top
module extrude_straight(text) {
  shaft_width = nut_hole_diameter + 2 * wall_width;

  difference() {

    union() {

      // body
      color(c="gray")
        rotate(a=90, v=[1, 0, 0])
          linear_extrude(height=straight_l, center=true)
            children();

      // bolt shafts
      color(c="darkblue")
        shaft(y=shaft_width, dy=straight_l / 2 - shaft_width, flange=text);
      color(c="steelblue")
        shaft(y=shaft_width, dy=-straight_l / 2, flange=text);
    }

    // bend info
    if (text)
      straight_text(text=text);

    // bolt holes
    translate(v=[wall_width + channel_width / 2, straight_l / 2 - shaft_width / 2, 0])
      bolt_hole(top=text);
    translate(v=[wall_width + channel_width / 2, -straight_l / 2 + shaft_width / 2, 0])
      bolt_hole(top=text);
  }
}
