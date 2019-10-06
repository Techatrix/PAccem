class Furniture extends RPoint{
	int _width;
	int _height;
	color _color;

	Furniture(int _width, int _height) {
		this(_width, _height, 0,0);
	}

	Furniture(int _width, int _height, int xpos, int ypos) {
		this(_width, _height, xpos, ypos, color(255, 150));
	}
	Furniture(int _width, int _height, int xpos, int ypos, color _color) {
		this(_width, _height, xpos, ypos, _color, 0);
	}
	Furniture(int _width, int _height, int xpos, int ypos, color _color, float rot) {
		this._width = _width;
		this._height = _height;
		this.xpos = xpos;
		this.ypos = ypos;
		this._color = _color;
		this.rot = rot;
	}
	void draw(boolean selected) {
		if (selected == true) {
			stroke(color(255,0,0, 150));
			fill(color(255,0,0, 150));
		} else {
			stroke(_color);
			fill(_color);
		}
		/*
		if(rot != 0) {
			pushMatrix();
				translate((xpos+_width/2)*rm.gridtilesize, (ypos+_height/2)*rm.gridtilesize);
				rotate(map(mouseX, 0, width, 0, TWO_PI));
				rect(-_width/2*rm.gridtilesize,-_height/2*rm.gridtilesize,_width*rm.gridtilesize,_height*rm.gridtilesize);
			popMatrix();
		} else {
			rect(xpos*rm.gridtilesize,ypos*rm.gridtilesize,_width*rm.gridtilesize,_height*rm.gridtilesize);
		}
		*/
		rect(xpos*rm.gridtilesize,ypos*rm.gridtilesize,_width*rm.gridtilesize,_height*rm.gridtilesize);
	}
	boolean checkover() {
		float a = rm.gridtilesize*rm.scale;
		float x1=xpos*a+rm.xoff+ov._width;
		float y1=ypos*a+rm.yoff+ov._height;
		if (mouseX >= x1 && mouseX <= x1+_width*a &&
			mouseY >= y1 && mouseY <= y1+_height*a) {
			return true;
		} else {
			return false;
		}
	}
	boolean setxpos(int value) {
		if(value > -1 && value <= rm.xgridsize-_width) {
			xpos = value;
			return true;
		}
		return false;
	}
	boolean setypos(int value) {
		if(value > -1 && value <= rm.ygridsize-_height) {
			ypos = value;
			return true;
		}
		return false;
	}
	void move(int dx, int dy) {
		setxpos(xpos+dx);
		setypos(ypos+dy);
	}
}
