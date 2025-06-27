// TODO
// create a single piece and rotate / extrude that

// clear the log
echo("\n\n\n\n\n\n\n\n\n\n");

$fn = 100;

// tube outer radius
tube_r = 8;

// bend
bend_r = 60;
bend_a = 180;

// length of straights
straight_l = 100;

// lower skirt, derived
skirt_r = bend_r * 1.5;
skirt_h = tube_r * 0.1;

// upper lip, derived
lip_h = tube_r * 0.1;

// rotate_extrude start is unavailable in GA, hence position parts around it's 180

echo($fa=$fa)
echo($fn=$fn)
echo($fs=$fs)
echo(tube_r=tube_r);
echo(bend_r=bend_r);
echo(bend_a=bend_a);
echo(straight_l=straight_l);
echo(skirt_r=skirt_r);
echo(skirt_h=skirt_h);
echo(lip_h=lip_h);

// bend body
difference() {
  color(c="red")
    rotate_extrude(angle=bend_a)
      translate(v=[0, -tube_r, 0])
        square([bend_r, tube_r * 2], center=false);

  // hollow
  color(c="green")
    rotate_extrude(angle=bend_a)
      translate(v=[bend_r, 0, 0])
        circle(r=tube_r);
}

// bend skirt
color(c="purple", alpha=0.5)
  translate([0, 0, -tube_r - skirt_h])
    rotate_extrude(angle=bend_a)
      square([skirt_r, skirt_h], center=false);

// bend lip edge
color(c="indigo", alpha=0.5)
  translate([0, 0, tube_r + lip_h])
    rotate_extrude(angle=bend_a)
      translate(v=[bend_r, 0, 0])
        circle(r=lip_h);

// bend top
color(c="aquamarine", alpha=0.25)
  translate([0, 0, tube_r])
    rotate_extrude(angle=bend_a)
      square([bend_r, lip_h * 2], center=false);

// straight body
translate([0, -straight_l / 2, 0]) {
  difference() {

    color(c="yellow", alpha=0.25)
      cube(size=[bend_r * 2, straight_l, tube_r * 2], center=true);

    // hollows
    color(c="blue")
      translate([-bend_r, 0, 0])
        rotate(a=90, v=[1, 0, 0])
          cylinder(h=straight_l, r=tube_r, center=true);

    color(c="cyan")
      translate([bend_r, 0, 0])
        rotate(a=90, v=[1, 0, 0])
          cylinder(h=straight_l, r=tube_r, center=true);
  }
}

// straight skirt
color(c="orange")
  translate([0, -straight_l / 2, -tube_r - skirt_h / 2])
    cube(size=[skirt_r * 2, straight_l, skirt_h], center=true);

// straight lip edges
color(c="tomato")
  translate([-bend_r, -straight_l / 2, tube_r + lip_h])
    rotate(a=90, v=[1, 0, 0])
      cylinder(h=straight_l, r=lip_h, center=true);
color(c="orangered")
  translate([bend_r, -straight_l / 2, tube_r + lip_h])
    rotate(a=90, v=[1, 0, 0])
      cylinder(h=straight_l, r=lip_h, center=true);

// straight top
color(c="chocolate")
  translate([0, -straight_l / 2, tube_r + lip_h])
    cube(size=[bend_r * 2, straight_l, lip_h * 2], center=true);
