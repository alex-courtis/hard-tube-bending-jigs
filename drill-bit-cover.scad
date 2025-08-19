d_entry = 10.9; // [1:0.01:50]
h_entry = 5; // [1:0.01:50]

d_tube = 11.9; // [1:0.01:50]
h_tube = 20; // [1:0.1:50]

d_bearing = 11.10; // [1:0.01:50]
h_bearing = 5.5; // [1:0.01:50]

d_nut = 8.6; // [1:0.01:50]
h_nut = 7; // [1:0.01:50]

$fn = 400;

// tube
render() {
  difference() {
    color(c="purple")
      cylinder(d=d_tube, h=h_tube);
    color(c="blue")
      cylinder(d=d_bearing, h=h_bearing);
    color(c="red")
      cylinder(d=d_nut, h=h_nut + h_bearing);
  }
  color(c="green")
    translate(v=[0, 0, h_tube])
      cylinder(d1=d_tube, d2=d_entry, h=h_entry);
}
