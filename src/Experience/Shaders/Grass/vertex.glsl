attribute float randomHeight;

uniform float uBladeWidth;
uniform float uBladeHeight;
uniform float uBladeHeightRandomness;
uniform float uSize;
uniform sampler2D uPerlinTexture;
uniform float uTime;
uniform vec2 uWindDirection;
uniform float uWindSpeed1;
uniform float uWindSpeed2;
uniform float uWindNoiseScale1;
uniform float uWindNoiseScale2;
uniform float uWindStrength;
uniform vec3 uBaseColor;
uniform vec3 uTipColor;


varying vec3 vColor;

vec2 getRotatePivot2d(vec2 uv, float rotation, vec2 pivot)
{
    return vec2(
        cos(rotation) * (uv.x - pivot.x) + sin(rotation) * (uv.y - pivot.y) + pivot.x,
        cos(rotation) * (uv.y - pivot.y) - sin(rotation) * (uv.x - pivot.x) + pivot.y
    );
}
// #include ../includes/getRotatePivot2d.glsl

void main()
{
    // get vertexID 0,1,2
    float vertexID = mod(float(gl_VertexID), 3.0);

    // step(edge, x) 0 if x < edge else 1
    float tip = step(vertexID, 0.5);

    // shape
    vec2 shape;
    // tip
    if(vertexID == 0.0)
        shape = vec2(0.0, 1.0);
    // left
    else if(vertexID == 1.0)
        shape = vec2(1.0, 0.0);
    // right
    else
        shape = vec2(-1.0, 0.0);

    // billboarding
    vec3 bladeCenterLocal = position;
    vec4 bladeCenterWorld = modelMatrix * vec4(bladeCenterLocal, 1.0);

    // compute angle in world space
    float angleToCamera = atan(bladeCenterWorld.x - cameraPosition.x, bladeCenterWorld.z - cameraPosition.z
    );

    // height
    float heightVariation = texture(uPerlinTexture, bladeCenterWorld.xz * 0.0321).r + 0.5;
    float heightRandomFactor = uBladeHeightRandomness * randomHeight + (1.0 - uBladeHeightRandomness);
    float height = uBladeHeight * heightRandomFactor * heightVariation;

    vec3 offset = vec3(shape.x * uBladeWidth, 0.0, -shape.y * height);

    // rotate offset around blade center
    offset.xy = getRotatePivot2d(offset.xy, angleToCamera, vec2(0.0));

    vec3 localPosition = position + offset;
    csm_Position = position + offset;
    vec4 modelPosition = modelMatrix * vec4(localPosition, 1.0);

    // wind
    vec2 worldXZ = modelPosition.xz;

    // noise layer 1
    vec2 noiseUv1 =
        (worldXZ * uWindNoiseScale1) +
        (uWindDirection * (uTime * 0.001 * uWindSpeed1));

    float noise1 = texture(uPerlinTexture, noiseUv1).r - 0.5;

    // noise layer 2
    vec2 noiseUv2 =
        (worldXZ * uWindNoiseScale2) +
        (uWindDirection * (uTime * 0.0001 * uWindSpeed2));

    float noise2 = texture(uPerlinTexture, noiseUv2).g;

    float wind = noise1 * noise2;

    // direction
    vec2 windDirection =
        uWindDirection *
        wind *
        uWindStrength;

    // apply only to tip
    csm_Position.x += windDirection.x * tip;
    csm_Position.z += windDirection.y * tip;

    
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectionPosition = projectionMatrix * viewPosition;

    gl_Position = projectionPosition;

    vec3 finalColor = mix(uBaseColor, uTipColor * tip, height);
    vColor = finalColor;




}