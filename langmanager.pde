class LanguageManager {
	int langid;
	String[] values;

	LanguageManager() {
		setlang(0);
	}

	void setlang(int newid) {
		langid = newid;

	}
	int getlang() {
		return langid;
	}

	String get(int id) {
		return "";
	}

}