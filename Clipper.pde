class Clipper {
	ArrayList<Clip> clips;	// contains clip information

	Clipper() {
		clips = new ArrayList<Clip>();
		clips.add(null);
	}

	Clip get() { // return the current clip setting
		return clips.get(clips.size()-1);
	}

	void pushClip(int x, int y, int w, int h) { // "pushes" the current clip setting
		clips.add(new Clip(x,y,w,h));
		imageMode(CORNER);
		clip(x,y,w,h);
	}

	void popClip() { // "poppes" the current clip
		if(clips.size() > 0) {
			clips.remove(clips.size()-1);
			Clip c = get();
			if(c == null) {
				noClip();
			} else {
				imageMode(CORNER);
				clip(c.x,c.y,c.w,c.h);
			}
		} else {
			noClip();
		}
	}

}

class Clip {
	int x;
	int y;
	int w;
	int h;

	Clip(int x, int y, int w, int h) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}
}
