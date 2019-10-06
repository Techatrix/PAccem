class Overlay {
	int _height;
	int _width;
	int sidebarwidth;

	ButtonList tabbar;
	ButtonList[] sidebars;
	int sidebarid;
	ButtonList toolbar;
	Popup popup;

	Overlay() {
		sidebars = new ButtonList[5];
		_height = 25;
		_width = 50;
		sidebarwidth = 300;
		sidebarid = -1;
		refresh();
	}

	void save() {
		rm.save(rm.name);

		File f1 = new File(sketchPath("data/rooms.json"));
		JSONArray json;
		boolean exists = false;
		if (f1.exists())
		{
			json = loadJSONArray("data/rooms.json");
			for (int i=0;i<json.size() ;i++ ) {
				if(rm.name.equals(json.getString(i))) {
					exists = true;
				}
			}
		} else {
			json = new JSONArray();
			exists = false;
		}
		if(!exists) {
			json.append(rm.name);
		}
		saveJSONArray(json, "data/rooms.json");
		ov.sidebarrefresh();
		//ov.refresh();
	}

	void refresh() {
		float scale = st.floats[1].getvalue();
		// Tool-bar
		ListItem[] toolbarbuttons = new ListItem[6];
		toolbarbuttons[0] = new ListItem("0", true) {@ Override public void action() {rm.tool = 0;}};
		toolbarbuttons[1] = new ListItem("1", true) {@ Override public void action() {rm.tool = 1;}};
		toolbarbuttons[2] = new ListItem("2", true) {@ Override public void action() {
			rm.tool = 2;
				ListItem[] listitems = new ListItem[2];
				listitems[0] = new ListItem("New Width", true, 2, true) {@ Override public void action() {}};
				listitems[1] = new ListItem("New height",true, 2, true) {@ Override public void action() {}};

				popup = new Popup(250,150, listitems) {
					@ Override public void ontrue() {
						rm.newfurniturewidth = int(values[0].bv.value);
						rm.newfurnitureheight = int(values[1].bv.value);
					}
					@ Override public void onfalse() {}
				};
				popup.values[0].bv.value = "1";
				popup.values[0].bv.newvalue = "1";
				popup.values[1].bv.value = "1";
				popup.values[1].bv.newvalue = "1";
				popup.text = "Select Size";
				popup.truetext = "Confirm";
				popup.falsetext = "Cancel";
		}};
		toolbarbuttons[3] = new ListItem("3", true) {@ Override public void action() {rm.tool = 3;}};
		toolbarbuttons[4] = new ListItem("4", true) {@ Override public void action() {rm.tool = 4;}};
		toolbarbuttons[5] = new ListItem("5", true) {@ Override public void action() {rm.tool = 5;}};
		toolbar = new ButtonList(0, _height, 50, ceil(height/scale)-_height, false, 50, 0, toolbarbuttons);

		// Tab-bar
		ListItem[] tabbarbuttons = new ListItem[9];

		tabbarbuttons[0] = new ListItem("New Room") {
			@ Override public void action() {
				ListItem[] listitems = new ListItem[2];
				listitems[0] = new ListItem("New Width", true, 2, true) {@ Override public void action() {}};
				listitems[1] = new ListItem("New height",true, 2, true) {@ Override public void action() {}};
				popup = new Popup(250,150, listitems) {
					@ Override public void ontrue() {
						int newxgridsize = int(values[0].bv.value);
						int newygridsize = int(values[1].bv.value);

						if(newxgridsize > 0 && newygridsize > 0) {
							rm.xgridsize = newxgridsize;
							rm.ygridsize = newygridsize;
							rm.reset();
						}
					}
					@ Override public void onfalse() {}
				};
				popup.text = "Create New Room";
				popup.truetext = "Confirm";
				popup.falsetext = "Cancel";
			}
		};
		tabbarbuttons[1] = new ListItem("ViewMode 2D") {@ Override public void action() {
			rm.switchviewmode(); name = rm.viewmode ? "ViewMode 3D" : "ViewMode 2D";
		}};
		tabbarbuttons[2] = new ListItem("Load File") {@ Override public void action() {ov.sidebarid = ov.sidebarid == 0 ? -1 : 0;}};
		tabbarbuttons[3] = new ListItem("Save File") {@ Override public void action() {ov.sidebarid = ov.sidebarid == 1 ? -1 : 1;}};
		tabbarbuttons[4] = new ListItem("Settings") {@ Override public void action() {ov.sidebarid = ov.sidebarid == 2 ? -1 : 2;}};
		tabbarbuttons[5] = new ListItem("Debug") {@ Override public void action() {ov.sidebarid = ov.sidebarid == 3 ? -1 : 3;}};
		tabbarbuttons[6] = new ListItem("Room Groups") {@ Override public void action() {ov.sidebarid = ov.sidebarid == 4 ? -1 : 4;}};
		tabbarbuttons[7] = new ListItem("About") {@ Override public void action() {
			popup = new Popup(width/6,height/3) {
				@ Override public void ontrue() {}
				@ Override public void onfalse() {}
			};
			popup.text = getabout();
			popup.single = true;
			popup.truetext = "ok";

		}};
		tabbarbuttons[8] = new ListItem("Reset") {
			@ Override public void action() {
				popup = new Popup(250,150) {
					@ Override public void ontrue() {rm.reset();ov.refresh();}
					@ Override public void onfalse() {}
				};
			}
		};
		tabbar = new ButtonList(0,0,ceil(width/scale),_height, true, 120, 0, tabbarbuttons);

		sidebarrefresh();

		// Popup
		popup = new Popup(250,150) {
			@ Override public void ontrue() {
			}
			@ Override public void onfalse() {}
		};
		popup.visible = false;
	}

	void sidebarrefresh() {
		// Load-buttons
		String[] rooms = rm.loadrooms();
		ListItem[] loadbuttons = new ListItem[0];
		if(rooms != null) {
			loadbuttons = new ListItem[rooms.length];
			for (int i=0;i<rooms.length;i++ ) {
				loadbuttons[i] = new ListItem(rooms[i]) {@ Override public void action() {rm.load(name);}};
			}
		}

		// Save-buttons
		ListItem[] savebuttons = new ListItem[2];
		savebuttons[0] = new ListItem("Name", true, 3, -99) {@ Override public void action() {}};
		savebuttons[1] = new ListItem("Save") {@ Override public void action() {

			if(rm.name == st.strings[0].getvalue()) {
				popup = new Popup(250, 150) {
					@ Override public void ontrue() {
						save();
					}
					@ Override public void onfalse() {}
				};
				popup.text = "Overwrite default Room?";
			} else {
				save();
			}
		}};

		// Room-Groups
		ListItem[] roomgroupsbuttons = new ListItem[5];
		roomgroupsbuttons[0] = new ListItem("Group 1", true, 0, -1) {@ Override public void action() {}};
		roomgroupsbuttons[1] = new ListItem("Group 2", true, 0, -2) {@ Override public void action() {}};
		roomgroupsbuttons[2] = new ListItem("Group 3", true, 0, -3) {@ Override public void action() {}};
		roomgroupsbuttons[3] = new ListItem("Group 4", true, 0, -4) {@ Override public void action() {}};
		roomgroupsbuttons[4] = new ListItem("Group 5", true, 0, -5) {@ Override public void action() {}};
		float scale = st.floats[1].getvalue();

		// Side-Bars
		int sxpos = ceil((width-sidebarwidth*scale)/scale);
		int sypos = ceil(_height);
		int swidth = ceil(sidebarwidth);
		int sheight = ceil(height/scale)-sypos;

		sidebars[0] = new ButtonList(sxpos,sypos,swidth,sheight, false, _height, 10, loadbuttons);
		sidebars[1] = new ButtonList(sxpos,sypos,swidth,sheight, false, _height, 10, savebuttons);
		sidebars[2] = new ButtonList(sxpos,sypos,swidth,sheight, false, _height, 2, 0); // Settings
		sidebars[3] = new ButtonList(sxpos,sypos,swidth,sheight, false, _height, 2, 1);// Debugger
		sidebars[4] = new ButtonList(sxpos,sypos,swidth,sheight, false, _height, 10, roomgroupsbuttons);
		sidebars[3].live = true;
	}

	void draw() {
		if(!st.booleans[1].getvalue()) {
			push();
			scale(st.floats[1].getvalue());
			if(sidebarid != -1) {
				sidebars[sidebarid].draw();
			}
			toolbar.draw();
			tabbar.draw();
			popup.draw();

			String date = str(day())+"."+str(month())+"."+str(year());
			fill(0);
			textAlign(RIGHT, CENTER);
			text(date, ceil(width/st.floats[1].getvalue())-12.5, 12.5);

			pop();
		}
	}
	void mousePressed() {
		if(popup.mousePressed()) {
			return;
		}
		toolbar.mousePressed();
		tabbar.mousePressed();
		if(sidebarid != -1) {
			sidebars[sidebarid].mousePressed();
		}
	}
	void mouseDragged() {
		if(true) {
			return;
		}
		if(popup.visible) {
			return;
		}
		toolbar.mouseDragged();
		tabbar.mouseDragged();
		if(sidebarid != -1) {
			sidebars[sidebarid].mouseDragged();
		}
	}
	boolean keyPressed() {
		boolean hit = false;
		if(popup.keyPressed()) {
			hit = true;
		}
		if(sidebarid != -1) {
			ButtonList sb = sidebars[sidebarid];
			if(sb.keyPressed()) {
				hit = true;
			}
		}
		if(!hit) {
			if(key == 'h') {
				st.booleans[1].setvalue(!st.booleans[1].getvalue());
				if(!st.booleans[1].getvalue()) {
					sidebarrefresh();
				}
			} else if( key == 'r') {
				popup = new Popup(250,150) {
					@ Override public void ontrue() {rm.reset();sidebarrefresh();}
					@ Override public void onfalse() {}
				};
			}
		}
		return hit;
	}
	boolean ishit() {
		float scale = st.floats[1].getvalue();
		if(popup.visible) {
			return true;
		}
		if(checkraw(toolbar.xpos, toolbar.ypos, toolbar._width, toolbar._height)) {
			return true;
		}
		if(checkraw(tabbar.xpos, tabbar.ypos, tabbar._width, tabbar._height)) {
			return true;
		}
		if(sidebarid != -1) {
			ButtonList sb = sidebars[sidebarid];
			if(checkraw(sb.xpos, sb.ypos, sb._width, sb._height)) {
				return true;
			}
		}
		return false;
	}
}

class ButtonList extends PWH{
	ListItem[] listitems = new ListItem[0];
	ListItem[] lastlistitems = new ListItem[0];
	boolean direction;
	int off = 0;
	int buttonsize = 50;
	int buttonmargin = 10;
	boolean live = false;


	ButtonList(int newxpos, int newypos, int newwidth, int newheight, boolean newdirection, int newbuttonsize, int newbuttonmargin) {
		xpos = newxpos;
		ypos = newypos;
		_width = newwidth;
		_height = newheight;
		direction = newdirection;
		buttonsize = newbuttonsize;
		buttonmargin = newbuttonmargin;
	}
	ButtonList(int newxpos, int newypos, int newwidth, int newheight, boolean newdirection, int newbuttonsize, int newbuttonmargin, ListItem[] newlistitems) {
		this(newxpos, newypos, newwidth, newheight, newdirection, newbuttonsize, newbuttonmargin);
		listitems = newlistitems;
	}
	ButtonList(int newxpos, int newypos, int newwidth, int newheight, boolean newdirection, int newbuttonsize, int newbuttonmargin, int type) {
		this(newxpos, newypos, newwidth, newheight, newdirection, newbuttonsize, newbuttonmargin);
		if(type == 0) {
			newsettings(st);
		} else {
			newdebugger(db);
		}

	}

	void newsettings(Settings settings) {
		listitems = new ListItem[settings.getsize()];
		int x=0;
		for (int i=0;i<settings.colors.length;i++ ) {
			listitems[x] = new ListItem(settings.colors[i].name, true, 0, i) {@ Override public void action() {}};
			x++;
		}
		for (int i=0;i<settings.floats.length;i++ ) {
			listitems[x] = new ListItem(settings.floats[i].name, true, 1, i) {@ Override public void action() {}};
			x++;
		}
		for (int i=0;i<settings.ints.length;i++ ) {
			listitems[x] = new ListItem(settings.ints[i].name, true, 2, i) {@ Override public void action() {}};
			x++;
		}
		for (int i=0;i<settings.strings.length;i++ ) {
			listitems[x] = new ListItem(settings.strings[i].name, true, 3, i) {@ Override public void action() {}};
			x++;
		}
		for (int i=0;i<settings.booleans.length;i++ ) {
			listitems[x] = new ListItem(settings.booleans[i].name, true, 4, i) {@ Override public void action() {}};
			x++;
		}
		lastlistitems = new ListItem[1];
		lastlistitems[0] = new ListItem("Save") {@ Override public void action() {st.save();println("Step 1");}};
	}
	void newdebugger(Debugger debugger) {
		listitems = new ListItem[debugger.items.length];
		for (int i=0;i<debugger.items.length;i++ ) {
			DebuggerItem item = debugger.items[i];
			listitems[i] = new ListItem(item.name + ": " + item.getvalue(), false) {@ Override public void action() {}};
		}
	}
	void draw() {
		noStroke();
		fill(st.colors[1].getvalue());
		if(direction) {
			rect(xpos+off, ypos, _width, _height);
		} else {
			rect(xpos, ypos+off, _width, _height);
		}
		if(live) {
			newdebugger(db);
		}
		for (int i=0;i<listitems.length;i++) {
			if(direction) {
				listitems[i].draw(xpos+(buttonsize+buttonmargin)*i+off, ypos, buttonsize, _height);
			} else {
				listitems[i].draw(xpos, ypos+(buttonsize+buttonmargin)*i+off, _width, buttonsize);
			}
		}
		if(lastlistitems != null) {
			for(int i=lastlistitems.length-1;i>=0;i--) {
				if(direction) {
					lastlistitems[i].draw(xpos+_width-(buttonsize+buttonmargin)*(i+1)+buttonmargin+off, ypos, buttonsize, _height);
				} else {
					lastlistitems[i].draw(xpos, ypos+_height-(buttonsize+buttonmargin)*(i+1)+buttonmargin+off, _width, buttonsize);
				}
			}
		}
	}

	int getlistheight() {
		return (listitems.length+listitems.length) * (buttonsize+buttonmargin);
	}

	void mousePressed() {
		if(mouseButton == LEFT) {
			for (int i=0;i<listitems.length;i++) {
				ListItem l = listitems[i];
				if(direction) {
					l.check(xpos+(buttonsize+buttonmargin)*i+off, ypos, buttonsize, _height);
				} else {
					l.check(xpos, ypos+(buttonsize+buttonmargin)*i+off, _width, buttonsize);
				}
			}
			for (int i=0;i<lastlistitems.length;i++) {
				ListItem l = lastlistitems[i];
				if(direction) {
					l.check(xpos+_width-(buttonsize+buttonmargin)*(i+1)+buttonmargin+off, ypos, buttonsize, _height);
				} else {
					l.check(xpos, ypos+_height-(buttonsize+buttonmargin)*(i+1)+buttonmargin+off, _width, buttonsize);
				}
			}
		}
	}
	void mouseDragged() {
		if(checkraw(xpos, ypos, _width, _height)) {
			if(mouseButton == LEFT) {
				if(direction) {
					off += mouseX - pmouseX;
					int listheight = getlistheight() < _width ? _width : getlistheight();
					off = constrain(off, _width-listheight, 0);
				} else {
					off += mouseY - pmouseY;
					int listheight = getlistheight() < _height ? _height : getlistheight();
					off = constrain(off, _height-listheight, 0);
				}
			}
		}
	}
	boolean keyPressed() {
		for (ListItem li : listitems) {
			if(li.keyPressed()) {
				return true;
			}
		}
		for (ListItem lli : lastlistitems) {
			if(lli.keyPressed()) {
				return true;
			}
		}
		return false;
	}
}

abstract class ListItem {
	String name;
	boolean isimage;
	boolean editable = false;
	boolean editmode= false;
	ButtonValue bv;

	ListItem(String newname) {
		name = newname;
	}
	ListItem(String newname, boolean newisimage) {
		name = newname;
		isimage = newisimage;
	}
	ListItem(String newname, boolean neweditable, int type, int newindex) {
		name = newname;
		editable = neweditable;
		bv = new ButtonValue(type, newindex);
	}
	ListItem(String newname, boolean neweditable, int type, boolean newisreadonly) {
		name = newname;
		editable = neweditable;
		bv = new ButtonValue(type, newisreadonly);
	}
	
	void draw(int xpos, int ypos, int _width, int _height) {
		if(!isimage) {
			textSize(16);
			textAlign(CENTER, CENTER);
			noStroke();
			fill(st.colors[2].getvalue());
			rect(xpos,ypos,_width, _height);
			if(checkraw(xpos, ypos, _width, _height) && !ov.popup.visible) {
				fill(0, 50);
				rect(xpos,ypos,_width, _height);
			}
			fill(editmode ? color(255,0,0) : 255);
			text(name + (editable ? ": " + (editmode ? bv.newvalue : bv.value) : ""), xpos, ypos, _width, _height);

		} else {
			if(checkraw(xpos, ypos, _width, _height) && !ov.popup.visible) {
				fill(0, 50);
				rect(xpos,ypos,_width, _height);
			}
			image(im.images[int(name)], xpos, ypos, _width, _height);
		}
	}
	abstract void action();

	boolean check(int xpos, int ypos, int _width, int _height) {
		if(checkraw(xpos,ypos,_width, _height)) {
			action();
			if(editable) {
				editmode = !editmode;
			}
			return true;
		} else {
		  	editmode = false;
		  	if(editable) {
		  		bv.newvalue = bv.value;
		  	}
		  	return false;
		}
	}
	boolean keyPressed() {
		boolean hit = false;
		if(editmode) {
			if(bv.keyPressed()) {
				hit = true;
			}
			if(keyCode == ENTER) {
				editmode = false;
			}
		}
		return hit;
	}
}

class ButtonValue{
	String value;
	String newvalue;
	int type;
	int index;
	boolean readonly;
	// 0 = color
	// 1 = float
	// 2 = int
	// 3 = string
	// 4 = boolean

	ButtonValue(int newtype, int newindex) {
		value = "";
		newvalue = "";
		type = newtype;
		index = newindex;
		getsetting();
		newvalue = value;
		readonly = false;
	}
	ButtonValue(int newtype, boolean newreadonly) {
		value = "";
		newvalue = "";
		type = newtype;
		index = -99;
		readonly = newreadonly;
	}

	void getsetting() {
		if(index != -99) {
			switch(type) {
				case 0:
				// 0 = color
					if(index < 0) {
						color c = rm.roomgrid.roomgroups[abs(index)-1];
						value = int(red(c)) + " " + int(green(c)) + " " + int(blue(c));
					} else {
						color c = st.colors[index].getvalue();
						value = int(red(c)) + " " + int(green(c)) + " " + int(blue(c));
					}
				break;
				case 1:
				// 1 = float
					value = str(st.floats[index].getvalue());
				break;
				case 2:
				// 2 = int
					value = str(st.ints[index].getvalue());
				break;
				case 3:
				// 3 = string
					value = st.strings[index].getvalue();
				break;
				case 4:
				// 4 = boolean
					value = st.booleans[index].getvalue() == true ? "true" : "false";
				break;	
			}
		} else {
			value = rm.name;
		}
	}

	void setsetting() {
		if(!readonly) {
			if(index != -99) {
				switch(type) {
					case 0:
					// 0 = color
						String[] strings = split(value, " ");
						int[] ints = new int[strings.length];
						for (int i=0; i<strings.length;i++) {
							ints[i] = int(strings[i]);
						}
						color c  = color(ints[0], ints[1], ints[2]);
						if(index < 0) {
							rm.roomgrid.roomgroups[abs(index)-1] = c;
						} else {
							st.colors[index].setvalue(c);
						}
					break;
					case 1:
					// 1 = float
						st.floats[index].setvalue(float(value));
						if(index == 1) {
							ov.refresh();
						}
					break;
					case 2:
					// 2 = int
						st.ints[index].setvalue(int(value));

						if(index == 0 || index == 1) {
							int sw = st.ints[0].getvalue();
							int sh = st.ints[1].getvalue();
							surface.setSize(sw,sh);
							ov.refresh();
						}
					break;
					case 3:
					// 3 = string
						st.strings[index].setvalue(value);
						if(index == 2) {
							setfont(st.strings[2].getvalue());
						}
					break;
					case 4:
					// 4 = boolean
						if(value.equals("0") || value.equals("1")) {
							newvalue = value.equals("0") ? "false" : "true";
							value = value.equals("0") ? "false" : "true";
						}
						st.booleans[index].setvalue(boolean(value));
						if(index == 2) {
							ov.popup = new Popup(250,150) {
								@ Override public void ontrue() {}
								@ Override public void onfalse() {}
							};
							ov.popup.text = "Restart Application to see the Effect";
							ov.popup.truetext = "ok";
							ov.popup.single = true;
						}
					break;
				}
			} else {
				rm.name = value;
			}
		}
	}



	boolean keyPressed() {
		if (keyCode == BACKSPACE) {
			if (newvalue.length() > 0) {
				newvalue = newvalue.substring(0, newvalue.length()-1);
			}
		} else if(keyCode == ENTER) {
			if(check()) {
				value = newvalue;
				setsetting();
			} else {
				newvalue = value;
			}
		} else if(keyCode == ESC) {
			newvalue = value;
			key = 0;
		}
		switch(type) {
			case 0:
			// 0 = color
				if ((keyCode > 47 && keyCode < 58 || keyCode == 32) && newvalue.toString().length() < 11) {
				  newvalue = newvalue + key;
				}
			break;
			case 1:
			// 1 = float
				if (((keyCode > 47 && keyCode < 58) || keyCode == 46) && newvalue.toString().length() < 12) {
				  newvalue = newvalue + key;
				}
			break;
			case 2:
			// 2 = int
				if (keyCode > 47 && keyCode < 58 && newvalue.length() < 12) {
				  newvalue = newvalue + key;
				}
			break;
			case 3:
			// 3 = string
				if ((keyCode > 47 && keyCode < 91  || keyCode == 32) && newvalue.length() < 24) {
				  newvalue = newvalue + key;
				}
			break;
			case 4:
			// 4 = boolean
				if ((keyCode > 47 && keyCode < 91  || keyCode == 32) && newvalue.length() < 5) {
				  newvalue = newvalue + key;
				}
			break;
		}
		return true;
	}
	boolean check() {
		if(newvalue.length() < 1) {
			return false;
		}
		switch(type) {
			case 0:
			// 0 = color
				String[] strings = split(newvalue, " ");
				int[] ints = new int[strings.length];
				for (int i=0; i<strings.length;i++) {
					if(strings[i].length() == 0) {
						return false;
					}
					int newint = int(strings[i]);
					if(newint > 255 || newint < 0) {
						return false;
					}
					ints[i] = newint;
				}
				if(ints.length == 3) {
					return true;
				}
			break;
			case 1:
			// 1 = float
				float f = float(newvalue);

				if(!Float.isNaN(f)) {
					return true;
				}
			break;
			case 2:
			// 2 = int
				if(index == 0 || index == 1) {
					if(int(newvalue) < 600) {
						return false;
					}
				}
				return true;
			case 3:
			// 3 = string
				return true;
			case 4:
			// 4 = boolean
				if(newvalue.equals("true") || newvalue.equals("false") || newvalue.equals("0") || newvalue.equals("1")) {
					return true;
				}
			break;
		}
		return false;
	}
}

abstract class Popup extends PWH {
	boolean visible;
	String text = "Are you Sure?";
	String truetext = "Yes";
	String falsetext = "No";
	ListItem[] values = new ListItem[0];
	boolean single = false;

	Popup(int newwidth, int newheight) {
		visible = true;
		float scale = st.floats[1].getvalue();
		float a = 2*scale*scale;
		xpos = round((width-newwidth)/a);
		ypos = round((height-newheight)/a);
		_width = newwidth;
		_height = newheight;
	}
	Popup(int newwidth, int newheight, ListItem[] newvalues) {
		visible = true;
		float scale = st.floats[1].getvalue();
		float a = 2*scale*scale;
		xpos = round((width-newwidth)/a);
		ypos = round((height-newheight)/a);
		_width = newwidth;
		_height = newheight;
		values = newvalues;
	}
	Popup(int newxpos, int newypos, int newwidth, int newheight) {
		visible = true;
		xpos = newxpos;
		ypos = newypos;
		_width = newwidth;
		_height = newheight;
	}

	void draw() {
		if(visible) {
			float scale = st.floats[1].getvalue();
			// Background
			noStroke();
			fill(0, 170);
			rect(0,0,width/scale,height/scale);
			// Popup Frame
			fill(255);
			rect(xpos,ypos, _width, _height);
			// Inputs
			for (int i=0;i<values.length;i++) {
				values[i].draw(xpos, ypos+30*i+_height-30*(values.length+1), _width, 30);

				if (checkraw(xpos, ypos+30*i+_height-30*(values.length+1), _width, 30)) {
					fill(0, 50);
					rect(xpos,ypos+30*i+_height-30*(values.length+1),_width, 30);
				}
			}

			// True & False Button
			fill(150);
			if(single) {
				rect(xpos,ypos+_height-30, _width, 30);
			} else {
				rect(xpos,ypos+_height-30, _width/2, 30);
				rect(xpos+_width/2,ypos+_height-30, _width/2, 30);
			}

			// Main Text
			fill(0);
			textAlign(CENTER, CENTER);
			push();
			textSize(16/((st.floats[1].getvalue()+1)/2)*1.125);
			rectMode(CENTER);
			text(text, xpos+_width/2, ypos+(_height-30*(values.length+1))/2, _width, _height-30);
			pop();
			// True & False Text
			if(single) {
				text(truetext, xpos+_width/2, ypos+_height-15);
			} else {
				text(truetext, xpos+_width/4, ypos+_height-15);
				text(falsetext, xpos+_width*3/4, ypos+_height-15);
			}
			if(single) {
				if(checkraw(xpos, ypos+_height-30, _width, _height)) {
					fill(0, 50);
					rect(xpos,ypos+_height-30,_width, 30);
				}
			} else {
				if(checkraw(xpos, ypos+_height-30, _width, _height)) {
					fill(0, 50);
					if(mouseX >= xpos*scale && mouseX <= (xpos+_width/2)*scale) {
						rect(xpos,ypos+_height-30,_width/2, 30);
					} else {
						rect(xpos+_width/2,ypos+_height-30,_width/2, 30);
					}
				}
			}
		}
	}

	abstract void ontrue();
	abstract void onfalse();

	boolean mousePressed() {
		if(visible && (mouseButton == LEFT)) {
			for (int i=0;i<values.length;i++) {
				values[i].check(xpos, ypos+30*i+_height-30*(values.length+1), _width, 30);
			}
			float scale = st.floats[1].getvalue();

			if(checkraw(xpos, ypos, _width, _height)) {
				if(mouseY >= (ypos+_height-30)*scale && mouseY <= (ypos+_height)*scale) {
					if(mouseX >= xpos*scale && mouseX <= (xpos+_width/2)*scale) {
						ontrue();
					} else {
						onfalse();
					}
					visible = false;
				}
			}
			return true;
		}
		return false;
	}
	boolean keyPressed() {
		boolean hit = false;
		if(visible) {
			for (int i=0;i<values.length;i++) {
				if(values[i].keyPressed()) {
					hit = true;
				}
			}
		}
		return hit;
	}
}