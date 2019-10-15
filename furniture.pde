class Furniture extends RPWH {
	int id;
	Furniture() {}
	Furniture(int id) {
		this(dm.getfurnituredata(id));
	}
	Furniture(int id, int xpos, int ypos) {
		this(id);
		this.xpos = xpos;
		this.ypos = ypos;
	}
	Furniture(FurnitureData fdata) {
		this.id = fdata.id;
		this._width = fdata._width;
		this._height = fdata._height;
	}
	Furniture(FurnitureData fdata, int xpos, int ypos) {
		this(fdata);
		this.xpos = xpos;
		this.ypos = ypos;
	}

	void draw(boolean viewmode, boolean selected) {
		if(!viewmode) {
			// 2D
			image(dm.furnitures[id].image, xpos, ypos, _width, _height);

			if (selected == true) {
				noStroke();
				fill(color(255,0,0,100));
				rect(xpos, ypos, _width, _height);
			}	
		} else {
			// 3D
			pg.translate(xpos, 0, ypos);
			pg.shape(dm.furnitures[id].shape);
			pg.translate(-xpos, 0, -ypos);
		}
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
