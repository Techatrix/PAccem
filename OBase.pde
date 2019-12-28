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

enum Dir { // used by Listview
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
	Box getbound();
	boolean ishit();

	void setxy(int ypos, int xpos);
	void setwh(int _width, int _height);
}

/* --------------- dynamic casting --------------- */
void mouseWheelitem(Object item, MouseEvent e) {
	if (item instanceof Tabbar) {
		((Tabbar)item).mouseWheel(e);
	} else if (item instanceof ListView) {
		((ListView)item).mouseWheel(e);
	} else if (item instanceof GridView) {
		((GridView)item).mouseWheel(e);
	} else if (item instanceof Container) {
		((Container)item).mouseWheel(e);
	} else if (item instanceof Transform) {
		((Transform)item).mouseWheel(e);
	} else if (item instanceof Dynamic) {
		((Dynamic)item).mouseWheel(e);
	} else if (item instanceof GetVisible) {
		((GetVisible)item).mouseWheel(e);
	} else if (item instanceof EventDetector) {
		((EventDetector)item).mouseWheel(e);
	} else if (item instanceof Popup) {
		((Popup)item).mouseWheel(e);
	}
}
boolean mousePresseditem(Object item) {
	if (item instanceof Tabbar) {
		return ((Tabbar)item).mousePressed();
	} else if (item instanceof ListView) {
		return ((ListView)item).mousePressed();
	} else if(item instanceof GridView) {
		return ((GridView)item).mousePressed();
	} else if(item instanceof Container) {
		return ((Container)item).mousePressed();
	} else if(item instanceof SetValueText) {
		return ((SetValueText)item).mousePressed();
	} else if(item instanceof Transform) {
		return ((Transform)item).mousePressed();
	} else if(item instanceof Dynamic) {
		return ((Dynamic)item).mousePressed();
	} else if(item instanceof GetVisible) {
		return ((GetVisible)item).mousePressed();
	} else if (item instanceof EventDetector) {
		((EventDetector)item).mousePressed();
	} else if (item instanceof Popup) {
		((Popup)item).mousePressed();
	} else if (item instanceof Slider) {
		((Slider)item).mousePressed();
	}
	return false;
}
boolean mouseDraggeditem(Object item) {
	if (item instanceof Tabbar) {
		return ((Tabbar)item).mouseDragged();
	} else if (item instanceof ListView) {
		return ((ListView)item).mouseDragged();
	} else if(item instanceof GridView) {
		return ((GridView)item).mouseDragged();
	} else if(item instanceof Container) {
		return ((Container)item).mouseDragged();
	} else if(item instanceof Transform) {
		return ((Transform)item).mouseDragged();
	} else if(item instanceof Dynamic) {
		return ((Dynamic)item).mouseDragged();
	} else if(item instanceof GetVisible) {
		return ((GetVisible)item).mouseDragged();
	} else if (item instanceof EventDetector) {
		((EventDetector)item).mouseDragged();
	} else if (item instanceof Popup) {
		((Popup)item).mouseDragged();
	} else if (item instanceof Slider) {
		((Slider)item).mouseDragged();
	}
	return false;
}
void keyPresseditem(Object item) {
	if (item instanceof Tabbar) {
		((Tabbar)item).keyPressed();
	} else if (item instanceof ListView) {
		((ListView)item).keyPressed();
	} else if (item instanceof GridView) {
		((GridView)item).keyPressed();
	} else if (item instanceof Container) {
		((Container)item).keyPressed();
	} else if (item instanceof SetValueText) {
		((SetValueText)item).keyPressed();
	} else if (item instanceof Transform) {
		((Transform)item).keyPressed();
	} else if (item instanceof Dynamic) {
		((Dynamic)item).keyPressed();
	} else if (item instanceof GetVisible) {
		((GetVisible)item).keyPressed();
	} else if (item instanceof EventDetector) {
		((EventDetector)item).keyPressed();
	} else if (item instanceof Popup) {
		((Popup)item).keyPressed();
	}
}
int getlistindex(Object item) {
	if (item instanceof ListView) {
		return ((ListView)item).getindex();
	} else if(item instanceof GridView) {
		return ((GridView)item).getindex();
	}
	return -1;
}
boolean getisitemhit(Object item) {
	if (item instanceof Tabbar) {
		return ((Tabbar)item).ishit();
	} else if (item instanceof ListView) {
		return ((ListView)item).ishit();
	} else if(item instanceof GridView) {
		return ((GridView)item).ishit();
	} else if(item instanceof Container) {
		return ((Container)item).ishit();
	} else if(item instanceof SetValueText) {
		return ((SetValueText)item).ishit();
	} else if(item instanceof GetValueText) {
		return ((GetValueText)item).ishit();
	} else if(item instanceof Transform) {
		return ((Transform)item).ishit();
	} else if(item instanceof Dynamic) {
		return ((Dynamic)item).ishit();
	} else if(item instanceof GetVisible) {
		return ((GetVisible)item).ishit();
	} else if(item instanceof EventDetector) {
		return ((EventDetector)item).ishit();
	} else if(item instanceof Popup) {
		return ((Popup)item).ishit();
	} else if(item instanceof Slider) {
		return ((Slider)item).ishit();
	}
	return false;
}
void drawitem(Object item, boolean hit) {
	if (item instanceof Tabbar) {
		((Tabbar)item).draw(hit);
	} else if (item instanceof ListView) {
		((ListView)item).draw(hit);
	} else if(item instanceof GridView) {
		((GridView)item).draw(hit);
	} else if(item instanceof Container) {
		((Container)item).draw(hit);
	} else if(item instanceof Text) {
		((Text)item).draw(hit);
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
	} else if(item instanceof GetVisible) {
		((GetVisible)item).draw(hit);
	} else if(item instanceof EventDetector) {
		((EventDetector)item).draw(hit);
	} else if(item instanceof Popup) {
		((Popup)item).draw(hit);
	} else if(item instanceof Slider) {
		((Slider)item).draw(hit);
	} else if(item instanceof SizedBox) {} else {
		if(deb) {
			toovmessages.add("drawitem(): " + item + " unhandeled");
		}
	}
}
void setitemwh(Object item, int _width, int _height) {
	if(item instanceof Tabbar) {
		((Tabbar)item).setwh(_width, _height);
	} else if(item instanceof ListView) {
		((ListView)item).setwh(_width, _height);
	} else if(item instanceof GridView) {
		((GridView)item).setwh(_width, _height);
	} else if(item instanceof Container) {
		((Container)item).setwh(_width, _height);
	} else if(item instanceof SizedBox) {
		((SizedBox)item).setwh(_width, _height);
	} else if(item instanceof Text) {
		((Text)item).setwh(_width, _height);
	} else if(item instanceof SetValueText) {
		((SetValueText)item).setwh(_width, _height);
	} else if(item instanceof GetValueText) {
		((GetValueText)item).setwh(_width, _height);
	} else if(item instanceof Image) {
		((Image)item).setwh(_width, _height);
	} else if(item instanceof Transform) {
		((Transform)item).setwh(_width, _height);
	} else if(item instanceof Dynamic) {
		((Dynamic)item).setwh(_width, _height);
	} else if(item instanceof GetVisible) {
		((GetVisible)item).setwh(_width, _height);
	} else if(item instanceof EventDetector) {
		((EventDetector)item).setwh(_width, _height);
	} else if(item instanceof Popup) {
		((Popup)item).setwh(_width, _height);
	} else if(item instanceof Slider) {
		((Slider)item).setwh(_width, _height);
	} else {
		if(deb && item != null) {
			toovmessages.add("setitemwh(): " + item + " unhandeled");
		}
	}
}
void setitemxy(Object item, int xpos, int ypos) {
	if(item instanceof Tabbar) {
		((Tabbar)item).setxy(xpos, ypos);
	} else if(item instanceof ListView) {
		((ListView)item).setxy(xpos, ypos);
	} else if(item instanceof GridView) {
		((GridView)item).setxy(xpos, ypos);
	} else if(item instanceof Container) {
		((Container)item).setxy(xpos, ypos);
	} else if(item instanceof SizedBox) {
		((SizedBox)item).setxy(xpos, ypos);
	} else if(item instanceof Text) {
		((Text)item).setxy(xpos, ypos);
	} else if(item instanceof SetValueText) {
		((SetValueText)item).setxy(xpos, ypos);
	} else if(item instanceof GetValueText) {
		((GetValueText)item).setxy(xpos, ypos);
	} else if(item instanceof Image) {
		((Image)item).setxy(xpos, ypos);
	} else if(item instanceof Transform) {
		((Transform)item).setxy(xpos, ypos);
	} else if(item instanceof Dynamic) {
		((Dynamic)item).setxy(xpos, ypos);
	} else if(item instanceof GetVisible) {
		((GetVisible)item).setxy(xpos, ypos);
	} else if(item instanceof EventDetector) {
		((EventDetector)item).setxy(xpos, ypos);
	} else if(item instanceof Popup) {
		((Popup)item).setxy(xpos, ypos);
	} else if(item instanceof Slider) {
		((Slider)item).setxy(xpos, ypos);
	} else {
		if(deb && item != null) {
			toovmessages.add("setitemxy(): " + item + " unhandeled");
		}
	}
}
Box getboundry(Object item) {
	if (item instanceof Tabbar) {
		return ((Tabbar)item).getbound();
	} else if (item instanceof ListView) {
		return ((ListView)item).getbound();
	} else if(item instanceof GridView) {
		return ((GridView)item).getbound();
	} else if(item instanceof Container) {
		return ((Container)item).getbound();
	} else if(item instanceof SizedBox) {
		return ((SizedBox)item).getbound();
	} else if(item instanceof Text) {
		return ((Text)item).getbound();
	} else if(item instanceof SetValueText) {
		return ((SetValueText)item).getbound();
	} else if(item instanceof GetValueText) {
		return ((GetValueText)item).getbound();
	} else if(item instanceof Image) {
		return ((Image)item).getbound();
	} else if(item instanceof Transform) {
		return ((Transform)item).getbound();
	} else if(item instanceof Dynamic) {
		return ((Dynamic)item).getbound();
	} else if(item instanceof GetVisible) {
		return ((GetVisible)item).getbound();
	} else if(item instanceof EventDetector) {
		return ((EventDetector)item).getbound();
	} else if(item instanceof Popup) {
		return ((Popup)item).getbound();
	} else if(item instanceof Slider) {
		return ((Slider)item).getbound();
	} else {
		if(deb) {
			toovmessages.add("getboundry(): " + item + " unhandeled");
		}
	}
	return null;
}