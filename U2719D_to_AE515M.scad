barLength = 230;
barDepth = 20;

backDepth = 3;
backHeight = 40;

frontHeight = 8;
frontJoinHeight = 6;

midGapBase = 15;
midGapLength = 70;
sideGapBase = frontJoinHeight;
sideGapLength = 30;

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

module gapProfile(base) {
    polygon([
        [-1, base],
        [backDepth + 1, base],
        [backDepth + 1, backHeight + 1],
        [-1, backHeight + 1]
    ]);
}

module gap(base, length) {
    linear_extrude(length) gapProfile(base);
}

module gaps() {
    union() {
        translate([0, 0, -0.1]) gap(sideGapBase, sideGapLength + 0.1);
        translate([0, 0, (barLength - midGapLength) / 2.0]) gap(midGapBase, midGapLength);
        translate([0, 0, barLength - sideGapLength]) gap(sideGapBase, sideGapLength + 0.1);
    }
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

module grips() {
    translate([10, -0.1, 28]) grip();
    translate([10, -0.1, 177]) grip();
}

module adaptor() {
    difference() {
        bar();
        union() {
            grips();
            gaps();
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
