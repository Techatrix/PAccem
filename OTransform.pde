class Transform implements IOverlay {
	Object item;
	int xoff;
	int yoff;

	Transform(Object item, int xoff, int yoff) {
		this.item = item;
		this.xoff = xoff;
		this.yoff = yoff;
	}
	
	void mouseWheel(MouseEvent e) {
		mouseWheelitem(item, e);
	}
	boolean mousePressed() {
		return mousePresseditem(item);
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
		setitemxy(item, xpos+xoff, ypos+yoff);
	}
	void setwh(int _width, int _height) {
		setitemwh(item, _width, _height);
	}
}
class Align implements IOverlay {
	Object item;
	Enum cor = Corner.TOPLEFT;

	Align(Object item, Corner cor) {
		this.item = item;
		this.cor = cor;
	}

	void mouseWheel(MouseEvent e) {
		mouseWheelitem(item, e);
	}
	boolean mousePressed() {
		return mousePresseditem(item);
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
		Box b = getbound();
		int xoff = 0;
		int yoff = 0;
		if(cor == Corner.TOPRIGHT) {
			xoff = width-b.w;
		} else if(cor == Corner.BOTTOMLEFT) {
			yoff = height-b.h;
		} else if(cor == Corner.BOTTOMRIGHT) {
			xoff = width-b.w;
			yoff = height-b.h;
		}
		setitemxy(item, xpos+xoff, ypos+yoff);
	}
	void setwh(int _width, int _height) {
		setitemwh(item, _width, _height);
	}
}