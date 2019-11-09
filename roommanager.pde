class Roommanager {
	ArrayList<Furniture> furnitures;
	Grid roomgrid;
	int selectionid = -1;
	String name;

	float xoff, yoff, scale; // 2D
	float dxoff, dyoff, dzoff, angle1, angle2, dspeed; // 3D

	int gridtilesize;

	int tool = 0;

	boolean viewmode = false; // true = 3D , false = 2D

	ArrayList<int[]> dragtiles = new ArrayList<int[]>();
	boolean dragstate;

	int newfurnitureid = 0;
	int newroomtilegroup = 0;
	boolean isprefab = false;

	Roommanager() {
		resetcam(true);
		load(st.strings[0].getvalue());
	}
	Roommanager(String loadname) {
		resetcam(true);
		load(loadname);
	}

	void mouseWheel(MouseEvent e) {
		float delta = e.getCount() > 0 ? 1.0/1.1 : e.getCount() < 0 ? 1.1 : 1.0;
		if(!viewmode) {
			float ovscale = st.booleans[1].getvalue() ? 0 : st.floats[1].getvalue();

			float mx = mouseX-ov._width*ovscale;
			float my = mouseY-ov._height*ovscale;

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
		if(!viewmode) {
			// Only dont drag if the mouseclick was a hit
			if(!ov.ishit()) {
				if(mouseButton == CENTER || tool == 0) {
					xoff += mouseX - pmouseX;
					yoff += mouseY - pmouseY;
				}
				if(mouseButton == LEFT && tool == 1) {
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
		} else {
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
	void mousePressed() {
		if(mouseButton == LEFT && !viewmode) {
			selectionid = -1;
			if(tool == 1) {
				int x = floor(getxpos());
				int y = floor(getypos());
				if(!isfurniture(x,y)){
					roomgrid.settilestate(!roomgrid.gettilestate(x,y), x,y);
					roomgrid.gettile(x,y).roomgroup = newroomtilegroup;
				} else {
					ov.showmessage("Furniture is in the way");
				}
			} else if(tool == 2) { // Place Furniture
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
									ov.showmessage(message);

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
								ov.showmessage(message);
								block = true;
								break;
							}
						}
					}
					if(!block) {
						furnitures.add(new Furniture(fdata, xpos, ypos));
					}
				}
			} else if(tool == 3) { // Select Furniture
				boolean found = false;
				for (int i=0; i<furnitures.size(); i++) {
					if(!found) {
						if(furnitures.get(i).checkover()) {
							selectionid = i;
							found = true;
						}
					}
				}
			} else if(tool == 4) { // Fill
				int x = floor(getxpos());
				int y = floor(getypos());
				roomgrid.filltool(!roomgrid.gettilestate(x,y), x,y);
			} else if(tool == 5) { // Window
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
	void keyPressed() {
		setKey(keyCode, true);
		if(!viewmode) {
			if(key == 127) { // Delete
				for (int i=0; i<furnitures.size(); i++) {
					if(selectionid == i) {
						furnitures.remove(i);
						selectionid = -1;
						break;
					}
				}
			} else if(key == 't') { // t
				roomgrid.cgol();
			} else if(keyCode < 54 && keyCode > 48) { // 1-5
				newroomtilegroup = keyCode - 49;
			} else if(keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT) {
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
								ov.showmessage("Can't move Furniture");
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

	float getxpos() {
		return (mouseX-xoff-ov._width)/gridtilesize/scale;
	}
	float getypos() {
		return (mouseY-yoff-ov._height)/gridtilesize/scale;
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
	int getxgridsize() {
		if(roomgrid == null) {
			return 5;
		}
		return roomgrid.tiles.length;
	}
	int getygridsize() {
		if(roomgrid == null) {
			return 5;
		}
		return roomgrid.tiles[0].length;
	}

	String[] loadrooms() {
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
	void save(String name) {
		if(deb) {
			println("Save: " + name);
		}
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
		//-------------------------------------------------------------------------------
		am.settitle(name);
		this.name = name;
		ov.showmessage("Saved Room: " + name);
	}
	void load(String name) {
		if(deb) {
			println("Load Roommanager: " + name);
		}
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
		//-------------------------------------------------------------------------------
		am.settitle(name);
		this.name = name;
		if(ov != null) {
			ov.showmessage("Loaded Room: " + name);
			ov.sidebars[1].listitems[0].bv.value = name;
			ov.sidebars[1].listitems[0].bv.newvalue = name;
			ov.refresh();
		}
	}

	int getprice() {
		int price = 0;
		for (Furniture f : furnitures) {
			price += f.price;
		}
		price += roomgrid.getprice();
		return price;
	}

	void reset() {
		resetcam(true);
		resetcam(false);
		viewmode = false;
		roomgrid = new Grid(getxgridsize(), getygridsize());
		furnitures = new ArrayList<Furniture>();
		name = st.strings[0].getvalue();
		st.load();
		am.settitle(name);
		if(ov != null) {
			ov.showmessage("Reset");
		}
	}
	void newroom(int xsize, int ysize) {
		roomgrid = new Grid(xsize, ysize);
		ov.showmessage("New Room: " + xsize + "x" + ysize);
	}

	void switchviewmode() {
		viewmode = !viewmode;
	}
	void resetcam(boolean viewmode) {
		if(viewmode) {
			angle1 = PI*5/4;
			angle2 = -2;
			dxoff = 0;
			dyoff = 0;
			dzoff = 0.4;
		} else {
			xoff = 0;
			yoff = 0;
			scale = 1;
		}
	}

	void draw() {
		background(c[8]);
		// Setup 2D or 3D View
		if(!viewmode) {
			xoff = constrain(xoff, Integer.MIN_VALUE, 0);
			yoff = constrain(yoff, Integer.MIN_VALUE, 0);
			// 2D View
			float ovscale = st.booleans[1].getvalue() ? 0 : st.floats[1].getvalue();

			translate(xoff+ov._width*ovscale, yoff+ov._height*ovscale);
			scale(scale);
		} else {
			if(isKeyUp || isKeyDown || isKeyLeft || isKeyRight) {
				dspeed += 10/frameRate;
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
				dspeed -= 30/frameRate;
				dspeed = constrain(dspeed, 0, 12);
			}

			// 3D View
			dxoff = constrain(dxoff, 0, Integer.MAX_VALUE);
			dyoff = constrain(dyoff, 0, Integer.MAX_VALUE);
			angle2 = constrain(angle2, -PI+0.1, 0);
			pg.beginDraw();
			pg.background(st.booleans[0].getvalue() ? 0 : 240);
			pg.directionalLight(200, 200, 200, 0.3, 1, 0.3);
			pg.ambientLight(140,140,140);

			pg.perspective(60*PI/180, width/height, 1, 10000);

			// Camera
			float centerx = sin(angle2) * cos(angle1);
			float centery = cos(angle2);
			float centerz = sin(angle2) * sin(angle1);

			pg.camera(dxoff,-height/2*dzoff,dyoff, dxoff+centerx,-height/2*dzoff-centery,dyoff+centerz, 0, 1, 0);

			// Debug
			if(ov.sidebarid == 3) {
				pg.pushStyle();
				// Axis
				pg.strokeWeight(5);
				pg.stroke(150,0,0);
				pg.line(0,0,0,1000,0,0); // X
				pg.stroke(0,150,0);
				pg.line(0,0,0,0,0,1000); // Z
				pg.stroke(0,0,150);
				pg.line(0,0,0,0,1000,0); // Y
				pg.popStyle();
			}
		}
		// Roomgrid
		roomgrid.draw(viewmode, gridtilesize);

		// Furnitures
		for (int i=0; i<furnitures.size(); i++) {
			furnitures.get(i).draw(viewmode, selectionid == i);
		}

		// 2D Tooltips
		if(!viewmode) {
			if(!ov.ishit()) {
				if(tool == 1) { // Room
					int x = floor(getxpos());
					int y = floor(getypos());
					if(roomgrid.isingrid(x,y)) {
						noStroke();
						fill(c[0], 50);
						rect(x,y,1,1);
					}
				} else if(tool == 2) { // Place Furniture
					int xpos = floor(getxpos());
					int ypos = floor(getypos());

					if(isprefab) {
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
					} else {
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
				} else if(tool == 3) { // Select Furniture
					int x = floor(getxpos());
					int y = floor(getypos());

					boolean hit = false;
					for (int i=0; i<furnitures.size(); i++) {
						Furniture f = furnitures.get(i);
						if(f.checkover()) {
							f.drawframe(selectionid == i);
						}
					}
				} else if(tool == 5) { // Window
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
		} else {
			// Draw 3D Graphics
			pg.endDraw();
			image(pg,0,0);
		}
	}
}
