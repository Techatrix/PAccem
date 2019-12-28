class DataManager {
	final PImage[] icons;				// list of all icons
	final PImage[] extras;				// list of all extra images(data/assets/img/)
	final FurnitureData[] furnitures;	// list of all furnitures that can be used
	final PrefabData[] prefabs;			// list of all prefabs that can be used

	// TODO: Validation
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

			int _width = furn.getInt("width", 1);
			int _height = furn.getInt("height", 1);
			String src = furn.getString("src");
			int price = furn.getInt("price", 0);
			PImage image = loadImage("data/assets/furn/img/" + src +".png");
			PShape shape = null;
			if(usegl) {
				shape = pg.loadShape("data/assets/furn/mdl/" + src +".obj");
			}
			String name = furn.getString("name", "Name not Found");
			furnitures[i] = new FurnitureData(i, _width, _height, image, shape, name, price);
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
				prefabfurns[j] = new PrefabFurnitureData(furnid, xpos, ypos);
			}

			prefabs[i] = new PrefabData(_width, _height, name, prefabfurns);
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
		this._width = 1;
		this._height = 1;
		this.image = dm.extras[0];
		this.shape = new PShape();
		this.name = "Not Found";
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

	PrefabFurnitureData(int id, int xpos, int ypos) {
		this.id = id;
		this.xpos = xpos;
		this.ypos = ypos;
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
		pg.background(0, 50);

		for (int i=0;i<furnitures.length;i++) {
			PrefabFurnitureData preffurndata = furnitures[i];
			FurnitureData furndata = dm.getFurnitureData(preffurndata.id);
			pg.image(furndata.image, preffurndata.xpos, preffurndata.ypos, furndata._width, furndata._height);
		}
		pg.endDraw();
		return pg.get();
	}

	boolean isFurniture(int xpos, int ypos) {
		if(xpos > -1 && xpos < _width && ypos > -1 && ypos < _height) {
			for (int i=0;i<furnitures.length;i++) {
				PrefabFurnitureData preffurndata = furnitures[i];
				FurnitureData furndata = dm.getFurnitureData(preffurndata.id);
				for (int x=0;x<furndata._width;x++) {
					for (int y=0;y<furndata._height;y++) {
						if(xpos == preffurndata.xpos+x && ypos == preffurndata.ypos+y) {
							return true;
						}
					}
				}
			}
		}
		return false;
	}

	// TODO: can be optimized : only check boundary of furniture and not every tile
	boolean validate() {
		boolean result = true;
		for (PrefabFurnitureData pfd : furnitures) {
			FurnitureData fd = dm.getFurnitureData(pfd.id);
			for (int x=0;x<fd._width;x++) {
				for (int y=0;y<fd._height;y++) {
					if(pfd.xpos+x >= _width || pfd.xpos+x < 0) {
						result = false;
					}
					if(pfd.ypos+y >= _height || pfd.ypos+y < 0) {
						result = false;
					}
				}
			}
		}
		return result;
	}
}
