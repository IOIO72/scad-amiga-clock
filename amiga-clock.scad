/*
Amiga Clock (3 June 2021)
by IOIO72 aka Tamio Patrick Honma

Based on Clock V2.15 from Amiga Workbench 1.2.

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.


Used clockwork for this project:
https://www.amazon.de/gp/product/B08RNJ5SYK/

You can use any other and enter your measurements.

---

Where's the second hand?

Since the second hand has a small pin for mounting, it is not easy to print one that is accurate enough. The purchasable clockwork packages usually include a variety of hands from which you can choose. There should definitely be a second hand that is just a dash, like the one on the Amiga Clock. Use this second hand and paint it orange.


Trivia

The preset time refers to the time displayed on the Amiga clock icon.
The story behind this time is interesting:
http://theamigamuseum.com/amiga-kickstart-workbench-os/workbench/workbench-1-2/


Smartwatch

If you want to wear an Amiga wristwatch as a Wear OS watchface, take a look at my WatchMaker creation:
http://bulletin-board.de/watchfaces/portfolio/amiga-wb-1-2/

*/


/* [Clockwork Enclosure Pins to align clockwork with clock face] */

// Dimameter of the pins
pin_diameter = 2.5;

// Depth of the pins (should be less than face_base_depth)
pin_depth = 1.25;

// Positions of the pins (left top, right top, right bottom, left bottom)
pin_positions = [
  [-21,-23], [21,-23],
  [21,23], [-21,23]
];


/* [Clockwork Hub] */

// Hub diameter
hub_diameter = 7.8;

// Hours hub diameter
hub_hours_diamater = 5.6;

// Minutes hub diameter
hub_minutes_diamater = 3.9;

// Backward hub embossment
hub_embossment = 21.5;


/* [Clock Face Base] */

// Clock face diameter
face_diamater = 160;

// Clock face base depth (should be larger than pin_depth)
face_base_depth = 2.1;

// Emboss depth of content in base
emboss_depth = 0.5;


/* [Clock Face Content] */

// Clock face content depth
face_content_depth = 2.1;

// Clock face border
face_border_size = 2.1;

// Clock face content margin
face_content_margin = 4.1;

// Minutes size (rectangle)
minutes_size = [5.1,1.1];

// Hours size (rhombus)
hours_size = [10.1,8.1];


/* [Clock Hands] */

// Hands depth
hands_depth = 1.5;

// Hands margin from hours rhombus'
hands_margin = 2.1;

// Hour hand height
hour_hand_height = 8.1;

// Minute hands height
minute_hand_height = 6.5;

// Clock time hour
clock_time_hour = 11; // [1:12]

// Clock time minute
clock_time_minute = 38; // [0:59]

// Mount ring border size
hands_mount_ring_border_size = 10.1;


/* [Modify Parts] */

// Fastening elements
fastening_elements = true;


/* [Select Parts] */

// Clock face base
clock_face_base = true;

// Clock face content
clock_face_content = true;

// Clock hours hand
clock_hour_hand = true;

// Clock minutes hand
clock_minute_hand = true;


/* [Test Parts] */

// Measurements test parts
measurements_test_parts = false;

// Test parts label tag width
test_tag_width = 40;

// Tags with values instead of labels
test_tag_values = false;


/* [Advanced] */

// Number of fragments
$fn = 100; // [1:200]

// Debug mode
debug = false;


/* [Hidden] */

face_inner_diameter = face_diamater - 2 * face_border_size;
face_content_diameter = face_inner_diameter - face_content_margin;
hands_content_diameter = face_content_diameter - hours_size[0] * 2 - hands_margin * 2;
minute_hand_length = hands_content_diameter / 2;
hour_hand_length = minute_hand_length / 1.4;

test_parts = [
  [hub_diameter, "HUB"],
  [hub_hours_diamater, "HUB HOURS"],
  [hub_minutes_diamater, "HUB MINUTES"],
  [pin_diameter, "PIN DIAMETER"]
];


module ring(_diameter, _inner_diameter) {
  difference() {
    circle(d = _diameter);
    circle(d = _inner_diameter);
  };
};

module rhombus(_width, _inbetween_width, _height) {
  polygon([
    [0, 0],
    [_inbetween_width, _height / 2],
    [_width, 0],
    [_inbetween_width, - _height / 2]
  ]);
};

module face_content() {

  // Border
  ring(face_diamater, face_inner_diameter);

  // Minutes
  for(i = [1:60]) {
    if (i % 5 != 0) {
      rotate([0, 0, i * 6])
      translate([face_content_diameter / 2 - minutes_size[0] / 2, 0, 0])
      square(minutes_size, center = true);
    };
  };

  // Hours
  for (i = [1:12]) {
    rotate([0, 0, i * 30])
    translate([face_content_diameter / 2 - hours_size[0], 0, 0])
    rhombus(hours_size[0], hours_size[0] / 2, hours_size[1]);
  };
};

module clock_hand(
  _hand_length,
  _hand_inbetween_width,
  _hand_height,
  _hub_diamater,
  _hub_mount_diamater,
  _with_fastening
) {
  difference() {
    union() {
      rhombus(_hand_length, _hand_inbetween_width, _hand_height);
      if (_with_fastening) {
        ring(
          _hub_mount_diamater,
          _hub_diamater
        );
      };
    };
    if (fastening_elements) {
      circle(d=_hub_diamater);
    };
  };
};


// Face Base
module alignment_pins() {
  for (i = pin_positions) {
    rotate([0, 0, 180]) {
      translate(i) {
        circle(d = pin_diameter);
        if (debug) {
          text(str(i), size = 6);
        };
      };
    };
  };
};

if (clock_face_base) {
  color(debug ? "#66aa99" : "#ffffff") {
    if (fastening_elements) {
      difference() {
        linear_extrude(face_base_depth) circle(d = face_diamater);
        linear_extrude(face_base_depth) circle(d = hub_diameter);

        // Alignment Pins
        linear_extrude(pin_depth) {
          alignment_pins();
          circle(d = hub_embossment);
        };
        
        // Emboss Face Content
        translate([0, 0, face_base_depth - emboss_depth]) {
          linear_extrude(emboss_depth) face_content();
        };
      };
    } else {
      linear_extrude(face_base_depth) circle(d = face_diamater);
    };
  };
};


// Face Content
if (clock_face_content) {
  color(debug ? "#6699bb" : "#000000") {
    translate([0, 0, fastening_elements ? face_base_depth - emboss_depth : face_base_depth]) {
      linear_extrude(fastening_elements ? face_content_depth + emboss_depth : face_content_depth) {
        face_content();
      };
    };
  };
};

// Hours Hand
if (clock_hour_hand) {
  color(debug ? "#cc6699" : "#000000") {
    translate([0, 0, fastening_elements ? face_base_depth + face_content_depth : face_base_depth]) {
      rotate([0, 0, 90 - clock_time_hour * 30 - clock_time_minute / 2]) {
        linear_extrude(hands_depth) {
          clock_hand(
            hour_hand_length,
            hour_hand_length / 1.3,
            hour_hand_height,
            hub_hours_diamater,
            hub_diameter + hands_mount_ring_border_size,
            fastening_elements
          );
        };
      };
    };
  };
};


// Minutes Hand
module minute_hand_part(_with_fastening) {
  linear_extrude(hands_depth / 2) {
    clock_hand(
      minute_hand_length,
      minute_hand_length / 1.24,
      minute_hand_height,
      hub_minutes_diamater,
      hub_diameter + hands_mount_ring_border_size,
      _with_fastening
    );
  };
};

if (clock_minute_hand) {
  color(debug ? "#dd9966" : "#000000") {
    translate([0, 0, fastening_elements ? face_base_depth + face_content_depth + hands_depth : face_base_depth]) {
      rotate([0, 0, 90 - clock_time_minute * 6]) {
        minute_hand_part(fastening_elements);
        translate([0, 0, hands_depth / 2]) {
          minute_hand_part(false);
        };
      };
    };
  };
};


// Measurements test parts
module test_part_tag(tag = [10, "undefined"]) {
  linear_extrude(0.4) {
    difference() {
      square([test_tag_width, tag[0] + 2], center = true);
      translate([- test_tag_width / 2 + tag[0] / 2 + 2, 0, 0]) {
        circle(d = tag[0]);
      };
    };
  };
  translate([- test_tag_width / 2 + tag[0] + 4, 0, 0.4]) {
    linear_extrude(0.8)
    text(test_tag_values ? str(tag[0]) : tag[1], size = 3, font = "Arial:style=Bold", halign="left", valign="center");
  };
 
};

if (measurements_test_parts) {
  translate([face_diamater + 5, 0, 0]) {
    for (i = [0 : len(test_parts) - 1]) {
      translate([0, i * 30, 0])
      test_part_tag(test_parts[i]);
    };
  
    // Alignment Pins
    translate([test_tag_width + 8, -50, 0]) {
      linear_extrude(0.4) {
        difference() {
          offset(pin_diameter) rotate([0, 0, 180]) polygon(pin_positions);
          rotate([0, 0, 180]) polygon(pin_positions);
          alignment_pins();
        };
      };
    };
    
    // Hub embossment
    translate([test_tag_width + 8, -50, 0]) {
      linear_extrude(pin_depth) {
        difference() {
          offset(pin_diameter) circle(d = hub_embossment);
          circle(d = hub_embossment);
        };
      };
    };

  };
};
