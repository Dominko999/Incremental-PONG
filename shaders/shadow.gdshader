shader_type canvas_item;
render_mode unshaded;

// W CanvasGroup musimy czytać z backbufora ekranu, żeby zachować logikę tego węzła
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec2 shadow_offset = vec2(4.0, 4.0);
uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.5);

void fragment() {
    // 1. Pobieramy zbuforowany obraz grupy z ekranu
    vec4 col = textureLod(screen_texture, SCREEN_UV, 0.0);
    
    // Wbudowany mechanizm CanvasGroup używa pre-multiplied alpha, więc to cofamy
    if (col.a > 0.0001) {
        col.rgb /= col.a;
    }

    // 2. Przesuwamy koordynaty, żeby stworzyć maskę dla naszego cienia
    vec2 ps = SCREEN_PIXEL_SIZE;
    vec4 shadow_mask = textureLod(screen_texture, SCREEN_UV - shadow_offset * ps, 0.0);
    
    // 3. Obliczamy kolor cienia z odpowiednią przezroczystością maski
    vec4 shadow = shadow_color;
    shadow.a *= shadow_mask.a;

    // 4. Mieszamy: najpierw rysujemy cień, a na to nakładamy właściwe obiekty
    vec4 final_color = mix(shadow, col, col.a);

    // Przekazujemy ostateczny wynik
    COLOR *= final_color;
}