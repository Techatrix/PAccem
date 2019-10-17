class Overlay {
	Object[] items;
	int xoff = 50;
	int yoff = 30;

	Overlay() {
		final String[] tabs = {"Newroom", "Viewmode", "Loadroom", "Saveroom", "Settings", "Debug", "Roomgroups", "About", "Reset"};
		items = new Object[2];
		items[0] = 
		new Tabbar(
			new ListViewBuilder() {
				@Override public Object i(int i) {
					final Temp temp = new Temp(i);
					return new Container(new Text(tabs[temp.i]));
				}
			}.build(tabs.length, width, yoff, 100, Dir.RIGHT),
			new Builder() {@Override public Object i(int i) {
				final Temp temp = new Temp(i);
				return new Transform(
					new Align(
						new ListViewBuilder() {
							@Override public Object i(int i) {
								return new Container(new Text("List: " + temp.i +" Item: " + (i+1)));
							}
						}.build(10, 300, height-yoff),
						Corner.TOPRIGHT
					),0,yoff
				);
			}}.build(tabs.length-4)
		) {
			@Override public void ontab(int i) {
				if(1 < i && i < 7) {
					if(tabid == i-2) {
						tabid = -1;
					} else {
						tabid = i-2;
					}
				}
				switch(i) { // Popups
					case 0: // New Room
					break;
					case 1: // Viewmode
					break;
					case 7: // About
					break;
					case 8: // Reset
					break;
				}
			}
		};
		items[1] =
		new Transform(
			new ListViewBuilder() {
				@Override public Object i(int i) {
					final Temp temp = new Temp(i);
					return new Container(new EventDetector(new Image(dm.icons[temp.i+1])) {
						@Override public void onevent(EventType et, MouseEvent e) {
							if(et == EventType.MOUSEPRESSED) {
								rm.tool = temp.i;
								println("Set TOOL: " + temp.i);
							}
						}
					});
				}
			}.build(5, xoff, height-yoff, xoff, Dir.DOWN),
			0,yoff
		);


		for (Object item : items) {
			setitemxy(item, 0,0);
		}
	}

	void draw() {
		for (Object item : items) {
			drawitem(item);
		}
	}

	boolean ishit() {
		for (Object item : items) {
			if(getisitemhit(item)) {
				return true;
			}
		}
		return false;
	}
	
	void mouseWheel(MouseEvent e) {
		for (Object item : items) {
			mouseWheelitem(item, e);
		}
	}
	boolean mousePressed() {
		boolean hit = false;
		for (Object item : items) {
			if(mousePresseditem(item)) {
				hit = true;
			}
		}
		return hit;
	}
	void mouseReleased() {
	}
	void mouseDragged() {
	}
	void keyPressed() {
	}
	void keyReleased() {
	}
}
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
	} else if (item instanceof Align) {
		((Align)item).mouseWheel(e);
	} else if (item instanceof EventDetector) {
		((EventDetector)item).onevent(EventType.MOUSEWHEEL, e);
	} else {
		println("Can't exec mouseWheel for: " + item.getClass().getName());
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
	} else if(item instanceof Transform) {
		return ((Transform)item).mousePressed();
	} else if(item instanceof Align) {
		return ((Align)item).mousePressed();
	} else if (item instanceof EventDetector) {
		((EventDetector)item).onevent(EventType.MOUSEPRESSED, null);
	} else {
		println("Can't exec mousePressed for: " + item.getClass().getName());
	}
	return false;
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
	}else if(item instanceof Transform) {
		return ((Transform)item).ishit();
	} else if(item instanceof Align) {
		return ((Align)item).ishit();
	} else if(item instanceof EventDetector) {
		return ((EventDetector)item).ishit();
	} else {
		println("Can't get ishit for item: " + item.getClass().getName());
	}
	return false;
}

void drawitem(Object item) {
	if (item instanceof Tabbar) {
		((Tabbar)item).draw();
	} else if (item instanceof ListView) {
		((ListView)item).draw();
	} else if(item instanceof GridView) {
		((GridView)item).draw();
	} else if(item instanceof Container) {
		((Container)item).draw();
	} else if(item instanceof Text) {
		((Text)item).draw();
	} else if(item instanceof Image) {
		((Image)item).draw();
	} else if(item instanceof Transform) {
		((Transform)item).draw();
	} else if(item instanceof Align) {
		((Align)item).draw();
	} else if(item instanceof EventDetector) {
		((EventDetector)item).draw();
	} else {
		println("Can't draw item: " + item.getClass().getName());
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
	} else if(item instanceof Text) {
		((Text)item).setwh(_width, _height);
	} else if(item instanceof Image) {
		((Image)item).setwh(_width, _height);
	} else if(item instanceof Transform) {
		((Transform)item).setwh(_width, _height);
	} else if(item instanceof Align) {
		((Align)item).setwh(_width, _height);
	} else if(item instanceof EventDetector) {
		((EventDetector)item).setwh(_width, _height);
	} else {
		println("Can't set WH of item: " + item.getClass().getName());
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
	} else if(item instanceof Text) {
		((Text)item).setxy(xpos, ypos);
	} else if(item instanceof Image) {
		((Image)item).setxy(xpos, ypos);
	} else if(item instanceof Transform) {
		((Transform)item).setxy(xpos, ypos);
	} else if(item instanceof Align) {
		((Align)item).setxy(xpos, ypos);
	} else if(item instanceof EventDetector) {
		((EventDetector)item).setxy(xpos, ypos);
	} else {
		println("Can't set XY of item: " + item.getClass().getName());
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
	} else if(item instanceof Text) {
		return ((Text)item).getbound();
	} else if(item instanceof Image) {
		return ((Image)item).getbound();
	} else if(item instanceof Transform) {
		return ((Transform)item).getbound();
	} else if(item instanceof Align) {
		return ((Align)item).getbound();
	} else if(item instanceof EventDetector) {
		return ((EventDetector)item).getbound();
	} else {
		println("Can't get boundry of item: " + item.getClass().getName());
		return null;
	}
}
enum Dir {
    UP, RIGHT, DOWN, LEFT;
}
enum Corner {
    TOPLEFT, TOPRIGHT, BOTTOMLEFT, BOTTOMRIGHT;
}

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