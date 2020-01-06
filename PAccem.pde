ApplicationManager am;	// manages the overall application (title, size, initialization)
Settings st;			// loads and stores the current settings
LanguageManager lg;		// loads the current language file
RoomManager rm;			// manages the room(grid, furniture & user input)
DataManager dm;			// stores data (3D-models, images, etc.)
OverlayManager ov;		// creates and manages the GUI
Clipper cl;				// allows pushing and popping of clip()

PGraphics pg;			// used for 3D-graphics
PGraphics shadowMap;	// shadow map framebuffer
PShader defaultShader;	// default shader which draws the 3D View  with shadow mapping
PFont font;				// the current font
ArrayList<String> toovmessages; // messages which are send to the overlay

PVector lightdir = new PVector(-80, 160, -140);	// light direction in 3D
int[] c = new int[9];	// easily accessible color values (0-8 => 0 - 255 or 255 - 0)
boolean isKeyUp, isKeyRight, isKeyLeft, isKeyDown, isKeyT;	// state of these keys

// arguments
boolean allowcgol = false;		// ?
boolean usegl = false;			// opengl setting when the application has started
boolean usefilters = true;		// whether or not filters are disabled
boolean useshadowmap = true;	// whether or not shadow mapping should be used
boolean deb = false;			// debug mode

/* --------------- main --------------- */
void settings() { // is being executed once before the window is created (pre-main())
	am = new ApplicationManager();
	am.initSettings();
}

void setup() { // is being executed once after the window is being created (main())
	am.initSetup();
}

void draw() { // is being executed on every frame
	am.loop();	// application manager
	rm.draw();	// room manager
	ov.draw();	// overlay
	ov.checkMessages();	// check toovmessages for any messages
}

/* --------------- mouse input --------------- */
void mousePressed() {
	if(ov.isHit() | ov.mousePressed()) {
		return;
	}
	rm.mousePressed();
}
void mouseReleased() {
	ov.mouseReleased();
	rm.mouseReleased();
}
void mouseDragged() {
	ov.mouseDragged();
	if(ov.isHit()) {
		return;
	}
	rm.mouseDragged();
}
void mouseWheel(MouseEvent e) {
	ov.mouseWheel(e);
	if(ov.isHit()) {
		return;
	}
	rm.mouseWheel(e);
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
