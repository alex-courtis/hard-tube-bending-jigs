$fn = 200;

// or bottom
top = false;

// outer
tube_radius = 8; // [4:1:10]

// to tube centre
bend_radius = 20; // [10:1:100]

// tube
bend_angle = 90; // [0:1:180]

// distance between centres of bends
straight_l = 80;

// skirt, top and sides thickness, lip radii
wall_width = 1.5; // [0:0.1:5]

// of bend radius
skirt_radius_multiplier = 2; // [1:0.1:3]

// default M3
bolt_radius = 1.5; // [0.5:0.1:10]

// bolt hole size multiplier
bolt_radius_multiplier = 1.1; // [1:0.01:2]

// nut width, default M3
nut_diameter = 5.5 * 1.03; // [1:0.1:10]

// nut hole width multiplier
nut_hole_multiplier = 1.03; // [1:0.01:2]

// nut depth, default M3
nut_depth = 4; // [0:0.1:20]

// size
text_pt = 7; // [4:1:50]

// inset
text_depth = 1; // [0:0.1:10]

// derived
skirt_radius = bend_radius * skirt_radius_multiplier;
bolt_hole_radius = bolt_radius * bolt_radius_multiplier;
nut_hole_diameter = nut_diameter * nut_hole_multiplier;

echo(skirt_radius=skirt_radius);
echo(bolt_hole_radius=bolt_hole_radius);
echo(nut_hole_diameter=nut_hole_diameter);

// entire piece
if (top) {

  extrude_bend()
    cross_section_top();
  extrude_right_straight()
    cross_section_top();
  extrude_left_straight()
    cross_section_top();
} else {

  extrude_bend()
    cross_section_bottom();
  extrude_right_straight()
    cross_section_bottom();
  extrude_left_straight()
    cross_section_bottom();
}

module cross_section_bottom() {

  // bottom skirt
  square([skirt_radius, wall_width], center=false);

  // body
  difference() {
    square([bend_radius, wall_width + tube_radius], center=false);

    // hollow
    translate(v=[wall_width, wall_width, 0])
      square([bend_radius - tube_radius - 2 * wall_width, tube_radius + wall_width - wall_width], center=false);

    // tube hollow
    translate(v=[bend_radius, wall_width + tube_radius, 0])
      circle(r=tube_radius);
  }
}

module cross_section_top() {

  // top lip
  translate(v=[bend_radius, wall_width, 0])
    circle(r=wall_width);

  difference() {

    // outer
    square([bend_radius, tube_radius + wall_width * 2], center=false);

    // hollow
    translate(v=[wall_width, wall_width, 0])
      square([bend_radius - tube_radius - 2 * wall_width, tube_radius + wall_width * 2 - wall_width], center=false);

    // tube hollow
    translate(v=[bend_radius, tube_radius + wall_width * 2, 0])
      circle(r=tube_radius);
  }
}

module bolt_shaft() {

  // full height
  if (top) {
    cylinder(h=tube_radius + wall_width * 2, r=bolt_hole_radius + wall_width, center=false);
  } else {
    cylinder(h=tube_radius + wall_width, r=bolt_hole_radius + wall_width, center=false);
  }
}

module bolt_hole() {

  // hole
  color(c="pink")
    cylinder(h=wall_width + tube_radius * 2 + wall_width * 2, r=bolt_hole_radius, center=false);

  // captive nut
  if (!top) {
    color(c="red")
      cylinder(h=nut_depth, r=nut_hole_w / sqrt(3), center=false, $fn=6);
  }
}

module straight_text(text) {
  translate(v=[bend_radius / 2, (bend_radius - straight_l) / 2, text_depth])
    rotate(a=90, v=[0, 0, 1])
      rotate(a=180, v=[1, 0, 0])
        linear_extrude(height=text_depth, center=false)
          text(size=text_pt, text=text);
}

module extrude_bend() {

  difference() {

    union() {

      // body
      color(c="blue")
        rotate_extrude(angle=180 - bend_angle)
          children();

      // bolt shaft closer to centre
      color(c="red")
        translate([(bend_radius - tube_radius) / 2 * cos((180 - bend_angle) / 2), (bend_radius - tube_radius) / 2 * sin((180 - bend_angle) / 2), 0])
          bolt_shaft();
    }

    // bolt hole
    translate([(bend_radius - tube_radius) / 2 * cos((180 - bend_angle) / 2), (bend_radius - tube_radius) / 2 * sin((180 - bend_angle) / 2), 0])
      bolt_hole();
  }
}

module extrude_right_straight() {

  translate([0, -straight_l / 2, 0]) {

    difference() {

      union() {

        // body
        color(c="green")
          rotate(a=90, v=[1, 0, 0])
            linear_extrude(height=straight_l, center=true)
              children();

        // bolt shaft
        color(c="red")
          translate(v=[(bend_radius - tube_radius) / 2, -(straight_l - bend_radius + tube_radius) / 2, 0])
            bolt_shaft();
      }

      // tube info
      if (top)
        straight_text(text=str(tube_radius * 2, "mm Tube"));

      // bolt hole
      translate(v=[(bend_radius - tube_radius) / 2, -(straight_l - bend_radius + tube_radius) / 2, 0])
        bolt_hole();
    }

    // assistive bend
    translate(v=[0, -straight_l / 2, 0])
      color(c="magenta")
        rotate_extrude(angle=-270)
          children();
  }
}

module extrude_left_straight() {

  rotate(a=180 - bend_angle, v=[0, 0, 1])

    translate([0, straight_l / 2, 0]) {

      difference() {

        union() {

          // body
          color(c="yellow")
            rotate(a=90, v=[1, 0, 0])
              linear_extrude(height=straight_l, center=true)
                children();

          // bolt shaft
          color(c="red")
            translate(v=[(bend_radius - tube_radius) / 2, (straight_l - bend_radius + tube_radius) / 2, 0])
              bolt_shaft();
        }

        // bend info
        if (top)
          straight_text(text=str(bend_angle, "° ", bend_radius, "mm"));

        // bolt hole
        translate(v=[(bend_radius - tube_radius) / 2, (straight_l - bend_radius + tube_radius) / 2, 0])
          bolt_hole();
      }

      // assistive bend
      translate(v=[0, straight_l / 2, 0])
        color(c="cyan")
          rotate_extrude(angle=270)
            children();
    }
}
