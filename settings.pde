class Settings {
	//final SettingColorValue[] colors;
	final SettingStringValue[] strings;
	final SettingBooleanValue[] booleans;
	final SettingIntValue[] ints;
	final SettingFloatValue[] floats;

	Settings() {
		if(deb) {
			println("Load Settings Class");
		}
		strings = new SettingStringValue[3];
		booleans = new SettingBooleanValue[4];
		ints = new SettingIntValue[3];
		floats = new SettingFloatValue[2];
		/*
		colors = new SettingColorValue[0];
		colors[0] = new SettingColorValue("backgroundcolor", color(0, 0, 0));
		colors[1] = new SettingColorValue("overlaybackgroundcolor", color(200, 200, 200));
		colors[2] = new SettingColorValue("overlaycolor", color(100, 100, 100));
		colors[3] = new SettingColorValue("gridlinecolor", color(255, 255, 255));
		*/
		strings[0] = new SettingStringValue("defaultroomname", "new Room");
		strings[1] = new SettingStringValue("language", "english");
		strings[2] = new SettingStringValue("font", "Roboto");

		booleans[0] = new SettingBooleanValue("darkmode", false);
		booleans[1] = new SettingBooleanValue("hide overlay", false);
		booleans[2] = new SettingBooleanValue("fullscreen", false);
		booleans[3] = new SettingBooleanValue("Use OpenGl Renderer", false);

		ints[0] = new SettingIntValue("width", 1200, 800, displayWidth);
		ints[1] = new SettingIntValue("height", 800, 600, displayHeight);
		ints[2] = new SettingIntValue("Anti-aliasing", 4, 0, 8);

		floats[0] = new SettingFloatValue("gridlineweight", 1);
		floats[1] = new SettingFloatValue("overlayscale", 1, 0.7, 1.5);

		load();
	}
	
	int getsize() {
		return strings.length + booleans.length + ints.length + floats.length;
	}
	String set(int id, String value) {
		String result = null;
		int index = 0;
		for (int i=0;i<strings.length;i++) {
			if(index == id) {
				result = strings[i].setvalue(value);
			}
			index++;
		}
		for (int i=0;i<booleans.length;i++) {
			if(index == id) {
				result = booleans[i].setvalue(value);
			}
			index++;
		}
		for (int i=0;i<ints.length;i++) {
			if(index == id) {
				result = ints[i].setvalue(value);
			}
			index++;
		}
		for (int i=0;i<floats.length;i++) {
			if(index == id) {
				result = floats[i].setvalue(value);
			}
			index++;
		}
		save();
		return result;
	}
	SettingValue get(int id) {
		int index = 0;
		for (int i=0;i<strings.length;i++) {
			if(index == id) {
				return strings[i].get();
			}
			index++;
		}
		for (int i=0;i<booleans.length;i++) {
			if(index == id) {
				return booleans[i].get();
			}
			index++;
		}
		for (int i=0;i<ints.length;i++) {
			if(index == id) {
				return ints[i].get();
			}
			index++;
		}
		for (int i=0;i<floats.length;i++) {
			if(index == id) {
				return floats[i].get();
			}
			index++;
		}
		println("Setting not found: " + id);
		return null;
	}
	void load() {
		if(deb) {
			println("Loaded Settings");
		}
		File f1 = new File(sketchPath("data/settings.json"));

		if (f1.exists())
		{
			JSONObject j = loadJSONObject("data/settings.json");
			/*
			for (int i=0;i<colors.length;i++) {
				SettingColorValue c = colors[i];
				c.setvalue(color(j.getFloat(c.name + "red"), j.getFloat(c.name + "green"), j.getFloat(c.name + "blue")));
				colors[i] = c;
			}
			*/
			for (int i=0;i<strings.length;i++) {
				SettingStringValue s = strings[i];
				s.setvalue(j.getString(s.name));
				strings[i] = s;
			}
			for (int i=0;i<booleans.length;i++) {
				SettingBooleanValue b = booleans[i];
				b.setvalue(j.getBoolean(b.name));
				booleans[i] = b;
			}
			for (int k=0;k<ints.length;k++) {
				SettingIntValue i = ints[k];
				i.setvalue(j.getInt(i.name));
				ints[k] = i;
			}
			for (int i=0;i<floats.length;i++) {
				SettingFloatValue f = floats[i];
				f.setvalue(j.getFloat(f.name));
				floats[i] = f;
			}
		}
	}

	void save() {
		if(deb) {
			println("Saved Settings");
		}

		File f1 = new File(sketchPath("data/settings.json"));
		JSONObject j = new JSONObject();
		if (f1.exists())
		{
			j = loadJSONObject("data/settings.json");
		}
		/*
		for (int i=0;i<colors.length;i++) {
			SettingColorValue c = colors[i];
			j.setFloat(c.name + "red", red(c.getvalue()));
			j.setFloat(c.name + "green", green(c.getvalue()));
			j.setFloat(c.name + "blue", blue(c.getvalue()));
		}
		*/
		for (int i=0;i<strings.length;i++) {
			SettingStringValue s = strings[i];
			j.setString(s.name, s.value);
		}
		for (int i=0;i<booleans.length;i++) {
			SettingBooleanValue b = booleans[i];
			j.setBoolean(b.name, b.value);
		}
		for (int k=0;k<ints.length;k++) {
			SettingIntValue i = ints[k];
			j.setInt(i.name, i.value);
		}
		for (int i=0;i<floats.length;i++) {
			SettingFloatValue f = floats[i];
			j.setFloat(f.name, f.value);
		}

		saveJSONObject(j, "data/settings.json");
	}
}
/*
class SettingColorValue {
	String name;
	color value;
	SettingColorValue(String newname) {
		name = newname;
	}
	SettingColorValue(String newname, color newdefaultvalue) {
		name = newname;
		value = newdefaultvalue;
	}
	void setvalue(color newvalue) {
		value = newvalue;
	}
}
*/
class SettingStringValue {
	String name;
	String value;
	SettingStringValue(String newname) {
		name = newname;
	}
	SettingStringValue(String newname, String newdefaultvalue) {
		name = newname;
		this.value = newdefaultvalue;
	}
	String setvalue(String newvalue) {
		this.value = newvalue;
		return this.value;
	}
	SettingValue get() {
		return new SettingValue(name, value, 0);
	}
}
class SettingBooleanValue {
	String name;
	boolean value;
	SettingBooleanValue(String newname) {
		name = newname;
	}
	SettingBooleanValue(String newname, boolean newdefaultvalue) {
		name = newname;
		this.value = newdefaultvalue;
	}
	void setvalue(boolean newvalue) {
		this.value = newvalue;
	}
	String setvalue(String newvalue) {
		if(newvalue.equals("true") || newvalue.equals("1")) {
			this.value = true;
			return "true";
		}
		if(newvalue.equals("false") || newvalue.equals("1")) {
			this.value = false;
			return "false";
		}
		return null;
	}
	SettingValue get() {
		return new SettingValue(name, str(value), 1);
	}
}
class SettingIntValue {
	String name;
	int value;
	int min = Integer.MIN_VALUE;
	int max = Integer.MAX_VALUE;
	SettingIntValue(String newname) {
		name = newname;
	}
	SettingIntValue(String newname, int newdefaultvalue) {
		name = newname;
		this.value = newdefaultvalue;
	}
	SettingIntValue(String newname, int newdefaultvalue, int minvalue, int maxvalue) {
		this(newname, newdefaultvalue);
		min = minvalue;
		max = maxvalue;
	}
	void setvalue(int newvalue) {
		value = constrain(newvalue, min, max);
	}
	String setvalue(String newvalue) {
		setvalue(int(newvalue));
		return str(value);
	}
	SettingValue get() {
		return new SettingValue(name, str(value), 2);
	}
}
class SettingFloatValue {
	String name;
	float value;
	float min = Float.MIN_VALUE;
	float max = Float.MAX_VALUE;
	SettingFloatValue(String newname) {
		name = newname;
	}
	SettingFloatValue(String newname, float newdefaultvalue) {
		name = newname;
		value = newdefaultvalue;
	}
	SettingFloatValue(String newname, float newdefaultvalue, float minvalue, float maxvalue) {
		this(newname, newdefaultvalue);
		min = minvalue;
		max = maxvalue;
	}
	void setvalue(float newvalue) {
		value = constrain(newvalue, min, max);
		if(Float.isNaN(this.value)) {
			value = 0;
		}
	}
	String setvalue(String newvalue) {
		setvalue(float(newvalue));
		return str(value);
	}
	SettingValue get() {
		return new SettingValue(name, str(value), 3);
	}
}
class SettingValue {
	String name;
	String value;
	int type;

	SettingValue(String name, String value, int type) {
		this.name = name;
		this.value = value;
		this.type = type;
	}
}