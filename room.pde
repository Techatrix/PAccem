class Grid {
	private GridTile[][] tiles;
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
	
	void draw(boolean viewmode) {
		int gts = rm.gridtilesize;
		if(!viewmode) {
			stroke(c[1]);
			strokeWeight(st.floats[0].getvalue());
			for (int x=gts; x<=rm.getxplanesize(); x+=gts) {
				line(x,0,x,rm.getyplanesize());
			}
			for (int y=gts; y<=rm.getyplanesize(); y+=gts) {
				line(0,y,rm.getxplanesize(),y);
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
						rect(x*gts,y*gts,gts,gts);

						stroke(c[0]);
						strokeWeight(2*st.floats[0].getvalue());

						GridTile t = gettile(x,y);
						if(t == null)
							break;
						if(!gettilestate(x+1,y)) { // Right
							if(t.window[0])
								stroke(0,0,255);
							line((x+1)*gts,y*gts,(x+1)*gts,(y+1)*gts);
							stroke(c[0]);
						}
						if(!gettilestate(x-1,y)) { // Left
							if(t.window[1])
								stroke(0,0,255);
							line(x*gts,y*gts,x*gts,(y+1)*gts);
							stroke(c[0]);
						}
						if(!gettilestate(x,y+1)) { // Bottom
							if(t.window[2])
								stroke(0,0,255);
							line(x*gts,(y+1)*gts,(x+1)*gts,(y+1)*gts);
							stroke(c[0]);
						}
						if(!gettilestate(x,y-1)) { // Top
							if(t.window[3])
								stroke(0,0,255);
							line(x*gts,y*gts,(x+1)*gts,y*gts);
							stroke(c[0]);
						}
					} else {
						// 3D
						pg.noStroke();
						pg.fill(roomgroups[gettile(x,y).roomgroup]);

						pg.beginShape(QUADS);
						pg.vertex(x*gts, 0, y*gts);
						pg.vertex((x+1)*gts, 0, y*gts);
						pg.vertex((x+1)*gts, 0, (y+1)*gts);
						pg.vertex(x*gts, 0, (y+1)*gts);

						pg.stroke(200);
						pg.fill(200);

						GridTile t = gettile(x,y);
						if(t == null) {
							break;
						}

						// Right
						if(!gettilestate(x+1,y)) {
							pg.vertex((x+1)*gts, 0, y*gts);
							pg.vertex((x+1)*gts, 0, (y+1)*gts);
							if(t.window[0]) {
								pg.vertex((x+1)*gts, -gts/3, (y+1)*gts);
								pg.vertex((x+1)*gts, -gts/3, y*gts);
								pg.vertex((x+1)*gts, -gts/3*2, y*gts);
								pg.vertex((x+1)*gts, -gts/3*2, (y+1)*gts);
							}
							pg.vertex((x+1)*gts, -gts, (y+1)*gts);
							pg.vertex((x+1)*gts, -gts, y*gts);
						}
						// Left
						if(!gettilestate(x-1,y)) {
							pg.vertex(x*gts, 0, y*gts);
							pg.vertex(x*gts, 0, (y+1)*gts);
							if(t.window[1]) {
								pg.vertex(x*gts, -gts/3, (y+1)*gts);
								pg.vertex(x*gts, -gts/3, y*gts);
								pg.vertex(x*gts, -gts/3*2, y*gts);
								pg.vertex(x*gts, -gts/3*2, (y+1)*gts);
							}
							pg.vertex(x*gts, -gts, (y+1)*gts);
							pg.vertex(x*gts, -gts, y*gts);
						}
						// Bottom
						if(!gettilestate(x,y+1)) {
							pg.vertex(x*gts, 0, (y+1)*gts);
							pg.vertex((x+1)*gts, 0, (y+1)*gts);
							if(t.window[2]) {
								pg.vertex((x+1)*gts, -gts/3, (y+1)*gts);
								pg.vertex(x*gts, -gts/3, (y+1)*gts);
								pg.vertex(x*gts, -gts/3*2, (y+1)*gts);
								pg.vertex((x+1)*gts, -gts/3*2, (y+1)*gts);
							}
							pg.vertex((x+1)*gts, -gts, (y+1)*gts);
							pg.vertex(x*gts, -gts, (y+1)*gts);
						}
						// Top
						if(!gettilestate(x,y-1)) {
							pg.vertex(x*gts, 0, y*gts);
							pg.vertex((x+1)*gts, 0, y*gts);
							if(t.window[3]) {
								pg.vertex((x+1)*gts, -gts/3, y*gts);
								pg.vertex(x*gts, -gts/3, y*gts);
								pg.vertex(x*gts, -gts/3*2, y*gts);
								pg.vertex((x+1)*gts, -gts/3*2, y*gts);
							}
							pg.vertex((x+1)*gts, -gts, y*gts);
							pg.vertex(x*gts, -gts, y*gts);
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
			}
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

	boolean settilestate(boolean value, int x, int y) {
		if(isingrid(x,y)) {
			tiles[x][y].state = value;
			return true;
		}
		return false;
	}
	boolean gettilestate(int x, int y) {
		/*
		if(isingrid(x,y)) {
			return tiles[x][y].state;
		}
		return false;
		*/
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
		return (x > -1 && x < rm.xgridsize && y > -1 && y < rm.ygridsize);
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