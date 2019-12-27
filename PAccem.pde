//import java.util.Map;
//import java.io.*;
//import java.util.stream.IntStream;

ApplicationManager am;	// manages the overal application (title, size, initialization)
Settings st;			// loads and stores the current settings
LanguageManager lg;		// loads the current language file
RoomManager rm;			// manages the room(grid, furniture & user input)
DataManager dm;			// stores data (3D-models, images, etc.)
OverlayManager ov;		// creates and manages the GUI

PGraphics pg;			// used for 3D-graphics
PFont font;				// the current font
boolean usegl;			// opengl setting when the application has started
boolean allowcgol;// ?
ArrayList<String> toovmessages;// messages which are send to the overlay
PShader blurshader;

int[] c = new int[9];	// easily accessible color values (0-8 => 0 - 255 or 255 - 0)
boolean isKeyUp, isKeyRight, isKeyLeft, isKeyDown, isKeyT;	// stores whether or not a arrow key is down

/* --------------- Experimental Version! WIP --------------- */

/* --------------- main --------------- */
void settings() { // is being executed once before the window is created	(pre-main())
	am = new ApplicationManager();
	am.initsettings();
}
void setup() { // is being executed once after the window is being created 	(main())
	am.initsetup();
	/*	serialization
	try {
		SETemp t = new SETemp(1);
		FileOutputStream fout= new FileOutputStream(sketchPath("f.txt"));  
		ObjectOutputStream out=new ObjectOutputStream(fout);  
		out.writeObject(t);  
		out.flush();   
		out.close();  
		println("success");  
	} catch (IOException i) {
		i.printStackTrace();
	}
	*/
}

void draw() { // is being executed on every frame
	am.loop();	// application manager
	rm.draw();	// room manager
	ov.draw();	// overlay
}

/* --------------- mouse input --------------- */
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
	if(ov.ishit() | ov.mousePressed()) {
		return;
	}
	rm.mousePressed();
}
/* --------------- keyboard input --------------- */
void keyPressed(KeyEvent e) {
	rm.getpricereport();
	ov.keyPressed(e);
	if(ov.ishit()) {
		return;
	}
	rm.keyPressed(e);
}
void keyReleased() {
	ov.keyReleased();
	rm.keyReleased();
}