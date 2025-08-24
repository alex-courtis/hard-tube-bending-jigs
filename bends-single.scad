include <bends-lib.scad>

module top_single() {
  extrude_bend(a=bend_angle[0], top=true) {
    cross_section_top();
    cross_section_brace(flange_inner=true, flange_outer=true);
  }

  translate(v=[0, -straight_l[0] / 2, 0])
    extrude_straight( l=straight_l[0], ar=bend_angle[0], top=true,)
      cross_section_top();

  rotate(a=180 - bend_angle[0], v=[0, 0, 1])
    translate(v=[0, straight_l[1] / 2, 0])
      extrude_straight( l=straight_l[1], al=bend_angle[0], top=true,)
        cross_section_top();
}

module bottom_single() {
  extrude_bend(a=bend_angle[0], top=false) {
    cross_section_bottom();
    cross_section_brace(flange_inner=false, flange_outer=false);
  }

  translate(v=[0, -straight_l[0] / 2, 0])
    extrude_straight(l=straight_l[0], top=false)
      cross_section_bottom();

  rotate(a=180 - bend_angle[0], v=[0, 0, 1])
    translate(v=[0, straight_l[1] / 2, 0])
      mirror([0, 1, 0])
        extrude_straight(l=straight_l[1], top=false)
          cross_section_bottom();
}

module bends_single() {
  top_single();

  // shift with a gap of 1
  dxy = max(straight_l[0], straight_l[1]) + bend_radius + wall_width + 1;
  translate(v=[dxy, dxy, 0])
    bottom_single();
}
