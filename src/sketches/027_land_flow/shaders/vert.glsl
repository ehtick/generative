attribute vec3 position;
attribute vec3 normal;
attribute vec2 uv;

uniform mat4 worldViewProjection;
uniform mat4 view;
uniform mat4 world;
uniform float iTime;

varying vec2 vUv;
varying vec3 vpos;
varying float fFogDistance;


#define MOD3 vec3(.1031,.11369,.13787)

vec3 hash33(vec3 p3)
{
  p3 = fract(p3 * MOD3);
  p3 += dot(p3, p3.yxz+19.19);
  return -1.0 + 2.0 * fract(vec3((p3.x + p3.y)*p3.z, (p3.x+p3.z)*p3.y, (p3.y+p3.z)*p3.x));
}

float noise(vec3 p)
{
  const float K1 = 0.333333333;
  const float K2 = 0.166666667;

  vec3 i = floor(p + (p.x + p.y + p.z) * K1);
  vec3 d0 = p - (i - (i.x + i.y + i.z) * K2);

  vec3 e = step(vec3(0.0), d0 - d0.yzx);
  vec3 i1 = e * (1.0 - e.zxy);
  vec3 i2 = 1.0 - e.zxy * (1.0 - e);

  vec3 d1 = d0 - (i1 - 1.0 * K2);
  vec3 d2 = d0 - (i2 - 2.0 * K2);
  vec3 d3 = d0 - (1.0 - 3.0 * K2);

  vec4 h = max(0.6 - vec4(dot(d0, d0), dot(d1, d1), dot(d2, d2), dot(d3, d3)), 0.0);
  vec4 n = h * h * h * h * vec4(dot(d0, hash33(i)), dot(d1, hash33(i + i1)), dot(d2, hash33(i + i2)), dot(d3, hash33(i + 1.0)));

  return dot(vec4(31.316), n);
}

void main() {
  vec4 worldPosition = world * vec4(position, 1.0);
  fFogDistance = (view * worldPosition).z;
  vUv = uv;
  float t = iTime*50.25;

  vpos = position;

  vec3 nvpos = vpos + vec3(0, 0, t*.1);

  vpos.y += noise(vec3(nvpos.x*.1, nvpos.z*.1, 0.))*1.5;
  vpos.y += noise(vec3(nvpos.x, nvpos.z, 0.))*.25;
  vpos.y += noise(vec3(nvpos.x*2., nvpos.z*2., 0.))*.1;
  vpos.y += noise(vec3(nvpos.x*5., nvpos.z*5., 0.))*.1;
  // vpos.y += noise(vec3(nvpos.xz*.5, t*5.5))*.25;


  gl_Position = worldViewProjection * vec4( vpos, 1.0 );
}
