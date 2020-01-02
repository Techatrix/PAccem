class ApplicationManager {
	String setfontrawinput = ""; // is being used by Thread in setFontRaw()

	ApplicationManager() {
		toovmessages = new ArrayList<String>();
		if(deb) {
			toovmessages.add("Loading ApplicationManager");
		}
	}

	void initSettings() { // is being executed once before the window is created
		manageArgs();
		st = new Settings();
		allowcgol=false;
		usegl = st.booleans[3].value;
		if(st.booleans[2].value) { // full screen
			fullScreen(usegl ? P2D : JAVA2D);  // creates the window and chooses a renderer according to the opengl setting
		} else { // not full screen
			size(max(st.ints[0].value, 600),max(st.ints[1].value,600), usegl ? P2D : JAVA2D); // MIN: 600 x 600
		}
		if(usegl) {
			PJOGL.setIcon("data/assets/icon/0.png"); // sets the window icon on opengl renderer
		}
		smooth(st.ints[2].value);	// anti-aliasing
		recalculateColor();
	}

	void initSetup() { // is being executed once after the window is being created
		if(usegl) { // creates graphics according to the opengl setting
			pg = createGraphics(width,height, P3D);
			pg.smooth(st.ints[2].value);				// anti-aliasing

			if(!disableblur) {
				try {
					blurshader = loadShader("data/assets/shader/blur.glsl");	// Load blur shader
					blurshader.init();
					// pass uniforms on to the shader
					//blurshader.set("blurSize", 9);
					//blurshader.set("sigma", 3.0);
					//blurshader.set("samplesize", 1);

					// pixelate shader
					//blurshader = loadShader("data/assets/shader/pixelate.glsl");
  					//blurshader.set("resolution", float(width), float(height));
				} catch(RuntimeException e) {
					disableblur = true;
					toovmessages.add("Shader RuntimeException: " + e);
					toovmessages.add("Disabled blur");
				}
			}
		}
		cl = new Clipper();								// initialize clipper
		lg = new LanguageManager(st.strings[1].value);	// initialize languagemanager
		dm = new DataManager();							// initialize datamanager
		rm = new RoomManager();							// initialize roommanager
		ov = new OverlayManager();						// initialize overlaymanager
		
		if(toovmessages.size() == 1) {
			ov.checkMessages();
			ov.drawconsole = false;
		}
		ov.checkMessages();

		int[] invalidids = dm.validate();
		for (int id : invalidids) {
			toovmessages.add(dm.prefabs[id].name + " is invalid!");
		}

		if(!usegl) {
	  		surface.setIcon(dm.icons[0]); // sets the window icon on not opengl renderer
		}
		setFont(st.strings[2].value);
		textSize(16);
	}

	void setTitle(String name) { // sets the window title
	  	surface.setTitle(appname + " - "+ appversion + ": " + name);
	}

	void setFont(String newfontname) { // sets the current font
		newfontname = newfontname.toLowerCase();
		/*  checks if the newfontname is any variant of Roboto (default font on Android and developed by Google)
		 *  would also work without but would require to execute a thread so it can save some time
		 */ 
		boolean isroboto = false;

		String[] robotofontnames = {"roboto", "roboto black","roboto black italic", "roboto bold", "roboto bold italic", "roboto italic", "roboto light", "roboto light italic", "roboto medium", "roboto medium italic", "roboto thin",  "roboto thin italic"};
		for (String robotofont : robotofontnames) {
			if(robotofont.equals(newfontname)) {
				isroboto = true;
				break;
			}
		}
		if(isroboto) {
			String newfont = "data/assets/font/Roboto";
			String[] keywords = split(newfontname, " ");

			if(keywords.length > 1) {
				switch(keywords[1]) {
					case "black":
					newfont += "-Black";
					break;
					case "bold":
					newfont += "-Bold";
					break;
					case "light":
					newfont += "-Light";
					break;
					case "medium":
					newfont += "-Medium";
					break;
					case "thin":
					newfont += "-Thin";
					break;
					case "italic":
					newfont += "-RegularItalic";
					break;
				}
				if(keywords.length > 2) {
					if(keywords[2].equals("italic")) {
						newfont += "Italic";
					}
				}
			} else {
				newfont += "-Regular";
			}
			newfont += ".ttf";
			font = createFont(newfont, 16);
			textFont(font);
			if(usegl) {
				pg.textFont(font);
			}
		} else { // execute setfontrawthread on a separate thread to not hang the main thread
			setfontrawinput = newfontname;
			thread("setfontrawthread");
		}
	}

	void setFontRaw() { // uses the chosen font if available or fall back to the default font (Roboto Regular)
		boolean hit = false;
		String[] fontnames = PFont.list();
		for (String fontname : fontnames) {
			if(fontname.toLowerCase().equals(setfontrawinput)) {
				hit = true;
				break;
			}
		}
		if(hit) {
			font = createFont(setfontrawinput, 16);
		} else {
			font = createFont("data/assets/font/Roboto-Regular.ttf", 16);
		}
		textFont(font);
		if(usegl) {
			pg.textFont(font);
		}
	}

	void recalculateColor() { // recalculates the easily accessible color values according to the dark mode setting
		boolean isdm = st.booleans[0].value;

		for (int i=0;i<c.length;i++) {
			c[i] = isdm ? 255-32*i : 32*i;
			c[i] = constrain(c[i], 0, 255);
		}
	}

	void manageArgs() {	// handles all arguments which have been handed over to the program
		if(args != null) {
			for (String arg : args) {
				if(arg.equals("-debug")) {
					deb = true;
					toovmessages.add("Debugmode activated");
				} else if(arg.equals("-noblur")) {
					disableblur = true;
				}
			}
		}
	}

	void loop() { // set window size according to the width & height setting
		int sw = st.ints[0].value;
		int sh = st.ints[1].value;
		if(width != sw || height != sh) {
			st.ints[0].setValue(width);	
			st.ints[1].setValue(height);
			if(usegl) {
				pg.setSize(width,height);
			}
			ov.build();
		}
	}

}

// this is the only way (i know) how to execute a function in a class in thread()
void setFontRawThread() { // used for in "void setfont(String newfontname)"
	am.setFontRaw();
}