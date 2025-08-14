d_tube = 11.85; // [1:0.01:50]
h_tube = 15; // [1:0.1:50]

d_rod_outer = 3.95; // [0:0.01:50]
d_rod_inner = 3.90; // [0:0.01:50]

dd_flange_socket = 5; // [0:0.01:50]
dd_flange_tube = 6; // [0:0.01:50]
h_flange = 2.0; // [0:0.01:50]

d_socket = 10; // [1:0.01:50]
h_socket = 12; // [1:0.1:50]

$fn = 400;

render() {

  // tube with female rod
  color(c="blue") {
    translate(v=[0, -d_tube - dd_flange_tube, 0]) {
      difference() {
        union() {
          translate(v=[0, 0, h_flange])
            cylinder(d=d_tube, h=h_tube);
          cylinder(d=d_tube + dd_flange_tube, h=h_flange);
        }
        #cylinder(d=d_rod_inner, h=h_tube + h_flange);
      }
    }
  }

  // tube with male rod, no flange
  color(c="orange") {
    translate(v=[0, d_tube + dd_flange_tube, 0]) {
      cylinder(d=d_tube, h=h_tube);
      cylinder(d=d_rod_outer, h=h_tube + h_flange + h_socket);
    }
  }

  // socket with female rod and flange
  translate(v=[d_socket + dd_flange_socket, 0, 0]) {
    color(c="green") {
      difference() {
        union() {
          translate(v=[0, 0, h_flange])
            cylinder(d=d_socket, h=h_socket);
          cylinder(d=d_socket + dd_flange_socket, h=h_flange);
        }
        #cylinder(d=d_rod_inner, h=h_socket + h_flange);
      }
    }
  }
}
