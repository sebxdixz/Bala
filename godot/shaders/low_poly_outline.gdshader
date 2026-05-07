// BALA - Borderlands-style cel shader
// Godot 4.6 | Toon shading + thick black outline
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_toon, specular_disabled;

uniform vec4 color_outline : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float grosor_outline : hint_range(0.0, 1.0, 0.01) = 0.12;
uniform vec4 color_ambient : source_color = vec4(0.2, 0.2, 0.25, 1.0);
uniform float intensidad_ambient : hint_range(0.0, 1.0, 0.05) = 0.35;
uniform int toon_steps : hint_range(1, 4, 1) = 2;
uniform vec4 color_sombra : source_color = vec4(0.05, 0.05, 0.1, 1.0);
uniform vec4 color_base : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D albedo_tex : source_color, hint_default_white;
uniform bool usar_textura = false;

void fragment() {
	vec4 tex_color = usar_textura ? texture(albedo_tex, UV) : vec4(1.0);
	vec3 base = tex_color.rgb * color_base.rgb;

	// Outline por borde de silueta (view-space rim)
	vec3 n = normalize(NORMAL);
	vec3 v = normalize(VIEW);
	float rim = 1.0 - abs(dot(n, v));
	float steps = float(max(toon_steps, 1));
	float rim_banded = floor(rim * steps) / steps;
	float outline_mask = smoothstep(1.0 - grosor_outline, 1.0, rim_banded);

	// Sombra suave estilizada independiente de luz directa
	float shadow_factor = smoothstep(0.0, 1.0, n.y * 0.5 + 0.5);
	vec3 shaded = mix(color_sombra.rgb * base, base, shadow_factor);
	vec3 ambient = color_ambient.rgb * intensidad_ambient * base;
	vec3 final_color = mix(shaded + ambient, color_outline.rgb, outline_mask);

	ALBEDO = final_color;
	ALPHA = tex_color.a * color_base.a;
}
