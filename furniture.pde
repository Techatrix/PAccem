class Furniture extends RPWH {
	int skin;

	Furniture(int _width, int _height) {
		this(_width, _height, 0,0);
	}

	Furniture(int _width, int _height, int xpos, int ypos) {
		this(_width, _height, xpos, ypos, 0);
	}
	Furniture(int _width, int _height, int xpos, int ypos, float rot) {
		this._width = _width;
		this._height = _height;
		this.xpos = xpos;
		this.ypos = ypos;
		this.rot = 0;
		this.skin = 0;
	}
	void draw(boolean viewmode, boolean selected) {
		int gts = rm.gridtilesize;
		if(!viewmode) {
			// 2D
			noStroke();
			int a = xpos*gts;
			int b = ypos*gts;
			int c = _width*gts;
			int d = _height*gts;

			pushMatrix();
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
				fill(150);
				rect(a,b,c,d);
			}

			if (selected == true) {
				fill(color(255,0,0,100));
				rect(a,b,c,d);
			}	
			popMatrix();
		} else {
			// 3D
			pg.push();
			pg.translate(xpos*gts, 0, ypos*gts);

			skin = 2;
			
			JSONObject data = dt.getindexdata(_width, _height, skin);
			int index = data.getInt("id", -1);
			if(0 <= index && index < dt.furnitures.length) {
				if(data.getBoolean("rotate", false)) {
					pg.rotateY(PI/2);
					pg.translate(gts*-_height, 0, 0);
				}
				pg.shape(dt.models[index]);
			}
  			pg.pop();
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
