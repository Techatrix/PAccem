static class LG {
	private int langid = 0;
	//String[] values;

	static {
		println("Static executed");	
	}

	void setlang(int newid) {
		langid = newid;
	}
	int getlang() {
		return langid;
	}

	static String get(int id) {
		return "Text";
	}

}