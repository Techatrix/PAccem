class GridView extends PWH implements IOverlay {
	Object[] items;
	int itemheight;
	int gridlength;
	int off = 0;
	//Enum dir = Dir.DOWN;
	// TODO: include direction

	GridView(Object[] items, int _width, int _height) {
		this(items, _width, _height, 1);
	}
	GridView(Object[] items, int _width, int _height, int gridlength) {
		this(items, _width, _height, gridlength, _width/gridlength);
	}
	GridView(Object[] items, int _width, int _height, int gridlength, int itemheight) {
		this.items = items;
		this._width = _width;
		this._height = _height;
		this.itemheight = itemheight;
		this.gridlength = gridlength;
		setWH(_width, _height);
	}

	boolean mousePressed() {
		if(isHit()) {
			for (Object item : items) {
				mousePressedItem(item);
			}
		}
		return isHit();
	}
	boolean mouseDragged() {
		boolean hit = false;
		if(isHit()) {
			for (Object item : items) {
				if(mousePressedItem(item)) {
					hit = true;
				}
			}
		}
		return hit;
	}
	boolean mouseWheel(MouseEvent e) {
		if(isHit()) {
			int length = itemheight * ceil(items.length / (float)gridlength);
			if(length > _height) {
				off -= e.getCount()*15;
				off = constrain(off, _height - length, 0);
			}
			recalculateItems();
			return true;
		}
		return false;
	}
	void keyPressed() {
		if(isHit()) {
			for (Object item : items) {
				keyPressedItem(item);
			}
		}
	}

	int getIndex() {
		for (int i=0;i<items.length;i++) {
			Object item = items[i];
			if(mousePressedItem(item)) {
				return i;
			}
		}
		return -1;
	}

	void draw(boolean hit) {
		fill(c[6]);

		boolean c = false;
		if(cl.get() == null) {
			cl.pushClip(xpos, ypos, _width, _height);
			c = true;
		}

		rect(xpos, ypos, _width, _height);
		boolean h = hit && isHit();
		for (Object item : items) {
			drawItem(item, h);
		}

		if(c) {
			cl.popClip();
		}
	}

	Box getBoundary() {
		return new Box(_width, _height);
	}

	boolean isHit() {
	  	return mouseX >= xpos && mouseX < xpos+_width && mouseY >= ypos && mouseY < ypos+_height;
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
		for (int i=0;i<items.length;i++) {
			Object item = items[i];
			int ih = floor(i / gridlength);
			int iw = i % gridlength;

			setItemXY(item, xpos+iw*(_width/gridlength), ypos+itemheight*ih+off);
			setItemWH(item, _width/gridlength, itemheight);
		}
	}
	
}
