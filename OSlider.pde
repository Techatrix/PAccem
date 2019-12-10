abstract class Slider extends PWH implements IOverlay {
	String text;
	boolean selected = false;
	float value;
	float minvalue;
	float maxvalue;

	Slider(String text) {
		this(text, 0.0);
	}
	Slider(String text, float value) {
		this.text = text;
		this.value = value;
		this._width = 200;
		this._height = 50;
	}
	boolean mousePressed() {
		if(ishit()) {
			selected = true;
			return true;
		}
		//newvalue = value;
		selected = false;
		return false;
	}
	boolean mouseDragged() {
		if(ishit()) {
			println("awdadwadwd");
			return true;
		}
		return false;
	}
	void keyPressed() {
	}

	abstract void onchange();

	void draw(boolean hit) {
		textSize(16);
		/*
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
		*/
		noStroke();
		fill(128,128,128);
		rect(xpos,ypos,_width*value,_height);
		stroke(255,0,0);
		noFill();
		rect(xpos,ypos,_width,_height);
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