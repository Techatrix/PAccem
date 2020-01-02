class Transform implements IOverlay {
	Object item;
	int xoff = 0;
	int yoff = 0;
	Align ali;

	Transform(Object item, int xoff, int yoff) {
		this.item = item;
		this.xoff = xoff;
		this.yoff = yoff;
	}
	Transform(Object item, Align ali) {
		this.item = item;
		this.ali = ali;
	}
	Transform(Object item, int xoff, int yoff, Align ali) {
		this.item = item;
		this.xoff = xoff;
		this.yoff = yoff;
		this.ali = ali;
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
		drawItem(item, hit);
	}

	Box getBoundary() {
		return getItemBoundary(item);
	}
	
	boolean isHit() {
	  	return getisItemHit(item);
	}

	void setXY(int xpos, int ypos) {
		recalculatealign();
		setItemXY(item, xpos+xoff, ypos+yoff);
	}
	void setWH(int _width, int _height) {
		setItemWH(item, _width, _height);
		recalculatealign();
	}
	void recalculatealign() {
		Box b = getBoundary();
		if(ali == Align.TOPRIGHT) {
			this.xoff = width-b.w;
		} else if(ali == Align.BOTTOMLEFT) {
			this.yoff = height-b.h;
		} else if(ali == Align.BOTTOMRIGHT) {
			this.xoff = width-b.w;
			this.yoff = height-b.h;
		} else if(ali == Align.CENTERCENTER) {
			this.xoff = (width-b.w)/2;
			this.yoff = (height-b.h)/2;
		}
	}
}
