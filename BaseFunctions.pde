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

/* --------------- Shadow mapping --------------- */
// Taken from: https://forum.processing.org/two/discussion/12775/simple-shadow-mapping
// Written by: Poersch
// Code has been slightly changed to better fit this application

void initShadowPass() { // initializes the shadowpass shader and framebuffer
	final int size = 30;
	shadowMap = createGraphics(2048, 2048, P3D);
	shadowMap.noSmooth();
	shadowMap.beginDraw();
	shadowMap.noStroke();
	try {
		shadowMap.shader(new PShader(this, "data/assets/shader/shadowmapvertSource.glsl", "data/assets/shader/shadowmapfragSource.glsl"));
	} catch(RuntimeException e) {
		useshadowmap = false;
		toovmessages.add("Shader RuntimeException: " + e);
		toovmessages.add("Disabled shadow mapping");
	}
	shadowMap.ortho(-size, size, -size, size, 5, 2000);
	shadowMap.endDraw();
}

void initDefaultPass() {// initializes the default shader
	try {
		pg.shader(defaultShader = new PShader(this, "data/assets/shader/vertSource.glsl", "data/assets/shader/fragSource.glsl"));
	} catch(RuntimeException e) {
		useshadowmap = false;
		toovmessages.add("Shader RuntimeException: " + e);
		toovmessages.add("Disabled shadow mapping");
	}
	pg.noStroke();
	pg.perspective(60 * DEG_TO_RAD, (float)width / height, 5, 2000);
}

void updateDefaultShader() { // sends a matrices and a framebuffer to the default shader
	PMatrix3D shadowTransform = new PMatrix3D(
		0.5, 0.0, 0.0, 0.5, 
		0.0, 0.5, 0.0, 0.5, 
		0.0, 0.0, 0.5, 0.5, 
		0.0, 0.0, 0.0, 1.0
	);
 
	shadowTransform.apply(((PGraphicsOpenGL)shadowMap).projmodelview);
 
	PMatrix3D modelviewInv = ((PGraphicsOpenGL)pg).modelviewInv;
	shadowTransform.apply(modelviewInv);
 
	defaultShader.set("shadowTransform", new PMatrix3D(
		shadowTransform.m00, shadowTransform.m10, shadowTransform.m20, shadowTransform.m30, 
		shadowTransform.m01, shadowTransform.m11, shadowTransform.m21, shadowTransform.m31, 
		shadowTransform.m02, shadowTransform.m12, shadowTransform.m22, shadowTransform.m32, 
		shadowTransform.m03, shadowTransform.m13, shadowTransform.m23, shadowTransform.m33
	));
 
	float lightNormalX = lightdir.x * modelviewInv.m00 + lightdir.y * modelviewInv.m10 + lightdir.z * modelviewInv.m20;
	float lightNormalY = lightdir.x * modelviewInv.m01 + lightdir.y * modelviewInv.m11 + lightdir.z * modelviewInv.m21;
	float lightNormalZ = lightdir.x * modelviewInv.m02 + lightdir.y * modelviewInv.m12 + lightdir.z * modelviewInv.m22;
	float normalLength = sqrt(lightNormalX * lightNormalX + lightNormalY * lightNormalY + lightNormalZ * lightNormalZ);
	defaultShader.set("lightDirection", lightNormalX / -normalLength, lightNormalY / -normalLength, lightNormalZ / -normalLength);
 
	defaultShader.set("shadowMap", shadowMap);
}
