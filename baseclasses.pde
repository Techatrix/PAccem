// Point
class Point {
	int xpos = 0;
	int ypos = 0;
}
//Width Height
class WH {
	int _width = 0;
	int _height = 0;
}
// Point Width Height
class PWH extends Point {
	int _width = 0;
	int _height = 0;
}
// Rotation and Point 
class RPoint extends Point {
	float rot = 0;
}
// Rotation and Point Width Height
class RPWH extends PWH {
	float rot = 0;
}
// holds a integer (used for final variable in abstract class)
class Temp {
	int i;
	Temp(int i) {
		this.i = i;
	}
}
// holds a string (used for final variable in abstract class)
class STemp {
	String s;
	STemp(String s) {
		this.s = s;
	}
}