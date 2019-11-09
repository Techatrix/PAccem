class Transform implements IOverlay {
	Object item;
	int xoff = 0;
	int yoff = 0;
	Align ali = null;

	// TODO: Allow Align and Transform at the same time
	Transform(Object item, int xoff, int yoff) {
		this.item = item;
		this.xoff = xoff;
		this.yoff = yoff;
	}
	Transform(Object item, Align ali) {
		this.item = item;
		this.ali = ali;
	}
	void mouseWheel(MouseEvent e) {
		mouseWheelitem(item, e);
	}
	boolean mousePressed() {
		return mousePresseditem(item);
	}
	void keyPressed() {
		keyPresseditem(item);
	}

	void draw(boolean hit) {
		drawitem(item, hit);
	}

	Box getbound() {
		return getboundry(item);
	}
	
	boolean ishit() {
	  	return getisitemhit(item);
	}

	void setxy(int xpos, int ypos) {
		recalculatealign();
		setitemxy(item, xpos+xoff, ypos+yoff);
	}
	void setwh(int _width, int _height) {
		setitemwh(item, _width, _height);
		recalculatealign();
	}
	void recalculatealign() {
		Box b = getbound();
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