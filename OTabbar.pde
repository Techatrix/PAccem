abstract class Tabbar implements IOverlay {
	Object list;
	Object[] tabs;

	Tabbar(Object list, Object[] tabs) {
		this.list = list;
		this.tabs = tabs;
	}

	void draw(boolean hit) {
		drawItem(list, hit);
		if(isValidTab()) {
			drawItem(tabs[getId()], hit);
		}
	}

	boolean mousePressed() {
		boolean hit = false;
		if(mousePressedItem(list)) {
			hit = true;
			onTab(getListIndex(list));
		}
		if(isValidTab()) {
			if(mousePressedItem(tabs[getId()])) {
				hit = true;
			}
		}
		return hit;
	}
	boolean mouseDragged() {
		boolean hit = false;
		if(mouseDraggedItem(list)) {
			hit = true;
			onTab(getListIndex(list));
		}
		if(isValidTab()) {
			if(mouseDraggedItem(tabs[getId()])) {
				hit = true;
			}
		}
		return hit;
	}
	boolean mouseWheel(MouseEvent e) {
		boolean result = mouseWheelItem(list, e);
		if(isValidTab()) {
			if(mouseWheelItem(tabs[getId()], e)) {
				result = true;
			}
		}
		return result;
	}
	void keyPressed() {
		keyPressedItem(list);
		if(isValidTab()) {
			keyPressedItem(tabs[getId()]);
		}
	}

	abstract void onTab(int i);
	abstract int getId();

	boolean isValidTab() {
		return -1 < getId() && getId() < tabs.length;
	}

	Box getBoundary() {
		return getItemBoundary(list);
	}
	
	boolean isHit() {
		boolean hit = false;
		if(getisItemHit(list)) {
			hit = true;
		}
		if(isValidTab()) {
			if(getisItemHit(tabs[getId()])) {
				hit = true;
			}
		}
		return hit;
	}

	void setXY(int xpos, int ypos) {
		setItemXY(list, xpos, ypos);
		for (Object tab : tabs) {
			setItemXY(tab, xpos, ypos);
		}
	}

	void setWH(int _width, int _height) {
		setItemWH(list, _width, _height);
		for (Object tab : tabs) {
			setItemWH(tab, _width, _height);
		}
	}
	
}
