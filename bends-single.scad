include <bends-lib.scad>

module top_single() {
  difference() {
    union() {
      extrude_bend(a=bend_angle[0], s=0, top=true)
        cross_section_top();

      translate(v=[0, -straight_l[0] / 2, 0])
        extrude_straight(
          l=straight_l[0], top=true, text_mirror_y=false,
          text=str(
            "ø", tube_radius * 2,
            "  ",
            "R", bend_radius,
            "  ",
            bend_angle[0], "°⟶"
          )
        )
          cross_section_top();

      rotate(a=180 - bend_angle[0], v=[0, 0, 1])
        translate(v=[0, straight_l[1] / 2, 0])
          mirror([0, 1, 0])
            extrude_straight(
              l=straight_l[1], top=true,
              text_mirror_y=true,
              text=str(
                "⟵", bend_angle[0], "°",
                "  ",
                "R", bend_radius,
                "  ",
                "ø", tube_radius * 2
              )
            )
              cross_section_top();
    }

    // bolt hole mid bend
    rotate(a=(180 - bend_angle[0]) / 2)
      translate(v=[channel_width / 2 + wall_width, 0, 0])
        bolt_hole(top=true);
  }
}

module bottom_single() {
  difference() {
    union() {
      extrude_bend(a=bend_angle[0], s=0, top=false)
        cross_section_bottom();

      translate(v=[0, -straight_l[0] / 2, 0])
        extrude_straight(l=straight_l[0], top=false)
          cross_section_bottom();

      rotate(a=180 - bend_angle[0], v=[0, 0, 1])
        translate(v=[0, straight_l[1] / 2, 0])
          mirror([0, 1, 0])
            extrude_straight(l=straight_l[1], top=false)
              cross_section_bottom();
    }

    // bolt hole mid bend
    rotate(a=(180 - bend_angle[0]) / 2)
      translate(v=[channel_width / 2 + wall_width, 0, 0])
        bolt_hole(top=false);
  }
}

module bends_single() {
  top_single();

  // shift with a gap of 1
  dxy = max(straight_l[0], straight_l[1]) + bend_radius + wall_width + 1;
  translate(v=[dxy, dxy, 0])
    bottom_single();
}
