abstract class Visible implements IOverlay {
	Object item;
	
	Visible() {
	}
	Visible(Object item) {
		this.item = item;
	}
	boolean mouseWheel(MouseEvent e) {
		if(Visible()) {
			return mouseWheelItem(item, e);
		}
		return false;
	}
	boolean mousePressed() {
		if(Visible()) {
			return mousePressedItem(item);
		}
		return false;
	}
	boolean mouseDragged() {
		if(Visible()) {
			return mouseDraggedItem(item);
		}
		return false;
	}

	void keyPressed() {
		if(Visible()) {
			keyPressedItem(item);
		}
	}
	abstract boolean Visible();

	void draw(boolean hit) {
		if(Visible()) {
			drawItem(item, hit);
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
		setItemXY(item, xpos, ypos);
	}
	void setWH(int _width, int _height) {
		setItemWH(item, _width, _height);
	}
}
