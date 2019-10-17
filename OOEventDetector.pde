abstract class EventDetector implements IOverlay {
	Object item;

	EventDetector(Object item) {
		this.item = item;
	}
	boolean mousePressed() {
		return mousePresseditem(item);
	}

	void mouseWheel(MouseEvent e) {
		mouseWheelitem(item, e);
	}
	abstract void onevent(EventType et, MouseEvent e);

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
		setitemxy(item, xpos, ypos);
	}
	void setwh(int _width, int _height) {
		setitemwh(item, _width, _height);
	}

}
enum EventType {
	MOUSEWHEEL, MOUSEPRESSED, MOUSERELEASED, MOUSEDRAGGED, KEYPRESSED, KEYRELEASED;
}