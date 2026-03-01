uniform vec3 uPlayerPosition;
uniform float uGrassSize;
uniform sampler2D uPerlinTexture;
uniform float uTime;
uniform vec2 uWindDirection;
uniform float uWindSpeed1;
uniform float uWindSpeed2;
uniform float uWindNoiseScale1;
uniform float uWindNoiseScale2;
uniform float uWindStrength;


attribute vec2 center;

varying vec3 vColor;

vec2 getRotatePivot2d(vec2 uv, float rotation, vec2 pivot)
{
    return vec2(
        cos(rotation) * (uv.x - pivot.x) + sin(rotation) * (uv.y - pivot.y) + pivot.x,
        cos(rotation) * (uv.y - pivot.y) - sin(rotation) * (uv.x - pivot.x) + pivot.y
    );
}


void main()
{

    // center
    vec2 newCenter = center;

    // lower the grass on z


    // infinite grass
    float halfSize = uGrassSize * 0.5;
    newCenter.x = mod(newCenter.x + halfSize, uGrassSize) - halfSize;
    newCenter.y = mod(newCenter.y + halfSize, uGrassSize) - halfSize;

    vec4 modelCenter = modelMatrix * vec4(newCenter.x, 0.0, newCenter.y, 1.0);

    vec4 modelPosition = modelMatrix * vec4(position, 1.0);

    // grass to center
    modelPosition.xz += newCenter;

    // tip of the blade
    float tip = step(2.0, mod(float(gl_VertexID) + 1.0, 3.0));

    // billboarding
    float angleToCamera = atan(modelCenter.x - cameraPosition.x, modelCenter.z - cameraPosition.z);
    modelPosition.xz = getRotatePivot2d(modelPosition.xz, angleToCamera, modelCenter.xz);

    // wind
    vec2 noiseUv1 = (modelPosition.xz * uWindNoiseScale1) + (uWindDirection * (uTime * 0.001 * uWindSpeed1));
    float noise1 = texture(uPerlinTexture, noiseUv1).r - 0.5;
    vec2 noiseUv2 = (modelPosition.xz * uWindNoiseScale2) + (uWindDirection * (uTime * 0.001 * uWindSpeed2));
    float noise2 = texture(uPerlinTexture, noiseUv2).g;
    float wind = noise1 * noise2;
    vec2 windForce = uWindDirection * wind * uWindStrength;

    // Apply wind
    modelPosition.x += windForce.x * tip;
    modelPosition.z += windForce.y * tip;

    // Push it slightly below ground so it doesn't z-fight with the floor
    // modelPosition.y -= interactionStrength * 0.1;

    // Scale the width down towards the center so it shrinks away
    // modelPosition.xz = mix(modelPosition.xz, newCenter, interactionStrength);

    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectionPositon = projectionMatrix * viewPosition;

    gl_Position = projectionPositon;

    // grass color
    vec3 grassColor = vec3(0.1, 0.4, 0.1);
    float gradient = tip * 0.8;
    vColor = vec3(grassColor * gradient);

}