vec3 pos = position;

vec3 spherePos = boxPosToSpherePos(pos, radius);

// float t = sin(iTime) * .5 + .5;
float t = 1.;

float fY = rand(vec2(offset.x*.0033, offset.z*.00175))*.5 - .25;
float fS = rand(vec2(offset.x*.0561, offset.z*.0217)) * PI2 + iTime;

float moveTime = sin(fS + iTime)*.5 + .5 + iTime;
float moveY = fract(moveTime)*2.;

t = clamp((offset.y + moveY) / 7.5, 0., 1.);
// t = 0.;
vec3 transformed = mix(pos, spherePos, t);

vec3 move = vec3(0., moveY + fY, 0.);

transformed += offset + move;

vNormal = normalMatrix * normalize(mix(objectNormal, spherePos, t));
