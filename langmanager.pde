class LanguageManager {
	private int langid = 0;
	private JSONObject data;

	LanguageManager(String newlang) {
		println("Load LanguageManager");
		setlang(newlang);
	}

	void setlang(int newlangid) {
		langid = newlangid;
		String name;
		if(langid == 1) {
			name = "german";
		} else  {
			name = "english";
		}
		File f = new File(sketchPath("data/assets/lang/" + name + ".json"));
		if (f.exists()) {
			data = loadJSONObject("data/assets/lang/" + name + ".json");
		}
	}
	boolean setlang(String newlang) {
		switch(newlang.toLowerCase()) {
			case "english":
			setlang(0);
			return true;
			case "german":
			setlang(1);
			return true;
			default:
			setlang(0);
			return false;
		}
	}
	int getlang() {
		return langid;
	}

	String get(String key) {
		return data.getString(key, "Not Found");
	}

}