class Container extends PWH implements IOverlay {
	Object item;
	ContainerStyle style = new ContainerStyle();

	Container(Object item) {
		this.item = item;
		Box b = getboundry(item);
		setwh(round(b.w), round(b.h));
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

	void draw() {
		if(style.drawbackground) {
			fill(style.backgroundcolor);
		}
		noStroke();
		rect(xpos, ypos, _width, _height);
		drawitem(item);
		if(style.drawhighlight) {
			if(ishit()) {
				fill(style.highlighcolor);
				rect(xpos, ypos, _width, _height);
			}
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

class ContainerStyle {
	boolean drawhighlight;
	color highlighcolor;
	boolean drawbackground;
	color backgroundcolor;

	ContainerStyle() {
		drawhighlight = true;
		highlighcolor = color(0,50);
		drawbackground = true;
		backgroundcolor = color(0,50);
	}

}