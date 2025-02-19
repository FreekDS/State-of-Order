shader_type canvas_item;

uniform sampler2D noiseTexture;
uniform float step_range : hint_range(0,1) = 0.5f;

float noise(vec2 p)
{
	float s = texture(noiseTexture,vec2(1.,2.*cos(TIME))*TIME*20. + p*1.).x;
	s *= s;
	return s;
}

float onOff(float a, float b, float c)
{
	return step(c, sin(TIME + a*cos(TIME*b))) * 0.0;
}

float ramp(float y, float start, float end)
{
	float inside = step(start,y) - step(end,y);
	float fact = (y-start)/(end-start)*inside;
	return (1.-fact) * inside;

}

float stripes(vec2 uv)
{

	float noi = noise(uv*vec2(0.5,1.) + vec2(1.,3.));
	return ramp(mod(uv.y*4. + TIME/2.+sin(TIME + sin(TIME*0.63)),1.),.4,.5)*noi;
}

vec3 getVideo(vec2 uv)
{
	vec2 look = uv * 0.0;
	float window = 1./(1.+20.*(look.y-mod(TIME/4.,1.))*(look.y-mod(TIME/4.,1.)));
	look.x = look.x + sin(look.y*10. + TIME)/50.*onOff(4.,4.,.3)*(1.+cos(TIME*80.))*window;
	float vShift = 0.4*onOff(2.,3.,.9)*(sin(TIME)*sin(TIME*20.) +
										 (0.5 + 0.1*sin(TIME*200.)*cos(TIME))) * 0.0;
	look.y = mod(look.y + vShift, 1.);
	vec3 video = vec3(texture(noiseTexture,look).rgb);
	return video;
}

vec2 screenDistort(vec2 uv)
{
	uv -= vec2(.5,.5);
	uv = uv*1.*(1./1.2+2.*uv.x*uv.x*uv.y*uv.y);
	uv += vec2(.5,.5);
	return uv;
}

void fragment()
{
	vec2 uv = FRAGCOORD.xy / (1.0 / SCREEN_PIXEL_SIZE).xy;
	//uv = screenDistort(uv);
	vec3 video = getVideo(uv);
	float vigAmt = 3.+.3*sin(TIME + 5.*cos(TIME*5.));
	float vignette = (1.-vigAmt*(uv.y-.5)*(uv.y-.5))*(1.-vigAmt*(uv.x-.5)*(uv.x-.5));

	video += stripes(uv);
	video += noise(uv)/4.;
	//video *= vignette;
	video *= (5.+mod(uv.y*30.+TIME,1.))/15.;

	COLOR = vec4(video,1.0);

	if(abs(UV.y - .5) > step_range || abs(UV.x - .5) > step_range) {
		COLOR.a = 0.0f;
	}

}