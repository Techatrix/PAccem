class Temp {int i; Temp(int i) {this.i = i;}}

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
		String newfont = "assets/font/Roboto";
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
		if(highbit) {
			pg.textFont(font);
		}
	} else {
		setfontrawinput = newfontname;
		thread("setfontraw");
	}
}
String setfontrawinput = "";
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
		font = createFont("assets/font/Roboto-Regular.ttf", 16/((st.floats[1].getvalue()+1)/2), true);
	}
	textFont(font);
	if(highbit) {
		pg.textFont(font);
	}
}

String getabout() {
	String text = appname + "\n";
	text += lg.get("version") + ": " + appversion + "\n";
	text += lg.get("programmedwith") + ": " + "Processing" + "\n";
	text += lg.get("madeby") + ": " + appmaker + "\n";
	return text;
}

void settitle(String name) {
  	surface.setTitle(appname + " - "+ appversion + ": " + name);
}
boolean isKeyUp, isKeyRight, isKeyLeft, isKeyDown;
void setKey(int k, boolean bool) {
  if      (k == UP    | k == 'W')   isKeyUp    = bool;
  else if (k == DOWN  | k == 'S')   isKeyDown  = bool;
  else if (k == LEFT  | k == 'A')   isKeyLeft  = bool;
  else if (k == RIGHT | k == 'D')   isKeyRight = bool;
}


int[] c = new int[9];
void recalculatecolor() {
	boolean isdm = st.booleans[0].getvalue();

	for (int i=0;i<c.length;i++) {
		c[i] = isdm ? 255-32*i : 32*i;
		c[i] = constrain(c[i], 0, 255);
	}
}

boolean checkraw(int xpos, int ypos, int _width, int _height) {
	float scale = st.floats[1].getvalue();
	if (mouseX >= xpos*scale && mouseX <= (xpos+_width)*scale && 
	    mouseY >= ypos*scale && mouseY <= (ypos+_height)*scale) {
	  	return true;
	}
	return false;
}