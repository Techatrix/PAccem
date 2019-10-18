class ListView extends PWH implements IOverlay {
	Object[] items;
	int itemheight;
	Enum dir = Dir.DOWN;

	int off = 0;

	ListView(Object[] items, int _width, int _height) {
		this(items, _width, _height, 30);
	}
	ListView(Object[] items, int _width, int _height, int itemheight) {
		this.items = items;
		this.itemheight = itemheight;
		setwh(_width, _height);
	}
	ListView(Object[] items, int _width, int _height, int itemheight, Dir dir) {
		this.items = items;
		this.itemheight = itemheight;
		this.dir = dir;
		setwh(_width, _height);
	}

	void mouseWheel(MouseEvent e) {
		if(ishit()) {
			if(dir == Dir.UP || dir == Dir.DOWN) {
				int length = items.length * itemheight;

				if(length > _height) {
					off -= e.getCount()*15;
					if(dir == Dir.UP) {
						off = constrain(off, 0, length - _height);
					} else {
						off = constrain(off, _height - length, 0);
					}
					recalculateitems();
				}
			}

		}
	}
	boolean mousePressed() {
		for (Object item : items) {
			mousePresseditem(item);
		}
		return ishit();
	}
	void keyPressed() {
		for (Object item : items) {
			keyPresseditem(item);
		}
	}
	
	int getindex() {
		for (int i=0;i<items.length;i++) {
			Object item = items[i];
			if(mousePresseditem(item)) {
				return i;
			}
		}
		return -1;
	}

	void draw() {
		fill(c[6]);
		clip(xpos, ypos, _width, _height);
		rect(xpos, ypos, _width, _height);

		for (Object item : items) {
			drawitem(item);
		}
    	noClip();
	}

	Box getbound() {
		return new Box(_width, _height);
	}
	
	boolean ishit() {
	  	return mouseX >= xpos && mouseX < xpos+_width && mouseY >= ypos && mouseY < ypos+_height;
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
		for (int i=0;i<items.length;i++) {
			Object item = items[i];

			int offset = (dir == Dir.LEFT ? _width : _height) - itemheight*(i+1);
			int x = (dir == Dir.RIGHT ? itemheight*i+off : 0) + (dir == Dir.LEFT ? offset+off : 0);
			int y = (dir == Dir.DOWN ? itemheight*i+off : 0) + (dir == Dir.UP ? offset+off : 0);
			setitemxy(item, xpos+x, ypos+y);

			if(dir == Dir.RIGHT || dir == Dir.LEFT) {
				setitemwh(item, itemheight, _height);
			} else {
				setitemwh(item, _width, itemheight);
			}
		}
	}
}


abstract class ListViewBuilder{
	ListView build(int length, int _width, int _height) {
		return build(length, _width, _height, 30, Dir.DOWN);
	}
	ListView build(int length, int _width, int _height, int itemheight) {
		return build(length, _width, _height, itemheight, Dir.DOWN);
	}
	ListView build(int length, int _width, int _height, int itemheight, Dir dir) {
		Object[] items = new Object[length];
		for (int i=0;i<length;i++) {
			items[i] = i(i);
		}
		return new ListView(items, _width, _height, itemheight, dir);
	}

	abstract Object i(int i);
}
abstract class Builder{

	Object[] build(int length) {
		Object[] items = new Object[length];
		for (int i=0;i<length;i++) {
			items[i] = i(i);
		}
		return items;
	}

	abstract Object i(int i);
}