abstract class EventDetector implements IOverlay {
	Object item;

	EventDetector(Object item) {
		this.item = item;
	}
	boolean mousePressed() {
		if(ishit()) {
			onevent(EventType.MOUSEPRESSED, null);
		}
		return mousePresseditem(item);
	}

	void mouseWheel(MouseEvent e) {
		if(ishit()) {
			onevent(EventType.MOUSEWHEEL, e);
		}
		mouseWheelitem(item, e);
	}
	void keyPressed() {
		if(ishit()) {
			onevent(EventType.KEYPRESSED, null);
		}
		keyPresseditem(item);
	}
	abstract void onevent(EventType et, MouseEvent e);

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
		setitemxy(item, xpos, ypos);
	}
	void setwh(int _width, int _height) {
		setitemwh(item, _width, _height);
	}

}
enum EventType {
	MOUSEWHEEL, MOUSEPRESSED, MOUSERELEASED, MOUSEDRAGGED, KEYPRESSED, KEYRELEASED;
}