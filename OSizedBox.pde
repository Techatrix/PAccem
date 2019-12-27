class SizedBox extends PWH implements IOverlay {
	boolean expand;

	SizedBox() {
		this(false);
	}
	SizedBox(boolean expand) {
		setwh(-1, -1);
		this.expand = expand;
	}

	void draw(boolean hit) {
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