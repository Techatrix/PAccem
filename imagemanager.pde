class ImageManager {
	PImage[] images;

	ImageManager() {
		images = new PImage[6];
		images[0] = loadImage("assets/img/0.png");
		images[1] = loadImage("assets/img/1.png");
		images[2] = loadImage("assets/img/2.png");
		images[3] = loadImage("assets/img/3.png");
		images[4] = loadImage("assets/img/4.png");
		images[5] = loadImage("assets/img/5.png");
	}
}