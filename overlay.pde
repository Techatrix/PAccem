class Overlay {
	Object[] items;								// array of all items in the overlay
	boolean visible = true;						// visiblity state of the overlay

	final int xoff = 50;						// used for aligning the roomgrid with the overlay
	final int yoff = 30;						// used for aligning the roomgrid with the overlay
	final color cc = color(255,0);

	boolean drawpopup = false;					// visiblity state of current popup
	int tabid = -1;								// used by Tabbar (in OTabbar.pde)
	String newroomname;							// the name of a new room 
	int newroomxsize = 15, newroomysize = 15;	// the size of a new room
	Object tempdata;							// temporary variable with diffrent uses(mostly for transfering data to popups)

	// Message Box
	ArrayList<String> messages = new ArrayList<String>(); // messages on the console
	int consoleoff = 0;							// offset of the console messages (scrolling)
	boolean drawconsole = false;				// visiblity state of console
	final int messageboxheight = 200;			// const. height of the message box


	Overlay() {
		if(deb) {
			PApplet.println("Loading Overlay");
		}
		visible = !st.booleans[1].value;
		newroomname = st.strings[0].value;
		build();

	}

	void build() { // build/create the overlay
		final String[] tabs = {"newroom", "viewmode", "loadroom", "saveroom", "settings", "debug", "roomgroups", "about", "reset"};
		items = new Object[4];
		items[0] = 
		new GetVisible() {@Override public boolean getvisible() {return drawpopup;}};
		// Tab bar 
		items[1] = 
		new Tabbar(
			// Tab selection bar 
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
			// Tabs
			new Object[] {
				// load room
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
					),0,yoff, Align.TOPRIGHT
				),
				// save room
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
										if(st.strings[0].value == ov.newroomname) {
											Object o =
											new Container(
												new Transform(
													new ListView(
														new Object[] {
															new SizedBox(true),
															new Text(lg.get("overwritedefaultroom")),
															new SizedBox(true),
															new ListView(
																new Object[] {
																	new EventDetector(new Container(new Text(lg.get("yes")))) {
																		@Override public void onevent(EventType et, MouseEvent e) {
																			if(et == EventType.MOUSEPRESSED) {
																				drawpopup = false;
																				rm.save(rm.name);
																				ov.build();
																			}}
																	},
																	new EventDetector(new Container(new Text(lg.get("no")))) {
																		@Override public void onevent(EventType et, MouseEvent e) {
																			if(et == EventType.MOUSEPRESSED) {
																				drawpopup = false;
																			}}
																	},
																}, width/4, 30, width/8, Dir.RIGHT
															)		
														}, width/4, height/4
													), Align.CENTERCENTER
												), width, height, color(0,150)
											);
											drawpopup = true;
											items[0] = new GetVisible(o) {@Override public boolean getvisible() {return drawpopup;}};
										} else {
											rm.save(rm.name);
											ov.build();
										}
									}
								}
							},
						}, 300, height-yoff
					),0,yoff, Align.TOPRIGHT
				),
				// settings
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
											if(usegl) {
												pg.setSize(width,height);
											}
											ov.build();
											break;
											case 8: // Height
											surface.setSize(st.ints[0].value,st.ints[1].value);
											if(usegl) {
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
					}.build(st.getsize(), 300, height-yoff),0,yoff, Align.TOPRIGHT
				),
				// debug
				new Transform(
					new ListView(
						new Object[] { // TODO: i should improve this (i could maybe use a ListViewBuilder)
							new Container(new GetValueText("Name") {@ Override public String getvalue() {return rm.name;}}),
							new Container(new GetValueText("X-off") {@ Override public String getvalue() {return str(rm.xoff);}}),
							new Container(new GetValueText("Y-off") {@ Override public String getvalue() {return str(rm.yoff);}}),
							new Container(new GetValueText("Scale") {@ Override public String getvalue() {return str(rm.scale);}}),
							new Container(new GetValueText("DX-off") {@ Override public String getvalue() {return str(rm.dxoff);}}),
							new Container(new GetValueText("DY-off") {@ Override public String getvalue() {return str(rm.dyoff);}}),
							new Container(new GetValueText("DZ-off") {@ Override public String getvalue() {return str(rm.dzoff);}}),
							new Container(new GetValueText("Angle 1") {@ Override public String getvalue() {return str(rm.angle1);}}),
							new Container(new GetValueText("Angle 2") {@ Override public String getvalue() {return str(rm.angle2);}}),
							new Container(new GetValueText("D-Speed") {@ Override public String getvalue() {return str(rm.dspeed);}}),
							new Container(new GetValueText("Gridtilesize") {@ Override public String getvalue() {return str(rm.gridtilesize);}}),
							new Container(new GetValueText("Tool") {@ Override public String getvalue() {return str(rm.tool);}}),
							new Container(new GetValueText("Viewmode") {@ Override public String getvalue() {return str(rm.viewmode);}}),
							new Container(new GetValueText("New Furnitureid") {@ Override public String getvalue() {return str(rm.newfurnitureid);}}),
							new Container(new GetValueText("Is Prefab") {@ Override public String getvalue() {return str(rm.isprefab);}}),
							new Container(new GetValueText("New Roomgroup") {@ Override public String getvalue() {return str(rm.newroomgroup);}}),
							new Container(new GetValueText("Selectionid") {@ Override public String getvalue() {return str(rm.selectionid);}}),
						}, 300, height-yoff
					),0,yoff, Align.TOPRIGHT
				),
				// roomgroups
				new Transform(
					new ListViewBuilder() {
						@Override public Object i(int i) {
							if(i==0) {
								return new EventDetector(new Container(new Text("Add Roomgroup"))) {
									@Override public void onevent(EventType et, MouseEvent e) {
										if(et == EventType.MOUSEPRESSED) {
											drawpopup(10);
										}
									}
								};
							} else {
								color c = rm.roomgrid.roomgroups.get(i-1).c;
								String cc = int(red(c)) + " " + int(green(c)) + " " + int(blue(c));
								final Temp temp = new Temp(i-1);
								final Temp temp2 = new Temp(rm.roomgrid.roomgroups.size());
								return new ListView(
									new Object[] {
										new Container(new SetValueText(rm.roomgrid.roomgroups.get(i-1).name, cc) {
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
													rm.roomgrid.roomgroups.get(temp.i).c = c;
												}
											}
										},200,30),
										// select roomgroup
										// TODO: Icon
										new EventDetector(new Container(new Text("S"),70,30)) {
											@Override public void onevent(EventType et, MouseEvent e) {
												if(et == EventType.MOUSEPRESSED) {
													rm.newroomgroup = temp.i;
												}
											}
										},
										// delete roomgroup
										// TODO: Icon
										new EventDetector(new Container(new Text("D"),30,30)) {
											@Override public void onevent(EventType et, MouseEvent e) {
												if(et == EventType.MOUSEPRESSED) {
													if(temp2.i > 1) {
														if(rm.roomgrid.isroomgroupinuse(temp.i)) {
															tempdata = temp.i;
															drawpopup(9);
														} else {
															rm.roomgrid.removeroomgroup(temp.i);
															ov.build();
														}
													} else {
														toovmessages.add("Can't remove last roomgroup");
													}
												}
											}
										},
									},300,30,Dir.RIGHT
								);
							}
						}
					}.build(rm.roomgrid.roomgroups.size()+1, 300, height-yoff),0,yoff, Align.TOPRIGHT
				),
				// furniture list
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
														new Image(dm.furnitures[temp.i].image, 150, round(150*0.75), Fit.RATIO, rm.furnituretint),
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
								}.build(dm.furnitures.length),300, height-yoff-60,2
							),
							new EventDetector(new Container(new Text("Select Color"), 300, 30)) {
								@Override public void onevent(EventType et, MouseEvent e) {
									if(et == EventType.MOUSEPRESSED) {
										drawpopup(11);
									}
								}
							},
							new EventDetector(new Container(new Text("Prefab List"), 300, 30)) {
								@Override public void onevent(EventType et, MouseEvent e) {
									if(et == EventType.MOUSEPRESSED) {
										tabid = 6;
									}
								}
							},
						},300, height-yoff
					),0,yoff, Align.TOPRIGHT
				),
				// prefab list
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
														new Image(dm.prefabs[temp.i].getimage(), 150, round(150*0.75), Fit.RATIO, rm.furnituretint),
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
					),0,yoff, Align.TOPRIGHT
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
					if(usegl) {
						rm.switchviewmode();
					}
				} else {
					drawpopup(i);
				}
			}
			@Override public int getid() {
				return tabid;
			}
		};
		// Tool bar
		items[2] =
		new Transform(
			new ListViewBuilder() {
				@Override public Object i(int i) {
					final Temp temp = new Temp(i);
					if (i < 6) {
						return new EventDetector(new Container(new Image(dm.icons[temp.i+1]))) {
							@Override public void onevent(EventType et, MouseEvent e) {
								if(et == EventType.MOUSEPRESSED) {
									rm.tool = temp.i;
									//im.setTool(temp.i);
									if(rm.tool == 2) {
										tabid = (tabid == 5) ? -1 : 5;
									}
								}
							}
						};
					} else {
						if(i == 6) {
							return new SizedBox(true);
						} else {
							return new EventDetector(new Container(new Image(dm.icons[7]))) {
							@Override public void onevent(EventType et, MouseEvent e) {
								if(et == EventType.MOUSEPRESSED) {
									drawconsole = !drawconsole;
								}
							}
						};
						}
					}
				}
			}.build(8, xoff, height-yoff, xoff, Dir.DOWN), 0,yoff
		);
		// Message Box
		items[3] = 
		new GetVisible(
			new Transform(
				new Dynamic() {
					@Override public Object getitem() {
						Object o = new EventDetector(
							new ListViewBuilder() {
								@Override public Object i(int i) {
									final Temp temp = new Temp(i);
									return new Container(new Text(messages.get(temp.i)), round(textWidth(messages.get(temp.i)))+10, 30, cc, false);
								}
							}.build(messages.size(),width-xoff,messageboxheight, 30, Dir.DOWN)
						) {
							@Override public void onevent(EventType et, MouseEvent e) {
								if(et == EventType.MOUSEWHEEL) {
									int length = messages.size()*30;
									if(length > messageboxheight) {
										consoleoff -= e.getCount()*15;
										consoleoff = constrain(consoleoff, messageboxheight - length, 0);
									}
								}
							}
						};
						((ListView)(((EventDetector)o).item)).off = consoleoff;
						return o;
					}
				},xoff, height-messageboxheight
			)
		) {@Override public boolean getvisible() {return drawconsole;}};

		for (Object item : items) {
			setitemxy(item, 0,0); // position all items at the origin
		}
	}

	void draw() { // draw the overlay
		if(visible) {
			// get hitdata for every item
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
				drawitem(items[i], h[i]); // the actual draw call
			}
			checkmessages();
		}
	}

	boolean ishit() { // return whether or not your mouse is on the overlay
		if(visible) {
			for (Object item : items) {
				if(getisitemhit(item)) {
					return true;
				}
			}
		}
		return false;
	}
	/* --------------- mouse input --------------- */
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
	boolean mouseDragged() {
		boolean hit = false;
		if(visible) {
			for (Object item : items) {
				if(mouseDraggeditem(item)) {
					hit = true;
					return true;
				}
			}
		}
		return hit;
	}
	/* --------------- keyboard input --------------- */
	void keyPressed() {
		if(visible) {
			for (Object item : items) {
				keyPresseditem(item);
			}
		}
	}
	void keyReleased() {
	}

	void requirerestart() { // draws the requiresrestart popup
		items[0] = new GetVisible(new Container(
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
		)) {@Override public boolean getvisible() {return drawpopup;}};
		drawpopup = true;
	}

	void checkmessages() {
		for (int i=0;i<toovmessages.size();i++) {
			println(toovmessages.get(i));
		}
		toovmessages.clear();
	}
	void println(String text) { // add a message to the console
		messages.add(fixlength(str(hour()), 2, '0') + ":" + fixlength(str(minute()), 2, '0') +": " + text);
		if(messages.size() > 5) {
			consoleoff -= 30;
		}
	}

	void drawpopup(int id) {
		Object o = new Object();
		switch(id) { // popups
			case 0: // new Room
				o =
				new Container(
					new Transform(
						new ListView(
							new Object[] {
								new Text(lg.get("newroom")),
								new SizedBox(true),
								new Container(new Slider(lg.get("newwidth"), (float)newroomxsize/100) {
									@Override public void onchange(float newvalue) {
										value = constrain(newvalue, 0.01, 1);
										int v = constrain(int(value*100), 1,100);
										newroomxsize = v;
									}
									@Override public String gettext() {
										return str(constrain(round(value*100), 1, 100));
									}
								}),
								new Container(new Slider(lg.get("newheight"), (float)newroomysize/100) {
									@Override public void onchange(float newvalue) {
										value = constrain(newvalue, 0.01, 1);
										int v = constrain(int(value*100), 1,100);
										newroomysize = v;
									}
									@Override public String gettext() {
										return str(constrain(round(value*100), 1, 100));
									}
								}),
								new ListView(
									new Object[] {
										new EventDetector(new Container(new Text(lg.get("ok")))) {
											@Override public void onevent(EventType et, MouseEvent e) {
												if(et == EventType.MOUSEPRESSED) {
													drawpopup = false;
													rm.newroom(newroomxsize, newroomysize);
												}}
										},
										new EventDetector(new Container(new Text(lg.get("cancel")))) {
											@Override public void onevent(EventType et, MouseEvent e) {
												if(et == EventType.MOUSEPRESSED) {
													drawpopup = false;
												}}
										},
									}, width/4, 30, width/8, Dir.RIGHT
								)		
							}, width/4, height/4
						), Align.CENTERCENTER
					), width, height, color(0,150),true, true
				);
			break;
			case 7: // about
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
					), width, height, color(0,150),true, true
				);
			break;
			case 8: // reset
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
					), width, height, color(0,150),true, true
				);
			break;
			case 9: // remove roomgroup
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
													rm.roomgrid.removeroomgroup((int)tempdata);
													ov.build();
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
					), width, height, color(0,150),true, true
				);
			break;
			case 10: // new roomgroup
				tempdata = "";
				o =
				new Container(
					new Transform(
						new ListView(
							new Object[] {
								new SizedBox(true),
								new Text("Name?"),
								new SizedBox(true),
								/* TODO: Color Slider / Color Picker
								new Container(new Slider("red", (float)50/255) {
									@Override public void onchange(float newvalue) {
										value = constrain(newvalue, 0, 1);
										int v = constrain(int(value*255), 0,255);
										//newroomysize = v;
									}
									@Override public String gettext() {
										return str(constrain(round(value*255), 0, 255));
									}
								}),
								*/
								new Container(new SetValueText("Name") {
									@Override public void onchange() {
										value = newvalue;
										tempdata = value;
									}
								}),
								new ListView(
									new Object[] {
										new EventDetector(new Container(new Text(lg.get("ok")))) {
											@Override public void onevent(EventType et, MouseEvent e) {
												if(et == EventType.MOUSEPRESSED) {
													if(tempdata != "") {
														rm.roomgrid.addroomgroup((String)tempdata, color(50,50,50));
														ov.build();
														drawpopup = false;
													} else {
														// TODO: Message
													}
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
					), width, height, color(0,150),true, true
				);
			break;
			case 11: // select color
				o =
				new Container(
					new Transform(
						new ListView(
							new Object[] {
								new SizedBox(true),
								new Text("Color?"),
								new SizedBox(true),

								new Container(new Slider("red", red(rm.furnituretint)/255) {
									@Override public void onchange(float newvalue) {
										value = constrain(newvalue, 0, 1);
										int v = constrain(int(value*255), 0,255);
										rm.furnituretint = color(v, green(rm.furnituretint), blue(rm.furnituretint));
									}
									@Override public String gettext() {
										return str(constrain(round(value*255), 0, 255));
									}
								}),
								new Container(new Slider("green", green(rm.furnituretint)/255) {
									@Override public void onchange(float newvalue) {
										value = constrain(newvalue, 0, 1);
										int v = constrain(int(value*255), 0,255);
										rm.furnituretint = color(red(rm.furnituretint), v, blue(rm.furnituretint));
									}
									@Override public String gettext() {
										return str(constrain(round(value*255), 0, 255));
									}
								}),
								new Container(new Slider("blue", blue(rm.furnituretint)/255) {
									@Override public void onchange(float newvalue) {
										value = constrain(newvalue, 0, 1);
										int v = constrain(int(value*255), 0,255);
										rm.furnituretint = color(red(rm.furnituretint), green(rm.furnituretint), v);
									}
									@Override public String gettext() {
										return str(constrain(round(value*255), 0, 255));
									}
								}),
								new ListView(
									new Object[] {
										new EventDetector(new Container(new Text(lg.get("ok")))) {
											@Override public void onevent(EventType et, MouseEvent e) {
												if(et == EventType.MOUSEPRESSED) {
													if(tempdata != "") {
														drawpopup = false;
														printcolor(rm.furnituretint);
														build();
													} else {
														// TODO: Message
													}
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
					), width, height, color(0,150),true, true
				);
			break;
			case 12: // select color
				o =
				new Container(
					new Transform(
						new ListView(
							new Object[] {
								new SizedBox(true),
								new Text("Activate CGOL?"),
								new SizedBox(true),
								new ListView(
									new Object[] {
										new EventDetector(new Container(new Text(lg.get("ok")))) {
											@Override public void onevent(EventType et, MouseEvent e) {
												if(et == EventType.MOUSEPRESSED) {
													drawpopup = false;
													allowcgol = true;
													rm.furnitures = new ArrayList<Furniture>();
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
					), width, height, color(0,150),true, true
				);
			break;
		}
		drawpopup = true;
		items[0] = new GetVisible(o) {@Override public boolean getvisible() {return drawpopup;}};
	}
}