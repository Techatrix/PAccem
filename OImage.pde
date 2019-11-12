class Image extends PWH implements IOverlay {
	PImage image;
	Fit fit;

	Image(PImage image) {
		this(image, -1, -1);
	}
	Image(PImage image, Fit fit) {
		this(image, -1, -1, fit);
	}
	Image(PImage image, int _width, int _height) {
		this(image, _width, _height, Fit.EXPAND);
	}
	Image(PImage image, int _width, int _height, Fit fit) {
		this.image = image;
		this.fit = fit;
		setwh(_width, _height);
	}

	void draw(boolean hit) {
		if(_width == -1 || _height == -1) {
			image(image, xpos, ypos);
		} else {
			if(fit == Fit.RATIO) {
				Box b = getwh();
				imageMode(CENTER);
				image(image, xpos+_width/2, ypos+_height/2, b.w, b.h);
				imageMode(CORNER);
			} else {
				image(image, xpos, ypos, _width, _height);
			}
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

	Box getwh() {
		if(fit == Fit.EXPAND) {
			return new Box(-1, -1);
		} else {
			float w = image.width;
			float h = image.height;
			if(w > _width) {
				float ratio = _width/w;
				w *= ratio;
				h *= ratio;
			}
			if(h > _height) {
				float ratio = _height/h;
				w *= ratio;
				h *= ratio;
			}
			return new Box(w, h);
		}
	}
}
enum Fit {
	EXPAND, RATIO
}