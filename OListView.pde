class ListView extends PWH implements IOverlay {
	Object[] items;
	int itemheight;
	Enum dir;
	int off = 0;

	ListView(Object[] items) {
		this(items, 0, 0, 30);
	}
	ListView(Object[] items, int _width, int _height) {
		this(items, _width, _height, 30);
	}
	ListView(Object[] items, int _width, int _height, Dir dir) {
		this(items, _width, _height, 0, dir);
	}
	ListView(Object[] items, int _width, int _height, int itemheight) {
		this(items, _width, _height, itemheight, Dir.DOWN);
	}
	ListView(Object[] items, int _width, int _height, int itemheight, Dir dir) {
		this.items = items;
		this.itemheight = itemheight;
		this.dir = dir;
		setWH(_width, _height);
	}

	void mouseWheel(MouseEvent ee) {
		if(isHit()) {
			int length = 0;

			for (Object item : items) {
				boolean e = false;
				if(item instanceof SizedBox) {
					if(((SizedBox)item).expand) {
						e = true;
					}
				}
				if(!e) {
					Box b = getItemBoundary(item);
					length += max(itemheight, (dir == Dir.DOWN || dir == Dir.UP) ? b.h : b.w);
				}
			}

			if(dir == Dir.UP || dir == Dir.DOWN) {
				if(length > _height) {
					off -= ee.getCount()*15;
					if(dir == Dir.UP) {
						off = constrain(off, 0, length - _height);
					} else {
						off = constrain(off, _height - length, 0);
					}
				}
			} else {
				if(length > _width) {
					off -= ee.getCount()*15;
					if(dir == Dir.DOWN) {
						off = constrain(off, 0, length - _width);
					} else {
						off = constrain(off, _width - length, 0);
					}
				}
			}
			recalculateitems();
		}
	}
	boolean mousePressed() {
		for (Object item : items) {
			mousePresseditem(item);
		}
		return isHit();
	}
	boolean mouseDragged() {
		for (Object item : items) {
			if(mouseDraggeditem(item)) {
				return true;
			}
		}
		return false;
	}
	void keyPressed() {
		for (Object item : items) {
			keyPresseditem(item);
		}
	}

	void draw(boolean hit) {
		fill(c[6]);
		clip(xpos, ypos, _width, _height);
		rect(xpos, ypos, _width, _height);

		for (Object item : items) {
			drawitem(item, hit);
		}
    	noClip();
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
		recalculateitems();
	}
	void setWH(int _width, int _height) {
		if(this._width == 0 && this._height == 0) {
			this._width = _width;
			this._height = _height;
		}
		recalculateitems();
	}
	void recalculateitems() {
		int sizelength = 0;
		int expands = 0;

		for (Object item : items) {
			boolean e = false;
			if(item instanceof SizedBox) {
				if(((SizedBox)item).expand) {
					e = true;
					expands++;
				}
			}
			if(!e) {
				Box b = getItemBoundary(item);
				sizelength += max(itemheight, (dir == Dir.DOWN || dir == Dir.UP) ? b.h : b.w);
			}
		}
		int expandsize = 0;
		if(expands > 0) {
			expandsize = (((dir == Dir.DOWN || dir == Dir.UP) ? _height : _width) - sizelength)/expands;
			if(expandsize < 0) {
				expandsize = 0;
			}
		}

		int off2 = 0;
		for (Object item : items) {
			boolean e = false;
			if(item instanceof SizedBox) {
				if(((SizedBox)item).expand) {
					e = true;
				}
			}
			Box b = getItemBoundary(item);
			if(dir == Dir.DOWN || dir == Dir.UP) {
				if(dir == Dir.DOWN) {
					setitemxy(item, xpos, ypos+off+off2);
				}
				if(e) {
					setitemwh(item, _width, expandsize);
					off2 += expandsize;
				} else {
					setitemwh(item, _width, max(itemheight, b.h));
					off2 += max(itemheight, b.h);
				}
				if(dir == Dir.UP) {
					setitemxy(item, xpos, ypos+_height-off-off2);
				}
			} else {
				if(dir == Dir.RIGHT) {
					setitemxy(item, xpos+off+off2, ypos);
				}
				if(e) {
					setitemwh(item, expandsize, _height);
					off2 += expandsize;
				} else {
					setitemwh(item, max(itemheight, b.w), _height);
					off2 += max(itemheight, b.w);
				}
				if(dir == Dir.LEFT) {
					setitemxy(item, xpos+_width-off-off2, ypos);
				}
			}
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
}
