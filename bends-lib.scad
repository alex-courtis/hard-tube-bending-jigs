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

module cross_section_brace(flange_inner, flange_outer) {
  translate(v=[wall_width, wall_width, 0]) {
    square([channel_width, channel_height], center=false);

    y = wall_width * flange_width_multiplier;
    z = channel_height + wall_width * (1 + flange_height_multiplier);

    if (flange_inner) {
      square([y, z], center=false);
    }

    if (flange_outer) {
      translate(v=[channel_width - y, 0])
        square([y, z], center=false);
    }
  }
}

module bolt_hole(top) {

  // hole
  color(c="black")
    cylinder(h=wall_width * 2 + tube_radius, d=bolt_hole_diameter, center=false);

  if (top) {
    // bolt sink
    color(c="brown")
      cylinder(h=bolt_inset_depth, d=bolt_inset_diameter, center=false);
  } else {
    // captive nut
    color(c="tan")
      cylinder(h=nut_depth, d=nut_inset_diameter, center=false, $fn=6);
  }
}

module straight_text(dx, text, text_mirror) {
  rotate(a=90, v=[0, 0, 1])
    translate(v=[0, dx, 0])
      linear_extrude(height=text_depth, center=false)
        mirror(v=[0, 1]) // text facing inwards
          mirror(v=[text_mirror ? 1 : 0, 0]) // optional for mirrorred straight
            text(size=text_height, text=text, halign="center", valign="center");
}

// text implies top
module extrude_straight(l, text, text_mirror) {

  brace_y = max(bolt_inset_diameter, nut_inset_diameter) + wall_width;

  brace_hole_dy = -l / 2 + brace_y;

  difference() {

    union() {

      rotate(a=90, v=[1, 0, 0]) {

        // body
        color(c="gray")
          linear_extrude(height=l, center=true)
            children();

        // bolt brace
        color(c="darkblue")
          translate(v=[0, 0, -brace_hole_dy])
            linear_extrude(height=brace_y, center=true)
              cross_section_brace(flange_inner=text, flange_outer=text);
      }
    }

    // bend info
    if (text) {
      straight_text(dx=-text_height * 1, text=text, text_mirror=text_mirror);
      straight_text(dx=-bend_radius - wall_width + text_height * 1, text=str("L", l), text_mirror=text_mirror);
    }

    // bolt hole
    translate(v=[wall_width + channel_width / 2, brace_hole_dy, 0])
      bolt_hole(top=text);
  }
}

module extrude_bend(a, top) {

  difference() {
    union() {
      // body
      color(c="lightgray")
        rotate_extrude(angle=180 - a)
          children();

      // brace
      color(c="royalblue")
        rotate_extrude(angle=180 - a)
          cross_section_brace(flange_inner=false, flange_outer=top);
    }

    // bolt hole near end
    rotate(a=(180 - a) / 2)
      translate(v=[channel_width / 2 + wall_width, 0, 0])
        bolt_hole(top=top);
  }
}
