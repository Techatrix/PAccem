class Text extends PWH implements IOverlay {
	String text;
	TextStyle textstyle;

	Text(String text) {
		this(text, new TextStyle());
	}
	Text(String text, TextStyle textstyle) {
		this.text = text;
		this.textstyle = textstyle;
		setwh(-1, -1);
	}

	void draw() {
		textSize(textstyle.fontsize);
		fill(textstyle.textcolor); 
		if(_width == -1 || _height == -1) {
			textAlign(LEFT, TOP);
			text(text, xpos,ypos);
		} else {
			textAlign(CENTER, CENTER);
			text(text, xpos,ypos, _width, _height);
		}
	}

	Box getbound() {
		textSize(textstyle.fontsize);
		return new Box(max(_width, textWidth(text)*1), max(_height, textstyle.fontsize + textDescent()));
	}
	
	boolean ishit() {
	  	return mouseX >= xpos && mouseX <= xpos+_width && mouseY >= ypos && mouseY <= ypos+_height;
	}

	void setxy(int xpos, int ypos) {
		this.xpos = xpos;
		this.ypos = ypos;
	}
	void setwh(int _width, int _height) {
		this._width = _width;
		this._height = _height;
	}
}

class TextStyle {
	color textcolor;
	int fontsize;

	TextStyle() {
		this(16);
	}
	TextStyle(int fontsize) {
		this(fontsize, color(255));
	}
	TextStyle(int fontsize, color textcolor) {
		this.fontsize = fontsize;
		this.textcolor = textcolor;
	}

}