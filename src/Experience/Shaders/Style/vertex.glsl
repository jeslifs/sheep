uniform float uBladeWidth;
uniform float uBladeHeight;


void main()
{

    // get vertexID 0,1,2
    float vertexID = mod(float(gl_VertexID), 3.0);

    // step(edge, x) 0 if x < edge else 1
    float tip = step(vertexID, 0.5);

    // shape
    vec2 shape;
    if(vertexID == 0.0)
        shape = vec2(0.0, 1.0);
    else if(vertexID == 1.0)
        shape = vec2(1.0, 0.0);
    else
        shape = vec2(-1.0, 0.0);

    vec3 offset = vec3(
        shape.x * uBladeWidth,
        0.0,
        -shape.y * uBladeHeight
        
    );

    vec3 localPosition = position + offset;

    vec4 modelPosition = modelMatrix * vec4(localPosition, 1.0);
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectionPosition = projectionMatrix * viewPosition;

    gl_Position = projectionPosition;

}