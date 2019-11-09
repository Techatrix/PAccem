class Furniture extends RPWH {
	int id;
	int price;

	Furniture() {}
	Furniture(int id) {
		this(dm.getfurnituredata(id));
	}
	Furniture(int id, int xpos, int ypos) {
		this(id);
		this.xpos = xpos;
		this.ypos = ypos;
	}
	Furniture(int id, int xpos, int ypos, float rot) {
		this(id, xpos, ypos);
		this.rot = rot;
	}
	Furniture(FurnitureData fdata) {
		this.id = fdata.id;
		this._width = fdata._width;
		this._height = fdata._height;
		this.price = fdata.price;
	}
	Furniture(FurnitureData fdata, int xpos, int ypos) {
		this(fdata);
		this.xpos = xpos;
		this.ypos = ypos;
	}

	void draw(boolean viewmode, boolean selected) {
		if(!viewmode) {
			// 2D
			translate(xpos, ypos);
			//rotate(rot);
			image(dm.furnitures[id].image, 0, 0, _width, _height);
			if (selected == true) {
				noStroke();
				fill(color(255,0,0,100));
				rect(0, 0, _width, _height);
			}
			//rotate(-rot);
			translate(-xpos, -ypos);
		} else {
			// 3D
			pg.translate(xpos, 0, ypos);
			pg.shape(dm.furnitures[id].shape);
			pg.translate(-xpos, 0, -ypos);
		}
	}
	void drawframe(boolean selected) {
		noStroke();
		if(selected) {
			fill(c[8], 100);
		} else {
			fill(255,0,0, 50);
		}
		translate(xpos, ypos);
		rotate(rot);
		rect(0,0,_width,_height);
		rotate(-rot);
		translate(-xpos, -ypos);
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

	boolean checkover(int xpos, int ypos) {
		for (int x=0;x<_width;x++) {
			for (int y=0;y<_height;y++) {
				if(this.xpos+x == xpos && this.ypos+y == ypos) {
					return true;
				}
			}
		}
		return false;
	}

	boolean setxpos(int value) {
		if(value > -1 && value <= rm.roomgrid.tiles.length-_width) {
			xpos = value;
			return true;
		}
		return false;
	}
	boolean setypos(int value) {
		if(value > -1 && value <= rm.roomgrid.tiles[0].length-_height) {
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
