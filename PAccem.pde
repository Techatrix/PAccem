ApplicationManager am;
Settings st;
LanguageManager lg;
Roommanager rm;
DataManager dm;
Debugger db;
Overlay ov;

PGraphics pg;
PFont font;

void settings() {
	am = new ApplicationManager();
	am.initsettings();
}
void setup() {
	am.initsetup();
}

void mouseWheel(MouseEvent e) {
	if(ov.popup.visible) {
		return;
	}
	if(!ov.ishit()) {
		rm.mouseWheel(e);
	}
}
void mouseDragged() {
	if(ov.popup.visible) {
		return;
	}
	ov.mouseDragged();
	rm.mouseDragged();
}
void mouseReleased() {
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
	am.draw();
	rm.draw();
	ov.draw();
}
