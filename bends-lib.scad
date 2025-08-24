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

module extrude_text(text, dx, dy, halign) {

  linear_extrude(height=text_depth, center=false)
    translate(
      v=[
        dx,
        dy - font_metrics.max.descent, // shift up from baseline valign
        0,
      ]
    )
      text(font=font, size=text_height, text=text, valign="baseline", halign=halign);
}

module extrude_straight(l, al, ar, top, text) {

  brace_y = max(bolt_inset_diameter, nut_inset_diameter) + wall_width;

  brace_hole_dy = ( -l + brace_y) / 2;

  difference() {

    union() {

      rotate(a=90, v=[1, 0, 0]) {

        // body
        color(c="gray")
          linear_extrude(height=l, center=true)
            children();

        // brace
        color(c="darkblue")
          translate(v=[0, 0, -brace_hole_dy])
            linear_extrude(height=brace_y, center=true)
              cross_section_brace(flange_inner=top, flange_outer=top);

        // brace
        color(c="cadetblue")
          translate(v=[0, 0, brace_hole_dy])
            linear_extrude(height=brace_y, center=true)
              cross_section_brace(flange_inner=top, flange_outer=top);
      }
    }

    // bend info
    if (top) {
      mirror(v=[0, 1, 0]) {
        rotate(a=270, v=[0, 0, 1]) {
          dy = bend_radius + wall_width - wall_width * 2 - font_metrics.nominal.ascent;

          extrude_text(
            text=al ? str(al, "°") : str("ø", tube_radius * 2),
            dx=-l / 2 + wall_width * 2,
            dy=dy,
            halign="left"
          );

          extrude_text(
            text=ar ? str(ar, "°") : str("ø", tube_radius * 2),
            dx=l / 2 - wall_width * 2,
            dy=dy,
            halign="right"
          );

          extrude_text(
            text=str("R", bend_radius),
            dx=0,
            dy=dy,
            halign="center"
          );

          extrude_text(
            text=str("L", l),
            dx=0,
            dy=wall_width,
            halign="center"
          );
        }
      }
    }

    // bolt holes
    translate(v=[wall_width + channel_width / 2, brace_hole_dy, 0])
      bolt_hole(top=top);
    translate(v=[wall_width + channel_width / 2, -brace_hole_dy, 0])
      bolt_hole(top=top);
  }
}

module extrude_bend(a, top, concave = false) {

  difference() {
    if (a < 0) {
      tw = top ? total_width_top : total_width_bottom;

      color(c="slategray")
        mirror(v=[1, 0])
          translate(v=[-tw, 0])
            difference() {
              // body and flange
              rotate_extrude(angle=180 + a, start=0)
                mirror(v=[1, 0])
                  translate(v=[-tw, 0])
                    children();

              // bolt hole
              if (bend_bolt) {
                rotate(a=(180 + a) / 2)
                  translate(v=[tw - channel_width / 2 - wall_width, 0, 0])
                    bolt_hole(top=top);
              }
            }
    } else {

      color(c="lightgray")
        difference() {
          // body and flange
          rotate_extrude(angle=180 - a)
            children();

          // bolt hole
          if (bend_bolt) {
            rotate(a=(180 - bend_angle[0]) / 2)
              translate(v=[channel_width / 2 + wall_width, 0, 0])
                bolt_hole(top=top);
          }
        }
    }
  }
}
