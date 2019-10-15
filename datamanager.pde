class DataManager {
	final PImage[] icons;
	final FurnitureData[] furnitures;
	final JSONArray furnituredata;

	DataManager() {
		println("Load DataManager");
		icons = new PImage[8];

		icons[0] = loadImage("assets/icon/0.png");
		icons[1] = loadImage("assets/icon/1.png");
		icons[2] = loadImage("assets/icon/2.png");
		icons[3] = loadImage("assets/icon/3.png");
		icons[4] = loadImage("assets/icon/4.png");
		icons[5] = loadImage("assets/icon/5.png");
		icons[6] = loadImage("assets/icon/6.png");
		icons[7] = loadImage("assets/icon/0.png");

		File f = new File(sketchPath("assets/furn/data.json"));
		if (f.exists()) {
			furnituredata = loadJSONArray("assets/furn/data.json");
		} else {
			furnituredata = new JSONArray();
		}

		furnitures = new FurnitureData[furnituredata.size()];
		for (int i=0;i<furnituredata.size();i++) {
			JSONObject furn = furnituredata.getJSONObject(i);

			int _width = furn.getInt("width", 1);
			int _height = furn.getInt("height", 1);
			String src = furn.getString("src");
			PImage image = loadImage("assets/furn/img/" + src +".png");
			PShape shape = null;
			if(highbit) {
				shape = pg.loadShape("assets/furn/mdl/" + src +".obj");
			}
			String name = furn.getString("name", "Name not Found");
			furnitures[i] = new FurnitureData(i, _width, _height, image, shape, name);
		}
	}
	FurnitureData getfurnituredata(int id) {
		for (FurnitureData fdata : furnitures) {
			if(id == fdata.id) {
				return fdata;
			}
		}
		return null;
	}
}


class FurnitureData {
	final int id;
	final int _width;
	final int _height;
	final PImage image;
	final PShape shape;
	final String name;

	FurnitureData(int id, int _width, int _height, PImage image, PShape shape, String name) {
		this.id = id;
		this._width = _width;
		this._height = _height;
		this.image = image;
		this.shape = shape;
		this.name = name;
	}
}