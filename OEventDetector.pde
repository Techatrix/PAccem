abstract class EventDetector implements IOverlay {
	Object item;

	EventDetector(Object item) {
		this.item = item;
	}
	void mouseWheel(MouseEvent e) {
		if(isHit()) {
			onEvent(EventType.MOUSEWHEEL, e);
		}
		mouseWheelitem(item, e);
	}
	boolean mousePressed() {
		if(isHit()) {
			onEvent(EventType.MOUSEPRESSED, null);
		}
		return mousePresseditem(item);
	}
	boolean mouseDragged() {
		if(isHit()) {
			onEvent(EventType.MOUSEDRAGGED, null);
		}
		return mouseDraggeditem(item);
	}
	void keyPressed() {
		if(isHit()) {
			onEvent(EventType.KEYPRESSED, null);
		}
		keyPresseditem(item);
	}
	abstract void onEvent(EventType et, MouseEvent e);

	void draw(boolean hit) {
		drawitem(item, hit);
	}

	Box getBoundary() {
		return getItemBoundary(item);
	}
	
	boolean isHit() {
		return getisItemHit(item);
	}

	void setXY(int xpos, int ypos) {
		setitemxy(item, xpos, ypos);
	}
	void setWH(int _width, int _height) {
		setitemwh(item, _width, _height);
	}

}
enum EventType {
	MOUSEWHEEL, MOUSEPRESSED, MOUSERELEASED, MOUSEDRAGGED, KEYPRESSED, KEYRELEASED;
}
