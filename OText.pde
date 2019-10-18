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
	  	return mouseX >= xpos && mouseX < xpos+_width && mouseY >= ypos && mouseY < ypos+_height;
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

abstract class SetValueText extends PWH implements IOverlay {
	String text;
	TextStyle textstyle;
	SetValueStyle valuestyle;
	boolean selected = false;
	String value = "";
	String newvalue = "";

	SetValueText(String text) {
		this(text, new SetValueStyle(), new TextStyle());
	}
	SetValueText(String text, String value) {
		this(text, new SetValueStyle(), new TextStyle());
		this.value = value;
		this.newvalue = value;
	}
	SetValueText(String text, String value, SetValueStyle valuestyle) {
		this(text, valuestyle, new TextStyle());
		this.value = value;
		this.newvalue = value;
	}
	SetValueText(String text, SetValueStyle valuestyle, TextStyle textstyle) {
		this.text = text;
		this.textstyle = textstyle;
		this.valuestyle = valuestyle;
		setwh(-1, -1);
	}
	boolean mousePressed() {
		if(ishit()) {
			selected = true;
			return true;
		}
		newvalue = value;
		selected = false;
		return false;
	}
	void keyPressed() {
		if(selected) {
			if (keyCode == BACKSPACE) {
				if (newvalue.length() > 0) {
					newvalue = newvalue.substring(0, newvalue.length()-1);
				}
			} else if(keyCode == ENTER) {
				onchange();
				newvalue = value;
				selected = false;
			} else if(keyCode == ESC) {
				newvalue = value;
				key = 0;
				selected = false;
			} else if(newvalue.toString().length() < valuestyle.maxlength) {
				switch(valuestyle.type) {
					case 0:// 0 = string
						if (keyCode > 47 && keyCode < 91  || keyCode == 32) {newvalue = newvalue + key;}
					break;
					case 1:// 1 = boolean
						if (keyCode > 47 && keyCode < 91  || keyCode == 32) {newvalue = newvalue + key;}
					break;
					case 2:// 2 = int
						if (keyCode > 47 && keyCode < 58) {newvalue = newvalue + key;}
					break;
					case 3:// 3 = float
						if (((keyCode > 47 && keyCode < 58) || keyCode == 46)) {newvalue = newvalue + key;}
					break;
				}
			}
		}
	}

	abstract void onchange();

	void draw() {
		textSize(textstyle.fontsize);
		if(selected) {
			fill(textstyle.selectedtextcolor); 
		} else {
			fill(textstyle.textcolor); 
		}
		if(_width == -1 || _height == -1) {
			textAlign(LEFT, TOP);
			text(text + ": " + newvalue, xpos,ypos);
		} else {
			textAlign(CENTER, CENTER);
			text(text + ": " + newvalue, xpos,ypos, _width, _height);
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

abstract class GetValueText extends PWH implements IOverlay {
	String text;
	TextStyle textstyle;

	GetValueText(String text) {
		this(text, new TextStyle());
	}
	GetValueText(String text, TextStyle textstyle) {
		this.text = text;
		this.textstyle = textstyle;
		setwh(-1, -1);
	}

	abstract String getvalue();

	void draw() {
		textSize(textstyle.fontsize);
		fill(textstyle.textcolor);
		if(_width == -1 || _height == -1) {
			textAlign(LEFT, TOP);
			text(text + ": " + getvalue(), xpos,ypos);
		} else {
			textAlign(CENTER, CENTER);
			text(text + ": " + getvalue(), xpos,ypos, _width, _height);
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

class SetValueStyle {
	int type; // String Boolean Integer Float 
	int maxlength;

	SetValueStyle() {
		this(0, 12);
	}
	SetValueStyle(int type) {
		this(type, type == 0 ? 12 : type == 1 ? 5 : type == 2 ? 6 : 7);
	}
	SetValueStyle(int type, int maxlength) {
		this.type = type;
		this.maxlength = maxlength;
	}
}

class TextStyle {
	color textcolor;
	color selectedtextcolor;
	int fontsize;

	TextStyle() {
		this(16);
	}
	TextStyle(int fontsize) {
		this(fontsize, color(255));
	}
	TextStyle(int fontsize, color textcolor) {
		this(fontsize, textcolor, color(255,0,0));
	}
	TextStyle(int fontsize, color textcolor, color selectedtextcolor) {
		this.fontsize = fontsize;
		this.textcolor = textcolor;
		this.selectedtextcolor = selectedtextcolor;
	}
}