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

	void draw(PGraphics canvas, boolean viewmode, float gts) { // draw the room grid
		if(!viewmode) { // setup 2D view
			scale(gts);
			stroke(c[1]);
			/* --------------- room grid grid lines --------------- */
			if(rm.scale >= 0.75) { // close view
				for (int x=1;x<=tiles.length;x++) { // Lines along Y-Axis
 					strokeWeight(1.5*st.floats[0].value/gts * ((x % 5 == 0) ? 2 : 1));
					line(x,0,x,tiles[0].length);
				}
				for (int y=1; y<=tiles[0].length;y++) { // Lines along X-Axis
 					strokeWeight(1.5*st.floats[0].value/gts * ((y % 5 == 0) ? 2 : 1));
					line(0,y,tiles.length,y);
				}
			} else { // far view
 				strokeWeight(2*st.floats[0].value/gts);
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
			canvas.push();
			canvas.translate(0.5,0,-0.5);
		}
		/* --------------- draw grid tiles --------------- */
		strokeCap(PROJECT);
		for (int x=0; x<tiles.length; x++) {
			for (int y=0; y<tiles[0].length; y++) {
				if(getTileState(x,y)) {
					if(!viewmode) { // 2D
						stroke(roomgroups.get(getTile(x,y).roomgroup).c);
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
						canvas.push();
						canvas.noStroke();
						canvas.fill(roomgroups.get(getTile(x,y).roomgroup).c);
						canvas.translate(x,0.05,-y);
						canvas.box(1,0.1,1);
						canvas.translate(0,-0.05,0);

						canvas.fill(200);

						GridTile t = getTile(x,y);

						if(!getTileState(x+1,y)) { // right side
							canvas.translate(0.55,1,0);
							if(t.window[0]) { // right window
								canvas.translate(0,-0.4,0);
								canvas.box(0.1,1.2,1);
								canvas.translate(0,1.275,0);
								canvas.box(0.1,0.25,1);
								canvas.translate(0,-0.875,0);
							} else {
								canvas.box(0.1,2,1);
							}
							canvas.translate(-0.55,-1,0);
						}
						if(!getTileState(x-1,y)) { // left side
							canvas.translate(-0.55,1,0);
							if(t.window[1]) { // left window
								canvas.translate(0,-0.4,0);
								canvas.box(0.1,1.2,1);
								canvas.translate(0,1.275,0);
								canvas.box(0.1,0.25,1);
								canvas.translate(0,-0.875,0);
							} else {
								canvas.box(0.1,2,1);
							}
							canvas.translate(0.55,-1,0);
						}
						if(!getTileState(x,y+1)) { // bottom side
							canvas.translate(0,1,-0.55);
							if(t.window[2]) { // bottom window
								canvas.translate(0,-0.4,0);
								canvas.box(1,1.2,0.1);
								canvas.translate(0,1.275,0);
								canvas.box(1,0.25,0.1);
								canvas.translate(0,-0.875,0);
							} else {
								canvas.box(1,2,0.1);
							}
							canvas.translate(0,-1,0.55);
						}
						if(!getTileState(x,y-1)) { // top side
							canvas.translate(0,1,0.55);
							if(t.window[3]) { // top window
								canvas.translate(0,-0.4,0);
								canvas.box(1,1.2,0.1);
								canvas.translate(0,1.275,0);
								canvas.box(1,0.25,0.1);
								canvas.translate(0,-0.875,0);
							} else {
								canvas.box(1,2,0.1);
							}
							canvas.translate(0,-1,-0.55);
						}

						canvas.pop();
					}
				}
			}
		}
		strokeCap(CORNER);
		if(viewmode) {
			canvas.pop();
		}
	}

	void loop() { // is being executed on every frame
		if(isKeyT) {
			if(allowcgol) {
				if(frameCount % 5 == 0) {
					cgol(); // thats a secret (but you've got the source code so its not hard to find out what it does)
					// and its not even well hidden
				}
			} else {
				if(!ov.drawpopup) {
					ov.drawPopup(7);
				}
			}
		}
	}

	void fillTool(boolean value, int xpos, int ypos) {
		ArrayList<int[]> filltiles = new ArrayList<int[]>();
		filltiles.add(new int[]{xpos,ypos});

		while(filltiles.size() != 0) {
			int x = filltiles.get(0)[0];
			int y = filltiles.get(0)[1];
			if(x > -1 && x < tiles.length && y > -1 && y < tiles[0].length) {
				if(tiles[x][y].state != value && (!rm.isFurniture(x,y) || value)) {
					tiles[x][y].state = value;

					filltiles.add(new int[] {x+1,y});
					filltiles.add(new int[] {x-1,y});
					filltiles.add(new int[] {x,y+1});
					filltiles.add(new int[] {x,y-1});
				}
			}
			filltiles.remove(0);
		}
	}

	boolean setTileState(boolean value, int x, int y) { // sets the state of the grid tile on given state
		if(isinGrid(x,y)) {
			if(value == false) {
				tiles[x][y] = new GridTile();
			} else {
				tiles[x][y].state = value;
			}
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
		println("Remove: " + id);
		for (int i=id+1;i<roomgroups.size();i++) {
			for (int x=0; x<tiles.length; x++) {
				for (int y=0; y<tiles[0].length; y++) {
					if(tiles[x][y].roomgroup == i) {
						tiles[x][y].roomgroup -= 1;
					}
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
