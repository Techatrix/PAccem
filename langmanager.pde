class LanguageManager {
	JSONObject data;

	LanguageManager(String newlang) {
		if(deb) {
			println("Loaded LanguageManager");
		}
		setlang(newlang);
	}
	boolean setlang(String newlang) {
		newlang = newlang.toLowerCase();
		File f = new File(sketchPath("data/assets/lang/" + newlang + ".json"));
		if (f.exists()) {
			data = loadJSONObject("data/assets/lang/" + newlang + ".json");
			return true;
		} else {
			data = loadJSONObject("data/assets/lang/english.json");
		}
		return false;
	}

	String get(String key) {
		return data.getString(key, "Not Found");
	}

}