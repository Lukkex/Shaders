// Proof of concept for creating a texture that can "remember" where a light-like object has been exposed and using that data to "reveal" a texture/map

// Make sure both Image and Buffer A have Buffer A in iChannel0

// Image
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;

    vec4 col = vec4(0., .6, .8, 1.); // Will be a texture/map to pull from and "reveal"

    fragColor = texture(iChannel0, uv) * col;
}

// Buffer A
float sdfCircle(vec2 uv, float r, vec2 offset) {
    return length(uv - offset) - r;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    vec2 uv0 = uv;
    
    uv -= .5;
    uv.x *= iResolution.x/iResolution.y;
    
    vec2 offset = vec2(0. + iTime / 5., 0.);
    float circle = sdfCircle(uv, .3, offset);
    
    vec3 old_color    = mix(vec3(0.), texture(iChannel0, uv0).rgb, 1.);
    vec3 circle_color = mix(vec3(1.), vec3(0.), smoothstep(0., .3, circle));
    vec3 color = max(old_color, circle_color);
    
    fragColor = vec4(color, 1.);
}
