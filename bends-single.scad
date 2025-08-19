include <bends-lib.scad>

module top() {
  extrude_bend(bend_angle[0], top=true)
    cross_section_top();

  translate(v=[0, -straight_l[0] / 2, 0])
    extrude_straight(straight_l[0], str("R", bend_radius, "   ", bend_angle[0], "°"), text_mirror=false)
      cross_section_top();

  rotate(a=180 - bend_angle[0], v=[0, 0, 1])
    translate(v=[0, straight_l[1] / 2, 0])
      mirror([0, 1, 0])
        extrude_straight(straight_l[1], text=str("ø", tube_radius * 2), text_mirror=true)
          cross_section_top();
}

module bottom() {
  extrude_bend(bend_angle[0])
    cross_section_bottom();

  translate(v=[0, -straight_l[0] / 2, 0])
    extrude_straight(straight_l[0])
      cross_section_bottom();

  rotate(a=180 - bend_angle[0], v=[0, 0, 1])
    translate(v=[0, straight_l[1] / 2, 0])
      mirror([0, 1, 0])
        extrude_straight(straight_l[1])
          cross_section_bottom();
}

module bends_single() {
  top();

  // shift with a gap of 1
  dxy = max(straight_l[0], straight_l[1]) + bend_radius + wall_width + 1;
  translate(v=[dxy, dxy, 0])
    bottom();
}
