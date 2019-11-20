abstract class Dynamic extends PWH implements IOverlay {
	Object item;

	Dynamic() {
		item = getitem();
	}
	boolean mousePressed() {
		return mousePresseditem(item);
	}

	void mouseWheel(MouseEvent e) {
		mouseWheelitem(item, e);
	}
	void keyPressed() {
		keyPresseditem(item);
	}
	abstract Object getitem();

	void draw(boolean hit) {
		item = getitem();
		setitemxy(item, xpos, ypos);
		setitemwh(item, _width, _height);
		drawitem(item, hit);
	}

	Box getbound() {
		return getboundry(item);
	}
	
	boolean ishit() {
		return getisitemhit(item);
	}
	void setxy(int xpos, int ypos) {
		this.xpos = xpos;
		this.ypos = ypos;
	}
	void setwh(int _width, int _height) {
		this._width = _width;
		this._height = _height;
	}
}