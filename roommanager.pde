class RoomManager {
	ArrayList<Furniture> furnitures;	// list of furnitures
	Grid roomgrid;						// the current roomgrid
	int selectionid = -1;				// id of the currently selected furniture (-1 = none)
	String name;						// name of the room

	float xoff, yoff, scale; // 2D
	float dxoff, dyoff, dzoff, angle1, angle2, dspeed; // 3D

	int gridtilesize;					// size of one tile

	int tool = 0;						// id of the currently selected tool
	// 0=move, 1=draw to roomgrid, 2=place furn. or pref., 3=select furn., 4=fill, 5=place window,

	boolean viewmode = false; 			// true = 3D , false = 2D

	ArrayList<int[]> dragtiles = new ArrayList<int[]>();	// list of all tiles that have already been draged over
	boolean dragstate;										// state to switch over when draging

	int newfurnitureid = 0;				// id of the currently selected furniture
	int newroomtilegroup = 0;			// id of the current roomtilegroup you are drawing
	boolean isprefab = false;			// whether or not you are placing a furniture or a prefab

	RoomManager() {
		resetcam(true);
		load(st.strings[0].value);
	}
	RoomManager(String loadname) {
		resetcam(true);
		load(loadname);
	}
	/* --------------- Mouse Input --------------- */
	void mouseWheel(MouseEvent e) { // mouse wheel zoom in & out
		float delta = e.getCount() > 0 ? 1.0/1.1 : e.getCount() < 0 ? 1.1 : 1.0;
		if(!viewmode) {
			float mx = mouseX-ov.xoff;
			float my = mouseY-ov.yoff;

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
	void mouseDragged() {
		if(!viewmode) { // 2D
			// Only dont drag if the mouseclick was a hit
			if(!ov.ishit()) {
				if(mouseButton == CENTER || tool == 0) {
					xoff += mouseX - pmouseX;
					yoff += mouseY - pmouseY;
				}
				if(mouseButton == LEFT && tool == 1) { // draw roomgrid
					int x = floor(getxpos());
					int y = floor(getypos());
					if(!isfurniture(x,y)){
						if(dragtiles.size() == 0) {
							dragstate = roomgrid.gettilestate(x,y);
						}
						int[] newgridtile = {x,y};
						if(!dragtiles.contains(newgridtile)) {
							dragtiles.add(newgridtile);
							roomgrid.settilestate(dragstate, x,y);
							roomgrid.gettile(x,y).roomgroup = newroomtilegroup;
						}
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
	void mouseReleased() {
		if(mouseButton == LEFT) {
			dragtiles = new ArrayList<int[]>();
		}
	}

	void settilestate(int xpos, int ypos) {
		if(!isfurniture(xpos,ypos)){
			roomgrid.settilestate(!roomgrid.gettilestate(xpos,ypos), xpos,ypos);
			roomgrid.gettile(xpos,ypos).roomgroup = newroomtilegroup;
		}
	}
	void filltool(int xpos, int ypos) {
		//GridTile[][] tiles = roomgrid.tiles;
		roomgrid.filltool(!roomgrid.gettilestate(xpos,ypos), xpos,ypos);
		//return tiles;
	}

	void mousePressed() {
		if(mouseButton == LEFT && !viewmode) {
			selectionid = -1;
			if(tool == 1) { // draw to roomgrid
				/*
				int x = floor(getxpos());
				int y = floor(getypos());
				if(!isfurniture(x,y)){
					roomgrid.settilestate(!roomgrid.gettilestate(x,y), x,y);
					roomgrid.gettile(x,y).roomgroup = newroomtilegroup;
				}
				*/
				im.settilestate(floor(getxpos()), floor(getypos()));
			} else if(tool == 2) { // place a new furniture or prefab
				int xpos = floor(getxpos());
				int ypos = floor(getypos());

				if(isprefab) {
					boolean block = false;
					PrefabData pdata = dm.getprefabdata(newfurnitureid);
					for (int x=0;x<pdata._width;x++) {
						for (int y=0;y<pdata._height;y++) {
							if(pdata.isfurniture(x,y)) {
								if(!roomgrid.gettilestate(xpos+x,ypos+y) || isfurniture(xpos+x,ypos+y) || !roomgrid.isingrid(xpos+x,ypos+y)) {
									String message = "";
									if(!roomgrid.gettilestate(xpos+x,ypos+y)) {
										message += "No Tile ";
									}
									if(isfurniture(xpos+x,ypos+y)) {
										message += "Furniture in the way ";
									}
									if(!roomgrid.isingrid(xpos+x,ypos+y)) {
										message += "Out of Room ";
									}
									ov.printmessage(message);

									block = true;
									break;
								}
							}
						}
					}
					if(!block) {
						for (int i=0;i<pdata.furnitures.length;i++) {
							PrefabFurnitureData pfd = pdata.furnitures[i];
							furnitures.add(new Furniture(dm.getfurnituredata(pfd.id), xpos+pfd.xpos, ypos+pfd.ypos));
						}
					}

				} else {
					boolean block = false;
					FurnitureData fdata = dm.furnitures[newfurnitureid];

					for (int x=0;x<fdata._width;x++) {
						for (int y=0;y<fdata._height;y++) {
							if(!roomgrid.gettilestate(xpos+x,ypos+y) || isfurniture(xpos+x,ypos+y) || !roomgrid.isingrid(xpos+x,ypos+y)) {
								String message = "";
								if(!roomgrid.gettilestate(xpos+x,ypos+y)) {
									message += "No Tile ";
								}
								if(isfurniture(xpos+x,ypos+y)) {
									message += "Furniture in the way ";
								}
								if(!roomgrid.isingrid(xpos+x,ypos+y)) {
									message += "Out of Room ";
								}
								ov.printmessage(message);
								block = true;
								break;
							}
						}
					}
					if(!block) {
						furnitures.add(new Furniture(fdata, xpos, ypos));
					}
				}
			} else if(tool == 3) { // select furniture
				boolean found = false;
				for (int i=0; i<furnitures.size(); i++) {
					if(!found) {
						if(furnitures.get(i).checkover()) {
							selectionid = i;
							found = true;
						}
					}
				}
			} else if(tool == 4) { // fill
				int x = floor(getxpos());
				int y = floor(getypos());
				roomgrid.filltool(!roomgrid.gettilestate(x,y), x,y);
			} else if(tool == 5) { // place window
				float fx = getxpos();
				float fy = getypos();
				int ix = floor(fx);
				int iy = floor(fy);
				if(roomgrid.gettilestate(ix,iy)) {
					stroke(0, 200, 255);
					fill(0, 200, 255, 150);
					GridTile gt = roomgrid.gettile(ix,iy);
					// Right
					if(fx % 1 > 0.8 && !roomgrid.gettilestate(ix+1,iy)) {
						gt.window[0] = !gt.window[0];
					}
					// Left
					if(fx % 1 < 0.2 && !roomgrid.gettilestate(ix-1,iy)) {
						gt.window[1] = !gt.window[1];
					}
					// Bottom
					if(fy % 1 > 0.8 && !roomgrid.gettilestate(ix,iy+1)) {
						gt.window[2] = !gt.window[2];
					}
					// Top
					if(fy % 1 < 0.2 && !roomgrid.gettilestate(ix,iy-1)) {
						gt.window[3] = !gt.window[3];
					}
				}
			}
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
			} else if(key == 't') { // t
				// TODO: add Confirm
				roomgrid.cgol();
			} else if(key == 'h') { // h
				if(key == 'h') {
					ov.visible = !ov.visible;
					st.booleans[1].setvalue(!st.booleans[1].value);
					st.save();
					ov.build();
				}
			} else if(e.isControlDown()) {
				if(e.getKeyCode() == 89) {
					im.undo();
				}
			} else if(keyCode < 54 && keyCode > 48) { // 1-5
				newroomtilegroup = keyCode - 49;
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
					if(dx != 0 || dy != 0) {
						boolean a = true;

						int b = (dx != 0) ? f._height : f._width;
						for (int v=0;v<b;v++ ) {
							int x = f.xpos;
							int y = f.ypos;

							if(dx != 0) {
								y += v;
								x += dx > 0 ? f._width : dx;
							} else {
								x += v;
								y += dy > 0 ? f._height : dy;
							}
							if(!roomgrid.gettilestate(x,y) || isfurniture(x,y) || !roomgrid.isingrid(x,y)) {
								a = false;
								ov.printmessage("Can't move Furniture");
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
	}
	void keyReleased() {
	  setKey(keyCode, false);
	}

	float getxpos() { // Converts Mouse-X position to roomgrid X-Pos
		return (mouseX-xoff-ov.xoff)/gridtilesize/scale;
	}
	float getypos() { // Converts Mouse-Y position to roomgrid Y-Pos
		return (mouseY-yoff-ov.yoff)/gridtilesize/scale;
	}
	boolean isfurniture(int xpos, int ypos) {
		for (int i=0; i<furnitures.size(); i++) {
			Furniture f = furnitures.get(i);
			if(f.checkover(xpos, ypos)) {
				return true;
			}
		}
		return false;
	}
	int getxgridsize() { // get X-Size of the current roomgrid
		if(roomgrid == null) {
			return 5;
		}
		return roomgrid.tiles.length;
	}
	int getygridsize() { // get Y-Size of the current roomgrid
		if(roomgrid == null) {
			return 5;
		}
		return roomgrid.tiles[0].length;
	}

	String[] loadrooms() { // loads all stored rooms in data/rooms/
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
		if(deb) {
			println("Save: " + name);
		}
		/*
		JSONObject json = new JSONObject();

		json.setFloat("xoff", xoff);
		json.setFloat("yoff", yoff);
		json.setFloat("scale", scale);
		json.setInt("xgridsize", getxgridsize());
		json.setInt("ygridsize", getygridsize());
		json.setInt("gridtilesize", gridtilesize);
		for (int i=0;i<5;i++ ) {
			color c = roomgrid.roomgroups[i];
			json.setFloat("roomgroupcolor" + str(i) + "red", red(c));
			json.setFloat("roomgroupcolor" + str(i) + "green", green(c));
			json.setFloat("roomgroupcolor" + str(i) + "blue", blue(c));

		}

		saveJSONObject(json, "data/rooms/" + name + "/data.json");
		//-------------------------------------------------------------------------------
		JSONArray furnituresarray = new JSONArray();

		for (int j = 0; j < furnitures.size(); j++) {

		  JSONObject f = new JSONObject();

		  f.setInt("id", furnitures.get(j).id);
		  f.setInt("xpos", furnitures.get(j).xpos);
		  f.setInt("ypos", furnitures.get(j).ypos);

		  furnituresarray.setJSONObject(j, f);
		}

		saveJSONArray(furnituresarray, "data/rooms/" + name + "/furnitures.json");
		//-------------------------------------------------------------------------------
		JSONArray roomarray = new JSONArray();

		for (int x = 0; x < getxgridsize(); x++) {
			JSONArray row = new JSONArray();
			for (int y = 0; y < getygridsize(); y++) {
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
		saveJSONArray(roomarray, "data/rooms/" + name + "/room.json");
		*/

		//-------------------------------------------------------------------------------
		am.settitle(name);
		this.name = name;
	}
	void load(String name) { // loads the choosen room from data/rooms/
		if(deb) {
			println("Load Roommanager: " + name);
		}
		/*
		File f1 = new File(sketchPath("data/rooms/" + name + "/data.json"));
		File f2 = new File(sketchPath("data/rooms/" + name + "/furnitures.json"));
		File f3 = new File(sketchPath("data/rooms/" + name + "/room.json"));

		JSONObject json1;
		if (f1.exists())
		{
			json1 = loadJSONObject("data/rooms/" + name + "/data.json");
		} else {
			json1 = new JSONObject();
		}
		xoff = json1.getFloat("xoff", 0);
		yoff = json1.getFloat("yoff", 0);
		scale = json1.getFloat("scale", 1);
		gridtilesize = json1.getInt("gridtilesize", 50);

		roomgrid = new Grid(json1.getInt("xgridsize", 1), json1.getInt("ygridsize", 1));
		// TODO: auto detect gridsize if file not available
		for (int i=0;i<5;i++) {
			float red = json1.getFloat("roomgroupcolor" + str(i) + "red", 50);
			float green = json1.getFloat("roomgroupcolor" + str(i) + "green", 50);
			float blue = json1.getFloat("roomgroupcolor" + str(i) + "blue", 50);
			roomgrid.roomgroups[i] = color(red, green, blue);
		}
		//-------------------------------------------------------------------------------

		furnitures = new ArrayList<Furniture>();
		if (f2.exists() && f1.exists())
		{
			JSONArray json = loadJSONArray("data/rooms/" + name + "/furnitures.json");
			for (int j = 0; j < json.size(); j++) {
				JSONObject f = json.getJSONObject(j);
				furnitures.add(new Furniture(f.getInt("id"), f.getInt("xpos", 0), f.getInt("ypos", 0)));
			}
		}
		//-------------------------------------------------------------------------------

		if (f3.exists())
		{
			JSONArray json = loadJSONArray("data/rooms/" + name + "/room.json");

			for (int x = 0; x < getxgridsize(); x++) {
				JSONArray row = json.getJSONArray(x);
				for (int y = 0; y < getygridsize(); y++) {
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
		}
		*/

		
		xoff = 0;
		yoff = 0;
		scale = 1;
		gridtilesize = 50;
		roomgrid = new Grid(15, 15);
		furnitures = new ArrayList<Furniture>();
		byte[] newb = new byte[5];
		for (int i=0;i<newb.length;i++) {
			newb[i] = -128;
		}


		saveBytes("data/rooms/" + name + "/room.dat", newb);
		File f1 = new File(sketchPath("data/rooms/" + name + "/room.dat"));
		if (f1.exists()) {
			byte bdata[] = loadBytes("data/rooms/" + name + "/room.dat"); 
			// beginroom:	00000000 0 
			// endroom:		00000010 2
			// beginfurn:	00000001 1
			// endfurn:		00000011 3
			// beginrow:	00000100 4
			// endroom:		00000101 5

			//Furniture: 3bytes: id, xpos, ypos
			int state = -1;
			for (byte b : bdata) {
				switch(state) {
					case -1:
	  				int ib = b & 0xff; 
					if(ib == 0) {
						state = 0;
						println("beginroom");
					} else if(ib == 1) {
						state = 1;
						println("beginfurn");
					} else {
						state = -1;
						println("huh?");
					}
					break;
					case 0:
					break;
					case 1:
					break;

				}

			}
		}
		//-------------------------------------------------------------------------------
		am.settitle(name);
		this.name = name;
	}

	int getprice() { // calculate the complete price of the room
		int price = 0;
		for (Furniture f : furnitures) {
			price += f.price;
		}
		price += roomgrid.getprice();
		return price;
	}

	void reset() { // reset everything (mostly everything)
		resetcam(true); // reset 3D Camera
		resetcam(false); // 2D Camera
		viewmode = false;
		roomgrid = new Grid(getxgridsize(), getygridsize());
		furnitures = new ArrayList<Furniture>();
		name = st.strings[0].value;
		st.load();
		am.settitle(name);
	}
	void newroom(int xsize, int ysize) { // create a new room with the choosen size
		roomgrid = new Grid(xsize, ysize);
		ov.printmessage("New Room " + xsize + "x" + ysize);
	}

	void switchviewmode() {	// well... switch the viewmode (2D -> 3D, 3D -> 2D)
		viewmode = !viewmode;
	}
	void resetcam(boolean viewmode) { // reset the choosen camera to the default view
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

	void draw() { // draw the roomgrid and furnitures and some other things...
		push();
		background(c[8]);
		// Setup 2D or 3D View
		if(!viewmode) { // 2D
			xoff = constrain(xoff, Integer.MIN_VALUE, 0);
			yoff = constrain(yoff, Integer.MIN_VALUE, 0);
			// 2D View
			if(!st.booleans[1].value) {
				translate(xoff+ov.xoff, yoff+ov.yoff);
			}
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
				dspeed -= 30/frameRate; // deaccelerate
				dspeed = constrain(dspeed, 0, 12);
			}

			// setup 3D view
			dxoff = constrain(dxoff, 0, Integer.MAX_VALUE);
			dyoff = constrain(dyoff, 0, Integer.MAX_VALUE);
			angle2 = constrain(angle2, -PI+0.1, 0);
			pg.beginDraw();
			pg.background(st.booleans[0].value ? 0 : 240);
			pg.directionalLight(200, 200, 200, 0.3, 1, 0.3);
			pg.ambientLight(140,140,140);

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
		// draw roomgrid
		roomgrid.draw(viewmode, gridtilesize);

		// draw urnitures
		for (int i=0; i<furnitures.size(); i++) {
			furnitures.get(i).draw(viewmode, selectionid == i);
		}

		if(!viewmode) { // 2D tooltips
			if(!ov.ishit()) {
				if(tool == 1) { // draw to roomgrid
					int x = floor(getxpos());
					int y = floor(getypos());
					if(roomgrid.isingrid(x,y)) {
						noStroke();
						fill(c[0], 50);
						rect(x,y,1,1);
					}
				} else if(tool == 2) { // place a new furniture or prefab
					int xpos = floor(getxpos());
					int ypos = floor(getypos());

					if(isprefab) { // place prefab
						PrefabData pdata = dm.getprefabdata(newfurnitureid);
						noStroke();
						fill(c[0], 50);
						rect(xpos, ypos, pdata._width, pdata._height);
						boolean block = false;
						for (int i=0;i<pdata.furnitures.length;i++) {
							PrefabFurnitureData pfd = pdata.furnitures[i];
							FurnitureData fdata = dm.getfurnituredata(pfd.id);
							for (int x=0;x<fdata._width;x++) {
								for (int y=0;y<fdata._height;y++) {
									if(!roomgrid.gettilestate(xpos+pfd.xpos+x,ypos+pfd.ypos+y) || isfurniture(xpos+pfd.xpos+x,ypos+pfd.ypos+y) || !roomgrid.isingrid(xpos+pfd.xpos+x,ypos+pfd.ypos+y)) {
										block = true;
										break;
									}
								}
							}
						}
						if(block) {
							tint(255,128);
						}
						for (int i=0;i<pdata.furnitures.length;i++) {
							PrefabFurnitureData pfd = pdata.furnitures[i];
							FurnitureData fdata = dm.getfurnituredata(pfd.id);
							image(fdata.image, xpos+pfd.xpos, ypos+pfd.ypos, fdata._width, fdata._height);
						}
						noTint();
					} else { // place furniture
						FurnitureData fdata = dm.getfurnituredata(newfurnitureid);
						boolean block = false;
						for (int x=0;x<fdata._width;x++) {
							for (int y=0;y<fdata._height;y++) {
								if(!roomgrid.gettilestate(xpos+x,ypos+y) || isfurniture(xpos+x,ypos+y) || !roomgrid.isingrid(xpos+x,ypos+y)) {
									block = true;
									break;
								}
							}
						}
						if(block) {
							tint(255,128);
						}
						image(fdata.image, xpos, ypos, fdata._width, fdata._height);
						noTint();
					}
				} else if(tool == 3) { // select furniture
					int x = floor(getxpos());
					int y = floor(getypos());

					boolean hit = false;
					for (int i=0; i<furnitures.size(); i++) {
						Furniture f = furnitures.get(i);
						if(f.checkover()) {
							f.drawframe(selectionid == i);
						}
					}
				} else if(tool == 4) { // fill
					// TODO: add preview
				} else if(tool == 5) { // place window
					float fx = getxpos();
					float fy = getypos();
					int ix = floor(fx);
					int iy = floor(fy);
					if(roomgrid.gettilestate(ix,iy)) {
						stroke(0, 200, 255);
						// Right
						if(fx % 1 > 0.8 && !roomgrid.gettilestate(ix+1,iy)) {
							line((ix+1),iy,(ix+1),(iy+1));
						}
						// Left
						if(fx % 1 < 0.2 && !roomgrid.gettilestate(ix-1,iy)) {
							line(ix,iy,ix,(iy+1));
						}
						// Bottom
						if(fy % 1 > 0.8 && !roomgrid.gettilestate(ix,iy+1)) {
							line(ix,(iy+1),(ix+1),(iy+1));
						}
						// Top
						if(fy % 1 < 0.2 && !roomgrid.gettilestate(ix,iy-1)) {
							line(ix,iy,(ix+1),iy);
						}
					}
				}
			}
		} else { // 3D graphics
			pg.endDraw();
			image(pg,0,0); // draw the graphics to the screen
		}
		pop();
	}
}
