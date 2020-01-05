class Filter extends PWH implements IOverlay {
	Object item;
	int filterid;
	boolean postfilter;

	Filter(Object item, int filterid) {
		this(item, filterid, false);
	}
	Filter(Object item, int filterid, boolean postfilter) {
		this.item = item;
		this.filterid = filterid;
		this.postfilter = postfilter;
	}

	boolean mousePressed() {
		return mousePressedItem(item);
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
		cl.pushClip(xpos, ypos, _width, _height);
		if(!postfilter && usegl && !disablefilters) {
			filter(dm.filters[filterid]);
		}
		drawItem(item, hit);
		if(postfilter && usegl && !disablefilters) {
			filter(dm.filters[filterid]);
		}
		cl.popClip();
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
		setItemXY(item, xpos, ypos);
	}
	void setWH(int _width, int _height) {
		this._width = _width;
		this._height = _height;
		setItemWH(item, _width, _height);
	}
}
