include <bends-lib.scad>

module straight_bend(n = len(straight_l) - 1, top = false) {

  // rotate about the tube, not origin
  dx = n < len(bend_angle) && bend_angle[n] >= 0 ? 0 : top ? total_width_top : total_width_bottom;
  rot = n < len(bend_angle) ? 180 + bend_angle[n] : 0;

  // shift everything to origin
  translate(v=[dx, 0, 0]) {
    rotate(a=rot) {
      translate(v=[-dx, 0, 0]) {
        translate(v=[0, -straight_l[n] / 2, 0]) {
          extrude_straight(l=straight_l[n], ar=bend_angle[n], top=top) {
            if (top) {
              cross_section_top();
            } else {
              cross_section_bottom();
            }
          }
        }

		// next one down
        translate(v=[0, -straight_l[n], 0]) {
          if (n > 0)
            straight_bend(n=n - 1, top=top);
        }

		// bends between straights only
        if (n < len(straight_l) - 1) {
          extrude_bend(a=bend_angle[n], top=top) {
            if (top) {
              cross_section_top();
            } else {
              cross_section_bottom();
            }
            cross_section_brace(flange_inner=top, flange_outer=top);
          }
        }
      }
    }
  }
}

module bends_double() {
  straight_bend(top=true);

  translate(v=[0, 0, tube_radius * 2 + wall_width * 2 + bottom_z])
    mirror(v=[0, 0, 1])
      straight_bend(top=false);
}
