barWidth = 230; // 230

barHeightBack = 5;
barHeightFront = 8;
barDepth = 20;

backHeight = 55;
backDepth = 5;
backWidth = 80;

gapHeight = 15;
gapWidth = 70;

backOffset = (barWidth - 2 * backWidth - gapWidth) / 2;

module barEnd() {
    polygon([
    [0, 0],
    [0, barHeightBack],
    [barDepth, barHeightFront],
    [barDepth, 0]
    ]);
}

module bar() {
    linear_extrude(height = barWidth)
        barEnd();
}

module back() {
    cube([backWidth, backDepth, backHeight]);
}

module gap() {
    cube([gapWidth, backDepth, gapHeight]);
}

//difference() {
union() {
    rotate([90,0,90]) bar();
    translate([0, 0, 0]) {
        translate([backOffset, 0, 0]) back();
        translate([backOffset + backWidth, 0, 0]) gap();
        translate([backOffset + backWidth + gapWidth, 0, 0]) back();
    }    
}

//union() {
//    color("blue")
//    rotate([-90,0,0])
//    translate([(barWidth-1)/2,4,10]) //5,8])
//    import("C:/Users/me/Downloads/soundbar-v1.stl");
//}
//}
