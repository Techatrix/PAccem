class RoomManager {
	ArrayList<Furniture> furnitures;	// list of furnitures
	Grid roomgrid;						// the current room grid
	int selectionid = -1;				// id of the currently selected furniture (-1 = none)
	String name;						// name of the room
	int gridtilesize;					// size of one tile

	float xoff, yoff, scale; 							// 2D view variables
	float dxoff, dyoff, dzoff, angle1, angle2, dspeed;	// 3D view variables


	int tool = 0;						// id of the currently selected tool
	// 0=move, 1=draw to room grid, 2=place furn. or pref., 3=select furn., 4=fill, 5=place window,

	boolean viewmode = false; 			// true = 3D , false = 2D

	ArrayList<int[]> dragtiles = new ArrayList<int[]>();	// list of all tiles that have already been dragged over
	boolean dragstate;										// state to switch over when dragging

	// new furniture
	int newfurnitureid = 0;						// id for a new furniture/prefab
	int newfurniturerot = 0;					// rotation for a new furniture/prefab
	color furnituretint = color(255,255,255);	// tint setting for a new furniture/prefab
	boolean isprefab = false;					// whether or not you are placing a furniture or a prefab

	int newroomgroup = 0;						// id for a new room tile

	RoomManager() {
		this(st.strings[0].value);
	}
	RoomManager(String loadname) {
		if(deb) {
			toovmessages.add("Loading RoomManager");
		}
		resetCamera(true);
		load(loadname);
	}
	/* --------------- Mouse Input --------------- */
	void mousePressed() {
		if(mouseButton == LEFT && !viewmode) {
			selectionid = -1;
			if(tool == 1) { // draw to room grid
				int x = floor(getXPos());
				int y = floor(getYPos());

				GridTile gt = roomgrid.getTile(x,y);
				if(gt.state) {
					if(gt.roomgroup == newroomgroup) {
						if(!isFurniture(x,y)) {
							gt = new GridTile();
						}
					} else {
						gt.roomgroup = newroomgroup;
					}
				} else {
					gt.state = true;
					gt.roomgroup = newroomgroup;
				}
				roomgrid.setTile(gt,x,y);
			} else if(tool == 2) { // place a new furniture or prefab
				if(!isFurnitureBlock(true)) {
					int xpos = floor(getXPos());
					int ypos = floor(getYPos());

					if(isprefab) {
						PrefabData pdata = dm.getPrefabData(newfurnitureid);
						for (PrefabFurnitureData pfd : pdata.furnitures) {
							furnitures.add(new Furniture(dm.getFurnitureData(pfd.id), xpos+pfd.xpos, ypos+pfd.ypos, furnituretint, pfd.rot));
						}
					} else {
						FurnitureData fdata = dm.getFurnitureData(newfurnitureid);
						furnitures.add(new Furniture(fdata, xpos, ypos, furnituretint, newfurniturerot));
					}
				}
			} else if(tool == 3) { // select furniture
				for (int i=0; i<furnitures.size(); i++) {
					if(furnitures.get(i).checkover()) {
						selectionid = i;
						break;
					}
				}
			} else if(tool == 4) { // fill
				int x = floor(getXPos());
				int y = floor(getYPos());
				roomgrid.fillTool(!roomgrid.getTileState(x,y), x,y);
			} else if(tool == 5) { // place window
				float fx = getXPos();
				float fy = getYPos();
				int ix = floor(fx);
				int iy = floor(fy);
				if(roomgrid.getTileState(ix,iy)) {
					push();
					stroke(0, 200, 255);
					fill(0, 200, 255, 150);
					GridTile gt = roomgrid.getTile(ix,iy);
					// Right
					if(fx % 1 > 0.8 && !roomgrid.getTileState(ix+1,iy)) {
						gt.window[0] = !gt.window[0];
					}
					// Left
					if(fx % 1 < 0.2 && !roomgrid.getTileState(ix-1,iy)) {
						gt.window[1] = !gt.window[1];
					}
					// Bottom
					if(fy % 1 > 0.8 && !roomgrid.getTileState(ix,iy+1)) {
						gt.window[2] = !gt.window[2];
					}
					// Top
					if(fy % 1 < 0.2 && !roomgrid.getTileState(ix,iy-1)) {
						gt.window[3] = !gt.window[3];
					}
					pop();
				}
			}
		}
	}
	void mouseReleased() {
		if(mouseButton == LEFT) {
			dragtiles = new ArrayList<int[]>();
		}
	}
	void mouseDragged() {
		if(!viewmode) { // 2D
			if(!ov.isHit() && 0 <= mouseX && mouseX < width && 0 <= mouseY && mouseY < height) {
				if(mouseButton == CENTER || tool == 0) {
					xoff += mouseX - pmouseX;
					yoff += mouseY - pmouseY;
				} else if(mouseButton == LEFT && tool == 1) { // draw room grid
					int x = floor(getXPos());
					int y = floor(getYPos());

					if(dragtiles.size() == 0) {
						dragstate = !roomgrid.getTileState(x,y);
					}
					int[] newgridtile = {x,y};
					if(!dragtiles.contains(newgridtile)) {

						GridTile gt = roomgrid.getTile(x,y);
						if(dragstate) {
							if(gt.roomgroup == newroomgroup) {
								if(!isFurniture(x,y)) {
									roomgrid.setTileState(false,x,y);
								}
							} else {
								gt.roomgroup = newroomgroup;
							}
						} else {
							gt.state = true;
							gt.roomgroup = newroomgroup;
						}

						dragtiles.add(newgridtile);
					}
				}
			}
		} else { // 3D
			// move 3D-Camera
			if(mouseButton == CENTER || mouseButton == RIGHT) {
				angle2 -= map(mouseY - pmouseY, 0, height, 0, PI);
				angle1 += map(mouseX - pmouseX, 0, width, 0, TWO_PI);
			}
		}
	}
	void mouseWheel(MouseEvent e) { // mouse wheel zoom in & out
		float delta = e.getCount() > 0 ? 1.0/1.1 : e.getCount() < 0 ? 1.1 : 1.0;
		if(!viewmode) {
			float mx = mouseX-ov.getXOff();
			float my = mouseY-ov.getYOff();

			if(scale*delta > 5) {
				delta = 5/scale;
			} else if(scale*delta < 0.25) {
				delta = 0.25/scale;
			}
			xoff = (xoff-mx) * delta + mx;
			yoff = (yoff-my) * delta + my;
			scale *= delta;
			scale = constrain(scale, 0.25,5);
		} else {
			dzoff += (delta-1)/2;
			dzoff = constrain(dzoff, 0.01,2.5);
		}
	}
	/* --------------- Keyboard Input --------------- */
	void keyPressed(KeyEvent e) {
		setKey(keyCode, true);
		if(!viewmode) {
			if(key == 127) { // delete
				for (int i=0; i<furnitures.size(); i++) {
					if(selectionid == i) {
						furnitures.remove(i);
						selectionid = -1;
						break;
					}
				}
			} else if(96 < key && key < 123) { // key input
				switch(key) {
					case 'h':
					ov.visible = !ov.visible;
					st.booleans[1].setValue(!st.booleans[1].value);
					st.save();
					ov.build();
					break;
					case 'c':
					ov.drawPopup(3);
					break;
					case 'n':
					ov.drawPopup(1);
					break;
					case 'r':
					newfurniturerot +=1;
					if(newfurniturerot > 3) {
						newfurniturerot = 0;
					}
					break;
				}
			} else if(48 < key && key < 58) { // 1-5
				int i = key - 49;
				if(i < roomgrid.roomgroups.size()) {
					newroomgroup = i;
					ov.build();
				}
			} else if(keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT) { // arrow keys
				if(selectionid != -1) {
					Furniture f = new Furniture();
					for (int i=0; i<furnitures.size(); i++) {
						if(selectionid == i) {
							f = furnitures.get(i);
							break;
						}
					}
					int dx = 0;
					int dy = 0;
					switch(keyCode) {
						case UP:
							dy = -1;
						break;
						case DOWN:
							dy = 1;
						break;
						case LEFT:
							dx = -1;
						break;
						case RIGHT:
							dx = 1;
						break;
					}
					boolean a = true;
					Clip c = f.getBoundary();
					int b = (dx != 0) ? c.h : c.w;
					for (int v=0;v<b;v++ ) {
						int x = c.x;
						int y = c.y;

						if(dx != 0) {
							y += v;
							x += dx > 0 ? c.w : dx;
						} else {
							x += v;
							y += dy > 0 ? c.h : dy;
						}
						if(!roomgrid.getTileState(x,y) || isFurniture(x,y) || !roomgrid.isinGrid(x,y)) {
							a = false;
							toovmessages.add(lg.get("cantmovefurn"));
							break;
						}
					}
					if(a) {
						f.move(dx,dy);
					}
				}
			}
		}
	}
	void keyReleased() {
	  setKey(keyCode, false);
	}

	float getXPos() { // Converts Mouse-X position to room grid X-Position
		return (mouseX-xoff-ov.getXOff())/gridtilesize/scale;
	}

	float getYPos() { // Converts Mouse-Y position to room grid Y-Position
		return (mouseY-yoff-ov.getYOff())/gridtilesize/scale;
	}

	boolean isFurniture(int xpos, int ypos) { // returns whether or not there is a Furniture at the given position
		for (Furniture f : furnitures) {
			if(f.checkover(xpos, ypos)) {
				return true;
			}
		}
		return false;
	}

	boolean isFurnitureBlock(boolean debug) { // returns whether or not a furniture is placeable at the mouse position
		int xpos = floor(getXPos());
		int ypos = floor(getYPos());
		int w;
		int h;
		if(isprefab) {
			PrefabData pdata = dm.getPrefabData(newfurnitureid);
			w = pdata._width;
			h = pdata._height;
		} else {
			FurnitureData fdata = dm.getFurnitureData(newfurnitureid);
			w = newfurniturerot % 2 == 0 ? fdata._width : fdata._height;
			h = newfurniturerot % 2 == 0 ? fdata._height : fdata._width;
		}
		for (int x=0;x<w;x++) {
			for (int y=0;y<h;y++) {
				if(!roomgrid.getTileState(xpos+x,ypos+y) || isFurniture(xpos+x,ypos+y) || !roomgrid.isinGrid(xpos+x,ypos+y)) {
					if(debug) {
						String message = "";
						if(!roomgrid.getTileState(xpos+x,ypos+y)) {
							message += lg.get("notile");
						}
						if(isFurniture(xpos+x,ypos+y)) {
							message += lg.get("fitw");
						}
						if(!roomgrid.isinGrid(xpos+x,ypos+y)) {
							message += lg.get("outofroom");
						}
						toovmessages.add(message);
					}
					return true;
				}
			}
		}
		return false;
	}

	int getXGridSize() { // get X-Size of the current room grid
		return roomgrid.tiles.length;
	}

	int getYGridSize() { // get Y-Size of the current room grid
		return roomgrid.tiles[0].length;
	}

	String[] loadRooms() { // loads all stored rooms in data/rooms/
		File[] files = listFiles(sketchPath("data/rooms"));
		if(files == null) {
			return new String[0];
		}
		int roomslength = 0;

		for (int i = 0; i < files.length; i++) {
			if(files[i].isDirectory()) {
				roomslength++;
			}
		}
		String[] rooms = new String[roomslength];

		int roomindex = 0;
		for (int i = 0; i < files.length; i++) {
		  File f = files[i];
			if(f.isDirectory()) {
				rooms[roomindex] = f.getName();
				roomindex++;
			}
		}
		return rooms;
	}

	void save(String name) { // saves the current room to data/rooms/
		String path = "data/rooms/" + name;
		JSONObject json = new JSONObject();

		json.setFloat("xoff", xoff);
		json.setFloat("yoff", yoff);
		json.setFloat("scale", scale);
		json.setInt("xgridsize", getXGridSize());
		json.setInt("ygridsize", getYGridSize());
		json.setInt("gridtilesize", gridtilesize);

		JSONArray jsonroomgroups = new JSONArray();

		for (int i=0;i<roomgrid.roomgroups.size();i++ ) {
			RoomGroup rg = roomgrid.roomgroups.get(i);
			JSONObject jsonroomgroup = new JSONObject();

			jsonroomgroup.setInt("red", (int)red(rg.c));
			jsonroomgroup.setInt("green", (int)green(rg.c));
			jsonroomgroup.setInt("blue", (int)blue(rg.c));

			jsonroomgroup.setString("name", rg.name);

			jsonroomgroups.setJSONObject(i,jsonroomgroup);
		}
		json.setJSONArray("roomgroups", jsonroomgroups);


		saveJSONObject(json, path + "/data.json");
		//-------------------------------------------------------------------------------
		JSONArray furnituresarray = new JSONArray();

		for (int j = 0; j < furnitures.size(); j++) {

			JSONObject jsonf = new JSONObject();

			Furniture f = furnitures.get(j);
			jsonf.setInt("id", f.id);
			jsonf.setInt("xpos", f.xpos);
			jsonf.setInt("ypos", f.ypos);
			jsonf.setInt("rot", f.rot);

			if(f.tint != color(255,255,255)) {
				JSONObject jsonfc = new JSONObject();
				jsonfc.setInt("red", (int)red(f.tint));
				jsonfc.setInt("green", (int)green(f.tint));
				jsonfc.setInt("blue", (int)blue(f.tint));
				jsonf.setJSONObject("color", jsonfc);
			}

			furnituresarray.setJSONObject(j, jsonf);
		}

		saveJSONArray(furnituresarray, path + "/furnitures.json");
		//-------------------------------------------------------------------------------
		JSONArray roomarray = new JSONArray();

		for (int x = 0; x < getXGridSize(); x++) {
			JSONArray row = new JSONArray();
			for (int y = 0; y < getYGridSize(); y++) {
				JSONObject tile = new JSONObject();

				if(roomgrid.tiles[x][y].state) {
					tile.setBoolean("g", true);
				}
				if(roomgrid.tiles[x][y].roomgroup != 0) {
					tile.setInt("r", roomgrid.tiles[x][y].roomgroup);
				}

				JSONArray windows = new JSONArray();
				boolean w = false;
				for (int i=0;i<4;i++) {
					if(roomgrid.tiles[x][y].window[i]) {
						windows.setBoolean(i, true);
						w = true;
					}
				}
				if(w) {
					tile.setJSONArray("w", windows);
				}

				row.setJSONObject(y, tile);
			}
			roomarray.setJSONArray(x, row);
		}
		saveJSONArray(roomarray, path + "/room.json");

		//-------------------------------------------------------------------------------
		toovmessages.add("Saved " + name);
		am.setTitle(name);
		this.name = name;
	}

	void load(String name) { // loads the chosen room from data/rooms/
		toovmessages.add("Loading " + name);
		String path = "data/rooms/" + name;
		File f1 = new File(sketchPath(path + "/data.json"));
		File f2 = new File(sketchPath(path + "/furnitures.json"));
		File f3 = new File(sketchPath(path + "/room.json"));

		if(!f1.exists() && !f2.exists() && !f3.exists()) {
			xoff = 0;
			yoff = 0;
			scale = 1;
			gridtilesize = 50;
			furnitures = new ArrayList<Furniture>();

			roomgrid = new Grid(15, 15);
		} else {
			JSONObject json1;
			int xg = 15;
			int yg = 15;
			if (f1.exists())
			{
				json1 = loadJSONObject(path + "/data.json");
				xg = json1.getInt("xgridsize", 15);
				yg = json1.getInt("ygridsize", 15);
			} else {
				toovmessages.add("data.json " + lg.get("doesntexist"));
				json1 = new JSONObject();
				if(f3.exists()) {
					JSONArray json = loadJSONArray(path + "/room.json");
					xg = json.size();
					yg = json.getJSONArray(0).size();
					toovmessages.add(lg.get("gridsizeevaluated"));
				}
			}
			xoff = json1.getFloat("xoff", 0);
			yoff = json1.getFloat("yoff", 0);
			scale = json1.getFloat("scale", 1);
			gridtilesize = json1.getInt("gridtilesize", 50);

			roomgrid = new Grid(xg, yg);

			roomgrid.roomgroups = new ArrayList<RoomGroup>();
			JSONArray jsonroomgroups = json1.getJSONArray("roomgroups");

			if(jsonroomgroups != null) {
				for (int i=0;i<jsonroomgroups.size();i++ ) {
					JSONObject jsonroomgroup = jsonroomgroups.getJSONObject(i);

					int r = jsonroomgroup.getInt("red", 50);
					int g = jsonroomgroup.getInt("green", 50);
					int b = jsonroomgroup.getInt("blue", 50);

					String roomgroupname = jsonroomgroup.getString("name", "No Name");

					roomgrid.roomgroups.add(new RoomGroup(roomgroupname, color(r,g,b)));
				}
			} else {
				roomgrid.roomgroups.add(new RoomGroup("Main", color(50)));
			}
			//-------------------------------------------------------------------------------

			furnitures = new ArrayList<Furniture>();
			if (f2.exists())
			{
				JSONArray json = loadJSONArray(path + "/furnitures.json");
				for (int j = 0; j < json.size(); j++) {
					JSONObject f = json.getJSONObject(j);

					color c = color(255,255,255);
					JSONObject fc = f.getJSONObject("color");
					if(fc != null) {
						c = color(fc.getInt("red", 255), fc.getInt("green", 255), fc.getInt("blue", 255));
					}
					int id = f.getInt("id",-1);
					if(!dm.validateId(id)) {
						toovmessages.add(lg.get("furnidisinvalid"));
						continue;
					}
					int xpos = f.getInt("xpos", 0);
					int ypos = f.getInt("ypos", 0);
					int rot = f.getInt("rot", 0);
					FurnitureData fd = dm.getFurnitureData(id);

					if(xpos+fd._width > xg || ypos+fd._height > yg) {
						toovmessages.add(lg.get("furnposisinvalid"));
					} else {
						furnitures.add(new Furniture(fd, xpos, ypos, c, rot));
					}
				}
			} else {
				toovmessages.add("furnitures.json " + lg.get("doesntexist"));
			}
			//-------------------------------------------------------------------------------

			if (f3.exists())
			{
				JSONArray json = loadJSONArray(path + "/room.json");

				for (int x = 0; x < getXGridSize(); x++) {
					JSONArray row = json.getJSONArray(x);
					for (int y = 0; y < getYGridSize(); y++) {
						JSONObject tile = row.getJSONObject(y);
						if(tile.getBoolean("g", false)) {
							JSONArray window = tile.getJSONArray("w");
							if(window == null) {
								roomgrid.tiles[x][y] = new GridTile(true, tile.getInt("r", 0));
							} else {
								roomgrid.tiles[x][y].state = true;
								roomgrid.tiles[x][y].roomgroup = tile.getInt("r", 0);
								for (int i=0;i<4;i++) {
									roomgrid.tiles[x][y].window[i] = window.getBoolean(i, false);
								}
							}
						} else {
							roomgrid.tiles[x][y] = new GridTile(false);
						}
					}
				}
			} else {
				toovmessages.add("room.json " + lg.get("doesntexist"));
			}
		}
		//-------------------------------------------------------------------------------
		if(ov != null) {
			ov.newroomname = name;
			ov.build();
		}
		am.setTitle(name);
		this.name = name;
	}

	PriceReport getPriceReport() { // calculate the complete price report of the room
		ArrayList<Integer> ids = new ArrayList<Integer>();
		ArrayList<Integer> counts = new ArrayList<Integer>();

		for (Furniture f : furnitures) {
			int exists = -1;
			for (int i=0;i<ids.size();i++) {
				if(f.id == ids.get(i)) {
					exists = i;
					break;
				}
			}
			if(exists == -1) {
				ids.add(f.id);
				counts.add(1);
			} else {
				counts.set(exists, counts.get(exists)+1);
			}
		}
		// convert arraylists to arrays
		int[] furnitureids = new int[ids.size()];
		int[] furniturecounts = new int[ids.size()];
		for (int i=0;i<furnitureids.length;i++) {
			furnitureids[i] = ids.get(i);
			furniturecounts[i] = counts.get(i);
		}

		return new PriceReport(roomgrid.getActiveTiles(), 1, furnitureids, furniturecounts);
	}

	void reset() { // reset everything (mostly everything)
		resetCamera(true); // reset 3D Camera
		resetCamera(false); // reset 2D Camera
		viewmode = false;
		roomgrid = new Grid(getXGridSize(), getYGridSize());
		furnitures.clear();
		name = st.strings[0].value;
		st.load();
		am.setTitle(name);
	}

	void newRoom(int xsize, int ysize) { // create a new room with the chosen size
		furnitures.clear();
		roomgrid = new Grid(xsize, ysize);
		toovmessages.add(lg.get("newroom") + " " + xsize + "x" + ysize);
	}

	void switchViewmode() {	// well... switches the view mode (2D -> 3D, 3D -> 2D)
		if(usegl) {
			viewmode = !viewmode;
		} else {
			ov.drawPopup(9);
		}
	}

	void resetCamera(boolean viewmode) { // reset the chosen camera to the default view
		if(viewmode) { // 3D
			angle1 = PI*5/4;
			angle2 = -2;
			dxoff = 0;
			dyoff = 0;
			dzoff = 0.4;
		} else { // 2D
			xoff = 0;
			yoff = 0;
			scale = 1;
		}
	}

	void draw() { // draw the room grid and furnitures and some other things...
		push();
		background(c[8]);
		// Setup 2D or 3D View
		if(!viewmode) { // 2D
			xoff = constrain(xoff, Integer.MIN_VALUE, 0);
			yoff = constrain(yoff, Integer.MIN_VALUE, 0);
			// 2D View
			translate(xoff+ov.getXOff(), yoff+ov.getYOff());
			scale(scale);
		} else { // 3D
			// move camera according to the given key inputs
			if(isKeyUp || isKeyDown || isKeyLeft || isKeyRight) {
				dspeed += 10/frameRate; // acceleration
				dspeed = constrain(dspeed, 0, 12);
				if(isKeyUp) {
					dxoff -= sin(-angle1+PI/2)*dspeed;
					dyoff -= cos(-angle1+PI/2)*dspeed;
				}
				if(isKeyDown) {
					dxoff += sin(-angle1+PI/2)*dspeed;
					dyoff += cos(-angle1+PI/2)*dspeed;
				}
				if(isKeyLeft) {
					dxoff += sin(-angle1)*dspeed;
					dyoff += cos(-angle1)*dspeed;
				}
				if(isKeyRight) {
					dxoff -= sin(-angle1)*dspeed;
					dyoff -= cos(-angle1)*dspeed;
				}
			} else {
				dspeed -= 30/frameRate; // decelerate
				dspeed = constrain(dspeed, 0, 12);
			}

			// setup 3D view
			dxoff = constrain(dxoff, 0, Integer.MAX_VALUE);
			dyoff = constrain(dyoff, 0, Integer.MAX_VALUE);
			angle2 = constrain(angle2, -PI+0.1, 0);
			pg.beginDraw();
			pg.background(st.booleans[0].value ? 0 : 240);
			pg.ambientLight(160,160,160);
			pg.directionalLight(255, 255, 255, 0.3, 1, 0);

			pg.perspective(60*PI/180, width/height, 1, 10000);

			// setup camera
			float centerx = sin(angle2) * cos(angle1);
			float centery = cos(angle2);
			float centerz = sin(angle2) * sin(angle1);

			pg.camera(dxoff,-height/2*dzoff,dyoff, dxoff+centerx,-height/2*dzoff-centery,dyoff+centerz, 0, 1, 0);

			// draw axis
			pg.pushStyle();
			pg.strokeWeight(5);
			pg.stroke(150,0,0);
			pg.line(0,0,0,1000,0,0); // X
			pg.stroke(0,150,0);
			pg.line(0,0,0,0,0,1000); // Z
			pg.stroke(0,0,150);
			pg.line(0,0,0,0,1000,0); // Y
			pg.popStyle();
		}
		// draw room grid
		roomgrid.draw(viewmode, gridtilesize);

		// draw furnitures
		for (int i=0; i<furnitures.size(); i++) {
			furnitures.get(i).draw(viewmode, selectionid == i);
		}

		if(!viewmode) { // 2D tool tips
			if(!ov.isHit()) {
				if(tool == 1) { // draw to room grid
					int x = floor(getXPos());
					int y = floor(getYPos());
					if(roomgrid.isinGrid(x,y)) {
						noStroke();
						fill(c[0], 50);
						rect(x,y,1,1);
					}
				} else if(tool == 2) { // place a new furniture or prefab
					int xpos = floor(getXPos());
					int ypos = floor(getYPos());

					if(isprefab) { // place prefab
						PrefabData pdata = dm.getPrefabData(newfurnitureid);
						noStroke();
						fill(c[0], 50);
						rect(xpos, ypos, pdata._width, pdata._height);

						color c = color(furnituretint, isFurnitureBlock(false) ? 128 : 255);
						for (PrefabFurnitureData pfd : pdata.furnitures) {
							FurnitureData fdata = dm.getFurnitureData(pfd.id);
							Furniture f =  new Furniture(fdata, xpos+pfd.xpos, ypos+pfd.ypos, c);
							f.rot = pfd.rot;
							f.draw(false, false);
						}
					} else { // place furniture
						color c = color(furnituretint, isFurnitureBlock(false) ? 128 : 255);
						FurnitureData fdata = dm.getFurnitureData(newfurnitureid);
						Furniture f =  new Furniture(fdata, xpos, ypos, c, newfurniturerot);
						f.draw(false, false);
					}
				} else if(tool == 3) { // select furniture
					int x = floor(getXPos());
					int y = floor(getYPos());

					boolean hit = false;
					for (int i=0; i<furnitures.size(); i++) {
						Furniture f = furnitures.get(i);
						if(f.checkover()) {
							f.drawFrame(selectionid == i);
						}
					}
				} else if(tool == 5) { // place window
					float fx = getXPos();
					float fy = getYPos();
					int ix = floor(fx);
					int iy = floor(fy);
					if(roomgrid.getTileState(ix,iy)) {
						stroke(0, 200, 255);
						// Right
						if(fx % 1 > 0.8 && !roomgrid.getTileState(ix+1,iy)) {
							line((ix+1),iy,(ix+1),(iy+1));
						}
						// Left
						if(fx % 1 < 0.2 && !roomgrid.getTileState(ix-1,iy)) {
							line(ix,iy,ix,(iy+1));
						}
						// Bottom
						if(fy % 1 > 0.8 && !roomgrid.getTileState(ix,iy+1)) {
							line(ix,(iy+1),(ix+1),(iy+1));
						}
						// Top
						if(fy % 1 < 0.2 && !roomgrid.getTileState(ix,iy-1)) {
							line(ix,iy,(ix+1),iy);
						}
					}
				}
			}
		} else { // 3D graphics
			pg.endDraw();
			image(pg,0,0); // draw the 3D graphics to the screen
		}
		pop();
	}
	
}
