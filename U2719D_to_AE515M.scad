barLength = 230; // 230
barDepth = 20;

backDepth = 5;
backHeight = 55;

frontHeight = 8;
frontJoinHeight = 6;

gapLength = 70;
gapBase = 15;

gripLength = 42;
gripDepth = 7;
gripHeight = 5;

gripSlideLength = 20;
gripSlideDepth = 1;
gripSlideHeight = 1;

module barProfile() {
    polygon([
        [0, 0],
        [barDepth, 0],
        [barDepth, frontHeight],
        [backDepth, frontJoinHeight],
        [backDepth, backHeight],
        [0, backHeight]
    ]);
}

module bar() {
    linear_extrude(barLength) barProfile();
}

module gapProfile() {
    polygon([
        [-1, gapBase],
        [backDepth + 1, gapBase],
        [backDepth + 1, backHeight + 1],
        [-1, backHeight + 1]
    ]);
}

module gap() {
    translate([0,0,(barLength - gapLength) / 2.0])
        linear_extrude(gapLength) gapProfile();
}

module gripInsetProfile() {
    polygon([
        [0, 0],
        [gripDepth + 2, 0],
        [gripDepth + 2, 1],
        [0, 1]
    ]);
}

module gripInset() {
    linear_extrude(gripLength + 2) gripInsetProfile();
}

module gripSlideProfile() {
    polygon([
        [0, 0],
        [gripSlideDepth + 0.2, 0],
        [gripSlideDepth + 0.2, gripSlideHeight + 0.2],
        [0, gripSlideHeight + 0.2]
    ]);
}

module gripSlide() {
    translate([0,0,-0.1])
        linear_extrude(gripSlideLength + 0.1) gripSlideProfile();
}

module gripBlockProfile() {
    polygon([
        [0, 0],
        [gripDepth, 0],
        [gripDepth, gripHeight],
        [0, gripHeight]
    ]);
}

module gripBlock() {
    difference() {
        linear_extrude(gripLength) gripBlockProfile();
        translate([-0.1, 1.0, 0])
            union() {
                gripSlide();
                translate([gripDepth - gripSlideDepth, 0, 0]) gripSlide();
            };
    }
}

module grip() {
    color("red")
    union() {
        gripInset();
        translate([1, 0, 1]) gripBlock();
    }
}

module adaptor() {
    difference() {
        bar();
        union() {
            translate([10, -0.1, 28]) grip();
            translate([10, -0.1, 177]) grip();
            gap();
        }
    }
}

module original() {
    color("blue")
    rotate([-90,0,0])
    translate([barLength / 2.0, 4, 10.4])
    import("soundbar-v1.stl");
}

//difference() {
    rotate([90,0,90]) adaptor();
//    original();
//}

//rotate([90,0,90]) adaptor();