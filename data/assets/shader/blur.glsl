#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform int blurSize = 9;
uniform float sigma = 3.0;
uniform int samplesize = 1;

void main()
{
	float off = (blurSize-1)/2; // offset to center everything
	vec4 sum;       // sum of all colors
	vec4 sumfactor; // sum of all factors/weights

	// loop over Pixels/Fragments
	for(int x=0;x<blurSize;x +=samplesize)
	{ 
		for(int y=0;y<blurSize;y +=samplesize)
		{
			// get color
			vec4 col = texture2D(texture, vertTexCoord.st + vec2(texOffset.s * (x-off), texOffset.t * (y-off) ));
			// get factor/weight (2d gaussian function)
			float factor = exp(-((x-off)*(x-off)+(y-off)*(y-off))/(2*sigma*sigma));

			// add factor/weight to sumfactor
			sumfactor += factor;
			// add the color multiplied with its corresponding factor/weight to the sum
			sum += factor * col;
		}
	}
	// output color
	gl_FragColor = sum / sumfactor * vertColor;
}