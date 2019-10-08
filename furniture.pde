class Furniture extends RPoint{
	private int _width;
	private int _height;
	private color _color;
	private int skin;

	Furniture(int _width, int _height) {
		this(_width, _height, 0,0);
	}

	Furniture(int _width, int _height, int xpos, int ypos) {
		this(_width, _height, xpos, ypos, color(150));
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
		this.skin = 0;
	}
	void draw(boolean selected) {
		noStroke();
		fill(_color);
		int a = xpos*rm.gridtilesize;
		int b = ypos*rm.gridtilesize;
		int c = _width*rm.gridtilesize;
		int d = _height*rm.gridtilesize;

		JSONObject data = dt.getindexdata(_width, _height, skin);
		int index = data.getInt("id", -1);
		if(0 <= index && index < dt.furnitures.length) {
			if(data.getBoolean("rotate", false)) {
				push();
				imageMode(CENTER);
  				translate(a+c/2, b+d/2);
				rotate(PI/2);
				image(dt.furnitures[index], 0,0,d,c);
				pop();
			} else {
				image(dt.furnitures[index], a,b,c,d);
			}
		} else {
			rect(xpos*rm.gridtilesize,ypos*rm.gridtilesize,_width*rm.gridtilesize,_height*rm.gridtilesize);
		}

		if (selected == true) {
			fill(color(255,0,0,100));
			rect(xpos*rm.gridtilesize,ypos*rm.gridtilesize,_width*rm.gridtilesize,_height*rm.gridtilesize);
		}
		/* Including Rotation
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
	}
	boolean checkover() {
		float ovscale = st.booleans[1].getvalue() ? 0 : st.floats[1].getvalue();
		float a = rm.gridtilesize*rm.scale;

		float x = xpos*a+ov._width*ovscale+rm.xoff;
		float y = ypos*a+ov._height*ovscale+rm.yoff;
		if (mouseX >= x && mouseX < x+_width*a &&
			mouseY >= y && mouseY < y+_height*a) {
			return true;
		}
		return false;
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
