interface IOverlay{

	void draw(boolean hit);
	Box getbound();
	boolean ishit();

	void setxy(int ypos, int xpos);
	void setwh(int _width, int _height);
}
/*
interface IMouseEvent {

	void mouseWheel(MouseEvent e);
	void mousePressed();
	void mouseReleased();
	void mouseDragged();
}
interface IKeyEvent {

	void keyPressed();
	void keyReleased();
}
*/