abstract class GetVisible implements IOverlay {
	Object item;

	GetVisible(Object item) {
		this.item = item;
	}

	void mouseWheel(MouseEvent e) {
		if(getvisible()) {
			mouseWheelitem(item, e);
		}
	}
	boolean mousePressed() {
		if(getvisible()) {
			return mousePresseditem(item);
		}
		return false;
	}
	boolean mouseDragged() {
		if(getvisible()) {
			return mouseDraggeditem(item);
		}
		return false;
	}

	void keyPressed() {
		if(getvisible()) {
			keyPresseditem(item);
		}
	}
	abstract boolean getvisible();

	void draw(boolean hit) {
		if(getvisible()) {
			drawitem(item, hit);
		}
	}

	Box getbound() {
		return getboundry(item);
	}
	
	boolean ishit() {
		if(getvisible()) {
	  		return getisitemhit(item);
		}
		return false;
	}

	void setxy(int xpos, int ypos) {
		setitemxy(item, xpos, ypos);
	}
	void setwh(int _width, int _height) {
		setitemwh(item, _width, _height);
	}
}