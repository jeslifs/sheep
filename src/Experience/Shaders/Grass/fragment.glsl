varying vec3 vColor;

void main()
{
    // gl_FragColor = vec4(vColor, 1.0);
    csm_DiffuseColor = vec4(vColor, 1.0);
}