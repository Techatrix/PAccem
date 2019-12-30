abstract class Visible implements IOverlay {
	Object item;
	
	Visible() {
	}
	Visible(Object item) {
		this.item = item;
	}

	void mouseWheel(MouseEvent e) {
		if(Visible()) {
			mouseWheelitem(item, e);
		}
	}
	boolean mousePressed() {
		if(Visible()) {
			return mousePresseditem(item);
		}
		return false;
	}
	boolean mouseDragged() {
		if(Visible()) {
			return mouseDraggeditem(item);
		}
		return false;
	}

	void keyPressed() {
		if(Visible()) {
			keyPresseditem(item);
		}
	}
	abstract boolean Visible();

	void draw(boolean hit) {
		if(Visible()) {
			drawitem(item, hit);
		}
	}

	Box getBoundary() {
		return getItemBoundary(item);
	}
	
	boolean isHit() {
		if(Visible()) {
	  		return getisItemHit(item);
		}
		return false;
	}

	void setXY(int xpos, int ypos) {
		setitemxy(item, xpos, ypos);
	}
	void setWH(int _width, int _height) {
		setitemwh(item, _width, _height);
	}
}
