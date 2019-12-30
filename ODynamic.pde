abstract class Dynamic extends PWH implements IOverlay {
	Object item;

	Dynamic() {
		item = getItem();
	}
	boolean mousePressed() {
		return mousePresseditem(item);
	}

	void mouseWheel(MouseEvent e) {
		mouseWheelitem(item, e);
	}
	boolean mouseDragged() {
		return mouseDraggeditem(item);
	}
	void keyPressed() {
		keyPresseditem(item);
	}
	abstract Object getItem();

	void draw(boolean hit) {
		item = getItem();
		setitemxy(item, xpos, ypos);
		setitemwh(item, _width, _height);
		drawitem(item, hit);
	}

	Box getBoundary() {
		return getItemBoundary(item);
	}
	
	boolean isHit() {
		return getisItemHit(item);
	}
	void setXY(int xpos, int ypos) {
		this.xpos = xpos;
		this.ypos = ypos;
	}
	void setWH(int _width, int _height) {
		this._width = _width;
		this._height = _height;
	}
}
