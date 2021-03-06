class LanguageManager {
	JSONObject data; // current language data

	LanguageManager(String newlang) {
		if(deb) {
			toovmessages.add("Loading LanguageManager");
		}
		setLang(newlang);
	}
	
	boolean setLang(String newlang) { // sets the current language if available
		newlang = newlang.toLowerCase();
		File f = new File(sketchPath("data/assets/lang/" + newlang + ".json"));
		if (f.exists()) {
			data = loadJSONObject(f.getPath());
			return true;
		} else {
			File ff = new File(sketchPath("data/assets/lang/english.json"));
			if(ff.exists()) {
				data = loadJSONObject(ff.getPath());
			} else {
				data = new JSONObject();
			}

		}
		return false;
	}

	String get(String key) { // get a translation in the current language
		String result = data.getString(key);
		if(result == null) {
			toovmessages.add("Translation for " + key + " doesnt exist");
			return "Not Found";
		}
		return result;
	}

}
