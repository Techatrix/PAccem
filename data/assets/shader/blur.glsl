#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform int blurSize = 9;
uniform float sigma = 3.0;
uniform int samplesize = 1;

const float PI = 3.14159265;

void main()
{
  vec4 sum;
  vec4 sumfactor;
  for(int x=-blurSize/2;x<=blurSize/2;x +=samplesize)
  { 
    for(int y=-blurSize/2;y<=blurSize/2;y +=samplesize)
    {
      vec4 col = texture2D(texture, vertTexCoord.st + vec2(texOffset.s * x, texOffset.t * y));
      float factor = exp(-((x*x+y*y)/(2*sigma*sigma)));
      sumfactor += factor;
      sum += factor * col;
    }
  }

  gl_FragColor = sum / sumfactor * vertColor;
}
