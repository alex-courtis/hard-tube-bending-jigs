// single bend: top and bottom printed separately and bolted together
// flush caches before render on "WARNING: Object may not be a valid 2-manifold and may need repair!"

$fn = 200;

// top or bottom
bottom = false;

// tube outer radius
tube_r = 8;

// bend to tube center
bend_r = 50;
bend_a = 60;

// length of straights from centre of bend
straight_l = 100;

// bolt, M3
bolt_r = 1.5;

// lower skirt
skirt_r = bend_r + 2 * tube_r;
skirt_h = 1.5;

// upper lip
lip_r = 1.5;

// clear the log
echo("\n\n\n\n\n\n\n\n\n\n");
echo($fa=$fa);
echo($fn=$fn);
echo($fs=$fs);
echo(tube_r=tube_r);
echo(bend_r=bend_r);
echo(bend_a=bend_a);
echo(straight_l=straight_l);
echo(skirt_r=skirt_r);
echo(skirt_h=skirt_h);
echo(lip_r=lip_r);

// entire piece
if (bottom) {

  extrude_bend()
    cross_section_bottom();
  extrude_right_straight()
    cross_section_bottom();
  extrude_left_straight()
    cross_section_bottom();

} else {

  extrude_bend()
    cross_section_top();
  extrude_right_straight()
    cross_section_top();
  extrude_left_straight()
    cross_section_top();
}

module cross_section_bottom() {

  // bottom skirt
  square([skirt_r, skirt_h], center=false);

  // body
  difference() {
    square([bend_r, skirt_h + tube_r], center=false);

    // tube hollow
    translate(v=[bend_r, skirt_h + tube_r, 0]) {
      circle(r=tube_r);
    }
  }
}

module cross_section_top() {

  // top lip
  translate(v=[bend_r, lip_r, 0]) {
    circle(r=lip_r);
  }

  // body and top
  difference() {
    square([bend_r, tube_r + lip_r * 2], center=false);

    // tube hollow
    translate(v=[bend_r, tube_r + lip_r * 2, 0]) {
      circle(r=tube_r);
    }
  }
}

module bolt_hole() {
  color(c="black")
    cylinder(h=skirt_h + tube_r * 2 + lip_r * 2, r=bolt_r, center=false);
}

module extrude_bend()
  difference() {

    // body
    color(c="blue")
      rotate_extrude(angle=180 - bend_a)
        children();

    // bolt hole closer to centre
    translate([(bend_r - tube_r) / 2 * cos((180 - bend_a) / 2), (bend_r - tube_r) / 2 * sin((180 - bend_a) / 2), 0])
      bolt_hole();
  }

module extrude_right_straight() {
  translate([0, -straight_l / 2, 0])
    difference() {
      // body
      color(c="green")
        rotate(a=90, v=[1, 0, 0])
          linear_extrude(height=straight_l, center=true)
            children();

      // bolt hole end
      translate(v=[(bend_r - tube_r) / 2, -(straight_l - bend_r + tube_r) / 2, 0])
        bolt_hole();
    }
}

module extrude_left_straight()
  rotate(a=180 - bend_a, v=[0, 0, 1])
    translate([0, straight_l / 2, 0])
      difference() {
        color(c="orange")
          rotate(a=90, v=[1, 0, 0])
            linear_extrude(height=straight_l, center=true)
              children();

        // bolt hole end
        translate(v=[(bend_r - tube_r) / 2, (straight_l - bend_r + tube_r) / 2, 0])
          bolt_hole();
      }
