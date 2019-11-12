class Overlay {
	Object[] items;
	boolean visible = true;

	int xoff = 50;
	int yoff = 30;
	boolean drawpopup = false;
	int tabid = -1;
	String newroomname;
	int newroomxsize = 15, newroomysize = 15;


	Overlay() {
		visible = !st.booleans[1].value;
		newroomname = st.strings[0].value;
		build();
	}

	void build() {
		final String[] tabs = {"newroom", "viewmode", "loadroom", "saveroom", "settings", "debug", "roomgroups", "about", "reset"};
		items = new Object[3];
		items[0] =
		new GetVisible(new Text(" ")) {@Override public boolean getvisible() {return drawpopup;}};
		items[1] = 
		new Tabbar(
			new ListViewBuilder() {
				@Override public Object i(int i) {
					final Temp temp = new Temp(i);
					if(i == 1) {
						return new Container(new GetValueText(lg.get(tabs[temp.i])) {
							@ Override public String getvalue() {return rm.viewmode ? "3D" : "2D";}
						});
					} else {
						return new Container(new Text(lg.get(tabs[temp.i])));
					}
				}
			}.build(tabs.length, width, yoff, 120, Dir.RIGHT),
			new Object[] {
				// Load Room
				new Transform(
					new Transform(
						new ListView(
							new Builder() {
								@Override public Object i(int i) {
									final Temp temp = new Temp(i);
									return new EventDetector(new Container(new Text("Room: " + rm.loadrooms()[i]))) {
										@Override public void onevent(EventType et, MouseEvent e) {
											if(et == EventType.MOUSEPRESSED) {
												rm.load(rm.loadrooms()[temp.i]);
											}
										}
									};
								}
							}.build(rm.loadrooms().length), 300, height-yoff
						), Align.TOPRIGHT
					),0,yoff
				),
				// Save Room
				new Transform(
					new Transform(
						new ListView(
							new Object[] {
								new Container(new SetValueText("Name", newroomname) {
									@Override public void onchange() {ov.newroomname = newvalue;value = newvalue;}
								}),
								new SizedBox(),
								new EventDetector(new Container(new Text("Save"))) {
									@Override public void onevent(EventType et, MouseEvent e) {
										if(et == EventType.MOUSEPRESSED) {
											rm.name = ov.newroomname;
											rm.save(rm.name);
											ov.build();
										}
									}
								},
							}, 300, height-yoff
						), Align.TOPRIGHT
					),0,yoff
				),
				// Settings
				new Transform(
					new Transform(
						new ListViewBuilder() {
							@Override public Object i(int i) {
								final Temp temp = new Temp(i);
								return new Container(new SetValueText(cap(st.get(temp.i).name), st.get(temp.i).value, new SetValueStyle(st.get(temp.i).type)) {
									@Override public void onchange() {
										String result = st.set(temp.i, newvalue);
										if(result != null) {
											value = result;
											switch(temp.i) {
												case 1:
												lg.setlang(st.strings[1].value);
												ov.build();
												break;
												case 2:
												am.setfont(st.strings[2].value);
												break;
												case 3:
												am.recalculatecolor();
												break;
												case 4: // Hide Overlay
												visible = !st.booleans[1].value;
												break;
												case 5: // Fullscreen
												requirerestart();
												break;
												case 6: // OPENGL Renderer
												requirerestart();
												break;
												case 7: // Width
												surface.setSize(st.ints[0].value,st.ints[1].value);
												if(st.booleans[3].value) {
													pg.setSize(width,height);
												}
												ov.build();
												break;
												case 8: // Height
												surface.setSize(st.ints[0].value,st.ints[1].value);
												if(st.booleans[3].value) {
													pg.setSize(width,height);
												}
												ov.build();
												break;
												case 9: // AA
												requirerestart();
												break;
											}
										}
									}
								});
							}
						}.build(st.getsize(), 300, height-yoff), Align.TOPRIGHT
					),0,yoff
				),
				// Debug
				new Transform(
					new Transform(
						new ListView(
							new Object[] {
								new Container(new GetValueText("Name") {@ Override public String getvalue() {return rm.name;}}),
								new Container(new GetValueText("X-off") {@ Override public String getvalue() {return str(rm.xoff);}}),
								new Container(new GetValueText("Y-off") {@ Override public String getvalue() {return str(rm.yoff);}}),
								new Container(new GetValueText("Scale") {@ Override public String getvalue() {return str(rm.scale);}}),
								new Container(new GetValueText("Angle 1") {@ Override public String getvalue() {return str(rm.angle1);}}),
								new Container(new GetValueText("Angle 2") {@ Override public String getvalue() {return str(rm.angle2);}}),
								new Container(new GetValueText("X-gridsize") {@ Override public String getvalue() {return str(rm.xgridsize);}}),
								new Container(new GetValueText("Y-gridsize") {@ Override public String getvalue() {return str(rm.ygridsize);}}),
								new Container(new GetValueText("Gridtilesize") {@ Override public String getvalue() {return str(rm.gridtilesize);}}),
								new Container(new GetValueText("Tool") {@ Override public String getvalue() {return str(rm.tool);}}),
								new Container(new GetValueText("Setup") {@ Override public String getvalue() {return str(rm.setup);}}),
								new Container(new GetValueText("Viewmode") {@ Override public String getvalue() {return str(rm.viewmode);}}),
								new Container(new GetValueText("New Furnitureid") {@ Override public String getvalue() {return str(rm.newfurnitureid);}}),
								new Container(new GetValueText("New Roomtilegroup") {@ Override public String getvalue() {return str(rm.newroomtilegroup);}}),
								new Container(new GetValueText("Selectionid") {@ Override public String getvalue() {return str(rm.selectionid);}}),
							}, 300, height-yoff
						), Align.TOPRIGHT
					),0,yoff
				),
				// Room Groups
				new Transform(
					new Transform(
						new ListViewBuilder() {
							@Override public Object i(int i) {
								color c = rm.roomgrid.roomgroups[i];
								final STemp stemp = new STemp(int(red(c)) + " " + int(green(c)) + " " + int(blue(c)));
								final Temp temp = new Temp(i);
								return new Container(new SetValueText(lg.get("group") + " " + (temp.i+1), stemp.s) {
									@Override public void onchange() {
										String[] strings = split(newvalue, " ");
										int[] ints = new int[strings.length];
										boolean a = true;
										for (int i=0; i<strings.length;i++) {
											if(strings[i].length() == 0) {
												a = false;
											}
											int newint = int(strings[i]);
											if(newint > 255 || newint < 0) {
												a = false;
											}
											ints[i] = newint;
										}
										if(a && ints.length == 3) {
											color c = color(ints[0], ints[1], ints[2]);
											value = ints[0]+" "+ints[1]+" "+ints[2];
											rm.roomgrid.roomgroups[temp.i] = c;
										}
									}
								});
							}
						}.build(5, 300, height-yoff), Align.TOPRIGHT
					),0,yoff
				),
				// Furniture List
				new Transform(
					new Transform(
						new ListView(
							new Object[] {
								new GridView(
									new Builder() {
										@Override public Object i(int i) {
											final Temp temp = new Temp(i);
											return new EventDetector(new Container(
													new ListView(
														new Object[] {
															new Image(dm.furnitures[temp.i].image, 150, round(150*0.75), Fit.RATIO),
															new Text(dm.furnitures[temp.i].name),
														}
													)
												)
											) {
												@Override public void onevent(EventType et, MouseEvent e) {
													if(et == EventType.MOUSEPRESSED) {
														rm.newfurnitureid = temp.i;
														rm.isprefab = false;
														rm.tool = 2;
													}
												}
											};
										}
									}.build(dm.furnitures.length),300, height-yoff-30,2
								),
								new EventDetector(new Container(new Text("Prefab List"), 300, 30)) {
									@Override public void onevent(EventType et, MouseEvent e) {
										if(et == EventType.MOUSEPRESSED) {
											tabid = 6;
										}
									}
								},
							},300, height-yoff
						), Align.TOPRIGHT
					),0,yoff
				),
				// Prefab List
				new Transform(
					new Transform(
						new ListView(
							new Object[] {
								new GridView(
									new Builder() {
										@Override public Object i(int i) {
											final Temp temp = new Temp(i);
											return new EventDetector(new Container(
													new ListView(
														new Object[] {
															new Image(dm.prefabs[temp.i].getimage(), 150, round(150*0.75), Fit.RATIO),
															new Text(dm.prefabs[temp.i].name),
														}
													)
												)
											) {
												@Override public void onevent(EventType et, MouseEvent e) {
													if(et == EventType.MOUSEPRESSED) {
														rm.newfurnitureid = temp.i;
														rm.isprefab = true;
														rm.tool = 2;
													}
												}
											};
										}
									}.build(dm.prefabs.length),300, height-yoff-30,2
								),
								new EventDetector(new Container(new Text("Furniture List"), 300, 30)) {
									@Override public void onevent(EventType et, MouseEvent e) {
										if(et == EventType.MOUSEPRESSED) {
											tabid = 5;
										}
									}
								},
							},300, height-yoff
						), Align.TOPRIGHT
					),0,yoff
				),
			}
			) {
			@Override public void ontab(int i) {
				if(1 < i && i < 7) {
					if(tabid == i-2) {
						tabid = -1;
					} else {
						tabid = i-2;
					}
				} else if(i == 1) {
					rm.switchviewmode();
				} else {
					Object o = new Object();
					switch(i) { // Popups
						case 0: // New Room
							o =
							new Container(
								new Transform(
									new ListView(
										new Object[] {
											new Text(lg.get("newroom")),
											new SizedBox(true),
											new Container(new SetValueText(lg.get("newwidth"), str(newroomxsize), new SetValueStyle(2)) {
												@Override public void onchange() {
													int v = constrain(int(newvalue), 1,100);
													value = str(v);
													newroomxsize = v;
												}
											}),
											new Container(new SetValueText(lg.get("newheight"), str(newroomysize), new SetValueStyle(2)) {
												@Override public void onchange() {
													int v = constrain(int(newvalue), 1,100);
													value = str(v);
													newroomysize = v;
												}
											}),
											new EventDetector(new Container(new Text(lg.get("ok")))) {
												@Override public void onevent(EventType et, MouseEvent e) {
													if(et == EventType.MOUSEPRESSED) {drawpopup = false;}}
											},
										}, width/4, height/4
									), Align.CENTERCENTER
								), width, height, color(0,150)
							);
						break;
						case 7: // About
							o =
							new Container(
								new Transform(
									new ListView(
										new Object[] {
											new Text(getabout(), 5),
											new SizedBox(true),
											new EventDetector(new Container(new Text("Github"))) {
												@Override public void onevent(EventType et, MouseEvent e) {
													if(et == EventType.MOUSEPRESSED) {link(githublink);}
												}
											},
											new EventDetector(new Container(new Text(lg.get("ok")))) {
												@Override public void onevent(EventType et, MouseEvent e) {
													if(et == EventType.MOUSEPRESSED) {drawpopup = false;}
												}
											},
										}, width/4, height/4
									), Align.CENTERCENTER
								), width, height, color(0,150)
							);
						break;
						case 8: // Reset
							o =
							new Container(
								new Transform(
									new ListView(
										new Object[] {
											new SizedBox(true),
											new Text(lg.get("areyousure")),
											new SizedBox(true),
											new ListView(
												new Object[] {
													new EventDetector(new Container(new Text(lg.get("ok")))) {
														@Override public void onevent(EventType et, MouseEvent e) {
															if(et == EventType.MOUSEPRESSED) {
																drawpopup = false;
																rm.reset();
															}
														}
													},
													new EventDetector(new Container(new Text(lg.get("cancel")))) {
														@Override public void onevent(EventType et, MouseEvent e) {
															if(et == EventType.MOUSEPRESSED) {drawpopup = false;}
														}
													},
												}, width/4, 30, width/8, Dir.RIGHT
											)
										}, width/4, height/4
									), Align.CENTERCENTER
								), width, height, color(0,150)
							);
						break;
					}
					drawpopup = true;
					items[0] = new GetVisible(o) {@Override public boolean getvisible() {return drawpopup;}};
				}
			}
			@Override public int getid() {
				return tabid;
			}
		};
		items[2] =
		new Transform(
			new ListViewBuilder() {
				@Override public Object i(int i) {
					final Temp temp = new Temp(i);
					return new EventDetector(new Container(new Image(dm.icons[temp.i+1]))) {
						@Override public void onevent(EventType et, MouseEvent e) {
							if(et == EventType.MOUSEPRESSED) {
								rm.tool = temp.i;
								if(rm.tool == 2) {
									tabid = (tabid == 5) ? -1 : 5;
								}
							}
						}
					};
				}
			}.build(6, xoff, height-yoff, xoff, Dir.DOWN), 0,yoff
		);
		for (Object item : items) {
			setitemxy(item, 0,0);
		}
	}

	void draw() {
		if(visible) {
			boolean hit = false;
			boolean[] h = new boolean[items.length];
			for (int i=0;i<items.length;i++) {
				boolean newhit = getisitemhit(items[i]);
				if(newhit) {
					if(!hit) {
						h[i] = true;
					}
					hit = true;
				} else {
					h[i] = false;
				}
			}

			for (int i=items.length-1;i>=0;i--) {
				drawitem(items[i], h[i]);
			}

		}
	}

	boolean ishit() {
		if(visible) {
			for (Object item : items) {
				if(getisitemhit(item)) {
					return true;
				}
			}
		}
		return false;
	}
	
	void mouseWheel(MouseEvent e) {
		if(visible) {
			for (Object item : items) {
				mouseWheelitem(item, e);
			}
		}
	}
	boolean mousePressed() {
		boolean hit = false;
		if(visible) {
			for (Object item : items) {
				if(mousePresseditem(item)) {
					hit = true;
					return true;
				}
			}
		}
		return hit;
	}
	void mouseReleased() {
	}
	void mouseDragged() {
	}
	void keyPressed() {
		if(visible) {
			for (Object item : items) {
				keyPresseditem(item);
			}
		}
	}
	void keyReleased() {
	}

	void requirerestart() {
		Object o =
		new Container(
			new Transform(
				new ListView(
					new Object[] {
						new SizedBox(true),
						new Text(lg.get("ratste"), 3),
						new SizedBox(true),
						new EventDetector(new Container(new Text(lg.get("ok")))) {
							@Override public void onevent(EventType et, MouseEvent e) {
								if(et == EventType.MOUSEPRESSED) {drawpopup = false;}
							}
						},
					}, width/4, height/4
				), Align.CENTERCENTER
			), width, height, color(0,150)
		);

		drawpopup = true;
		items[0] = new GetVisible(o) {@Override public boolean getvisible() {return drawpopup;}};
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
	} else if (item instanceof GetVisible) {
		((GetVisible)item).mouseWheel(e);
	} else if (item instanceof EventDetector) {
		((EventDetector)item).mouseWheel(e);
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
	} else if(item instanceof GetVisible) {
		return ((GetVisible)item).mousePressed();
	} else if (item instanceof EventDetector) {
		((EventDetector)item).mousePressed();
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
	} else if (item instanceof GetVisible) {
		((GetVisible)item).keyPressed();
	} else if (item instanceof EventDetector) {
		((EventDetector)item).keyPressed();
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
	} else if(item instanceof GetVisible) {
		return ((GetVisible)item).ishit();
	} else if(item instanceof EventDetector) {
		return ((EventDetector)item).ishit();
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
	} else if(item instanceof GetVisible) {
		((GetVisible)item).draw(hit);
	} else if(item instanceof EventDetector) {
		((EventDetector)item).draw(hit);
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
	} else if(item instanceof GetVisible) {
		((GetVisible)item).setwh(_width, _height);
	} else if(item instanceof EventDetector) {
		((EventDetector)item).setwh(_width, _height);
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
	} else if(item instanceof GetVisible) {
		((GetVisible)item).setxy(xpos, ypos);
	} else if(item instanceof EventDetector) {
		((EventDetector)item).setxy(xpos, ypos);
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
	} else if(item instanceof GetVisible) {
		return ((GetVisible)item).getbound();
	} else if(item instanceof EventDetector) {
		return ((EventDetector)item).getbound();
	}
	return null;
}

enum Dir {
    UP, RIGHT, DOWN, LEFT;
}
enum Align {
    TOPLEFT, TOPRIGHT, BOTTOMLEFT, BOTTOMRIGHT, CENTERCENTER;
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