abstract class EventDetector implements IOverlay {
	Object item;

	EventDetector(Object item) {
		this.item = item;
	}
	boolean mouseWheel(MouseEvent e) {
		if(isHit()) {
			onEvent(EventType.MOUSEWHEEL, e);
		}
		return mouseWheelItem(item, e);
	}
	boolean mousePressed() {
		if(isHit()) {
			onEvent(EventType.MOUSEPRESSED, null);
		}
		return mousePressedItem(item);
	}
	boolean mouseDragged() {
		if(isHit()) {
			onEvent(EventType.MOUSEDRAGGED, null);
		}
		return mouseDraggedItem(item);
	}
	void keyPressed() {
		if(isHit()) {
			onEvent(EventType.KEYPRESSED, null);
		}
		keyPressedItem(item);
	}
	abstract void onEvent(EventType et, MouseEvent e);

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
		setItemXY(item, xpos, ypos);
	}
	void setWH(int _width, int _height) {
		setItemWH(item, _width, _height);
	}

}
enum EventType {
	MOUSEWHEEL, MOUSEPRESSED, MOUSERELEASED, MOUSEDRAGGED, KEYPRESSED, KEYRELEASED;
}
