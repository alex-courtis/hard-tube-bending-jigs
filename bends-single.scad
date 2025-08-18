include <bends-lib.scad>

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

module bends_single() {
  top();

  translate(v=[straight_l + bend_radius + wall_width, straight_l + bend_radius + wall_width, 0])
    bottom();
}
