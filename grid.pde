class Grid {
	GridTile[][] tiles;
	color[] roomgroups = new color[5];

	Grid(int xsize, int ysize) {
		color c = color(50,50,50);
		roomgroups[0] = c;
		roomgroups[1] = c;
		roomgroups[2] = c;
		roomgroups[3] = c;
		roomgroups[4] = c;

		tiles = new GridTile[xsize][ysize];
		for (int x=0; x<xsize; x++) {
			for (int y=0; y<ysize; y++) {
				tiles[x][y] = new GridTile();
			}
		}
	}
	
	void draw(boolean viewmode, float gts) {
		if(!viewmode) {
			scale(gts);
			strokeWeight(1.5*st.floats[0].getvalue()/gts);
		} else {
			pg.scale(gts);
			pg.strokeWeight(st.floats[0].getvalue()/gts);
		}
		// Grid Lines
		if(!viewmode) {
			stroke(c[1]);
			for (int x=1;x<=tiles.length;x++ ) {
				line(x,0,x,tiles[0].length);
			}
			for (int y=1; y<=tiles[0].length; y++) {
				line(0,y,tiles.length,y);
			}
		}
		strokeCap(PROJECT);
		for (int x=0; x<tiles.length; x++) {
			for (int y=0; y<tiles[0].length; y++) {
				if(gettilestate(x,y)) {
					if(!viewmode) {
						// 2D
						noStroke();
						fill(roomgroups[gettile(x,y).roomgroup]);
						rect(x,y,1,1);

						stroke(c[0]);

						GridTile t = gettile(x,y);
						if(t == null)
							break;
						if(!gettilestate(x+1,y)) { // Right
							if(t.window[0])
								stroke(0,0,255);
							line(x+1,y,x+1,y+1);
							stroke(c[0]);
						}
						if(!gettilestate(x-1,y)) { // Left
							if(t.window[1])
								stroke(0,0,255);
							line(x,y,x,y+1);
							stroke(c[0]);
						}
						if(!gettilestate(x,y+1)) { // Bottom
							if(t.window[2])
								stroke(0,0,255);
							line(x,y+1,x+1,y+1);
							stroke(c[0]);
						}
						if(!gettilestate(x,y-1)) { // Top
							if(t.window[3])
								stroke(0,0,255);
							line(x,y,x+1,y);
							stroke(c[0]);
						}
					} else {
						// 3D
						pg.noStroke();
						pg.fill(roomgroups[gettile(x,y).roomgroup]);

						pg.beginShape(QUADS);
						pg.vertex(x, 0, y);
						pg.vertex(x+1, 0, y);
						pg.vertex(x+1, 0, y+1);
						pg.vertex(x, 0, y+1);

						pg.stroke(200);
						pg.fill(200);
						pg.strokeWeight(st.floats[0].getvalue()/gts);

						GridTile t = gettile(x,y);
						if(t == null) {
							break;
						}
						// Right
						if(!gettilestate(x+1,y)) {
							pg.vertex(x+1, 0, y);
							pg.vertex(x+1, 0, y+1);
							if(t.window[0]) {
								pg.vertex(x+1, -0.33, y+1);
								pg.vertex(x+1, -0.33, y);
								pg.vertex(x+1, -0.66, y);
								pg.vertex(x+1, -0.66, y+1);
							}
							pg.vertex(x+1, -1, y+1);
							pg.vertex(x+1, -1, y);
						}
						// Left
						if(!gettilestate(x-1,y)) {
							pg.vertex(x, 0, y);
							pg.vertex(x, 0, y+1);
							if(t.window[1]) {
								pg.vertex(x, -0.33, y+1);
								pg.vertex(x, -0.33, y);
								pg.vertex(x, -0.66, y);
								pg.vertex(x, -0.66, y+1);
							}
							pg.vertex(x, -1, y+1);
							pg.vertex(x, -1, y);
						}
						// Bottom
						if(!gettilestate(x,y+1)) {
							pg.vertex(x  , 0, y+1);
							pg.vertex(x+1, 0, y+1);
							if(t.window[2]) {
								pg.vertex(x+1, -0.33, y+1);
								pg.vertex(x  , -0.33, y+1);
								pg.vertex(x  , -0.66, y+1);
								pg.vertex(x+1, -0.66, y+1);
							}
							pg.vertex(x+1, -1, y+1);
							pg.vertex(x  , -1, y+1);
						}
						// Top
						if(!gettilestate(x,y-1)) {
							pg.vertex(x  , 0, y);
							pg.vertex(x+1, 0, y);
							if(t.window[3]) {
								pg.vertex(x+1, -0.33, y);
								pg.vertex(x  , -0.33, y);
								pg.vertex(x  , -0.66, y);
								pg.vertex(x+1, -0.66, y);
							}
							pg.vertex(x+1, -1, y);
							pg.vertex(x  , -1, y);
						}
						pg.endShape();
					}
				}
			}
		}
		strokeCap(ROUND);
	}

	void filltool(boolean value, int x, int y) {
		if(gettilestate(x,y) != value) {
			if(!rm.isfurniture(x,y) || value) {
				settilestate(value, x,y);

				if(isingrid(x+1, y)) {
					filltool(value, x+1,y);
				}
				if(isingrid(x-1, y)) {
					filltool(value, x-1,y);
				}
				if(isingrid(x, y+1)) {
					filltool(value, x,y+1);
				}
				if(isingrid(x, y-1)) {
					filltool(value, x,y-1);
				}
			}
		}
	}

	boolean settilestate(boolean value, int x, int y) {
		if(isingrid(x,y)) {
			tiles[x][y].state = value;
			return true;
		}
		return false;
	}
	boolean gettilestate(int x, int y) {
		return gettile(x,y).state;
	}

	boolean settile(GridTile value, int x, int y) {
		if(isingrid(x,y)) {
			tiles[x][y] = value;
			return true;
		}
		return false;
	}
	GridTile gettile(int x, int y) {
		if(isingrid(x,y)) {
			return tiles[x][y];
		}
		return new GridTile();
	}

	boolean isingrid(int x, int y) {
		return (x > -1 && x < tiles.length && y > -1 && y < tiles[0].length);
	}
}

class GridTile {
	boolean state;
	boolean[] window;
	int roomgroup;

	GridTile() {
		state = false;
		window = new boolean[4];
		roomgroup = 0;
	}
}