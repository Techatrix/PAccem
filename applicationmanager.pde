class ApplicationManager {
	String setfontrawinput = "";

	ApplicationManager() {
		if(deb) {
		println("Loaded ApplicationManager");
		}
	}

	void initsettings() {
		st = new Settings();
		if(st.booleans[2].getvalue()) {
			fullScreen(st.booleans[2].getvalue() ? P2D : JAVA2D);
		} else {
			size(max(st.ints[0].getvalue(), 600),max(st.ints[1].getvalue(),600), st.booleans[3].getvalue() ? P2D : JAVA2D); // MIN: 500 x 500
		}
		if(st.booleans[3].getvalue()) {
			PJOGL.setIcon("data/assets/icon/0.png");
		}
		smooth(st.ints[2].getvalue());
		recalculatecolor();
	}
	void initsetup() {
		if(st.booleans[3].getvalue()) {
			pg = createGraphics(width,height, P3D);
			pg.smooth(st.ints[2].getvalue());
		}
		lg = new LanguageManager(st.strings[1].getvalue());
		dm = new DataManager();
		rm = new Roommanager();
		db = new Debugger();
		ov = new Overlay();

		if(!st.booleans[3].getvalue()) {
	  		surface.setIcon(dm.icons[0]);
		}
		setfont(st.strings[2].getvalue());
		textSize(16/((st.floats[1].getvalue()+1)/2));
	}

	void settitle(String name) {
	  	surface.setTitle(appname + " - "+ appversion + ": " + name);
	}

	void setfont(String newfontname) {
		newfontname = newfontname.toLowerCase();
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
			font = createFont(newfont, 16/((st.floats[1].getvalue()+1)/2), true);
			textFont(font);
			if(st.booleans[3].getvalue()) {
				pg.textFont(font);
			}
		} else {
			setfontrawinput = newfontname;
			thread("setfontraw");
		}
	}
	void setfontraw() {
		boolean hit = false;
		String[] fontnames = PFont.list();
		for (String fontname : fontnames) {
			if(fontname.toLowerCase().equals(setfontrawinput)) {
				hit = true;
				break;
			}
		}
		if(hit) {
			font = createFont(setfontrawinput, 16/((st.floats[1].getvalue()+1)/2), true);
		} else {
			font = createFont("data/assets/font/Roboto-Regular.ttf", 16/((st.floats[1].getvalue()+1)/2), true);
		}
		textFont(font);
		if(st.booleans[3].getvalue()) {
			pg.textFont(font);
		}
	}

	void recalculatecolor() {
		boolean isdm = st.booleans[0].getvalue();

		for (int i=0;i<c.length;i++) {
			c[i] = isdm ? 255-32*i : 32*i;
			c[i] = constrain(c[i], 0, 255);
		}
	}
	void loop() {
		int sw = st.ints[0].getvalue();
		int sh = st.ints[1].getvalue();
		if(width != sw || height != sh) {
			st.ints[0].setvalue(width);
			st.ints[1].setvalue(height);
			ov.refresh();
			if(st.booleans[3].getvalue()) {
				pg.setSize(width,height);
			}
		}
	}

}