class Overlay {
	Object[] items;								// array of all items in the overlay
	boolean visible = true;						// visiblity state of the overlay

	Overlay() {
		if(deb) {
			println("Loading Overlay");
		}
	}
	void setitems(Object[] items) {
		this.items = items;
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
	void keyPressed(KeyEvent e) {
		if(visible) {
			for (Object item : items) {
				keyPresseditem(item);
			}
		}
	}
	void keyReleased() {
	}
}