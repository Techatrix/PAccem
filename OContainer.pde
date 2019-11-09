class Container extends PWH implements IOverlay {
	Object item;
	color cc = color(c[5]);

	Container(Object item) {
		this.item = item;
		Box b = getboundry(item);
		setwh(round(b.w), round(b.h));
	}
	Container(Object item, int _width, int _height) {
		this._width = _width;
		this._height = _height;
		this.item = item;
		Box b = getboundry(item);
		setwh(max(round(b.w), _width), max(round(b.h), _height));
	}
	Container(Object item, int _width, int _height, color _color) {
		this(item, _width, _height);
		this.cc = _color;
	}

	void mouseWheel(MouseEvent e) {
		mouseWheelitem(item, e);
	}
	boolean mousePressed() {
		mousePresseditem(item);
		return ishit();
	}
	void keyPressed() {
		keyPresseditem(item);
	}

	void draw(boolean hit) {
		fill(cc);
		noStroke();
		rect(xpos, ypos, _width, _height);
		boolean h = hit && ishit();
		drawitem(item, h);
		if(h) {
			fill(c[8], 50);
			rect(xpos, ypos, _width, _height);
		}
	}

	Box getbound() {
		return new Box(_width, _height);
	}

	void setxy(int xpos, int ypos) {
		this.xpos = xpos;
		this.ypos = ypos;
		recalculateitems();
	}
	void setwh(int _width, int _height) {
		this._width = _width;
		this._height = _height;
		recalculateitems();
	}
	void recalculateitems() {
		setitemxy(item, xpos, ypos);
		setitemwh(item, _width, _height);
	}

	boolean ishit() {
		return mouseX >= xpos && mouseX < xpos+_width && mouseY >= ypos && mouseY < ypos+_height;
	}
}