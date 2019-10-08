class DataManager {
	final PImage[] icons;
	final PImage[] furnitures;
	final PShape[] models;
	final JSONArray furnituredata;

	DataManager() {
		icons = new PImage[7];
		furnitures = new PImage[6];

		File f = new File(sketchPath("assets/furn/data.json"));
		if (f.exists()) {
			furnituredata = loadJSONArray("assets/furn/data.json");
		} else {
			furnituredata = new JSONArray();
		}

		icons[0] = loadImage("assets/icon/0.png");
		icons[1] = loadImage("assets/icon/1.png");
		icons[2] = loadImage("assets/icon/2.png");
		icons[3] = loadImage("assets/icon/3.png");
		icons[4] = loadImage("assets/icon/4.png");
		icons[5] = loadImage("assets/icon/5.png");
		icons[6] = loadImage("assets/icon/6.png");

		furnitures[0] = loadImage("assets/furn/img/11.png"); // 1 1		11
		furnitures[1] = loadImage("assets/furn/img/12.png"); // 1 2, 2 1	12, 12
		furnitures[2] = loadImage("assets/furn/img/13.png"); // 1 3, 3 1	13, 13
		furnitures[3] = loadImage("assets/furn/img/22.png"); // 2 2		22
		furnitures[4] = loadImage("assets/furn/img/23.png"); // 2 3, 3 2	23,23
		furnitures[5] = loadImage("assets/furn/img/33.png"); // 3 3		33
		if(highbit) {
			models = new PShape[6];
			//models[0].setFill(color(100,200,0));
			models[0] = pg.loadShape("assets/furn/mdl/table11.obj");
			models[1] = pg.loadShape("assets/furn/mdl/table12.obj");
			models[2] = pg.loadShape("assets/furn/mdl/table13.obj");
			models[3] = pg.loadShape("assets/furn/mdl/table22.obj");
			models[4] = pg.loadShape("assets/furn/mdl/table23.obj");
			models[5] = pg.loadShape("assets/furn/mdl/table33.obj");
		}
	}

	JSONObject getindexdata(int _width, int _height, int skinid) {
		/*  Write JSON
		JSONArray widths = new JSONArray();
		for(int w=0;w<3;w++) {
			JSONArray heights = new JSONArray();
			for(int h=0;h<3;h++) {
				JSONArray skins = new JSONArray();
					for(int s=0;s<3;s++) {
						JSONObject skin = new JSONObject();
						skin.setInt("id", floor(random(255)));
						skins.setJSONObject(s, skin);
					}
				heights.setJSONArray(h,skins);
			}
			widths.setJSONArray(w,heights);
		}
	  	saveJSONArray(widths, "assets/furn/data.json");

		// Read JSON
	  	widths = loadJSONArray("assets/furn/data.json");
		for(int w=0;w<widths.size();w++) {
			JSONArray heights = widths.getJSONArray(w);
			for(int h=0;h<heights.size();h++) {
				JSONArray skins = heights.getJSONArray(h);
				for(int s=0;s<skins.size();s++) {
					JSONObject skin = skins.getJSONObject(s);
					println("Width: " + (w+1) + " Height " + (h+1) + " Skin: " + s + " ID: " + skin.getInt("id"));
				}
			}
		}
		*/

		JSONObject data = new JSONObject();
		try {
			JSONArray heights = furnituredata.getJSONArray(_width-1);
			JSONArray skins = heights.getJSONArray(_height-1);
			data = skins.getJSONObject(skinid);
		} catch (Exception e) {
			println("getindexdata ERROR: " + e);
		}
		return data;
	}
}
