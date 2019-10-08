Settings st;
Roommanager rm;
Overlay ov;
DataManager dt;
LanguageManager lg;
Debugger db;

PGraphics pg;
PFont font;

void settings() {
	st = new Settings();

	if(st.booleans[2].getvalue()) {
		fullScreen(highbit ? P2D : JAVA2D);
	} else {
		int sw = st.ints[0].getvalue();
		int sh = st.ints[1].getvalue();
		size(max(sw, 600),max(sh,600), highbit ? P2D : JAVA2D); // MIN: 500 x 500
	}
	if(highbit) {
		PJOGL.setIcon("assets/icon/0.png");
	}
	smooth(4);
}
void setup() {
	lg = new LanguageManager(st.strings[1].getvalue());
	rm = new Roommanager();
	db = new Debugger();
	ov = new Overlay();

	if(highbit) {
		pg = createGraphics(width,height, P3D);
		pg.smooth(4);
		dt = new DataManager();
	} else {
  		surface.setIcon(dt.icons[0]);
	}

	setfont(st.strings[2].getvalue());
	textSize(16/((st.floats[1].getvalue()+1)/2));

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
