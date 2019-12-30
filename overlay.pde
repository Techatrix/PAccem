class Overlay {
	Object[] items;				// array of all items in the overlay
	boolean visible = true;		// visibility state of the overlay

	Overlay() {
		if(deb) {
			toovmessages.add("Loading Overlay");
		}
	}
	
	void setItems(Object[] items) { // sets the items of the overlay
		this.items = items;
		for (Object item : items) {
			setItemXY(item, 0,0); // position all items at the origin
		}
	}

	void draw() { // draw the overlay
		if(visible) {
			// get hit data for every item
			boolean hit = false;
			boolean[] h = new boolean[items.length];
			for (int i=0;i<items.length;i++) {
				boolean newhit = getisItemHit(items[i]);
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
				drawItem(items[i], h[i]); // the actual draw call
			}
		}
	}

	boolean isHit() { // return whether or not your mouse is on the overlay
		if(visible) {
			for (Object item : items) {
				if(getisItemHit(item)) {
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
				mouseWheelItem(item, e);
			}
		}
	}
	boolean mousePressed() {
		boolean hit = false;
		if(visible) {
			for (Object item : items) {
				if(mousePressedItem(item)) {
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
				if(mouseDraggedItem(item)) {
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
				keyPressedItem(item);
			}
		}
	}
	void keyReleased() {
	}
}
