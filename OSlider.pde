abstract class Slider extends PWH implements IOverlay {
	String text;
	boolean selected = false;
	float value;

	Slider(String text) {
		this(text, 0.0);
	}
	Slider(String text, float value) {
		this.text = text;
		this.value = value;
	}

	boolean mousePressed() {
		if(ishit()) {
			selected = true;
			onchange(constrain(map(mouseX, xpos, xpos+_width,0,1), 0,1));
			return true;
		}
		//newvalue = value;
		selected = false;
		return false;
	}
	boolean mouseDragged() {
		if(selected) {
			onchange(constrain(map(mouseX, xpos, xpos+_width,0,1), 0,1));
			return true;
		}
		return false;
	}
	void keyPressed() {
	}

	abstract void onchange(float newvalue);
	abstract String gettext();

	void draw(boolean hit) {
		noStroke();
		fill(128,128,128);
		rect(xpos,ypos,_width*value,_height);
		fill(c[0]);

		if(_width == -1 || _height == -1) {
			textAlign(LEFT, TOP);
			text(text + ": " + gettext(), xpos,ypos);
		} else {
			textAlign(CENTER, CENTER);
			text(text + ": " + gettext(), xpos,ypos, _width, _height);
		}
	}

	Box getbound() {
		return new Box(_width, _height);
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