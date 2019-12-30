ApplicationManager am;	// manages the overall application (title, size, initialization)
Settings st;			// loads and stores the current settings
LanguageManager lg;		// loads the current language file
RoomManager rm;			// manages the room(grid, furniture & user input)
DataManager dm;			// stores data (3D-models, images, etc.)
OverlayManager ov;		// creates and manages the GUI
Clipper cl;				// allows pushing and popping of clip()

PGraphics pg;			// used for 3D-graphics
PShader blurshader;		// blur shader
PFont font;				// the current font
boolean usegl;			// opengl setting when the application has started
boolean allowcgol;		// ?
ArrayList<String> toovmessages;// messages which are send to the overlay

int[] c = new int[9];	// easily accessible color values (0-8 => 0 - 255 or 255 - 0)
boolean isKeyUp, isKeyRight, isKeyLeft, isKeyDown, isKeyT;	// state of these keys
boolean deb = false;	// debug mode
boolean disableblur = false;	// whether or not blur is disabled

/* --------------- main --------------- */
void settings() { // is being executed once before the window is created	(pre-main())
	am = new ApplicationManager();
	am.initSettings();
}
void setup() { // is being executed once after the window is being created 	(main())
	am.initSetup();
}

void draw() { // is being executed on every frame
	am.loop();	// application manager
	rm.draw();	// room manager
	ov.draw();	// overlay
	ov.checkMessages();	// check toovmessages for any messages
}

/* --------------- mouse input --------------- */
void mouseWheel(MouseEvent e) {
	ov.mouseWheel(e);
	if(ov.isHit()) {
		return;
	}
	rm.mouseWheel(e);
}
void mouseDragged() {
	ov.mouseDragged();
	if(ov.isHit()) {
		return;
	}
	rm.mouseDragged();
}
void mouseReleased() {
	ov.mouseReleased();
	rm.mouseReleased();
}
void mousePressed() {
	if(ov.isHit() | ov.mousePressed()) {
		return;
	}
	rm.mousePressed();
}
/* --------------- keyboard input --------------- */
void keyPressed(KeyEvent e) {
	ov.keyPressed(e);
	if(ov.isHit()) {
		return;
	}
	rm.keyPressed(e);
}
void keyReleased() {
	ov.keyReleased();
	rm.keyReleased();
}
