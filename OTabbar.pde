abstract class Tabbar implements IOverlay {
	Object list;
	Object[] tabs;

	Tabbar(Object list, Object[] tabs) {
		this.list = list;
		this.tabs = tabs;
	}

	void draw(boolean hit) {
		drawitem(list, hit);
		if(isvalidtab()) {
			drawitem(tabs[getid()], hit);
		}
	}

	void mouseWheel(MouseEvent e) {
		mouseWheelitem(list, e);
		if(isvalidtab()) {
			mouseWheelitem(tabs[getid()], e);
		}
	}
	boolean mousePressed() {
		boolean hit = false;
		if(mousePresseditem(list)) {
			hit = true;
			ontab(getlistindex(list));
		}
		if(isvalidtab()) {
			if(mousePresseditem(tabs[getid()])) {
				hit = true;
			}
		}
		return hit;
	}
	boolean mouseDragged() {
		return false;
	}
	void keyPressed() {
		keyPresseditem(list);
		if(isvalidtab()) {
			keyPresseditem(tabs[getid()]);
		}
	}

	abstract void ontab(int i);
	abstract int getid();

	boolean isvalidtab() {
		return -1 < getid() && getid() < tabs.length;
	}

	Box getbound() {
		return getboundry(list);
	}
	
	boolean ishit() {
		boolean hit = false;
		if(getisitemhit(list)) {
			hit = true;
		}
		if(isvalidtab()) {
			if(getisitemhit(tabs[getid()])) {
				hit = true;
			}
		}
		return hit;
	}

	void setxy(int xpos, int ypos) {
		setitemxy(list, xpos, ypos);
		for (Object tab : tabs) {
			setitemxy(tab, xpos, ypos);
		}
	}
	void setwh(int _width, int _height) {
		setitemwh(list, _width, _height);
		for (Object tab : tabs) {
			setitemwh(tab, _width, _height);
		}
	}
}