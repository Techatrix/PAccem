Settings st;
Roommanager rm;
Overlay ov;
ImageManager im;

PGraphics pg;
PFont font;

void settings() {
	im = new ImageManager();
	st = new Settings();

	if(st.booleans[3].getvalue()) {
		fullScreen(P2D);
	} else {
		int sw = st.ints[0].getvalue();
		int sh = st.ints[1].getvalue();
		size((sw < 600 ? 600 : sw),(sh < 600 ? 600 : sh), P2D); // MIN: 500x500
	}
	smooth(4);
}
void setup() {
	rm = new Roommanager();
	ov = new Overlay();

	font = createFont("assets/font/Roboto-Regular.ttf", 16);
	textFont(font);

    noClip();
	pg = createGraphics(width,height, P3D);
	pg.smooth(4);
	pg.textFont(font);

	//noLoop();
	//redraw();
  	//surface.setResizable(true);
  	//surface.setLocation(100, 100);
}

void mouseWheel(MouseEvent e) {
	boolean block = false;;
	if(ov.popup != null) {
		if(ov.popup.visible) {
			block = true;
		}
	}
	if(!block) {
		rm.mouseWheel(e);
	}
}
void mouseDragged() {
	boolean block = false;;
	if(ov.popup != null) {
		if(ov.popup.visible) {
			block = true;
		}
	}
	if(!block) {
		rm.mouseDragged();
	}
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
	ov.keyPressed();
	rm.keyPressed();
}

void draw() {
	rm.draw();
	ov.draw();
}