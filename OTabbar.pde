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

	Box getBoundary() {
		return getItemBoundary(list);
	}
	
	boolean isHit() {
		boolean hit = false;
		if(getisItemHit(list)) {
			hit = true;
		}
		if(isvalidtab()) {
			if(getisItemHit(tabs[getid()])) {
				hit = true;
			}
		}
		return hit;
	}

	void setXY(int xpos, int ypos) {
		setitemxy(list, xpos, ypos);
		for (Object tab : tabs) {
			setitemxy(tab, xpos, ypos);
		}
	}
	void setWH(int _width, int _height) {
		setitemwh(list, _width, _height);
		for (Object tab : tabs) {
			setitemwh(tab, _width, _height);
		}
	}
}
