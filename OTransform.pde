class Transform implements IOverlay {
	Object item;
	int xoff = 0;
	int yoff = 0;
	Corner cor = null;

	// TODO: Allow Align and Transform at the same time
	Transform(Object item, int xoff, int yoff) {
		this.item = item;
		this.xoff = xoff;
		this.yoff = yoff;
	}
	Transform(Object item, Corner cor) {
		this.item = item;
		this.cor = cor;
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

	void draw() {
		drawitem(item);
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
		if(cor == Corner.TOPRIGHT) {
			this.xoff = width-b.w;
		} else if(cor == Corner.BOTTOMLEFT) {
			this.yoff = height-b.h;
		} else if(cor == Corner.BOTTOMRIGHT) {
			this.xoff = width-b.w;
			this.yoff = height-b.h;
		}
	}
}