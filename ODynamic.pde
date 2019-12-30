abstract class Dynamic extends PWH implements IOverlay {
	Object item;

	Dynamic() {
		item = getItem();
	}
	boolean mousePressed() {
		return mousePressedItem(item);
	}

	boolean mouseWheel(MouseEvent e) {
		return mouseWheelItem(item, e);
	}
	boolean mouseDragged() {
		return mouseDraggedItem(item);
	}
	void keyPressed() {
		keyPressedItem(item);
	}
	abstract Object getItem();

	void draw(boolean hit) {
		item = getItem();
		setItemXY(item, xpos, ypos);
		setItemWH(item, _width, _height);
		drawItem(item, hit);
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
