class Settings {
	SettingColorValue[] colors;
	SettingFloatValue[] floats;
	SettingIntValue[] ints;
	SettingStringValue[] strings;
	SettingBooleanValue[] booleans;

	Settings() {
		colors = new SettingColorValue[5];
		floats = new SettingFloatValue[2];
		ints = new SettingIntValue[2];
		strings = new SettingStringValue[2];
		booleans = new SettingBooleanValue[4];

		colors[0] = new SettingColorValue("backgroundcolor", color(0, 0, 0));
		colors[1] = new SettingColorValue("tabbarcolor", color(200, 200, 200));
		colors[2] = new SettingColorValue("tabcolor", color(100, 100, 100));
		colors[3] = new SettingColorValue("gridlinecolor", color(255, 255, 255));
		colors[4] = new SettingColorValue("gridtilecolor", color(120, 120, 120));

		floats[0] = new SettingFloatValue("gridlineweight", 1);
		floats[1] = new SettingFloatValue("overlayscale", 1);

		ints[0] = new SettingIntValue("width", 1200);
		ints[1] = new SettingIntValue("height", 800);

		strings[0] = new SettingStringValue("defaultroomname", "new Room");
		strings[1] = new SettingStringValue("language", "english");

		booleans[0] = new SettingBooleanValue("darkmode", false);
		booleans[1] = new SettingBooleanValue("no blur", false);
		booleans[2] = new SettingBooleanValue("hide overlay", false);
		booleans[3] = new SettingBooleanValue("fullscreen", false);

		load();
	}

	int getsize() {
		return colors.length + floats.length + ints.length + strings.length + booleans.length;
	}

	void load() {
		println("Load Settings");
		File f1 = new File(sketchPath("data/settings.json"));

		if (f1.exists())
		{
  			JSONObject j = loadJSONObject("data/settings.json");
  			for (int i=0;i<colors.length;i++) {
  				SettingColorValue c = colors[i];
  				c._color = color(j.getFloat(c.name + "red"), j.getFloat(c.name + "green"), j.getFloat(c.name + "blue"));
  				colors[i] = c;
  			}
  			for (int i=0;i<floats.length;i++) {
  				SettingFloatValue f = floats[i];
  				f._float = j.getFloat(f.name);
  				floats[i] = f;
  			}
  			for (int k=0;k<ints.length;k++) {
  				SettingIntValue i = ints[k];
  				i._int = j.getInt(i.name);
  				ints[k] = i;
  			}
  			for (int i=0;i<strings.length;i++) {
  				SettingStringValue s = strings[i];
  				s._string = j.getString(s.name);
  				strings[i] = s;
  			}
  			for (int i=0;i<booleans.length;i++) {
  				SettingBooleanValue b = booleans[i];
  				b._boolean = j.getBoolean(b.name);
  				booleans[i] = b;
  			}
		}
		if(ov != null) {
			ov.sidebars[2].newsettings(st);
		}
	}

	void save() {
		println("Save Settings");

		File f1 = new File(sketchPath("data/settings.json"));
		JSONObject j = new JSONObject();
		if (f1.exists())
		{
  			j = loadJSONObject("data/settings.json");
		}
  		for (int i=0;i<colors.length;i++) {
  			SettingColorValue c = colors[i];
	  		j.setFloat(c.name + "red", red(c._color));
	  		j.setFloat(c.name + "green", green(c._color));
	  		j.setFloat(c.name + "blue", blue(c._color));
  		}
  		for (int i=0;i<floats.length;i++) {
  			SettingFloatValue f = floats[i];
	  		j.setFloat(f.name, f._float);
  		}
  		for (int k=0;k<ints.length;k++) {
  			SettingIntValue i = ints[k];
	  		j.setInt(i.name, i._int);
  		}
  		for (int i=0;i<strings.length;i++) {
  			SettingStringValue s = strings[i];
	  		j.setString(s.name, s._string);
  		}
  		for (int i=0;i<booleans.length;i++) {
  			SettingBooleanValue b = booleans[i];
	  		j.setBoolean(b.name, b._boolean);
  		}
		saveJSONObject(j, "data/settings.json");
	}
}

class SettingColorValue {
	String name;
	color _color;
	color _colordefault;
	SettingColorValue(String newname) {
		name = newname;
	}
	SettingColorValue(String newname, color newdefaultcolor) {
		name = newname;
		_color = newdefaultcolor;
		_colordefault = newdefaultcolor;
	}
	String gettext() {
		String text = name + ": ";
		text += str(floor(red(_color))) +" ";
		text += str(floor(green(_color))) +" ";
		text += str(floor(blue(_color))) +" ";
		return text;
	}
}
class SettingFloatValue {
	String name;
	float _float;
	float _floatdefault;
	float min;
	float max;
	SettingFloatValue(String newname) {
		name = newname;
	}
	SettingFloatValue(String newname, float newdefaultfloat) {
		name = newname;
		_float = newdefaultfloat;
		_floatdefault = newdefaultfloat;
	}
	String gettext() {
		return name + ": " + _float;
	}
}
class SettingIntValue {
	String name;
	int _int;
	int _intdefault;
	SettingIntValue(String newname) {
		name = newname;
	}
	SettingIntValue(String newname, int newdefaultint) {
		name = newname;
		_int = newdefaultint;
		_intdefault = newdefaultint;
	}
	String gettext() {
		return name + ": " + _int;
	}
}
class SettingStringValue {
	String name;
	String _string;
	String _stringdefault;
	SettingStringValue(String newname) {
		name = newname;
	}
	SettingStringValue(String newname, String newdefaultstring) {
		name = newname;
		_string = newdefaultstring;
		_stringdefault = newdefaultstring;
	}
	String gettext() {
		return name + ": " + _string;
	}
}
class SettingBooleanValue {
	String name;
	boolean _boolean;
	boolean _booleandefault;
	SettingBooleanValue(String newname) {
		name = newname;
	}
	SettingBooleanValue(String newname, boolean newdefaultboolean) {
		name = newname;
		_boolean = newdefaultboolean;
		_booleandefault = newdefaultboolean;
	}
	String gettext() {
		return name + ": " + _boolean;
	}
}