shader_type canvas_item;

uniform vec4 origin:hint_color;
uniform vec4 new:hint_color;

uniform vec4 origin2:hint_color;
uniform vec4 new2:hint_color;

uniform vec4 origin3:hint_color;
uniform vec4 new3:hint_color;

uniform vec4 origin4:hint_color;
uniform vec4 new4:hint_color;

uniform bool active = false;

vec4 trunc_vec(vec4 v, float n){
    v.x=floor(pow(10,n) * v.x) / pow(10,n);
    v.y=floor(pow(10,n) * v.x) / pow(10,n);
    v.z=floor(pow(10,n) * v.x) / pow(10,n);
    return v;
}

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);
	if (current_pixel == origin)
		COLOR = new;
	else if (current_pixel == origin2)
		COLOR = new2;
	else if (trunc_vec(current_pixel, 5) == trunc_vec(origin3, 5))
		COLOR = new3;
	else if (round(current_pixel) == round(origin4))
		COLOR = new4;
	else
		COLOR = current_pixel;
		
	if (active == true){
		vec4 previous_color = texture(TEXTURE, UV);
		vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a);
		vec4 new_color = previous_color;
		new_color = white_color;
		COLOR = new_color;
	}
}