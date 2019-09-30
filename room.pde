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
	
	void draw() {
		strokeCap(PROJECT);
		for (int x=0; x<tiles.length; x++) {
			for (int y=0; y<tiles[0].length; y++) {
				if(gettilestate(x,y)) {
					//stroke(st.colors[4]._color);
					//fill(st.colors[4]._color);
					stroke(roomgroups[gettile(x,y).roomgroup]);
					fill(roomgroups[gettile(x,y).roomgroup]);
					rect(x*rm.gridtilesize,y*rm.gridtilesize,rm.gridtilesize,rm.gridtilesize);

					stroke(255);
					strokeWeight(2);

					GridTile t = gettile(x,y);
					if(t == null) {
						break;
					}
					// Right
					if(!gettilestate(x+1,y)) {
						if(t.window[0]) {
							println("draw Right");
							stroke(0,0,255);
						}
						line((x+1)*rm.gridtilesize,y*rm.gridtilesize,(x+1)*rm.gridtilesize,(y+1)*rm.gridtilesize);
						stroke(255);
					}
					// Left
					if(!gettilestate(x-1,y)) {
						if(t.window[1]) {
							println("draw Left");
							stroke(0,0,255);
						}
						line(x*rm.gridtilesize,y*rm.gridtilesize,x*rm.gridtilesize,(y+1)*rm.gridtilesize);
						stroke(255);
					}
					// Bottom
					if(!gettilestate(x,y+1)) {
						if(t.window[2]) {
							println("draw Bottom");
							stroke(0,0,255);
						}
						line(x*rm.gridtilesize,(y+1)*rm.gridtilesize,(x+1)*rm.gridtilesize,(y+1)*rm.gridtilesize);
						stroke(255);
					}
					// Top
					if(!gettilestate(x,y-1)) {
						if(t.window[3]) {
							println("draw Top");
							stroke(0,0,255);
						}
						line(x*rm.gridtilesize,y*rm.gridtilesize,(x+1)*rm.gridtilesize,y*rm.gridtilesize);
						stroke(255);
					}
				}
			}
		}
		strokeCap(ROUND);
	}

	void filltool(boolean value, int x, int y) {
		if(gettilestate(x,y) != value) {
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

	boolean settilestate(boolean value, int x, int y) {
		if(isingrid(x,y)) {
			tiles[x][y].state = value;
			return true;
		}
		return false;
	}
	boolean gettilestate(int x, int y) {
		if(isingrid(x,y)) {
			return tiles[x][y].state;
		}
		return false;
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
		return null;
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
