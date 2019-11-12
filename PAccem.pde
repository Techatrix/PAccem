ApplicationManager am;
Settings st;
LanguageManager lg;
Roommanager rm;
DataManager dm;
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

void draw() {
	push();
	am.loop();
	rm.draw();
	pop();
	ov.draw();
}

void mouseWheel(MouseEvent e) {
	ov.mouseWheel(e);
	if(ov.ishit()) {
		return;
	}
	rm.mouseWheel(e);
}
void mouseDragged() {
	ov.mouseDragged();
	if(ov.ishit()) {
		return;
	}
	rm.mouseDragged();
}
void mouseReleased() {
	ov.mouseReleased();
	rm.mouseReleased();
}
void mousePressed() {
	ov.mousePressed();
	if(ov.ishit()) {
		return;
	}
	rm.mousePressed();
}
void keyPressed() {
	ov.keyPressed();
	if(ov.ishit()) {
		return;
	}
	rm.keyPressed();
}
void keyReleased() {
	ov.keyReleased();
	rm.keyReleased();
}