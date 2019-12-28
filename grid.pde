class Grid {
	GridTile[][] tiles; // 2 dimensional array of tiles
	ArrayList<RoomGroup> roomgroups; // list of all room groups

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
	
	void draw(boolean viewmode, float gts) { // draw the room grid
		if(isKeyT) {
			if(allowcgol) {
				cgol(); // thats a secret (but you've got the source code so its not hard to find out what it does)
				// and its not even well hidden
			} else {
				if(!ov.drawpopup) {
					ov.drawPopup(7);
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
				if(getTileState(x,y)) {
					if(!viewmode) { // 2D
						noStroke();
						fill(roomgroups.get(getTile(x,y).roomgroup).c);
						rect(x,y,1,1);

						stroke(c[0]);

						GridTile t = getTile(x,y);
						if(t == null)
							break;
						if(!getTileState(x+1,y)) { // right side
							if(t.window[0])
								stroke(0,0,255);
							line(x+1,y,x+1,y+1);
							stroke(c[0]);
						}
						if(!getTileState(x-1,y)) { // left side
							if(t.window[1])
								stroke(0,0,255);
							line(x,y,x,y+1);
							stroke(c[0]);
						}
						if(!getTileState(x,y+1)) { // bottom side
							if(t.window[2])
								stroke(0,0,255);
							line(x,y+1,x+1,y+1);
							stroke(c[0]);
						}
						if(!getTileState(x,y-1)) { // top side
							if(t.window[3])
								stroke(0,0,255);
							line(x,y,x+1,y);
							stroke(c[0]);
						}
					} else { // 3D
						pg.noStroke();
						pg.fill(roomgroups.get(getTile(x,y).roomgroup).c);

						pg.beginShape(QUADS);
						pg.vertex(x, 0, y);
						pg.vertex(x+1, 0, y);
						pg.vertex(x+1, 0, y+1);
						pg.vertex(x, 0, y+1);

						pg.stroke(200);
						pg.fill(200);
						pg.strokeWeight(st.floats[0].value/gts);

						GridTile t = getTile(x,y);
						if(t == null) {
							break;
						}

						if(!getTileState(x+1,y)) { // right side
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
						if(!getTileState(x-1,y)) { // left side
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
						if(!getTileState(x,y+1)) { // bottom side
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
						if(!getTileState(x,y-1)) { // top side
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

	void fillTool(boolean value, int x, int y) { // apply the fill tool
		if(getTileState(x,y) != value) {
			if(!rm.isFurniture(x,y) || value) {
				setTileState(value, x,y);

				if(isinGrid(x+1, y)) {
					fillTool(value, x+1,y);
				}
				if(isinGrid(x-1, y)) {
					fillTool(value, x-1,y);
				}
				if(isinGrid(x, y+1)) {
					fillTool(value, x,y+1);
				}
				if(isinGrid(x, y-1)) {
					fillTool(value, x,y-1);
				}
			}
		}
	}

	boolean setTileState(boolean value, int x, int y) { // sets the state of the grid tile on given state
		if(isinGrid(x,y)) {
			tiles[x][y].state = value;
			return true;
		}
		return false;
	}
	boolean getTileState(int x, int y) { // return the state of the grid tile on the chosen position
		return getTile(x,y).state;
	}

	boolean setTile(GridTile value, int x, int y) { // sets the grid tile on the chosen position to the given grid tile
		if(isinGrid(x,y)) {
			tiles[x][y] = value;
			return true;
		}
		return false;
	}
	GridTile getTile(int x, int y) { // return the grid tile on the chosen position if possible
		if(isinGrid(x,y)) {
			return tiles[x][y];
		}
		return new GridTile();
	}

	boolean isinGrid(int x, int y) { // return true if the chosen position is inside the room grid
		return (x > -1 && x < tiles.length && y > -1 && y < tiles[0].length);
	}

	boolean isRoomGroupinuse(int id) { // returns whether or not a room group is in use
		for (int x=0; x<tiles.length; x++) {
			for (int y=0; y<tiles[0].length; y++) {
				if(tiles[x][y].state && tiles[x][y].roomgroup == id) {
					return true;
				}
			}
		}
		return false;
	}
	void removeRoomGroup(int id) { // removes a room group and sets all references in the grid to the main room group
		for (int x=0; x<tiles.length; x++) {
			for (int y=0; y<tiles[0].length; y++) {
				if(tiles[x][y].roomgroup == id) {
					tiles[x][y].roomgroup = 0;
				}
			}
		}
		roomgroups.remove(id);
	}
	void addRoomGroup(String name, color value) {
		roomgroups.add(new RoomGroup(name, value));
	}

	void cgol() { // hmmmm?
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

	int getActiveTiles() { // returns the amount of active tiles
		int count = 0;
		for (int x=0; x<tiles.length; x++) {
			for (int y=0; y<tiles[0].length; y++) {
				if(tiles[x][y].state) {
					count++;
				}
			}
		}
		return count;
	}
}

class GridTile {
	boolean state;		// whether or not this tile is part of the room
	int roomgroup;		// room group id
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

class RoomGroup {
	String name;	// name of the room group
	color c;		// color of the room group

	RoomGroup(String name, color c) {
		this.name = name;
		this.c = c;
	}
}