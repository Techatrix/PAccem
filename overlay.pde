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

	void refresh() {
		float scale = st.floats[1]._float;
		// Toolbar
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
				popup.text = "Select Size";
				popup.truetext = "Confirm";
				popup.falsetext = "Cancel";
		}};
		toolbarbuttons[3] = new ListItem("3", true) {@ Override public void action() {rm.tool = 3;}};
		toolbarbuttons[4] = new ListItem("4", true) {@ Override public void action() {rm.tool = 4;}};
		toolbarbuttons[5] = new ListItem("5", true) {@ Override public void action() {rm.tool = 5;}};
		toolbar = new ButtonList(0, _height, 50, ceil(height/scale)-_height, false, 50, 0, toolbarbuttons);

		// Tabbar
		ListItem[] tabbarbuttons = new ListItem[7];

		tabbarbuttons[0] = new ListItem("New Room") {
			@ Override public void action() {
				ListItem[] listitems = new ListItem[2];
				listitems[0] = new ListItem("New Width", true, 2, true) {@ Override public void action() {}};
				listitems[1] = new ListItem("New height",true, 2, true) {@ Override public void action() {}};

				popup = new Popup(250,150, listitems) {
					@ Override public void ontrue() {
						rm.xgridsize = int(values[0].bv.value);
						rm.ygridsize = int(values[1].bv.value);
						rm.reset();
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
		tabbarbuttons[5] = new ListItem("Room Groups") {@ Override public void action() {ov.sidebarid = ov.sidebarid == 4 ? -1 : 4;}};
		tabbarbuttons[6] = new ListItem("Reset") {
			@ Override public void action() {
				popup = new Popup(250,150) {
					@ Override public void ontrue() {rm.reset();}
					@ Override public void onfalse() {}
				};
			}
		};
		tabbar = new ButtonList(0,0,ceil(width/scale),_height, true, 120, 0, tabbarbuttons);

		// Loadbuttons
		String[] rooms = rm.loadrooms();
		ListItem[] loadbuttons = new ListItem[0];
		if(rooms != null) {
			loadbuttons = new ListItem[rooms.length];
			for (int i=0;i<rooms.length;i++ ) {
				loadbuttons[i] = new ListItem(rooms[i]) {@ Override public void action() {rm.load(name);}};
			}
		}

		// Savebuttons
		ListItem[] savebuttons = new ListItem[2];
		savebuttons[0] = new ListItem("Name", true, 3, -99) {@ Override public void action() {}};
		savebuttons[1] = new ListItem("Save") {@ Override public void action() {
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
  			ov.refresh();
		}};

		// Room Groups
		ListItem[] roomgroupsbuttons = new ListItem[5];
		roomgroupsbuttons[0] = new ListItem("Group 1", true, 0, -1) {@ Override public void action() {}};
		roomgroupsbuttons[1] = new ListItem("Group 2", true, 0, -2) {@ Override public void action() {}};
		roomgroupsbuttons[2] = new ListItem("Group 3", true, 0, -3) {@ Override public void action() {}};
		roomgroupsbuttons[3] = new ListItem("Group 4", true, 0, -4) {@ Override public void action() {}};
		roomgroupsbuttons[4] = new ListItem("Group 5", true, 0, -5) {@ Override public void action() {}};

		// Sidebars
		sidebars[0] = new ButtonList(ceil(width/scale)-sidebarwidth,_height,sidebarwidth,height-_height, false, _height, 10, loadbuttons);
		sidebars[1] = new ButtonList(ceil(width/scale)-sidebarwidth,_height,sidebarwidth,height-_height, false, _height, 10, savebuttons);
		sidebars[2] = new ButtonList(ceil(width/scale)-sidebarwidth,_height,sidebarwidth,height-_height, false, _height, 2, st);
		sidebars[3] = new ButtonList(ceil(width/scale)-sidebarwidth,_height,sidebarwidth,height-_height, false, _height, 10);
		sidebars[4] = new ButtonList(ceil(width/scale)-sidebarwidth,_height,sidebarwidth,height-_height, false, _height, 10, roomgroupsbuttons);
	}

	void draw() {
		push();
		scale(st.floats[1]._float);
		if(sidebarid != -1) {
			sidebars[sidebarid].draw();
		}
		toolbar.draw();
		tabbar.draw();
		if(popup != null) {
			popup.draw();
		}
		pop();
	}
	boolean mousePressed() {
		float scale = st.floats[1]._float;
		if(popup != null) {
			if(popup.mousePressed()) {
				return true;
			}
		}
		boolean hit = false;
		toolbar.mousePressed();
		if (mouseX >= toolbar.xpos*scale && mouseX <= (toolbar.xpos+toolbar._width)*scale && 
		    mouseY >= toolbar.ypos*scale && mouseY <= (toolbar.ypos+toolbar._height)*scale) {
		  	hit = true;
		}
		tabbar.mousePressed();
		if (mouseX >= tabbar.xpos*scale && mouseX <= (tabbar.xpos+tabbar._width)*scale && 
		    mouseY >= tabbar.ypos*scale && mouseY <= (tabbar.ypos+tabbar._height)*scale) {
		  	hit = true;
		}
		if(sidebarid != -1) {
			ButtonList sb = sidebars[sidebarid];
			sb.mousePressed();
			if (mouseX >= sb.xpos*scale && mouseX <= (sb.xpos+sb._width)*scale && 
			    mouseY >= sb.ypos*scale && mouseY <= (sb.ypos+sb._height)*scale) {
			  	hit = true;
			}
		}
		return hit;
	}
	void mouseDragged() {
		if(sidebarid != -1) {
			ButtonList sb = sidebars[sidebarid];
			sb.mouseDragged();
		}
	}
	void keyPressed() {
		if(popup != null) {
			if(popup.visible) {
				popup.keyPressed();
			}
		}
		if(sidebarid != -1) {
			ButtonList sb = sidebars[sidebarid];
			sb.keyPressed();
		}
	}
}

class ButtonList extends PWH{
	ListItem[] listitems;
	boolean direction;
	float off;
	int buttonsize = 50;
	int buttonmargin = 10;

	ListItem[] lastlistitems;

	ButtonList(int newxpos, int newypos, int newwidth, int newheight, boolean newdirection, int newbuttonsize, int newbuttonmargin) {
		xpos = newxpos;
		ypos = newypos;
		_width = newwidth;
		_height = newheight;
		direction = newdirection;
		off = 0;
		buttonsize = newbuttonsize;
		buttonmargin = newbuttonmargin;
		listitems = new ListItem[0];
	}
	ButtonList(int newxpos, int newypos, int newwidth, int newheight, boolean newdirection, int newbuttonsize, int newbuttonmargin, Settings settings) {
		xpos = newxpos;
		ypos = newypos;
		_width = newwidth;
		_height = newheight;
		direction = newdirection;
		off = 0;
		buttonsize = newbuttonsize;
		buttonmargin = newbuttonmargin;

		newsettings(st);
	}
	ButtonList(int newxpos, int newypos, int newwidth, int newheight, boolean newdirection, int newbuttonsize, int newbuttonmargin, ListItem[] newlistitems) {
		xpos = newxpos;
		ypos = newypos;
		_width = newwidth;
		_height = newheight;
		direction = newdirection;
		off = 0;
		buttonsize = newbuttonsize;
		buttonmargin = newbuttonmargin;

		listitems = newlistitems;
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
	}
	void draw() {
		pushMatrix();
		translate(0,off);
		noStroke();
		fill(st.colors[1]._color);
		rect(xpos, ypos, _width, _height);
		for (int i=0;i<listitems.length;i++) {
			if(direction) {
				listitems[i].draw(xpos+(buttonsize+buttonmargin)*i, ypos, buttonsize, _height);
			} else {
				listitems[i].draw(xpos, ypos+(buttonsize+buttonmargin)*i, _width, buttonsize);
			}
		}
		popMatrix();
	}

	int getlistheight() {
		return (listitems.length+buttonmargin) * buttonsize;
	}

	void mousePressed() {
		if(mouseButton == LEFT) {
			for (int i=0;i<listitems.length;i++) {
				ListItem l = listitems[i];
				if(direction) {
					l.check(xpos+(buttonsize+buttonmargin)*i, ypos, buttonsize, _height);
				} else {
					l.check(xpos, ypos+(buttonsize+buttonmargin)*i, _width, buttonsize);
				}
			}
		}
	}
	void mouseDragged() {
		if(mouseButton == LEFT) {
			off += mouseY - pmouseY;
			int listheight = getlistheight() < _height ? _height : getlistheight();
			off = constrain(off, _height-listheight, 0);
		}
	}
	void keyPressed() {
		for (ListItem li : listitems) {
			li.keyPressed();
		}
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
			fill(st.colors[2]._color);
			rect(xpos,ypos,_width, _height);
			if(checkraw(xpos, ypos, _width, _height)) {
				fill(0, 50);
				rect(xpos,ypos,_width, _height);
			}
			fill(editmode ? color(255,0,0) : 255);
			text(name + (editable ? ": " + (editmode ? bv.newvalue : bv.value) : ""), xpos+_width/2, ypos+_height/2);

		} else {
			if(checkraw(xpos, ypos, _width, _height)) {
				fill(0, 50);
				rect(xpos,ypos,_width, _height);
			}
			image(im.images[int(name)], xpos, ypos, _width, _height);
		}
	}
	abstract void action();

	boolean checkraw(int xpos, int ypos, int _width, int _height) {
		float scale = st.floats[1]._float;
		if (mouseX >= xpos*scale && mouseX <= (xpos+_width)*scale && 
		    mouseY >= ypos*scale && mouseY <= (ypos+_height)*scale) {
		  	return true;
		} else {
		  	return false;
		}
	}

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
	void keyPressed() {
		if(editmode) {
			bv.keyPressed();
			if(keyCode == ENTER) {
				editmode = false;
			}
		}
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
						color c = st.colors[index]._color;
						value = int(red(c)) + " " + int(green(c)) + " " + int(blue(c));
					}
				break;
				case 1:
				// 1 = float
					value = str(st.floats[index]._float);
				break;
				case 2:
				// 2 = int
					value = str(st.ints[index]._int);
				break;
				case 3:
				// 3 = string
					value = st.strings[index]._string;
				break;
				case 4:
				// 4 = boolean
					value = st.booleans[index]._boolean == true ? "true" : "false";
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
							st.colors[index]._color = c;
						}
					break;
					case 1:
					// 1 = float
						st.floats[index]._float = float(value);
					break;
					case 2:
					// 2 = int
						st.ints[index]._int = int(value);

						if(index == 0 || index == 1) {
							int sw = st.ints[0]._int;
							int sh = st.ints[1]._int;
							surface.setSize(sw,sh);
	  						ov.refresh();
						}
					break;
					case 3:
					// 3 = string
						st.strings[index]._string = value;
					break;
					case 4:
					// 4 = boolean
						if(value.equals("0") || value.equals("1")) {
							newvalue = value.equals("0") ? "false" : "true";
							value = value.equals("0") ? "false" : "true";
						}
						st.booleans[index]._boolean = boolean(value);
						if(index == 3) {
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
				print("aaa");
				st.save();
			} else {
				rm.name = value;
			}
		}
	}



	void keyPressed() {
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
				if ((keyCode > 47 && keyCode < 91  || keyCode == 32) && newvalue.length() < 12) {
				  newvalue = newvalue + key;
				}
			break;
			case 4:
			// 4 = boolean
				if ((keyCode > 47 && keyCode < 91  || keyCode == 32) && newvalue.length() < 6) {
				  newvalue = newvalue + key;
				}
			break;
		}
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
		xpos = (width-newwidth)/2;
		ypos = (height-newheight)/2;
		_width = newwidth;
		_height = newheight;
	}
	Popup(int newwidth, int newheight, ListItem[] newvalues) {
		visible = true;
		xpos = (width-newwidth)/2;
		ypos = (height-newheight)/2;
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
			// Background
			noStroke();
			fill(0, 170);
			rect(0,0,width,height);
			// Popup Frame
			fill(255);
			rect(xpos,ypos, _width, _height);
			// Inputs
			for (int i=0;i<values.length;i++) {
				values[i].draw(xpos, ypos+30*i+_height-30*(values.length+1), _width, 30);
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
			textSize(18);
			rectMode(CENTER);
			text(text, xpos+_width/2, ypos+(_height-30*(values.length+1))/2, _width, _height-30);
			rectMode(CORNER);

			// True & False Text
			textAlign(CENTER, CENTER);
			textSize(16);
			if(single) {
				text(truetext, xpos+_width/2, ypos+_height-15);
			} else {
				text(truetext, xpos+_width/4, ypos+_height-15);
				text(falsetext, xpos+_width*3/4, ypos+_height-15);
			}
			if(single) {
				if(mouseX >= xpos && mouseX <= xpos+_width && 
			    	mouseY >= ypos+_height-30 && mouseY <= ypos+_height) {
					fill(0, 50);
					rect(xpos,ypos+_height-30,_width, 30);
				}
			} else {
				if(mouseX >= xpos && mouseX <= xpos+_width && 
			    	mouseY >= ypos+_height-30 && mouseY <= ypos+_height) {
					fill(0, 50);
					if(mouseX >= xpos && mouseX <= xpos+_width/2) {
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

			if (mouseX >= xpos && mouseX <= xpos+_width && 
			    mouseY >= ypos && mouseY <= ypos+_height) {
				if(mouseY >= ypos+_height-30 && mouseY <= ypos+_height) {
					if(mouseX >= xpos && mouseX <= xpos+_width/2) {
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
	void keyPressed() {
		for (int i=0;i<values.length;i++) {
			values[i].keyPressed();
		}
	}
}