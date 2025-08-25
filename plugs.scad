h_flange = 3.0; // [0:0.01:50]

d_rod_outer = 3.75; // [0:0.001:50]
d_rod_inner = 3.90; // [0:0.001:50]

d_tube = 11.85; // [1:0.01:50]
h_tube = 15; // [1:0.1:50]

d1_flange_tube = 23; // [0:0.01:50]
d2_flange_tube = 20; // [0:0.01:50]

d_socket = 11.4; // [1:0.01:50]
h_socket = 6.2; // [1:0.1:50]

d1_flange_socket = 23; // [0:0.01:50]
d2_flange_socket = 20; // [0:0.01:50]

$fn = 400;

// tube with female rod
color(c="blue") {
  translate(v=[0, -d1_flange_tube, 0]) {
    difference() {
      union() {
        translate(v=[0, 0, h_flange])
          cylinder(d=d_tube, h=h_tube);
        cylinder(d1=d1_flange_tube, d2=d2_flange_tube, h=h_flange);
      }
      #cylinder(d=d_rod_inner, h=h_tube + h_flange);
    }
  }
}

// tube with male rod
color(c="orange") {
  translate(v=[0, d_tube, 0]) {
    cylinder(d=d_tube, h=h_tube);
    translate(v=[0, 0, h_tube + h_flange])
      mirror(v=[0, 0, 1])
        cylinder(d1=d1_flange_tube, d2=d2_flange_tube, h=h_flange);
    cylinder(d=d_rod_outer, h=h_tube + h_flange * 2 + h_socket);
  }
}

// socket with female rod and flange
translate(v=[d1_flange_socket, 0, 0]) {
  color(c="green") {
    difference() {
      union() {
        translate(v=[0, 0, h_flange])
          cylinder(d=d_socket, h=h_socket);
        cylinder(d1=d1_flange_socket, d2=d2_flange_socket, h=h_flange);
      }
      #cylinder(d=d_rod_inner, h=h_socket + h_flange);
    }
  }
}
