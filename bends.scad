// global
$fn = 200; // [0:1:1000]

// outer
tube_radius = 8; // [4:1:10]

// to tube centre
bend_radius = 20; // [10:0.01:100]

// n bends, n+1 straights
bends = 3; // [1:1:3]

// of tube, left to right
bend_angle = [60, -120, 90]; // [-180:1:180]

// distance between centres of bends, left to right, 0 for no bend
straight_l = [80, 70, 90, 100]; // [0:1:1000]

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
flange_height_multiplier = 0.6; // [0:0.1:1]

// applied to wall width
flange_width_multiplier = 1; // [0:0.1:5]

// extra bolt hole in bend, space allowing
bend_bolt = true;

// size
text_height = 5; // [3:1:50]

// inset
text_depth = 0.6; // [0:0.1:10]

font = "Hack Nerd Font Mono";

// part separation
bottom_z = 100; // [0:1:500]

// derived
font_metrics = fontmetrics(font=font, size=text_height);

skirt_radius = bend_radius + tube_radius * skirt_radius_multiplier;
bolt_hole_diameter = bolt_diameter * bolt_radius_multiplier;
nut_inset_diameter = nut_width * nut_inset_multiplier * 2 / sqrt(3);

channel_width = bend_radius - tube_radius - 2 * wall_width;
channel_height = tube_radius - wall_width;

total_width_top = bend_radius + wall_width;
total_width_bottom = skirt_radius + wall_width;
total_width_bottom_no_skirt = bend_radius + wall_width;
total_height = tube_radius + wall_width;

echo(font_metrics=font_metrics);

echo(skirt_radius=skirt_radius);
echo(bolt_hole_diameter=bolt_hole_diameter);
echo(bolt_inset_diameter=bolt_inset_diameter);
echo(nut_inset_diameter=nut_inset_diameter);

echo(channel_width=channel_width);
echo(channel_height=channel_height);

echo(total_width_top=total_width_top);
echo(total_width_bottom=total_width_bottom);
echo(total_height=total_height);

assert(total_width_top == total_width_bottom_no_skirt);

function truncv(v, l) = [for (i = [0:l - 1]) v[i]];

module cross_section_bottom(skirt = true) {

  if (skirt) {

    // bottom skirt
    square([skirt_radius, wall_width], center=false);

    // bottom lip
    translate(v=[skirt_radius, 0, 0])
      intersection() {
        square([wall_width, wall_width], center=false);

        circle(r=wall_width);
      }
  } else {
    // fill in the lip for continuity
    square([total_width_bottom_no_skirt, wall_width], center=false);
  }

  // body
  difference() {
    square([bend_radius, total_height], center=false);

    // hollow
    translate(v=[wall_width, wall_width, 0])
      square([channel_width, channel_height + wall_width], center=false);

    // tube hollow
    translate(v=[bend_radius, total_height, 0])
      circle(r=tube_radius);
  }
}

module cross_section_top() {

  // top lip
  translate(v=[bend_radius, 0, 0])
    intersection() {
      square([wall_width, wall_width], center=false);
      circle(r=wall_width);
    }

  difference() {

    // outer
    square([bend_radius, total_height], center=false);

    // channel
    translate(v=[wall_width, wall_width, 0])
      square([channel_width, channel_height + wall_width], center=false);

    // tube hollow
    translate(v=[bend_radius, total_height, 0])
      circle(r=tube_radius);
  }
}

module cross_section_brace(flange_inner, flange_outer) {
  translate(v=[wall_width, wall_width, 0]) {
    square([channel_width, channel_height], center=false);

    y = wall_width * flange_width_multiplier;
    z = channel_height + wall_width * (1 + flange_height_multiplier);

    if (flange_inner)
      square([y, z], center=false);

    if (flange_outer)
      translate(v=[channel_width - y, 0])
        square([y, z], center=false);
  }
}

module bolt_hole(top) {

  // hole
  color(c="black")
    cylinder(h=total_height, d=bolt_hole_diameter, center=false);

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
    // shift up from baseline valign
    translate(v=[dx, dy - font_metrics.max.descent, 0])
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
          linear_extrude(height=l, center=true) {
            if (top)
              cross_section_top();
            else
              cross_section_bottom();
          }

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

module extrude_bend(a, top) {

  // mirrored rotation for negative angles
  dx = a >= 0 ? 0 : top ? -total_width_top : -total_width_bottom_no_skirt;
  mx = a >= 0 ? 0 : 1;

  // negative a bolt rotates from tube, positive from channel
  chan_dx = channel_width / 2 + wall_width;
  bolt_dx = a >= 0 ? chan_dx : dx - chan_dx;

  mirror(v=[mx, 0])
    translate(v=[dx, 0])
      difference() {

        // body
        color(c="slategray")
          rotate_extrude(angle=180 - abs(a))
            mirror(v=[mx, 0])
              translate(v=[dx, 0]) {
                if (top)
                  cross_section_top();
                else
                  cross_section_bottom(skirt=a >= 0);

                cross_section_brace(flange_inner=top, flange_outer=top);
              }

        // bolt hole
        if (bend_bolt)
          rotate(a=(180 - abs(a)) / 2)
            translate(v=[bolt_dx, 0, 0])
              bolt_hole(top=top);
      }
}

module build(
  n = bends,
  ls = truncv(straight_l, bends + 1),
  as = truncv(bend_angle, bends),
  top = false
) {

  l = ls[n];
  a = as[n];
  a_next = bend_angle[n - 1];

  dx = is_num(a) && a >= 0 ? 0 : top ? total_width_top : total_width_bottom_no_skirt;
  rot = is_num(a) ? 180 + a : 0;

  // rotate fulcrum about origin
  translate(v=[dx, 0, 0])
    rotate(a=rot)
      translate(v=[-dx, 0, 0]) {

        // straight shift y to origin
        translate(v=[0, -l / 2, 0])
          extrude_straight(l=l, al=a_next, ar=a, top=top);

        // bends in place at origin
        if (is_num(a))
          extrude_bend(a=a, top=top);

        // recurse and shift y to origin
        if (n > 0)
          translate(v=[0, -l, 0])
            build(n=n - 1, top=top);
      }
}

render() {
  build(top=true);

  translate(v=[0, 0, total_height * 2 + bottom_z])
    mirror(v=[0, 0, 1])
      build(top=false);
}
