final String appname = "PAccem"; // Raumplaner 2020, Roccem, PAccem
final String appversion = "0.5.3";
final String appmaker = "Techatrix";
final boolean lowbit = false; // true if 32bit

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
		font = createFont(newfont, 16/((st.floats[1].getvalue()+1)/2));
		textFont(font);
		pg.textFont(font);
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
		font = createFont(setfontrawinput, 16/((st.floats[1].getvalue()+1)/2));
	} else {
		font = createFont("assets/font/Roboto-Regular.ttf", 16/((st.floats[1].getvalue()+1)/2));
	}
	textFont(font);
	pg.textFont(font);
}

String getabout() {
	String text = appname + "\n";
	text += "Version: " + appversion + "\n";
	text += "Made with: " + "Processing" + "\n";
	text += "Made by: " + appmaker + "\n";
	//text += "\n";
	//text += "Help";
	return text;
}

// Point => Xposition and Yposition
class Point {
	int xpos=0;
	int ypos=0;
}
// Point and Rotation
class RPoint extends Point {
	float rot=0;
}

// Point Width and Height
class PWH extends Point {
	int _width=0;
	int _height=0;
}

void settitle(String name) {
  	surface.setTitle(appname + " - "+ appversion + ": " + name);
}
boolean checkraw(int xpos, int ypos, int _width, int _height) {
	float scale = st.floats[1].getvalue();
	if (mouseX >= xpos*scale && mouseX <= (xpos+_width)*scale && 
	    mouseY >= ypos*scale && mouseY <= (ypos+_height)*scale) {
	  	return true;
	} else {
	  	return false;
	}
}
