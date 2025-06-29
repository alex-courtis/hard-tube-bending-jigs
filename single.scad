// single bend: top and bottom printed separately and bolted together
// flush caches before render on "WARNING: Object may not be a valid 2-manifold and may need repair!"

$fn = 200;

// bottom or top
top = false;

// tube outer radius
tube_r = 8;

// bend to tube center
bend_r = 30;
bend_a = 45;

// length of straights from centre of bend
straight_l = 80;

// lower skirt
skirt_r = bend_r + 2 * tube_r;
skirt_h = 1.5;

// upper lip
lip_r = 1.5;

// wall thickness
wall_w = lip_r * 2;

// bolt and nut, M3
bolt_r = 1.5 * 1.02;
nut_w = 5.5 * 1.02;
nut_d = 4;

// text size and depth; maybe need to move to skirt
text_pt = 7;
text_d = 1;

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
echo(bolt_r=bolt_r);
echo(nut_w=nut_w);
echo(nut_d=nut_d);
echo(text_pt=text_pt);
echo(text_d=text_d);

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
  square([skirt_r, skirt_h], center=false);

  // body
  difference() {
    square([bend_r, skirt_h + tube_r], center=false);

    // hollow
    translate(v=[wall_w, wall_w, 0])
      square([bend_r - tube_r - 2 * wall_w, tube_r + skirt_h - wall_w], center=false);

    // tube hollow
    translate(v=[bend_r, skirt_h + tube_r, 0])
      circle(r=tube_r);
  }
}

module cross_section_top() {

  // top lip
  translate(v=[bend_r, lip_r, 0])
    circle(r=lip_r);

  difference() {

    // outer
    square([bend_r, tube_r + lip_r * 2], center=false);

    // hollow
    translate(v=[wall_w, wall_w, 0])
      square([bend_r - tube_r - 2 * wall_w, tube_r + lip_r * 2 - wall_w], center=false);

    // tube hollow
    translate(v=[bend_r, tube_r + lip_r * 2, 0])
      circle(r=tube_r);
  }
}

module bolt_shaft() {

  // full height
  if (top) {
    cylinder(h=tube_r + lip_r * 2, r=bolt_r + wall_w, center=false);
  } else {
    cylinder(h=tube_r + skirt_h, r=bolt_r + wall_w, center=false);
  }
}

module bolt_hole() {

  // hole
  color(c="pink")
    cylinder(h=skirt_h + tube_r * 2 + lip_r * 2, r=bolt_r, center=false);

  // captive nut
  if (!top) {
    color(c="red")
      cylinder(h=nut_d, r=nut_w / sqrt(3), center=false, $fn=6);
  }
}

module straight_text(text) {
  translate(v=[bend_r / 2, (bend_r - straight_l) / 2, text_d])
    rotate(a=90, v=[0, 0, 1])
      rotate(a=180, v=[1, 0, 0])
        linear_extrude(height=text_d, center=false)
          text(size=text_pt, text=text);
}

module extrude_bend() {

  difference() {

    union() {

      // body
      color(c="blue")
        rotate_extrude(angle=180 - bend_a)
          children();

      // bolt shaft closer to centre
      color(c="red")
        translate([(bend_r - tube_r) / 2 * cos((180 - bend_a) / 2), (bend_r - tube_r) / 2 * sin((180 - bend_a) / 2), 0])
          bolt_shaft();
    }

    // bolt hole
    translate([(bend_r - tube_r) / 2 * cos((180 - bend_a) / 2), (bend_r - tube_r) / 2 * sin((180 - bend_a) / 2), 0])
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
          translate(v=[(bend_r - tube_r) / 2, -(straight_l - bend_r + tube_r) / 2, 0])
            bolt_shaft();
      }

      // tube info
      if (top)
        straight_text(text=str(tube_r * 2, "mm Tube"));

      // bolt hole
      translate(v=[(bend_r - tube_r) / 2, -(straight_l - bend_r + tube_r) / 2, 0])
        bolt_hole();
    }

    // assistive bend
    translate(v=[0, -straight_l / 2, 0])
      color(c="magenta")
        rotate_extrude(angle=-90)
          children();
  }
}

module extrude_left_straight() {

  rotate(a=180 - bend_a, v=[0, 0, 1])

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
            translate(v=[(bend_r - tube_r) / 2, (straight_l - bend_r + tube_r) / 2, 0])
              bolt_shaft();
        }

        // bend info
        if (top)
          straight_text(text=str(bend_a, "° ", bend_r, "mm"));

        // bolt hole
        translate(v=[(bend_r - tube_r) / 2, (straight_l - bend_r + tube_r) / 2, 0])
          bolt_hole();
      }

      // assistive bend
      translate(v=[0, straight_l / 2, 0])
        color(c="cyan")
          rotate_extrude(angle=90)
            children();
    }
}
