abstract class Popup extends PWH implements IOverlay {
	Object item;
	boolean blur;

	Popup() {
		item = new Container();
	}
	Popup(Object item) {
		this(item, true);
	}
	Popup(Object item, boolean blur) {
		this.blur = blur;
		this.item = 
		new Container(
			new Transform(item, Align.CENTERCENTER)
			, width, height, color(0,150)
		);
	}
	Popup(Object[] items, String truetext, String falsetext) {
		this(items, truetext, falsetext, true);
	}
	Popup(Object[] items, String truetext, String falsetext, boolean blur) {
		this.blur = blur;
		Object[] listviewitems = new Object[items.length+1];
		for (int i=0;i<items.length;i++) {
			listviewitems[i] = items[i];
		}
        listviewitems[items.length] =
        new ListView(
			new Object[] {
				new EventDetector(new Container(new Text(truetext))) {
					@Override public void onEvent(EventType et, MouseEvent e) {
						if(et == EventType.MOUSEPRESSED) {ontrue();}
					}
				},
				new EventDetector(new Container(new Text(falsetext))) {
					@Override public void onEvent(EventType et, MouseEvent e) {
						if(et == EventType.MOUSEPRESSED) {onfalse();}
					}
				},
			}, width/4, 30, width/8, Dir.RIGHT
		);
		this.item = 
		new Container(
			new Transform(
				new ListView(
					listviewitems, width/4, height/4
				), Align.CENTERCENTER
			), width, height, color(0,150)
		);
	}

	void mouseWheel(MouseEvent e) {
		if(Visible()) {
			mouseWheelitem(item, e);
		}
	}
	boolean mousePressed() {
		if(Visible()) {
			return mousePresseditem(item);
		}
		return false;
	}
	boolean mouseDragged() {
		if(Visible()) {
			return mouseDraggeditem(item);
		}
		return false;
	}

	void keyPressed() {
		if(Visible()) {
			keyPresseditem(item);
		}
	}

	abstract void ontrue();
	abstract void onfalse();
	abstract boolean Visible();

	void draw(boolean hit) {
		if(Visible()) {
			if(blur && usegl && !disableblur) {
				filter(blurshader);
			}
			drawitem(item, hit);
		}
	}

	Box getBoundary() {
		return getItemBoundary(item);
	}

	void setXY(int xpos, int ypos) {
		setitemxy(item, xpos, ypos);
	}
	void setWH(int _width, int _height) {
		setitemwh(item, _width, _height);
	}

	boolean isHit() {
		return Visible() && getisItemHit(item);
	}
}
