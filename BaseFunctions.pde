String getAbout() { // returns the about text
	String text = appname + "\n";
	text += lg.get("version") + ": " + appversion + "\n";
	text += lg.get("madeby") + ": " + appmaker + "\n";
	return text;
}
void setKey(int k, boolean bool) {	// sets the state of some keys(Arrow keys, T)
  if      (k == UP    | k == 'W')	isKeyUp		= bool;
  else if (k == DOWN  | k == 'S')	isKeyDown	= bool;
  else if (k == LEFT  | k == 'A')	isKeyLeft	= bool;
  else if (k == RIGHT | k == 'D')	isKeyRight	= bool;
  else if (             k == 'T')	isKeyT		= bool;
}
String cap(String str) { // converts the first letter of a string to upper case
	return str.substring(0, 1).toUpperCase() + str.substring(1);
}
String fixLength(String str, int length, char c) {
	while(str.length() < length) {
		str = c + str;
	}
	return str;
}
void printColor(int c) { // prints a color
	println("Red: " + (int)red(c) + ", Green: " + (int)green(c) + ", Blue: " + (int)blue(c));
}
void printColorhex(int c) { // prints a color int hexadecimal
	String red = Integer.toHexString((int)red(c));
	String green = Integer.toHexString((int)green(c));
	String blue = Integer.toHexString((int)blue(c));
	if(red.length() < 2) {
		red = '0' + red;
	}
	if(green.length() < 2) {
		green = '0' + green;
	}
	if(blue.length() < 2) {
		blue = '0' + blue;
	}
	println(red + green + blue);
}