class Roommanager {
	ArrayList<Furniture> furnitures;
	Grid roomgrid;
	int selectionid;
	String name;

	float xoff = 0;
	float yoff = 0;
	float scale = 1;

	int xgridsize;
	int ygridsize;
	int gridtilesize;

	int tool = 0;

	boolean viewmode; // true = 3D , false = 2D

	ArrayList<int[]> dragtiles = new ArrayList<int[]>();
	boolean dragstate;

	int newfurniturewidth = 1;
	int newfurnitureheight = 1;

	int newroomtilegroup = 0;

	Roommanager() {
		name = st.strings[0].getvalue();
		load(name);
		settitle(name);
	}
	Roommanager(String loadname) {
		name = loadname;
		load(name);
	}

	void mouseWheel(MouseEvent e) {
		float delta = e.getCount() > 0 ? 0.9 : e.getCount() < 0 ? 1.1 : 1.0;
		if(!viewmode) {
			if(scale*delta > 5) {
				delta = 5/scale;
			} else if(scale*delta < 0.25) {
				delta = 0.25/scale;
			}
			xoff = (xoff-mouseX) * delta + mouseX;
			yoff = (yoff-mouseY) * delta + mouseY;
		}
		scale *= delta;
		scale = constrain(scale, 0.25,5);
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
			if(mouseButton == CENTER) {
				xoff -= mouseX - pmouseX;
				xoff = xoff % width;
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
				}
			}
			if(tool == 2) {
				int xpos = floor(getxpos());
				int ypos = floor(getypos());

				boolean hit = false;
				for (int x=0;x<newfurniturewidth;x++) {
					for (int y=0;y<newfurnitureheight;y++) {
						if(!roomgrid.gettilestate(xpos+x,ypos+y) || isfurniture(xpos+x,ypos+y) || !roomgrid.isingrid(xpos+x,ypos+y)) {
							hit = true;
							break;
						}
					}
				}
				if(!hit) {
					furnitures.add(new Furniture(newfurniturewidth, newfurnitureheight, xpos, ypos));
				}
			}
			if(tool == 3) {
				boolean found = false;
				for (int i=0; i<furnitures.size(); i++) {
					if(found == false) {
						if(furnitures.get(i).checkover()) {
							selectionid = i;
							found = true;
						}
					}
				}
			}
			if(tool == 4) {
				int x = floor(getxpos());
				int y = floor(getypos());
				roomgrid.filltool(!roomgrid.gettilestate(x,y), x,y);
			}
			if(tool == 5) {
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
		if(!viewmode) {
			if(key == 127) {
				for (int i=0; i<furnitures.size(); i++) {
					if(selectionid == i) {
						furnitures.remove(i);
						selectionid = -1;
					}
				}
			}
			if(keyCode < 54 && keyCode > 48) {
				newroomtilegroup = keyCode - 49;
				//println("a: " + keyCode);
				//println("b: " + newroomtilegroup);
			}
			if(keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT) {
				Furniture f = new Furniture(0,0);
				for (int i=0; i<furnitures.size(); i++) {
					if(selectionid == i) {
						f = furnitures.get(i);
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
					boolean m = true;
					for (int x=dx;x<f._width+dx;x++) {
						for (int y=dy;y<f._height+dy;y++) {
							if(!roomgrid.gettilestate(f.xpos+x,f.ypos+y) || isfurniture(f.xpos+x,f.ypos+y) || !roomgrid.isingrid(f.xpos+x,f.ypos+y)) {
								m = false;
								break;
							}
						}
					}
					if(m) {
						f.move(dx,dy);
					}
				}
			}
		}
	}
	int getxplanesize() {
		return xgridsize * gridtilesize;
	}
	int getyplanesize() {
		return ygridsize * gridtilesize;
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
			for (int x=0;x<f._width;x++) {
				for (int y=0;y<f._height;y++) {
					if(f.xpos+x == xpos && f.ypos+y == ypos) {
						return true;
					}
				}
			}
		}
		return false;
	}

	String[] loadrooms() {
		File f1 = new File(sketchPath("data/rooms.json"));

		String[] rooms = null;
		if (f1.exists())
		{
  			JSONArray json = loadJSONArray("data/rooms.json");
			rooms = new String[json.size()];
			for (int i=0;i<json.size();i++ ) {
				rooms[i] = json.getString(i);
			}
		}
		return rooms;
	}
	void save(String name) {
		println("Save: " + name);
		JSONObject json = new JSONObject();

  		json.setFloat("xoff", xoff);
  		json.setFloat("yoff", yoff);
  		json.setFloat("scale", scale);
  		json.setInt("xgridsize", xgridsize);
  		json.setInt("ygridsize", ygridsize);
  		json.setInt("gridtilesize", gridtilesize);
  		json.setBoolean("viewmode", viewmode);
  		for (int i=0;i<5;i++ ) {
  			color c = roomgrid.roomgroups[i];
	  		json.setFloat("roomgroupcolor" + str(i) + "red", red(c));
	  		json.setFloat("roomgroupcolor" + str(i) + "green", green(c));
	  		json.setFloat("roomgroupcolor" + str(i) + "blue", blue(c));
  		}

		saveJSONObject(json, "data/" + name + "/data.json");
		//-------------------------------------------------------------------------------
		JSONArray furnituresarray = new JSONArray();

		for (int j = 0; j < furnitures.size(); j++) {

		  JSONObject f = new JSONObject();

		  f.setInt("id", j);
		  f.setInt("xpos", furnitures.get(j).xpos);
		  f.setInt("ypos", furnitures.get(j).ypos);
		  f.setInt("width", furnitures.get(j)._width);
		  f.setInt("height", furnitures.get(j)._height);

		  furnituresarray.setJSONObject(j, f);
		}

		saveJSONArray(furnituresarray, "data/" + name + "/furnitures.json");
		//-------------------------------------------------------------------------------
		JSONArray roomarray = new JSONArray();

		for (int x = 0; x < xgridsize; x++) {
			JSONArray row = new JSONArray();
			for (int y = 0; y < ygridsize; y++) {
				JSONObject tile = new JSONObject();
				tile.setBoolean("g", roomgrid.tiles[x][y].state);
				tile.setInt("r", roomgrid.tiles[x][y].roomgroup);

				JSONArray windows = new JSONArray();
				windows.setBoolean(0, roomgrid.tiles[x][y].window[0]);
				windows.setBoolean(1, roomgrid.tiles[x][y].window[1]);
				windows.setBoolean(2, roomgrid.tiles[x][y].window[2]);
				windows.setBoolean(3, roomgrid.tiles[x][y].window[3]);

  				tile.setJSONArray("w", windows);

				row.setJSONObject(y, tile);
			}
			roomarray.setJSONArray(x, row);
		}
  		surface.setTitle(appname + ": " + name);
  		this.name = name;

		saveJSONArray(roomarray, "data/" + name + "/room.json");
	}
	void load(String name) {
		println("Load: " + name);
		File f1 = new File(sketchPath("data/" + name + "/data.json"));
		File f2 = new File(sketchPath("data/" + name + "/furnitures.json"));
		File f3 = new File(sketchPath("data/" + name + "/room.json"));

		if (f1.exists())
		{
  			JSONObject json = loadJSONObject("data/" + name + "/data.json");
  			xoff = json.getFloat("xoff");
  			yoff = json.getFloat("yoff");
  			scale = json.getFloat("scale");
  			xgridsize = json.getInt("xgridsize");
  			ygridsize = json.getInt("ygridsize");
  			gridtilesize = json.getInt("gridtilesize");
  			viewmode = json.getBoolean("viewmode");

			roomgrid = new Grid(xgridsize, ygridsize);
  			for (int i=0;i<5;i++ ) {
  				roomgrid.roomgroups[i] = color(json.getFloat("roomgroupcolor" + str(i) + "red"), json.getFloat("roomgroupcolor" + str(i) + "green"), json.getFloat("roomgroupcolor" + str(i) + "blue"));
  			}
		} else {
  			xgridsize = 24;
  			ygridsize = 12;
  			gridtilesize = 50;
  			viewmode = false;
			roomgrid = new Grid(xgridsize, ygridsize);
		}
		//-------------------------------------------------------------------------------

		furnitures = new ArrayList<Furniture>();
		if (f2.exists() && f1.exists())
		{
  			JSONArray json = loadJSONArray("data/" + name + "/furnitures.json");
			for (int j = 0; j < json.size(); j++) {
    			JSONObject f = json.getJSONObject(j); 

    			Furniture newf = new Furniture(0,0);
				newf.xpos = f.getInt("xpos");
				newf.ypos = f.getInt("ypos");
				newf._width = f.getInt("width");
				newf._height = f.getInt("height");
    			furnitures.add(newf);
			}
		}
		//-------------------------------------------------------------------------------

		if (f3.exists() && f1.exists())
		{
  			JSONArray json = loadJSONArray("data/" + name + "/room.json");

			for (int x = 0; x < xgridsize; x++) {
				JSONArray row = json.getJSONArray(x);
				for (int y = 0; y < ygridsize; y++) {
					JSONObject tile = row.getJSONObject(y);
					roomgrid.tiles[x][y].state = tile.getBoolean("g");
					roomgrid.tiles[x][y].roomgroup = tile.getInt("r");

					JSONArray window = tile.getJSONArray("w");
					roomgrid.tiles[x][y].window[0] = window.getBoolean(0);
					roomgrid.tiles[x][y].window[1] = window.getBoolean(1);
					roomgrid.tiles[x][y].window[2] = window.getBoolean(2);
					roomgrid.tiles[x][y].window[3] = window.getBoolean(3);
				}
			}
		}
		//-------------------------------------------------------------------------------
		settitle(name);
  		this.name = name;
		if(ov != null) {
			ov.sidebars[1].listitems[0].bv.value = name;
			ov.sidebars[1].listitems[0].bv.newvalue = name;
			ov.refresh();
		}
	}

	void reset() {
		xoff = 0;
		yoff = 0;
		scale = 1;
		tool = 0;
		roomgrid = new Grid(xgridsize, ygridsize);
		furnitures = new ArrayList<Furniture>();
		name = st.strings[0].getvalue();
		st.load();
  		surface.setTitle(appname + ": " + name);
	}

	void switchviewmode() {
		xoff = 0;
		yoff = 0;
		scale = 1;
		tool = 0;
		viewmode = !viewmode;
	}

	void draw() {
		background(st.colors[0].getvalue());
		push();
		if(!viewmode) {
			xoff = constrain(xoff, Integer.MIN_VALUE, 0);
			yoff = constrain(yoff, Integer.MIN_VALUE, 0);
			// 2D View
			float ovscale = st.booleans[1].getvalue() ? 0 : st.floats[1].getvalue();

			translate(xoff+ov._width*ovscale, yoff+ov._height*ovscale);
			scale(scale);
			push();
			stroke(st.colors[3].getvalue());
			strokeWeight(st.floats[0].getvalue());
			for (int x=gridtilesize; x<=getxplanesize(); x+=gridtilesize) {
				line(x,0,x,getyplanesize());
			}
			for (int y=gridtilesize; y<=getyplanesize(); y+=gridtilesize) {
				line(0,y,getxplanesize(),y);
			}
			pop();
			roomgrid.draw();
			for (int i=0; i<furnitures.size(); i++) {
				Furniture f = furnitures.get(i);
				f.draw(selectionid == i);
			}
			if(!ov.ishit()) {
				if(tool == 1 || tool == 2) {
					int x = floor(getxpos());
					int y = floor(getypos());
					if(roomgrid.isingrid(x,y)) {
						noStroke();
						fill(255, 255, 255, 50);
						rect(x*gridtilesize,y*gridtilesize,gridtilesize,gridtilesize);
					}
				}
				if(tool == 2) {

				}
				if(tool == 5) {
					float fx = getxpos();
					float fy = getypos();
					int ix = floor(fx);
					int iy = floor(fy);
					if(roomgrid.gettilestate(ix,iy)) {
						stroke(0, 200, 255);
						fill(0, 200, 255, 150);
						// Right
						if(fx % 1 > 0.8 && !roomgrid.gettilestate(ix+1,iy)) {
							line((ix+1)*rm.gridtilesize,iy*rm.gridtilesize,(ix+1)*rm.gridtilesize,(iy+1)*rm.gridtilesize);
						}
						// Left
						if(fx % 1 < 0.2 && !roomgrid.gettilestate(ix-1,iy)) {
							line(ix*rm.gridtilesize,iy*rm.gridtilesize,ix*rm.gridtilesize,(iy+1)*rm.gridtilesize);
						}
						// Bottom
						if(fy % 1 > 0.8 && !roomgrid.gettilestate(ix,iy+1)) {
							line(ix*rm.gridtilesize,(iy+1)*rm.gridtilesize,(ix+1)*rm.gridtilesize,(iy+1)*rm.gridtilesize);
						}
						// Top
						if(fy % 1 < 0.2 && !roomgrid.gettilestate(ix,iy-1)) {
							line(ix*rm.gridtilesize,iy*rm.gridtilesize,(ix+1)*rm.gridtilesize,iy*rm.gridtilesize);
						}
					}
				}
			}
		} else {
			// 3D View
		  	pg.beginDraw();
		  	pg.background(st.colors[0].getvalue());
		  	PVector lightdir = new PVector(0.3,1,0.3);
			pg.directionalLight(200, 200, 200, lightdir.x, lightdir.y, lightdir.z);
			pg.ambientLight(140,140,140);

			//pg.camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
			
			float a = map(xoff, 0, width, 0, TWO_PI);
			float centerx = roomgrid.tiles.length*gridtilesize/2;
			float centerz = roomgrid.tiles[0].length*gridtilesize/2;
			float r = max(centerx, centerz)*2;


			float xx = sin(a)*r+centerx;
			float zz = cos(a)*r+centerz;
			float hh = -gridtilesize;


			pg.camera(xx, height/2-map(scale, 0, 5, 0, height/2), zz, centerx, height/2, centerz, 0, 1, 0);
			pg.translate(0, height/2, 0);
			//pg.scale(scale);
			stroke(100);
			strokeWeight(1);
			//pg.line(0,0,0, lightdir.x*100, lightdir.y*100, lightdir.z*100);
			//pg.noStroke();

			for (int x=0; x<roomgrid.tiles.length; x++) {
				for (int y=0; y<roomgrid.tiles.length; y++) {
					if(roomgrid.gettilestate(x,y)) {
						pg.fill(255);
						stroke(100);
						strokeWeight(1);

						pg.beginShape(QUADS);
						pg.vertex(x*gridtilesize, 0, y*gridtilesize);
						pg.vertex((x+1)*gridtilesize, 0, y*gridtilesize);
						pg.vertex((x+1)*gridtilesize, 0, (y+1)*gridtilesize);
						pg.vertex(x*gridtilesize, 0, (y+1)*gridtilesize);

						pg.fill(200);
						// Right
						if(!roomgrid.gettilestate(x+1,y)) {
							pg.vertex((x+1)*gridtilesize, 0, y*gridtilesize);
							pg.vertex((x+1)*gridtilesize, 0, (y+1)*gridtilesize);
							pg.vertex((x+1)*gridtilesize, hh, (y+1)*gridtilesize);
							pg.vertex((x+1)*gridtilesize, hh, y*gridtilesize);
						}
						// Left
						if(!roomgrid.gettilestate(x-1,y)) {
							pg.vertex(x*gridtilesize, 0, y*gridtilesize);
							pg.vertex(x*gridtilesize, 0, (y+1)*gridtilesize);
							pg.vertex(x*gridtilesize, hh, (y+1)*gridtilesize);
							pg.vertex(x*gridtilesize, hh, y*gridtilesize);
						}
						// Bottom
						if(!roomgrid.gettilestate(x,y+1)) {
							pg.vertex(x*gridtilesize, 0, (y+1)*gridtilesize);
							pg.vertex((x+1)*gridtilesize, 0, (y+1)*gridtilesize);
							pg.vertex((x+1)*gridtilesize, hh, (y+1)*gridtilesize);
							pg.vertex(x*gridtilesize, hh, (y+1)*gridtilesize);
						}
						// Top
						if(!roomgrid.gettilestate(x,y-1)) {
							pg.vertex(x*gridtilesize, 0, y*gridtilesize);
							pg.vertex((x+1)*gridtilesize, 0, y*gridtilesize);
							pg.vertex((x+1)*gridtilesize, hh, y*gridtilesize);
							pg.vertex(x*gridtilesize, hh, y*gridtilesize);
						}
						pg.endShape();
					}
				}
			}
			pg.pushStyle();
			// Axis
			pg.strokeWeight(5);
			pg.stroke(150,0,0);
			pg.line(0,0,0,1000,0,0);
			pg.stroke(0,150,0);
			pg.line(0,0,0,0,0,1000);
			pg.stroke(0,0,150);
			pg.line(0,0,0,0,1000,0);
			pg.popStyle();

		  	pg.endDraw();
			image(pg,0,0);
		}
		pop();
	}
}
