final String appname = "Raumplaner 2020";
final String appversion = "0.5.1";

class Point {
	int xpos=0;
	int ypos=0;
}
class RPoint extends Point{
	float rot=0;
}

class PWH extends Point {
	int _width=0;
	int _height=0;
}

void settitle(String name) {
  	surface.setTitle(appname + " - "+appversion + ": " + name);
}