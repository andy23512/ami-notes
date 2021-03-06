void trilinearInterpolation( // comment show the reference variable or formula from wikipedia
  in vec3 normalizedPosition, // vec3(xd, yd, zd)
  out vec4 interpolatedValue, // c
  in vec4 v000, in vec4 v100, // c000, c100
  in vec4 v001, in vec4 v101, // c001, c101
  in vec4 v010, in vec4 v110, // c010, c110
  in vec4 v011, in vec4 v111  // c011, c111
) {
  // https://en.wikipedia.org/wiki/Trilinear_interpolation
  vec4 c00 = v000 * ( 1.0 - normalizedPosition.x ) + v100 * normalizedPosition.x; // c00=c000*(1-xd)+c100*(xd)
  vec4 c01 = v001 * ( 1.0 - normalizedPosition.x ) + v101 * normalizedPosition.x; // c01=c001*(1-xd)+c101*(xd)
  vec4 c10 = v010 * ( 1.0 - normalizedPosition.x ) + v110 * normalizedPosition.x; // c10=c010*(1-xd)+c110*(xd)
  vec4 c11 = v011 * ( 1.0 - normalizedPosition.x ) + v111 * normalizedPosition.x; // c11=c011*(1-xd)+c111*(xd)

  // c0 and c1
  vec4 c0 = c00 * ( 1.0 - normalizedPosition.y) + c10 * normalizedPosition.y; // c0=c00*(1-yd)+c10*(yd)
  vec4 c1 = c01 * ( 1.0 - normalizedPosition.y) + c11 * normalizedPosition.y; // c1=c01*(1-yd)+c11*(yd)

  // c
  vec4 c = c0 * ( 1.0 - normalizedPosition.z) + c1 * normalizedPosition.z; // c = c0*(1-zd)+c1*zd
  interpolatedValue = c;
}

void interpolationTrilinear(in vec3 currentVoxel, out vec4 dataValue, out vec3 gradient){

  vec3 lower_bound = floor(currentVoxel);
  lower_bound = max(vec3(0.), lower_bound); // prevent negative value, get position for c000 point

  vec3 higher_bound = lower_bound + vec3(1.); // get position for c111 point

  vec3 normalizedPosition = (currentVoxel - lower_bound); // get (xd, yd, zd)
  normalizedPosition =  max(vec3(0.), normalizedPosition); // prevent negative value

  vec4 interpolatedValue = vec4(0.); // declare for result

  //
  // fetch values required for interpolation
  //
  vec4 v000 = vec4(0.0, 0.0, 0.0, 0.0);
  vec3 c000 = vec3(lower_bound.x, lower_bound.y, lower_bound.z);
  interpolationIdentity(c000, v000);

  //
  vec4 v100 = vec4(0.0, 0.0, 0.0, 0.0);
  vec3 c100 = vec3(higher_bound.x, lower_bound.y, lower_bound.z);
  interpolationIdentity(c100, v100);

  //
  vec4 v001 = vec4(0.0, 0.0, 0.0, 0.0);
  vec3 c001 = vec3(lower_bound.x, lower_bound.y, higher_bound.z);
  interpolationIdentity(c001, v001);

  //
  vec4 v101 = vec4(0.0, 0.0, 0.0, 0.0);
  vec3 c101 = vec3(higher_bound.x, lower_bound.y, higher_bound.z);
  interpolationIdentity(c101, v101);

  //
  vec4 v010 = vec4(0.0, 0.0, 0.0, 0.0);
  vec3 c010 = vec3(lower_bound.x, higher_bound.y, lower_bound.z);
  interpolationIdentity(c010, v010);

  vec4 v110 = vec4(0.0, 0.0, 0.0, 0.0);
  vec3 c110 = vec3(higher_bound.x, higher_bound.y, lower_bound.z);
  interpolationIdentity(c110, v110);

  //
  vec4 v011 = vec4(0.0, 0.0, 0.0, 0.0);
  vec3 c011 = vec3(lower_bound.x, higher_bound.y, higher_bound.z);
  interpolationIdentity(c011, v011);

  vec4 v111 = vec4(0.0, 0.0, 0.0, 0.0);
  vec3 c111 = vec3(higher_bound.x, higher_bound.y, higher_bound.z);
  interpolationIdentity(c111, v111);

  // compute interpolation at position
  trilinearInterpolation(normalizedPosition, interpolatedValue ,v000, v100, v001, v101, v010,v110, v011,v111);
  dataValue = interpolatedValue;

  // That breaks shading in volume rendering
  // if (gradient.x == 1.) { // skip gradient calculation for slice helper
  //  return;
  // }

  // compute gradient
  float gradientStep = 0.005;

  // x axis
  vec3 g100 = vec3(1., 0., 0.);
  vec3 ng100 = normalizedPosition + g100 * gradientStep;
  ng100.x = min(1., ng100.x);

  vec4 vg100 = vec4(0.);
  trilinearInterpolation(ng100, vg100 ,v000, v100, v001, v101, v010,v110, v011,v111);

  vec3 go100 = -g100;
  vec3 ngo100 = normalizedPosition + go100 * gradientStep;
  ngo100.x = max(0., ngo100.x);

  vec4 vgo100 = vec4(0.);
  trilinearInterpolation(ngo100, vgo100 ,v000, v100, v001, v101, v010,v110, v011,v111);

  gradient.x = (g100.x * vg100.x + go100.x * vgo100.x);

  // y axis
  vec3 g010 = vec3(0., 1., 0.);
  vec3 ng010 = normalizedPosition + g010 * gradientStep;
  ng010.y = min(1., ng010.y);

  vec4 vg010 = vec4(0.);
  trilinearInterpolation(ng010, vg010 ,v000, v100, v001, v101, v010,v110, v011,v111);

  vec3 go010 = -g010;
  vec3 ngo010 = normalizedPosition + go010 * gradientStep;
  ngo010.y = max(0., ngo010.y);

  vec4 vgo010 = vec4(0.);
  trilinearInterpolation(ngo010, vgo010 ,v000, v100, v001, v101, v010,v110, v011,v111);

  gradient.y = (g010.y * vg010.x + go010.y * vgo010.x);

  // z axis
  vec3 g001 = vec3(0., 0., 1.);
  vec3 ng001 = normalizedPosition + g001 * gradientStep;
  ng001.z = min(1., ng001.z);

  vec4 vg001 = vec4(0.);
  trilinearInterpolation(ng001, vg001 ,v000, v100, v001, v101, v010,v110, v011,v111);

  vec3 go001 = -g001;
  vec3 ngo001 = normalizedPosition + go001 * gradientStep;
  ngo001.z = max(0., ngo001.z);

  vec4 vgo001 = vec4(0.);
  trilinearInterpolation(ngo001, vgo001 ,v000, v100, v001, v101, v010,v110, v011,v111);

  gradient.z = (g001.z * vg001.x + go001.z * vgo001.x);

  // normalize gradient
  // +0.0001  instead of if?
  float gradientMagnitude = length(gradient);
  if (gradientMagnitude > 0.0) {
    gradient = -(1. / gradientMagnitude) * gradient;
  }
}