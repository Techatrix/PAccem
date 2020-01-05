#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform vec2 resolution;
uniform float size = 16;

void main()
{
	//sth is wrong with the texturecordinates because it shifts everything a tiny bit and hell know why!
	float xsize = resolution.x / size;
	float ysize = resolution.y / size;

	int sx = int(vertTexCoord.s * xsize);
	int sy = int(vertTexCoord.t * ysize);
	gl_FragColor = texture2D(texture, vec2(float(sx) / xsize, float(sy) / ysize)) * vertColor;
}