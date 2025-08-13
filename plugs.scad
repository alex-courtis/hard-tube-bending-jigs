d_tube = 11.85; // [1:0.01:50]
h_tube = 15; // [1:0.1:50]

d_connector_male = 5; // [0:0.01:50]
d_connector_female = 5.2; // [0:0.01:50]

dd_flange = 5; // [0:0.01:50]
h_flange = 1.2; // [0:0.01:50]

d_socket = 10; // [1:0.01:50]
h_socket = 12; // [1:0.1:50]

$fn = 400;

render() {

  // tube with male connector
  color(c="blue") {
    translate(v=[0, -d_tube, 0]) {
      cylinder(d=d_tube, h=h_tube);
      cylinder(d=d_connector_male, h=h_socket + h_flange + h_tube);
    }
  }

  // socket with female connector and flange
  translate(v=[0, d_socket + dd_flange]) {
    color(c="green") {
      difference() {
        union() {
          translate(v=[0, 0, h_flange])
            cylinder(d=d_socket, h=h_socket);
          cylinder(d=d_socket + dd_flange, h=h_flange);
        }
        cylinder(d=d_connector_female, h=h_socket + h_flange);
      }
    }
  }
}
