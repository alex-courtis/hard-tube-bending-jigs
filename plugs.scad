d_tube_inner = 8; // [1:0.01:50]
h_tube = 8; // [1:0.1:50]

d_socket = 4; // [1:0.01:50]
h_socket = 4; // [1:0.1:50]

d_hole = 2; // [0:0.1:50]

$fn = 200;

render()
  difference() {
    union() {
      cylinder(d=d_tube_inner, h=h_tube);
      cylinder(d=d_socket, h=h_tube + h_socket);
    }
    cylinder(d=d_hole, h=h_tube + h_socket);
  }
