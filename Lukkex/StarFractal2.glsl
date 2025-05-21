vec3 palette(float t){
    vec3 a = vec3(0.5, 0.1, 0.5);
    vec3 b = vec3(0.5, 0.2, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.0, 0.8, 0.67);
    
    return a + b * cos(6.28318*(c*t+d));
}

vec3 palette(float t, vec3 a){
    vec3 b = vec3(0.5, 0.2, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.0, 0.8, 0.67);
    
    return a + b * cos(6.28318*(c*t+d));
}

mat2 rotate2D(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

float sdPentagram(in vec2 p, in float r )
{
    const float k1x = 0.809016994; // cos(π/ 5) = ¼(√5+1)
    const float k2x = 0.309016994; // sin(π/10) = ¼(√5-1)
    const float k1y = 0.587785252; // sin(π/ 5) = ¼√(10-2√5)
    const float k2y = 0.951056516; // cos(π/10) = ¼√(10+2√5)
    const float k1z = 0.726542528; // tan(π/ 5) = √(5-2√5)
    const vec2  v1  = vec2( k1x,-k1y);
    const vec2  v2  = vec2(-k1x,-k1y);
    const vec2  v3  = vec2( k2x,-k2y);
    
    p.x = abs(p.x);
    p -= 2.0*max(dot(v1,p),0.0)*v1;
    p -= 2.0*max(dot(v2,p),0.0)*v2;
    p.x = abs(p.x);
    p.y -= r;
    return length(p-v3*clamp(dot(p,v3),0.0,k1z*r))
           * sign(p.y*v3.x-p.x*v3.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord * 2.0 - iResolution.xy)/iResolution.y;
    vec2 uv0 = rotate2D(-iTime) * uv;
    vec3 finalColor = vec3(0.0);

    for (float i = 0.0; i < 3.0; i++){
        uv = fract(uv*(sin(iTime + 2.0)+0.9 * .8)) - 0.5;
        
        float d = length(uv);
        
        vec3 col = palette(length(uv) + iTime * 1.5 * i);
        
        d = sin(d*8. + iTime)/8.;
        d = abs(d);
        
        d = 0.14/d;
        
        finalColor += col / sdPentagram(uv0 * i, d);
        
        for (float j = 0.0; j <3.0; j++){
            d = cos(d * 100. + iTime)/1.;
            finalColor /= fract(sdPentagram(uv0 * j, d));
        }
    }

    finalColor = palette(sin(iTime), finalColor);
    fragColor = vec4(finalColor,1.0);
}