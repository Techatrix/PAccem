class OverlayManager {
	Overlay overlay = new Overlay();			// manages the rendering and event handling of the overlay

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
	final int messageboxheight = 180;			// const. height of the message box

	final TabData[] tabs = new TabData[] {new TabData("newroom",1,true),new TabData("viewmode",-1,false),new TabData("loadroom",0,false),new TabData("saveroom",1,false),
	new TabData("settings",2,false),new TabData("debug",3,false),new TabData("roomgroups",4,false),new TabData("about",2,true),new TabData("reset", 3,true),new TabData("price",5,false)};

	OverlayManager() {
		build();
		newroomname = st.strings[0].value;
		overlay.visible = !st.booleans[1].value;
	}
	void build() {
		Object[] items = new Object[4];
		items[0] = 
		new Popup() {
			@Override public void ontrue() {}
			@Override public void onfalse() {}
			@Override public boolean getvisible() {return drawpopup;}
		};
		// Tab bar 
		items[1] = 
		new Tabbar(
			// Tab selection bar 
			new ListViewBuilder() {
				@Override public Object i(int i) {
					final Temp temp = new Temp(i);
					TabData td = tabs[temp.i];
					if(td.id == -1) {
						return new Container(new GetValueText(lg.get(td.name)) {
							@ Override public String getvalue() {return rm.viewmode ? "3D" : "2D";}
						});
					} else {
						return new Container(new Text(lg.get(td.name)));
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
								return new EventDetector(new Container(new Text(lg.get("room") + ": " + rm.loadrooms()[i]))) {
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
											overlay.items[0] = new GetVisible(o) {@Override public boolean getvisible() {return drawpopup;}};
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
							return new Container(new SetValueText(lg.get(st.get(temp.i).name), st.get(temp.i).value, new SetValueStyle(st.get(temp.i).type)) {
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
											setvisible(!st.booleans[1].value);
											break;
											case 5: // Fullscreen
											drawpopup(0);
											break;
											case 6: // OPENGL Renderer
											drawpopup(0);
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
											drawpopup(0);
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
					new Dynamic() {
						@Override public Object getitem() {
							final String[] names = new String[] {"name","xoff","yoff","scale","dxoff","dyoff","dzoff","angle1","angle2",
								"dspeed","gridtilesize","tool","viewmode","newfurnitureid","isprefab","newroomgroup","selectionid"};
							final String[] values = new String[] {rm.name,str(rm.xoff),str(rm.yoff),str(rm.scale),str(rm.dxoff),
								str(rm.dyoff),str(rm.dzoff),str(rm.angle1),str(rm.angle2),str(rm.dspeed),str(rm.gridtilesize),
								str(rm.tool),str(rm.viewmode),str(rm.newfurnitureid),str(rm.isprefab),str(rm.newroomgroup),str(rm.selectionid)};

							return new ListViewBuilder() {
								@Override public Object i(int i) {
									final Temp temp = new Temp(i);
									return new Container(new Text(lg.get(names[temp.i]) + ": " + values[temp.i]));
								}
							}.build(values.length, 300, height-yoff);
						}
					},0,yoff, Align.TOPRIGHT
				),
				// roomgroups
				new Transform(
					new ListViewBuilder() {
						@Override public Object i(int i) {
							if(i==0) {
								return new EventDetector(new Container(new Text(lg.get("addrg")))) {
									@Override public void onevent(EventType et, MouseEvent e) {
										if(et == EventType.MOUSEPRESSED) {
											drawpopup(5);
										}
									}
								};
							} else {
								color rgc = rm.roomgrid.roomgroups.get(i-1).c;
								String cstring = int(red(rgc)) + " " + int(green(rgc)) + " " + int(blue(rgc));
								final Temp temp = new Temp(i-1);
								final Temp temp2 = new Temp(rm.roomgrid.roomgroups.size());
								return new ListView(
									new Object[] {
										new Container(new SetValueText(rm.roomgrid.roomgroups.get(i-1).name, cstring) {
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
													color col = color(ints[0], ints[1], ints[2]);
													value = ints[0]+" "+ints[1]+" "+ints[2];
													rm.roomgrid.roomgroups.get(temp.i).c = col;
												}
											}
										},200,30),
										// select roomgroup
										// TODO: Icon
										new EventDetector(new Container(new Text("S"),70,30, (rm.newroomgroup == temp.i) ? color(c[3]) : color(c[5]))) {
											@Override public void onevent(EventType et, MouseEvent e) {
												if(et == EventType.MOUSEPRESSED) {
													rm.newroomgroup = temp.i;
													ov.build();
												}
											}
										},
										// delete roomgroup
										new EventDetector(new Container(new Image(dm.icons[8]),30,30)) {
											@Override public void onevent(EventType et, MouseEvent e) {
												if(et == EventType.MOUSEPRESSED) {
													if(temp2.i > 1) {
														if(rm.roomgrid.isroomgroupinuse(temp.i)) {
															tempdata = temp.i;
															drawpopup(4);
														} else {
															rm.roomgrid.removeroomgroup(temp.i);
															ov.build();
														}
													} else {
														toovmessages.add(lg.get("crlrg"));
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
				// price
				new Transform(
					new Dynamic() {
						@Override public Object getitem() {
							PriceReport pr = rm.getpricereport();
							int total = 0;
							Object[] o = new Object[pr.furnitureids.length+1];
							for (int i=0;i<o.length;i++) {
								if(i != o.length-1) {
									FurnitureData fd = dm.getfurnituredata(pr.furnitureids[i]);
									total += fd.price * pr.furniturecounts[i];
									o[i] = new Text(pr.furniturecounts[i]+" * "+fd.name+"("+fd.price+")"+": "+fd.price*pr.furniturecounts[i]);
								} else {
									o[i] = new Text(lg.get("total") + ": " + total);
								}
							}

							return new ListView(
								o,300, height-yoff
							);
						}
					},0,yoff, Align.TOPRIGHT
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
							new EventDetector(new Container(new Text(lg.get("selectcolor")), 300, 30)) {
								@Override public void onevent(EventType et, MouseEvent e) {
									if(et == EventType.MOUSEPRESSED) {
										drawpopup(6);
									}
								}
							},
							new EventDetector(new Container(new Text(lg.get("prefablist")), 300, 30)) {
								@Override public void onevent(EventType et, MouseEvent e) {
									if(et == EventType.MOUSEPRESSED) {
										tabid = 7;
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
							new EventDetector(new Container(new Text(lg.get("furnlist")), 300, 30)) {
								@Override public void onevent(EventType et, MouseEvent e) {
									if(et == EventType.MOUSEPRESSED) {
										tabid = 6;
									}
								}
							},
						},300, height-yoff
					),0,yoff, Align.TOPRIGHT
				),
			}
			) {
			@Override public void ontab(int i) {
				TabData td = ov.tabs[i];
				//println(td.name);
				//println(td.id);
				//println(td.type);
				if(td.type) {
					drawpopup(td.id);
				} else {
					if(td.id == -1) {
						rm.switchviewmode();
					} else {
						if(tabid == td.id) {
							tabid = -1;
						} else {
							tabid = td.id;
						}
					}
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
									if(rm.tool == 2) {
										tabid = (tabid == 6) ? -1 : 6;
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
		overlay.setitems(items);
	}

	void draw() {
		overlay.draw();
		checkmessages();
	}
	boolean getvisible() {
		return overlay.visible;
	}
	void setvisible(boolean visible) {
		if(overlay.visible != visible) {
			overlay.visible = visible;
			ov.build();
		}
	}

	void checkmessages() { // print out all messages in the to overlay messages variable
		if(toovmessages.size() > 0) {
			for (int i=0;i<toovmessages.size();i++) {
				printmessage(toovmessages.get(i));
			}
			toovmessages.clear();
		}
	}
	void printmessage(String text) { // add a message to the console
		messages.add(fixlength(str(hour()), 2, '0') + ":" + fixlength(str(minute()), 2, '0') +": " + text);
		if(messages.size() > messageboxheight/30) {
			consoleoff -= 30;
		}
		drawconsole = true;
	}

	void drawpopup(int id) { // opens a Popup
		switch(id) { // popups
			case 0: // Opens the requiresrestart popup
				overlay.items[0] =
				new Popup(
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
					)) {
					@Override public void ontrue() {drawpopup = false;}
					@Override public void onfalse() {drawpopup = false;}
					@Override public boolean getvisible() {return drawpopup;}
				};
			break;
			case 1: // new Room
				overlay.items[0] =
				new Popup(
					new Object[] {
						new SizedBox(true),
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
						}
					),},lg.get("ok"), lg.get("cancel")) {
					@Override public void ontrue() {drawpopup = false;rm.newroom(newroomxsize, newroomysize);}
					@Override public void onfalse() {drawpopup = false;}
					@Override public boolean getvisible() {return drawpopup;}
				};
			break;
			case 2: // about
				overlay.items[0] =
				new Popup(
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
					)) {
					@Override public void ontrue() {drawpopup = false;}
					@Override public void onfalse() {drawpopup = false;}
					@Override public boolean getvisible() {return drawpopup;}
				};
			break;
			case 3: // reset
				overlay.items[0] =
				new Popup(
					new Object[] {
						new SizedBox(true),
						new Text(lg.get("areyousure")),
						new SizedBox(true),
					},lg.get("ok"), lg.get("cancel")) {
					@Override public void ontrue() {drawpopup = false;rm.reset();}
					@Override public void onfalse() {drawpopup = false;}
					@Override public boolean getvisible() {return drawpopup;}
				};
			break;
			case 4: // remove roomgroup
				overlay.items[0] =
				new Popup(
					new Object[] {
						new SizedBox(true),
						new Text(lg.get("areyousure")),
						new SizedBox(true),
					},lg.get("ok"), lg.get("cancel")) {
					@Override public void ontrue() {
						drawpopup = false;
						rm.roomgrid.removeroomgroup((int)tempdata);
						ov.build();
					}
					@Override public void onfalse() {drawpopup = false;}
					@Override public boolean getvisible() {return drawpopup;}
				};
			break;
			case 5: // new roomgroup
				tempdata = "";
				overlay.items[0] =
				new Popup(
					new Object[] {
						new SizedBox(true),
						new Text(lg.get("name") + "?"),
						new SizedBox(true),
						new Container(new SetValueText(lg.get("name")) {
							@Override public void onchange() {
								value = newvalue;
								tempdata = value;
							}
						}),

					},lg.get("ok"), lg.get("cancel")) {
					@Override public void ontrue() {
						if(tempdata != "") {
							rm.roomgrid.addroomgroup((String)tempdata, color(50,50,50));
							ov.build();
							drawpopup = false;
						} else {
							// TODO: Message
						}
					}
					@Override public void onfalse() {drawpopup = false;}
					@Override public boolean getvisible() {return drawpopup;}
				};
			break;
			case 6: // select color
				overlay.items[0] =
				new Popup(
					new Object[] {
					new SizedBox(true),
					new Text(lg.get("selectcolor")),
					new SizedBox(true),

					new Container(new Slider(lg.get("red"), red(rm.furnituretint)/255) {
									@Override public void onchange(float newvalue) {
										value = constrain(newvalue, 0, 1);
										int v = constrain(int(value*255), 0,255);
										rm.furnituretint = color(v, green(rm.furnituretint), blue(rm.furnituretint));
									}
									@Override public String gettext() {
										return str(constrain(round(value*255), 0, 255));
									}
					}),
					new Container(new Slider(lg.get("green"), green(rm.furnituretint)/255) {
									@Override public void onchange(float newvalue) {
										value = constrain(newvalue, 0, 1);
										int v = constrain(int(value*255), 0,255);
										rm.furnituretint = color(red(rm.furnituretint), v, blue(rm.furnituretint));
									}
									@Override public String gettext() {
										return str(constrain(round(value*255), 0, 255));
									}
					}),
					new Container(new Slider(lg.get("blue"), blue(rm.furnituretint)/255) {
									@Override public void onchange(float newvalue) {
										value = constrain(newvalue, 0, 1);
										int v = constrain(int(value*255), 0,255);
										rm.furnituretint = color(red(rm.furnituretint), green(rm.furnituretint), v);
									}
									@Override public String gettext() {
										return str(constrain(round(value*255), 0, 255));
									}
					}),
					},lg.get("ok"), lg.get("cancel")) {
					@Override public void ontrue() {drawpopup = false;printcolor(rm.furnituretint);build();}
					@Override public void onfalse() {drawpopup = false;}
					@Override public boolean getvisible() {return drawpopup;}
				};
			break;
			case 7: // activate cgol
				overlay.items[0] =
				new Popup(
					new Object[] {
						new SizedBox(true),
						new Text("Activate CGOL?"),
						new SizedBox(true),
					},lg.get("ok"), lg.get("cancel")) {
					@Override public void ontrue() {drawpopup = false;allowcgol = true;rm.furnitures = new ArrayList<Furniture>();}
					@Override public void onfalse() {drawpopup = false;}
					@Override public boolean getvisible() {return drawpopup;}
				};
			break;
		}
		drawpopup = true;
	}
	boolean ishit() { // return whether or not your mouse is on the overlay
		return overlay.ishit();
	}
	/* --------------- mouse input --------------- */
	void mouseWheel(MouseEvent e) {
		overlay.mouseWheel(e);
	}
	boolean mousePressed() {
		return overlay.mousePressed();
	}
	void mouseReleased() {
		overlay.mouseReleased();
	}
	boolean mouseDragged() {
		return overlay.mouseDragged();
	}
	/* --------------- keyboard input --------------- */
	void keyPressed(KeyEvent e) {
		overlay.keyPressed(e);
	}
	void keyReleased() {
		overlay.keyReleased();
	}
}