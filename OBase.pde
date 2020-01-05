class Box {
	int w;
	int h;
	Box(int w, int h) {
		this.w = w;
		this.h = h;
	}
	Box(float w, float h) {
		this.w = round(w);
		this.h = round(h);
	}
}

class TabData {
	String name;
	int id;
	boolean type;
	
	TabData(String name, int id, boolean type) {
		this.name = name;
		this.id = id;
		this.type = type;
	}
}

abstract class Builder{

	Object[] build(int length) {
		Object[] items = new Object[length];
		for (int i=0;i<length;i++) {
			items[i] = i(i);
		}
		return items;
	}

	abstract Object i(int i);
}

abstract class ListViewBuilder{
	ListView build(int length, int _width, int _height) {
		return build(length, _width, _height, 30, Dir.DOWN);
	}
	ListView build(int length, int _width, int _height, int itemheight) {
		return build(length, _width, _height, itemheight, Dir.DOWN);
	}
	ListView build(int length, int _width, int _height, int itemheight, Dir dir) {
		Object[] items = new Object[length];
		for (int i=0;i<length;i++) {
			items[i] = i(i);
		}
		return new ListView(items, _width, _height, itemheight, dir);
	}

	abstract Object i(int i);
}

enum Dir { // used by ListView
    UP, RIGHT, DOWN, LEFT;
}
enum Align { // used by Transform
    TOPLEFT, TOPRIGHT, BOTTOMLEFT, BOTTOMRIGHT, CENTERCENTER;
}
enum Fit { // used by Image
	EXPAND, RATIO
}

interface IOverlay {

	void draw(boolean hit);
	Box getBoundary();
	boolean isHit();

	void setXY(int ypos, int xpos);
	void setWH(int _width, int _height);
}

/* --------------- dynamic casting --------------- */
boolean mousePressedItem(Object item) {
	if(item instanceof Container) {
		return ((Container)item).mousePressed();
	} else if (item instanceof Tabbar) {
		return ((Tabbar)item).mousePressed();
	} else if (item instanceof ListView) {
		return ((ListView)item).mousePressed();
	} else if(item instanceof GridView) {
		return ((GridView)item).mousePressed();
	} else if(item instanceof SetValueText) {
		return ((SetValueText)item).mousePressed();
	} else if(item instanceof Transform) {
		return ((Transform)item).mousePressed();
	} else if(item instanceof Dynamic) {
		return ((Dynamic)item).mousePressed();
	} else if(item instanceof Visible) {
		return ((Visible)item).mousePressed();
	} else if (item instanceof EventDetector) {
		((EventDetector)item).mousePressed();
	} else if (item instanceof Popup) {
		((Popup)item).mousePressed();
	} else if (item instanceof Slider) {
		((Slider)item).mousePressed();
	} else if (item instanceof CheckBox) {
		((CheckBox)item).mousePressed();
	} else if (item instanceof Filter) {
		((Filter)item).mousePressed();
	}
	return false;
}
boolean mouseDraggedItem(Object item) {
	if(item instanceof Container) {
		return ((Container)item).mouseDragged();
	} else if (item instanceof Tabbar) {
		return ((Tabbar)item).mouseDragged();
	} else if (item instanceof ListView) {
		return ((ListView)item).mouseDragged();
	} else if(item instanceof GridView) {
		return ((GridView)item).mouseDragged();
	} else if(item instanceof Transform) {
		return ((Transform)item).mouseDragged();
	} else if(item instanceof Dynamic) {
		return ((Dynamic)item).mouseDragged();
	} else if(item instanceof Visible) {
		return ((Visible)item).mouseDragged();
	} else if (item instanceof EventDetector) {
		((EventDetector)item).mouseDragged();
	} else if (item instanceof Popup) {
		((Popup)item).mouseDragged();
	} else if (item instanceof Slider) {
		((Slider)item).mouseDragged();
	} else if (item instanceof Filter) {
		((Filter)item).mouseDragged();
	}
	return false;
}
boolean mouseWheelItem(Object item, MouseEvent e) {
	if (item instanceof Container) {
		return ((Container)item).mouseWheel(e);
	} else if (item instanceof Tabbar) {
		return ((Tabbar)item).mouseWheel(e);
	} else if (item instanceof ListView) {
		return ((ListView)item).mouseWheel(e);
	} else if (item instanceof GridView) {
		return ((GridView)item).mouseWheel(e);
	} else if (item instanceof Transform) {
		return ((Transform)item).mouseWheel(e);
	} else if (item instanceof Dynamic) {
		return ((Dynamic)item).mouseWheel(e);
	} else if (item instanceof Visible) {
		return ((Visible)item).mouseWheel(e);
	} else if (item instanceof EventDetector) {
		return ((EventDetector)item).mouseWheel(e);
	} else if (item instanceof Popup) {
		return ((Popup)item).mouseWheel(e);
	} else if (item instanceof Filter) {
		return ((Filter)item).mouseWheel(e);
	}
	return false;
}
void keyPressedItem(Object item) {
	if (item instanceof Container) {
		((Container)item).keyPressed();
	} else if (item instanceof Tabbar) {
		((Tabbar)item).keyPressed();
	} else if (item instanceof ListView) {
		((ListView)item).keyPressed();
	} else if (item instanceof GridView) {
		((GridView)item).keyPressed();
	} else if (item instanceof SetValueText) {
		((SetValueText)item).keyPressed();
	} else if (item instanceof Transform) {
		((Transform)item).keyPressed();
	} else if (item instanceof Dynamic) {
		((Dynamic)item).keyPressed();
	} else if (item instanceof Visible) {
		((Visible)item).keyPressed();
	} else if (item instanceof EventDetector) {
		((EventDetector)item).keyPressed();
	} else if (item instanceof Popup) {
		((Popup)item).keyPressed();
	} else if (item instanceof Filter) {
		((Filter)item).keyPressed();
	}
}
int getListIndex(Object item) {
	if (item instanceof ListView) {
		return ((ListView)item).getIndex();
	} else if(item instanceof GridView) {
		return ((GridView)item).getIndex();
	}
	return -1;
}
boolean getisItemHit(Object item) {
	if(item instanceof Container) {
		return ((Container)item).isHit();
	} else if (item instanceof Tabbar) {
		return ((Tabbar)item).isHit();
	} else if (item instanceof ListView) {
		return ((ListView)item).isHit();
	} else if(item instanceof GridView) {
		return ((GridView)item).isHit();
	} else if(item instanceof SetValueText) {
		return ((SetValueText)item).isHit();
	} else if(item instanceof GetValueText) {
		return ((GetValueText)item).isHit();
	} else if(item instanceof Transform) {
		return ((Transform)item).isHit();
	} else if(item instanceof Dynamic) {
		return ((Dynamic)item).isHit();
	} else if(item instanceof Visible) {
		return ((Visible)item).isHit();
	} else if(item instanceof EventDetector) {
		return ((EventDetector)item).isHit();
	} else if(item instanceof Popup) {
		return ((Popup)item).isHit();
	} else if(item instanceof Slider) {
		return ((Slider)item).isHit();
	} else if(item instanceof CheckBox) {
		return ((CheckBox)item).isHit();
	} else if(item instanceof Filter) {
		return ((Filter)item).isHit();
	}
	return false;
}
void drawItem(Object item, boolean hit) {
	if(item instanceof Container) {
		((Container)item).draw(hit);
	} else if(item instanceof Text) {
		((Text)item).draw(hit);
	} else if (item instanceof Tabbar) {
		((Tabbar)item).draw(hit);
	} else if (item instanceof ListView) {
		((ListView)item).draw(hit);
	} else if(item instanceof GridView) {
		((GridView)item).draw(hit);
	} else if(item instanceof SetValueText) {
		((SetValueText)item).draw(hit);
	} else if(item instanceof GetValueText) {
		((GetValueText)item).draw(hit);
	} else if(item instanceof Image) {
		((Image)item).draw(hit);
	} else if(item instanceof Transform) {
		((Transform)item).draw(hit);
	} else if(item instanceof Dynamic) {
		((Dynamic)item).draw(hit);
	} else if(item instanceof Visible) {
		((Visible)item).draw(hit);
	} else if(item instanceof EventDetector) {
		((EventDetector)item).draw(hit);
	} else if(item instanceof Popup) {
		((Popup)item).draw(hit);
	} else if(item instanceof Slider) {
		((Slider)item).draw(hit);
	} else if(item instanceof CheckBox) {
		((CheckBox)item).draw(hit);
	} else if(item instanceof Filter) {
		((Filter)item).draw(hit);
	} else if(item instanceof SizedBox) {} else {
		if(deb) {
			toovmessages.add("drawItem(): " + item + " unhandeled");
		}
	}
}
void setItemWH(Object item, int _width, int _height) {
	if(item instanceof Container) {
		((Container)item).setWH(_width, _height);
	} else if(item instanceof Text) {
		((Text)item).setWH(_width, _height);
	} else if(item instanceof Tabbar) {
		((Tabbar)item).setWH(_width, _height);
	} else if(item instanceof ListView) {
		((ListView)item).setWH(_width, _height);
	} else if(item instanceof GridView) {
		((GridView)item).setWH(_width, _height);
	} else if(item instanceof SizedBox) {
		((SizedBox)item).setWH(_width, _height);
	} else if(item instanceof SetValueText) {
		((SetValueText)item).setWH(_width, _height);
	} else if(item instanceof GetValueText) {
		((GetValueText)item).setWH(_width, _height);
	} else if(item instanceof Image) {
		((Image)item).setWH(_width, _height);
	} else if(item instanceof Transform) {
		((Transform)item).setWH(_width, _height);
	} else if(item instanceof Dynamic) {
		((Dynamic)item).setWH(_width, _height);
	} else if(item instanceof Visible) {
		((Visible)item).setWH(_width, _height);
	} else if(item instanceof EventDetector) {
		((EventDetector)item).setWH(_width, _height);
	} else if(item instanceof Popup) {
		((Popup)item).setWH(_width, _height);
	} else if(item instanceof Slider) {
		((Slider)item).setWH(_width, _height);
	} else if(item instanceof CheckBox) {
		((CheckBox)item).setWH(_width, _height);
	} else if(item instanceof Filter) {
		((Filter)item).setWH(_width, _height);
	} else {
		if(deb && item != null) {
			toovmessages.add("setItemWH(): " + item + " unhandeled");
		}
	}
}
void setItemXY(Object item, int xpos, int ypos) {
	if(item instanceof Container) {
		((Container)item).setXY(xpos, ypos);
	} else if(item instanceof Text) {
		((Text)item).setXY(xpos, ypos);
	} else if(item instanceof Tabbar) {
		((Tabbar)item).setXY(xpos, ypos);
	} else if(item instanceof ListView) {
		((ListView)item).setXY(xpos, ypos);
	} else if(item instanceof GridView) {
		((GridView)item).setXY(xpos, ypos);
	} else if(item instanceof SizedBox) {
		((SizedBox)item).setXY(xpos, ypos);
	} else if(item instanceof SetValueText) {
		((SetValueText)item).setXY(xpos, ypos);
	} else if(item instanceof GetValueText) {
		((GetValueText)item).setXY(xpos, ypos);
	} else if(item instanceof Image) {
		((Image)item).setXY(xpos, ypos);
	} else if(item instanceof Transform) {
		((Transform)item).setXY(xpos, ypos);
	} else if(item instanceof Dynamic) {
		((Dynamic)item).setXY(xpos, ypos);
	} else if(item instanceof Visible) {
		((Visible)item).setXY(xpos, ypos);
	} else if(item instanceof EventDetector) {
		((EventDetector)item).setXY(xpos, ypos);
	} else if(item instanceof Popup) {
		((Popup)item).setXY(xpos, ypos);
	} else if(item instanceof Slider) {
		((Slider)item).setXY(xpos, ypos);
	} else if(item instanceof CheckBox) {
		((CheckBox)item).setXY(xpos, ypos);
	} else if(item instanceof Filter) {
		((Filter)item).setXY(xpos, ypos);
	} else {
		if(deb && item != null) {
			toovmessages.add("setItemXY(): " + item + " unhandeled");
		}
	}
}
Box getItemBoundary(Object item) {
	if(item instanceof Container) {
		return ((Container)item).getBoundary();
	} else if(item instanceof Text) {
		return ((Text)item).getBoundary();
	} else if (item instanceof Tabbar) {
		return ((Tabbar)item).getBoundary();
	} else if (item instanceof ListView) {
		return ((ListView)item).getBoundary();
	} else if(item instanceof GridView) {
		return ((GridView)item).getBoundary();
	} else if(item instanceof SizedBox) {
		return ((SizedBox)item).getBoundary();
	} else if(item instanceof SetValueText) {
		return ((SetValueText)item).getBoundary();
	} else if(item instanceof GetValueText) {
		return ((GetValueText)item).getBoundary();
	} else if(item instanceof Image) {
		return ((Image)item).getBoundary();
	} else if(item instanceof Transform) {
		return ((Transform)item).getBoundary();
	} else if(item instanceof Dynamic) {
		return ((Dynamic)item).getBoundary();
	} else if(item instanceof Visible) {
		return ((Visible)item).getBoundary();
	} else if(item instanceof EventDetector) {
		return ((EventDetector)item).getBoundary();
	} else if(item instanceof Popup) {
		return ((Popup)item).getBoundary();
	} else if(item instanceof Slider) {
		return ((Slider)item).getBoundary();
	} else if(item instanceof CheckBox) {
		return ((CheckBox)item).getBoundary();
	} else if(item instanceof Filter) {
		return ((Filter)item).getBoundary();
	} else {
		if(deb) {
			toovmessages.add("getBoundary(): " + item + " unhandeled");
		}
	}
	return null;
}
