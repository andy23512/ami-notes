void interpolationIdentity(in vec3 currentVoxel, out vec4 dataValue){
  // lower bound
  vec3 rcurrentVoxel = vec3(floor(currentVoxel.x + 0.5 ), floor(currentVoxel.y + 0.5 ), floor(currentVoxel.z + 0.5 ));
  ivec3 voxel = ivec3(int(rcurrentVoxel.x), int(rcurrentVoxel.y), int(rcurrentVoxel.z));

  vec4 tmp = vec4(0., 0., 0., 0.);
  int offset = 0;

  ${Texture3d.api(this._base, 'voxel', 'tmp', 'offset')}
  ${Unpack.api(this._base, 'tmp', 'offset', 'dataValue')}
}