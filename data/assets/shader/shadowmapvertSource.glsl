// Taken from: https://forum.processing.org/two/discussion/12775/simple-shadow-mapping
// Written by: Poersch

uniform mat4 transform;

attribute vec4 vertex;

void main() {
    gl_Position = transform * vertex;
}