class Image extends PWH implements IOverlay {
	PImage image;

	Image(PImage image) {
		this(image, -1, -1);
	}
	Image(PImage image, int _width, int _height) {
		this.image = image;
		setwh(_width, _height);
	}

	void draw(boolean hit) {
		if(_width == -1 || _height == -1) {
			image(image, xpos, ypos);
		} else {
			image(image, xpos, ypos, _width, _height);
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