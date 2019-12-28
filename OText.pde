class Text extends PWH implements IOverlay {
	String text;
	int lines;
	int align;

	Text(String text) {
		this(text, CENTER, 1);
	}
	Text(String text, int align) {
		this(text, align, 1);
	}
	Text(String text, int align, int lines) {
		this.text = text;
		this.align = align;
		this.lines = lines;
		setwh(-1, -1);
	}

	void draw(boolean hit) {
		fill(c[0]); 
		if(_width == -1 || _height == -1) {
			textAlign(LEFT, TOP);
			text(text, xpos,ypos);
		} else {
			textAlign(align, CENTER);
			text(text, xpos,ypos, _width, _height);
		}
	}

	Box getboundary() {
		return new Box(max(_width, textWidth(text)), max(_height, lines*(16 + textDescent())));
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
	SetValueStyle valuestyle;
	boolean selected = false;
	String value;
	String newvalue;

	SetValueText(String text) {
		this(text, "");
	}
	SetValueText(String text, String value) {
		this(text, value, new SetValueStyle());
	}
	SetValueText(String text, SetValueStyle valuestyle) {
		this(text, "", valuestyle);
	}
	SetValueText(String text, String value, SetValueStyle valuestyle) {
		this.text = text;
		this.value = value;
		this.newvalue = value;
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
				boolean isvalidchar = (64 < key && key < 91) || (96 < key && key < 123) || (47 < key && key < 58);
				switch(valuestyle.type) {
					case 0:// 0 = string
						if (isvalidchar  || key == 32) {newvalue = newvalue + key;}
					break;
					case 1:// 1 = boolean
						if (isvalidchar  || key == 32) {newvalue = newvalue + key;}
					break;
					case 2:// 2 = int
						if (47 < key && key < 58) {newvalue = newvalue + key;}
					break;
					case 3:// 3 = float
						if ((47 < key && key < 58) || key == 46) {newvalue = newvalue + key;}
					break;
				}
			}
		}
	}

	abstract void onchange();

	void draw(boolean hit) {
		textSize(16);
		if(selected) {
			fill(color(255,0,0)); 
		} else {
			fill(c[0]); 
		}
		if(_width == -1 || _height == -1) {
			textAlign(LEFT, TOP);
			text(text + ": " + newvalue, xpos,ypos);
		} else {
			textAlign(CENTER, CENTER);
			text(text + ": " + newvalue, xpos,ypos, _width, _height);
		}
	}

	Box getboundary() {
		textSize(16);
		return new Box(max(_width, textWidth(text)*1), max(_height, 16 + textDescent()));
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

abstract class GetValueText extends PWH implements IOverlay {
	String text;

	GetValueText(String text) {
		this.text = text;
		setwh(-1, -1);
	}

	abstract String getvalue();

	void draw(boolean hit) {
		textSize(16);
		fill(c[0]);
		if(_width == -1 || _height == -1) {
			textAlign(LEFT, TOP);
			text(text + ": " + getvalue(), xpos,ypos);
		} else {
			textAlign(CENTER, CENTER);
			text(text + ": " + getvalue(), xpos,ypos, _width, _height);
		}
	}

	Box getboundary() {
		textSize(16);
		return new Box(max(_width, textWidth(text)*1), max(_height, 16 + textDescent()));
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
