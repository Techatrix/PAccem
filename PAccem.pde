//import java.util.Map;
//import java.io.*;
//import java.util.stream.IntStream;

ApplicationManager am;	// manages the overal application (title, size, initialization)
Settings st;			// loads and stores the current settings
LanguageManager lg;		// loads the current language file
RoomManager rm;			// manages the room(grid, furniture & user input)
DataManager dm;			// stores data (3D-models, images, etc.)
Overlay ov;				// draws & manages the user interface
//InstructionManager im;// manages all previously executed instructions to allow Strg+Z, undo feature	abandoned

PGraphics pg;			// used for 3D-graphics
PFont font;				// the current font
boolean usegl;			// opengl setting when the application has started

int[] c = new int[9];	// easily accessible color values (0-8 => 0 - 255 or 255 - 0)
boolean isKeyUp, isKeyRight, isKeyLeft, isKeyDown, isKeyT;	// stores whether or not a arrow key is down

/* --------------- Experimental Version! WIP --------------- */
/* 
 * InstructionManager (Strg+Z, undo feature)		abandoned
 * message box/console								console abandoned
 * improved datastorage								delayed
 * furniture color
 * Slider, Checkbox									Slider complete
 * debugmode setting
*/


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
	/*	bluring
	loadPixels();
	int ww=300;
	int hh=300;

	int[] weights = {1, 2, 1, 2, 4, 2, 1, 2, 1};
	int weightWidth = 3;



    for (int h = hh - weights.length / weightWidth + 1, w = ww - weightWidth + 1, y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
            int r = 0;
            int g = 0;
            int b = 0;
            for (int filterIndex = 0, pixelIndex = y * width + x;filterIndex < weights.length;pixelIndex ++) {
                for (int fx = 0; fx < weightWidth; fx++, pixelIndex++, filterIndex++) {
                    color col = pixels[pixelIndex];
                    int factor = weights[filterIndex];

                    // sum up color channels seperately
                    r += red(col) * factor;
                    g += green(col) * factor;
                    b += blue(col) * factor;
                }
            }
            r /= 16;
            g /= 16;
            b /= 16;
            // combine channels with full opacity
            pixels[y * width + x] = color(r,g,b);
        }
    }
    
	/*
	for (int x=0;x<100;x++) {
		for (int y=0;y<100;y++) {
			int i=0;
			int r=0;
			int g=0;
			int b=0;
			for (int dx=-5;dx<5;dx++) {
				for (int dy=-5;dy<5;dy++) {
					if(x+dx > -1 && y+dy> -1) {
						color c = pixels[(y+dy)*width+x+dx];
						r += red(c);
						g += green(c);
						b += blue(c);
						i++;
					}
				}
			}
			r /= i;
			g /= i;
			b /= i;
			pixels[y*width+x] = color(r,g,b);
		}
	}
	*/
	/*
	updatePixels();
	*/
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
	ov.mousePressed();
	if(ov.ishit()) {
		return;
	}
	rm.mousePressed();
}
/* --------------- keyboard input --------------- */
void keyPressed(KeyEvent e) {
	ov.keyPressed();
	if(ov.ishit()) {
		return;
	}
	rm.keyPressed(e);
}
void keyReleased() {
	ov.keyReleased();
	rm.keyReleased();
}