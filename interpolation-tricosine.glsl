varying vec2 vUv;
varying vec3 vPosition;
uniform vec3 baseColor;
uniform int index;
uniform float resolution;
uniform float rangeFactor;
uniform float smoothness;

int mod(int x, int m) {
	return int(mod(float(x), float(m)));
}

float random5(vec3 co) {
	return fract(sin(dot(co.xyz ,vec3(12.9898,78.233,1.23456))) * 5356.5453);
}


float random4(float x, float y, float z) {
	return random5(vec3(x, y, z));
}

float random4(int x, int y, int z) {
	return random4(float(x), float(y), float(z));
}

float interpolation(float a, float b, float x) {
	float ft = x * 3.1415927; // f * pi
	float f = (1.0 - cos(ft)) * 0.5; // k(f) = 1 - cos(f * pi) / 2
	return a*(1.0-f) + b*f; // C(y1, y2, f) = y1 * (1 - k(f)) + y2 * k(f)
}

float tricosine(vec3 coordFloat) {
	vec3 coord0 = vec3(floor(coordFloat.x), floor(coordFloat.y), floor(coordFloat.z));
	vec3 coord1 = vec3(coord0.x+1.0, coord0.y+1.0, coord0.z+1.0);
	float xd = (coordFloat.x - coord0.x)/max(1.0, (coord1.x-coord0.x));
	float yd = (coordFloat.y - coord0.y)/max(1.0, (coord1.y-coord0.y));
	float zd = (coordFloat.z - coord0.z)/max(1.0, (coord1.z-coord0.z));
	float c00 = interpolation(random4(coord0.x, coord0.y, coord0.z), random4(coord1.x, coord0.y, coord0.z), xd);
	float c10 = interpolation(random4(coord0.x, coord1.y, coord0.z), random4(coord1.x, coord1.y, coord0.z), xd);
	float c01 = interpolation(random4(coord0.x, coord0.y, coord1.z), random4(coord1.x, coord0.y, coord1.z), xd);
	float c11 = interpolation(random4(coord0.x, coord1.y, coord1.z), random4(coord1.x, coord1.y, coord1.z), xd);
	float c0 = interpolation(c00, c10, yd);
	float c1 = interpolation(c01, c11, yd);
	float c = interpolation(c0, c1, zd);

	return c;
}

float nearestNeighbour(vec3 coordFloat) {
	return random4(int(floor(coordFloat.x)), int(floor(coordFloat.y)), int(floor(coordFloat.z)));
}

float helper(float x, float y, float z, float resolution) {
	x = (x+1.0)/2.0*resolution;
	y = (y+1.0)/2.0*resolution;
	z = (z+1.0)/2.0*resolution;

	vec3 coordFloat = vec3(x, y, z);
  float interpolated = tricosine(coordFloat);
	//float interpolated = nearestNeighbour(coordFloat);
	return interpolated;
}

vec3 scalarField(float x, float y, float z, float maxRes, float smoothness) {
  float c = 0.0;
  float amp = 0.56;
  for(int l = 6; l > 0; l--) {
    float res = maxRes/pow(2.0,float(l));
    float level = helper(x, y, z, res);
    c += level*amp;
    amp/=smoothness;
  }
	//if (c < 0.5) c *= 0.9;

	c = clamp(c, 0.0, 1.0);

	return vec3(c, c, c);
}

vec3 getSphericalCoord(int index, float x, float y, float width) {
	width /= 2.0;
	x -= width;
	y -= width;
	vec3 coord = vec3(0.0, 0.0, 0.0);

	if (index == 0) {coord.x=width; coord.y=-y; coord.z=-x;}
	else if (index == 1) {coord.x=-width; coord.y=-y; coord.z=x;}
	else if (index == 2) {coord.x=x; coord.y=width; coord.z=y;}
	else if (index == 3) {coord.x=x; coord.y=-width; coord.z=-y;}
	else if (index == 4) {coord.x=x; coord.y=-y; coord.z=width;}
	else if (index == 5) {coord.x=-x; coord.y=-y; coord.z=-width;}

	return normalize(coord);
}

void main() {
	float x = vUv.x;
    float y = 1.0 - vUv.y;
    //x = 0.5+vPosition.x;
	//y = 1.0 - (0.5+vPosition.y);
	vec3 sphericalCoord = getSphericalCoord(index, x*resolution, y*resolution, resolution);

	vec3 grad = scalarField(sphericalCoord.x, sphericalCoord.y, sphericalCoord.z, 512.0, smoothness);
        vec3 color = baseColor + (grad-0.5)/rangeFactor;

	gl_FragColor = vec4(color.xyz, 1.0);
}