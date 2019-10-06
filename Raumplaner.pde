Settings st;
Roommanager rm;
Overlay ov;
ImageManager im;
Debugger db;

PGraphics pg;
PFont font;


void settings() {
	im = new ImageManager();
	st = new Settings();

	if(st.booleans[2].getvalue()) {
		fullScreen(P2D);
	} else {
		int sw = st.ints[0].getvalue();
		int sh = st.ints[1].getvalue();
		size((sw < 600 ? 600 : sw),(sh < 600 ? 600 : sh), P2D); // MIN: 500 x 500
	}
	smooth(4);
}
void setup() {
	rm = new Roommanager();
	db = new Debugger();
	ov = new Overlay();

    // 3D Plane
	pg = createGraphics(width,height, P3D);
	pg.smooth(4);
	/*
	for (String newfont : robotofontnames) {
		println("SetFont: " + newfont);
		setfont(newfont);
	}
	*/
	setfont(st.strings[2].getvalue());



	//noLoop();
	//redraw();
  	//surface.setResizable(true);
  	//surface.setLocation(100, 100);
  	//link("https://www.google.com/");
  	// add public static void main(String[] args)
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
	ov.mousePressed();
	if(!ov.ishit()) {
		rm.mousePressed();
	}
}
void keyPressed() {
	ov.keyPressed();
	rm.keyPressed();
}

void draw() {
	background(0);
	int sw = st.ints[0].getvalue();
	int sh = st.ints[1].getvalue();
	if(width != sw || height != sh) {
		st.ints[0].setvalue(width);
		st.ints[1].setvalue(height);
		ov.refresh();
	}
	rm.draw();
	ov.draw();
}