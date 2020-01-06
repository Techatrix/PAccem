class DataManager {
	final PImage[] icons;				// list of all icons
	final PImage[] extras;				// list of all extra images(data/assets/img/)
	final FurnitureData[] furnitures;	// list of all furnitures that can be used
	final PrefabData[] prefabs;			// list of all prefabs that can be used
	final PShader[] filters;			// list of all filters/shaders

	DataManager() {
		if(deb) {
			toovmessages.add("Loading DataManager");
		}
		/* --------------- load icon data --------------- */
		icons = new PImage[9];
		for (int i=0;i<icons.length;i++) {
			icons[i] = loadImage("data/assets/icon/"+i+".png");
		}
		/* --------------- load extras data --------------- */
		extras = new PImage[1];
		extras[0] = loadImage("data/assets/img/error.png");

		/* --------------- load furniture data --------------- */
		JSONArray furnituredata;
		File f1 = new File(sketchPath("data/furnituredata.json"));
		if (f1.exists()) {
			furnituredata = loadJSONArray("data/furnituredata.json");
		} else {
			furnituredata = new JSONArray();
		}

		furnitures = new FurnitureData[furnituredata.size()];
		for (int i=0;i<furnituredata.size();i++) {
			JSONObject furn = furnituredata.getJSONObject(i);

			int id = furn.getInt("id", 0);
			int _width = furn.getInt("width", 1);
			int _height = furn.getInt("height", 1);
			String src = furn.getString("src");
			int price = furn.getInt("price", 0);

			PImage image;
			File ff = new File(sketchPath("data/assets/furn/img/" + src +".png"));
			if(ff.exists()) {
				image = loadImage(ff.getPath());
			} else {
				toovmessages.add(src +".png" + " not found");
				image = extras[0];
			}
			PShape shape = null;
			if(usegl) {
				File fs = new File(sketchPath("data/assets/furn/mdl/" + src +".obj"));
				if(ff.exists()) {
					shape = pg.loadShape(fs.getPath());
				} else {
					toovmessages.add(src +".obj" + " not found");
					shape = new PShape();
				}
			}
			String name = furn.getString("name", "Name not found");
			furnitures[i] = new FurnitureData(id, _width, _height, image, shape, name, price);
		}
		
		/* --------------- load prefab data --------------- */
		JSONArray prefabdata;
		File f2 = new File(sketchPath("data/prefabdata.json"));
		if (f2.exists()) {
			prefabdata = loadJSONArray("data/prefabdata.json");
		} else {
			prefabdata = new JSONArray();
		}
		prefabs = new PrefabData[prefabdata.size()];

		for (int i=0;i<prefabdata.size();i++) {
			JSONObject pref = prefabdata.getJSONObject(i);

			int _height = pref.getInt("height", 1);
			int _width = pref.getInt("width", 1);
			String name = pref.getString("name", "Name not Found");

			JSONArray prefabfurnsdata = pref.getJSONArray("furnitures");
			PrefabFurnitureData[] prefabfurns = new PrefabFurnitureData[prefabfurnsdata.size()];

			for (int j=0;j<prefabfurnsdata.size();j++) {
				JSONObject preffurn = prefabfurnsdata.getJSONObject(j);

				int furnid = preffurn.getInt("id", 0);
				int xpos = preffurn.getInt("xpos", 0);
				int ypos = preffurn.getInt("ypos", 0);
				int rot = preffurn.getInt("rot", 0);
				prefabfurns[j] = new PrefabFurnitureData(furnid, xpos, ypos, rot);
			}

			prefabs[i] = new PrefabData(_width, _height, name, prefabfurns);
		}
		/* --------------- load shaders/filter --------------- */
		if(usegl && usefilters) {
			filters = new PShader[2];
			try {
				filters[0] = loadShader("data/assets/shader/blur.glsl");		// Load blur shader
				filters[1] = loadShader("data/assets/shader/pixelate.glsl");	// Load pixelate shader
				filters[0].init();
				filters[1].init();
				// pass uniforms on to the shaders
				filters[0].set("blurSize", 16);
				filters[0].set("sigma", 2.5);
				//filters[0].set("samplesize", 1);

  				filters[1].set("resolution", float(width), float(height));
  				filters[1].set("size", 2.0);
			} catch(RuntimeException e) {
				usefilters = false;
				toovmessages.add("Shader RuntimeException: " + e);
				toovmessages.add("Disabled filters");
			}
		} else {
			filters = new PShader[0];
		}
	}

	int[] validate() { // checks if in every prefabs the used furnitures are in the given boundary box (can only be executed after class construction)
		ArrayList<Integer> r1 = new ArrayList<Integer>();
		for (int i=0;i<prefabs.length;i++) {
			if(!prefabs[i].validate()) {
				r1.add(i);
			}
		}
        int[] r2 = new int[r1.size()];
        for (int i=0;i<r2.length;i++) {
         	r2[i] = r1.get(i);
        }
		return r2;
	}

	boolean validateId(int id) { // checks if a furniture with the given id exists
		for (int i=0;i<furnitures.length;i++) {
			if(furnitures[i].id == id) {
				return true;
			}
		}
		return false;
	}

	FurnitureData getFurnitureData(int id) { // return the furniture data with the corresponding id
		for (FurnitureData fdata : furnitures) {
			if(id == fdata.id) {
				return fdata;
			}
		}
		toovmessages.add("Furniture ID " + id + " not found");
		return new FurnitureData();
	}
	PrefabData getPrefabData(int id) { // return the prefab data with the corresponding id
		return prefabs[id];
	}

}

class FurnitureData {
	final int id;
	final int _width;
	final int _height;
	final PImage image;
	final PShape shape;
	final String name;
	final int price;

	FurnitureData() { // not found furniture
		this.id = -1;
		this._width = 0;
		this._height = 0;
		this.image = new PImage();
		this.shape = new PShape();
		this.name = "Not found";
		this.price = 0;
	}
	FurnitureData(int id, int _width, int _height, PImage image, PShape shape, String name, int price) {
		this.id = id;
		this._width = _width;
		this._height = _height;
		this.image = image;
		this.shape = shape;
		this.name = name;
		this.price = price;
	}
}

class PrefabFurnitureData {
	final int id;
	final int xpos;
	final int ypos;
	final int rot;

	PrefabFurnitureData(int id, int xpos, int ypos, int rot) {
		this.id = id;
		this.xpos = xpos;
		this.ypos = ypos;
		this.rot = rot;
	}
}

class PrefabData {
	final int _width;
	final int _height;
	final String name;
	final PrefabFurnitureData[] furnitures;

	PrefabData(int _width, int _height, String name, PrefabFurnitureData[] furnitures) {
		this._width = _width;
		this._height = _height;
		this.name = name;
		this.furnitures = furnitures;
	}

	PImage getImage() {
		PGraphics pg = createGraphics(_width*50,_height*50);
		pg.beginDraw();
		pg.scale(50);
		pg.background(0, c[0]);

		for (PrefabFurnitureData preffurndata : furnitures) {
			FurnitureData furndata = dm.getFurnitureData(preffurndata.id);

			pg.push();
			pg.translate(preffurndata.xpos, preffurndata.ypos);
			pg.rotate(HALF_PI*preffurndata.rot);

			int dx = (preffurndata.rot>1) ? -furndata._width : 0;
			int dy = (preffurndata.rot == 1 || preffurndata.rot ==2) ? -furndata._height : 0;
			pg.image(furndata.image, dx, dy, furndata._width, furndata._height); // draw furniture

			pg.pop();
		}
		pg.endDraw();
		return pg.get();
	}

	boolean isFurniture(int xpos, int ypos) {
		if(-1 < xpos && xpos < _width && -1 < ypos && ypos < _height) {
			for (PrefabFurnitureData preffurndata : furnitures) {
				FurnitureData furndata = dm.getFurnitureData(preffurndata.id);

				int w;
				int h;
				if(preffurndata.rot % 2 == 0) {
					w = furndata._width;
					h = furndata._height;
				} else {
					w = furndata._height;
					h = furndata._width;
				}
				for (int x=0;x<w;x++) {
					for (int y=0;y<h;y++) {
						if(preffurndata.xpos+x == xpos && preffurndata.ypos+y == ypos) {
							return true;
						}
					}
				}
			}
		}
		return false;
	}

	boolean validate() {
		boolean[][] tiles = new boolean[_width][_height];
		for (int x=0;x<tiles.length;x++) 
			for(int y=0;y<tiles[0].length;y++)
				tiles[x][y] = false;


		for (PrefabFurnitureData pfd : furnitures) {
			FurnitureData fdata = dm.getFurnitureData(pfd.id);

			for (int x=0;x<(pfd.rot % 2 == 0 ? fdata._width : fdata._height);x++) {
				for (int y=0;y<(pfd.rot % 2 == 0 ? fdata._height : fdata._width);y++) {
					if(-1 < pfd.xpos+x && pfd.xpos+x < _width && -1 < pfd.ypos+y && pfd.ypos+y < _height) {
						if(tiles[pfd.xpos+x][pfd.ypos+y]) {
							return false;
						} else {
							tiles[pfd.xpos+x][pfd.ypos+y] = true;
						}
					} else {
						return false;
					}
				}
			}
		}
		return true;
	}
	
}
