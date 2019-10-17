class Settings {
	SettingColorValue[] colors;
	SettingFloatValue[] floats;
	SettingIntValue[] ints;
	SettingStringValue[] strings;
	SettingBooleanValue[] booleans;

	Settings() {
		if(deb) {
			println("Load Settings Class");
		}
		colors = new SettingColorValue[0];
		floats = new SettingFloatValue[2];
		ints = new SettingIntValue[3];
		strings = new SettingStringValue[3];
		booleans = new SettingBooleanValue[4];
		/*
		colors[0] = new SettingColorValue("backgroundcolor", color(0, 0, 0));
		colors[1] = new SettingColorValue("overlaybackgroundcolor", color(200, 200, 200));
		colors[2] = new SettingColorValue("overlaycolor", color(100, 100, 100));
		colors[3] = new SettingColorValue("gridlinecolor", color(255, 255, 255));
		*/
		floats[0] = new SettingFloatValue("gridlineweight", 1);
		floats[1] = new SettingFloatValue("overlayscale", 1, 0.7, 1.5);

		ints[0] = new SettingIntValue("width", 1200, 800, displayWidth);
		ints[1] = new SettingIntValue("height", 800, 600, displayHeight);
		ints[2] = new SettingIntValue("Anti-aliasing", 4, 0, 8);

		strings[0] = new SettingStringValue("defaultroomname", "new Room");
		strings[1] = new SettingStringValue("language", "english");
		strings[2] = new SettingStringValue("font", "Roboto");

		booleans[0] = new SettingBooleanValue("darkmode", false);
		booleans[1] = new SettingBooleanValue("hide overlay", false);
		booleans[2] = new SettingBooleanValue("fullscreen", false);
		booleans[3] = new SettingBooleanValue("Use OpenGl Renderer", false);

		load();
	}
	
	int getsize() {
		return colors.length + floats.length + ints.length + strings.length + booleans.length;
	}

	void load() {
		if(deb) {
			println("Loaded Settings");
		}
		File f1 = new File(sketchPath("data/settings.json"));

		if (f1.exists())
		{
  			JSONObject j = loadJSONObject("data/settings.json");
  			for (int i=0;i<colors.length;i++) {
  				SettingColorValue c = colors[i];
  				c.setvalue(color(j.getFloat(c.name + "red"), j.getFloat(c.name + "green"), j.getFloat(c.name + "blue")));
  				colors[i] = c;
  			}
  			for (int i=0;i<floats.length;i++) {
  				SettingFloatValue f = floats[i];
  				f.setvalue(j.getFloat(f.name));
  				floats[i] = f;
  			}
  			for (int k=0;k<ints.length;k++) {
  				SettingIntValue i = ints[k];
  				i.setvalue(j.getInt(i.name));
  				ints[k] = i;
  			}
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
  		for (int i=0;i<colors.length;i++) {
  			SettingColorValue c = colors[i];
	  		j.setFloat(c.name + "red", red(c.getvalue()));
	  		j.setFloat(c.name + "green", green(c.getvalue()));
	  		j.setFloat(c.name + "blue", blue(c.getvalue()));
  		}
  		for (int i=0;i<floats.length;i++) {
  			SettingFloatValue f = floats[i];
	  		j.setFloat(f.name, f.getvalue());
  		}
  		for (int k=0;k<ints.length;k++) {
  			SettingIntValue i = ints[k];
	  		j.setInt(i.name, i.getvalue());
  		}
  		for (int i=0;i<strings.length;i++) {
  			SettingStringValue s = strings[i];
	  		j.setString(s.name, s.getvalue());
  		}
  		for (int i=0;i<booleans.length;i++) {
  			SettingBooleanValue b = booleans[i];
	  		j.setBoolean(b.name, b.getvalue());
  		}
		saveJSONObject(j, "data/settings.json");
	}
}

class SettingColorValue {
	String name;
	color _value;
	color _valuedefault;
	SettingColorValue(String newname) {
		name = newname;
	}
	SettingColorValue(String newname, color newdefaultvalue) {
		name = newname;
		_value = newdefaultvalue;
		_valuedefault = newdefaultvalue;
	}
	void setvalue(color newvalue) {
		_value = newvalue;
	}
	color getvalue() {
		return _value;
	}
	String gettext() {
		String text = name + ": ";
		text += str(floor(red(_value))) +" ";
		text += str(floor(green(_value))) +" ";
		text += str(floor(blue(_value))) +" ";
		return text;
	}
}
class SettingFloatValue {
	String name;
	float _value;
	float _valuedefault;
	float min = Float.MIN_VALUE;
	float max = Float.MAX_VALUE;
	SettingFloatValue(String newname) {
		name = newname;
	}
	SettingFloatValue(String newname, float newdefaultvalue) {
		name = newname;
		_value = newdefaultvalue;
		_valuedefault = newdefaultvalue;
	}
	SettingFloatValue(String newname, float newdefaultvalue, float minvalue, float maxvalue) {
		this(newname, newdefaultvalue);
		min = minvalue;
		max = maxvalue;
	}
	void setvalue(float newvalue) {
		_value = constrain(newvalue, min, max);
	}
	float getvalue() {
		return _value;
	}
	String gettext() {
		return name + ": " + _value;
	}
}
class SettingIntValue {
	String name;
	int _value;
	int _valuedefault;
	int min = Integer.MIN_VALUE;
	int max = Integer.MAX_VALUE;
	SettingIntValue(String newname) {
		name = newname;
	}
	SettingIntValue(String newname, int newdefaultvalue) {
		name = newname;
		_value = newdefaultvalue;
		_valuedefault = newdefaultvalue;
	}
	SettingIntValue(String newname, int newdefaultvalue, int minvalue, int maxvalue) {
		this(newname, newdefaultvalue);
		min = minvalue;
		max = maxvalue;
	}
	void setvalue(int newvalue) {
		_value = constrain(newvalue, min, max);
	}
	int getvalue() {
		return _value;
	}
	String gettext() {
		return name + ": " + _value;
	}
}
class SettingStringValue {
	String name;
	String _value;
	String _valuedefault;
	SettingStringValue(String newname) {
		name = newname;
	}
	SettingStringValue(String newname, String newdefaultvalue) {
		name = newname;
		_value = newdefaultvalue;
		_valuedefault = newdefaultvalue;
	}
	void setvalue(String newvalue) {
		_value = newvalue;
	}
	String getvalue() {
		return _value;
	}
	String gettext() {
		return name + ": " + _value;
	}
}
class SettingBooleanValue {
	String name;
	boolean _value;
	boolean _valuedefault;
	SettingBooleanValue(String newname) {
		name = newname;
	}
	SettingBooleanValue(String newname, boolean newdefaultvalue) {
		name = newname;
		_value = newdefaultvalue;
		_valuedefault = newdefaultvalue;
	}
	void setvalue(boolean newvalue) {
		_value = newvalue;
	}
	boolean getvalue() {
		return _value;
	}
	String gettext() {
		return name + ": " + _value;
	}
}