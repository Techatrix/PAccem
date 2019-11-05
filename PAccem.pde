ApplicationManager am;
Settings st;
LanguageManager lg;
Roommanager rm;
DataManager dm;
Debugger db;
Overlay ov;

PGraphics pg;
PFont font;

int[] c = new int[9];
boolean isKeyUp, isKeyRight, isKeyLeft, isKeyDown, isKeyT;

void settings() {
	am = new ApplicationManager();
	am.initsettings();
}
void setup() {
	am.initsetup();
}

void mouseWheel(MouseEvent e) {
	if(!ov.ishit()) {
		rm.mouseWheel(e);
	}
}
void mouseDragged() {
	if(!ov.mouseDragged()) {
		rm.mouseDragged();
	}
}
void mouseReleased() {
	ov.mouseReleased();
	rm.mouseReleased();
}

void mousePressed() {
	if(!ov.mousePressed()) {
		rm.mousePressed();
	}
}
void keyPressed() {
	if(!ov.keyPressed()) {
		rm.keyPressed();
	}
}
void keyReleased() {
	rm.keyReleased();
}

void draw() {
	am.loop();
	rm.draw();
	ov.draw();
}
