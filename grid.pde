class Grid {
	GridTile[][] tiles; // 2 dimensionales array of tiles
	ArrayList<RoomGroup> roomgroups;

	Grid(int xsize, int ysize) {
		roomgroups = new ArrayList<RoomGroup>();
		roomgroups.add(new RoomGroup("Main", color(50,50,50)));
		tiles = new GridTile[xsize][ysize];
		for (int x=0; x<xsize; x++) {
			for (int y=0; y<ysize; y++) {
				tiles[x][y] = new GridTile();
			}
		}
	}
	
	void draw(boolean viewmode, float gts) { // draw the roomgrid
		if(isKeyT) { // TODO: add confirm
			if(allowcgol) {
				cgol(); // thats a secret (but youve got the source code so its not hard to find out what it does)
				// and i dont even really try to hide it
			} else {
				if(!ov.drawpopup) {
					ov.drawpopup(12);
				}
			}
		}
		if(!viewmode) { // setup 2D view
			scale(gts);
			stroke(c[1]);
			/* --------------- room grid grid lines --------------- */
			if(rm.scale >= 1) { // close view
				for (int x=1;x<=tiles.length;x++) { // Lines along Y-Axis
					if(x % 5 == 0) {
 						strokeWeight(1.5*st.floats[0].value/gts*2);
					} else {
 						strokeWeight(1.5*st.floats[0].value/gts);
					}
					line(x,0,x,tiles[0].length);
				}
				for (int y=1; y<=tiles[0].length;y++) { // Lines along X-Axis
					if(y % 5 == 0) {
 						strokeWeight(1.5*st.floats[0].value/gts*2);
					} else {
 						strokeWeight(1.5*st.floats[0].value/gts);
					}
					line(0,y,tiles.length,y);
				}
			} else { // far view
 				strokeWeight(1.5*st.floats[0].value/gts);
				for (int x=1;x<=tiles.length;x++) { // Lines along Y-Axis
					if(x % 5 == 0) { // Include Border
						line(x,0,x,tiles[0].length);
					}
				}
				for (int y=1; y<=tiles[0].length;y++) { // Lines along X-Axis
					if(y % 5 == 0) {
						line(0,y,tiles.length,y);
					}
				}
			}
		} else { // setup 3D view
			pg.scale(gts);
			pg.strokeWeight(st.floats[0].value/gts);
		}
		/* --------------- draw grid tiles --------------- */
		strokeCap(PROJECT);
		for (int x=0; x<tiles.length; x++) {
			for (int y=0; y<tiles[0].length; y++) {
				if(gettilestate(x,y)) {
					if(!viewmode) { // 2D
						noStroke();
						fill(roomgroups.get(gettile(x,y).roomgroup).c);
						rect(x,y,1,1);

						stroke(c[0]);

						GridTile t = gettile(x,y);
						if(t == null)
							break;
						if(!gettilestate(x+1,y)) { // right side
							if(t.window[0])
								stroke(0,0,255);
							line(x+1,y,x+1,y+1);
							stroke(c[0]);
						}
						if(!gettilestate(x-1,y)) { // left side
							if(t.window[1])
								stroke(0,0,255);
							line(x,y,x,y+1);
							stroke(c[0]);
						}
						if(!gettilestate(x,y+1)) { // bottom side
							if(t.window[2])
								stroke(0,0,255);
							line(x,y+1,x+1,y+1);
							stroke(c[0]);
						}
						if(!gettilestate(x,y-1)) { // top side
							if(t.window[3])
								stroke(0,0,255);
							line(x,y,x+1,y);
							stroke(c[0]);
						}
					} else { // 3D
						pg.noStroke();
						pg.fill(roomgroups.get(gettile(x,y).roomgroup).c);

						pg.beginShape(QUADS);
						pg.vertex(x, 0, y);
						pg.vertex(x+1, 0, y);
						pg.vertex(x+1, 0, y+1);
						pg.vertex(x, 0, y+1);

						pg.stroke(200);
						pg.fill(200);
						pg.strokeWeight(st.floats[0].value/gts);

						GridTile t = gettile(x,y);
						if(t == null) {
							break;
						}

						if(!gettilestate(x+1,y)) { // right side
							pg.vertex(x+1, 0, y);
							pg.vertex(x+1, 0, y+1);
							if(t.window[0]) { // right window
								pg.vertex(x+1, -0.33, y+1);
								pg.vertex(x+1, -0.33, y);
								pg.vertex(x+1, -0.66, y);
								pg.vertex(x+1, -0.66, y+1);
							}
							pg.vertex(x+1, -1, y+1);
							pg.vertex(x+1, -1, y);
						}
						if(!gettilestate(x-1,y)) { // left side
							pg.vertex(x, 0, y);
							pg.vertex(x, 0, y+1);
							if(t.window[1]) { // left window
								pg.vertex(x, -0.33, y+1);
								pg.vertex(x, -0.33, y);
								pg.vertex(x, -0.66, y);
								pg.vertex(x, -0.66, y+1);
							}
							pg.vertex(x, -1, y+1);
							pg.vertex(x, -1, y);
						}
						if(!gettilestate(x,y+1)) { // bottom side
							pg.vertex(x  , 0, y+1);
							pg.vertex(x+1, 0, y+1);
							if(t.window[2]) { // bottom window
								pg.vertex(x+1, -0.33, y+1);
								pg.vertex(x  , -0.33, y+1);
								pg.vertex(x  , -0.66, y+1);
								pg.vertex(x+1, -0.66, y+1);
							}
							pg.vertex(x+1, -1, y+1);
							pg.vertex(x  , -1, y+1);
						}
						if(!gettilestate(x,y-1)) { // top side
							pg.vertex(x  , 0, y);
							pg.vertex(x+1, 0, y);
							if(t.window[3]) { // top window
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

	void filltool(boolean value, int x, int y) { // apply the fill tool
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

	boolean settilestate(boolean value, int x, int y) { // sets the state of the grid tile on given state
		if(isingrid(x,y)) {
			tiles[x][y].state = value;
			return true;
		}
		return false;
	}
	boolean gettilestate(int x, int y) { // return the state of the grid tile on the chosen position
		return gettile(x,y).state;
	}

	boolean settile(GridTile value, int x, int y) { // sets the grid tile on the chosen position to the given grid tile
		if(isingrid(x,y)) {
			tiles[x][y] = value;
			return true;
		}
		return false;
	}
	GridTile gettile(int x, int y) { // return the grid tile on the chosen position if possible
		if(isingrid(x,y)) {
			return tiles[x][y];
		}
		return new GridTile();
	}

	boolean isingrid(int x, int y) { // return true if the chosen position is inside the roomgrid
		return (x > -1 && x < tiles.length && y > -1 && y < tiles[0].length);
	}

	boolean isroomgroupinuse(int id) { // returns whether or not a roomgroup is in use
		for (int x=0; x<tiles.length; x++) {
			for (int y=0; y<tiles[0].length; y++) {
				if(tiles[x][y].state && tiles[x][y].roomgroup == id) {
					return true;
				}
			}
		}
		return false;
	}
	void removeroomgroup(int id) { // removes a roomgroup and sets all refrences in the grid to the main roomgroup
		for (int x=0; x<tiles.length; x++) {
			for (int y=0; y<tiles[0].length; y++) {
				if(tiles[x][y].roomgroup == id) {
					tiles[x][y].roomgroup = 0;
				}
			}
		}
		roomgroups.remove(id);
	}
	void addroomgroup(String name, color value) {
		roomgroups.add(new RoomGroup(name, value));
	}

	void cgol() {	//hmmmm?
		GridTile[][] newtiles = new GridTile[tiles.length][tiles[0].length];
		for (int x=0; x<tiles.length; x++) {
			for (int y=0; y<tiles[0].length; y++) {
				newtiles[x][y] = new GridTile();
				int activetiles = 0;
				for (int dx=-1;dx<2;dx++) {
					for (int dy=-1;dy<2;dy++) {
						if(x+dx > -1 && x+dx < tiles.length && y+dy > -1 && y+dy < tiles[0].length) {
							if(dx != 0 || dy != 0) {
								if(tiles[x+dx][y+dy].state) {
									activetiles++;
								}
							}
						}
					}
				}
				boolean alive = tiles[x][y].state;
				if(alive) {
					if(activetiles != 2 && activetiles != 3) {
						alive = false;
					}
				} else {
					alive = (activetiles == 3) ? true : false;
				}
				newtiles[x][y].state = alive;
			}
		}
		tiles = newtiles;
	}

	int getprice() { // calculate the price of the roomgrid
		int price = 0;
		for (int x=0; x<tiles.length; x++) {
			for (int y=0; y<tiles[0].length; y++) {
				if(tiles[x][y].state) {
					price += 1;
				}
			}
		}
		return price;
	}
}

class RoomGroup {
	String name;
	color c;

	RoomGroup(String name, color c) {
		this.name = name;
		this.c = c;
	}
}

class GridTile {
	boolean state;		// whether or not this tile is part of the room
	int roomgroup;		// roomgroup id
	boolean[] window;	// window data

	GridTile() {
		this(false);
	}
	GridTile(boolean state) {
		this(state, 0);
	}
	GridTile(boolean state, int roomgroup) {
		this.state = state;
		this.roomgroup = roomgroup;
		window = new boolean[4];
	}
}
