class Container extends PWH implements IOverlay {
	Object item;
	boolean autocolor = true;
	color _color;
	boolean selectable = true;

	Container() {
	}
	Container(Object item) {
		this.item = item;
	}
	Container(Object item, int _width, int _height) {
		this.item = item;
		Box b = getItemBoundary(item);
		setWH(max(round(b.w), _width), max(round(b.h), _height));
	}
	Container(Object item, int _width, int _height, color _color) {
		this(item, _width, _height);
		this._color = _color;
		this.autocolor = false;
	}
	Container(Object item, int _width, int _height, color _color, boolean selectable) {
		this(item, _width, _height, _color);
		this.selectable = selectable;
	}

	boolean mousePressed() {
		mousePressedItem(item);
		return isHit();
	}
	boolean mouseDragged() {
		return mouseDraggedItem(item);
	}
	boolean mouseWheel(MouseEvent e) {
		return mouseWheelItem(item, e);
	}
	void keyPressed() {
		keyPressedItem(item);
	}

	void draw(boolean hit) {
		fill(autocolor ? c[5] : _color);
		noStroke();
		rect(xpos, ypos, _width, _height);
		boolean h = hit && isHit();
		drawItem(item, h);
		if(h && selectable) {
			fill(c[8], 50);
			noStroke();
			rect(xpos, ypos, _width, _height);
		}
	}

	Box getBoundary() {
		return new Box(_width, _height);
	}

	void setXY(int xpos, int ypos) {
		this.xpos = xpos;
		this.ypos = ypos;
		recalculateItems();
	}

	void setWH(int _width, int _height) {
		if(this._width == 0 && this._height == 0) {
			this._width = _width;
			this._height = _height;
		}
		recalculateItems();
	}

	void recalculateItems() {
		setItemXY(item, xpos, ypos);
		setItemWH(item, _width, _height);
	}

	boolean isHit() {
		return mouseX >= xpos && mouseX < xpos+_width && mouseY >= ypos && mouseY < ypos+_height;
	}
	
}
