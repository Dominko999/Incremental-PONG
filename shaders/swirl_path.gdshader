shader_type particles;

uniform int point_count = 2;
uniform vec2 points[50];
uniform int active_start_index = 0; // Od którego punktu rodzą się nowe cząsteczki

// USTAWIENIA RUCHU I WYGLĄDU
uniform float constant_speed = 300.0; // Prędkość w pikselach na sekundę (zamiast path_speed!)
uniform float swirl_radius = 15.0;
uniform float swirl_speed = 5.0;
uniform float scatter_radius = 25.0; 
uniform float min_scale = 0.5;
uniform float max_scale = 1.5;

void start() {
    // 1. Obliczamy całkowity dystans od początku (points[0]) do aktywnego segmentu
    float start_dist = 0.0;
    for (int i = 0; i < 50; i++) {
        if (i >= point_count - 1) break;
        float l = length(points[i+1] - points[i]);
        if (i < active_start_index) {
            start_dist += l;
        }
    }

    // 2. Obliczamy długość tylko aktywnej (żywej) ścieżki
    float active_length = 0.0;
    for (int i = 0; i < 50; i++) {
        if (i >= point_count - 1) break;
        float l = length(points[i+1] - points[i]);
        if (i >= active_start_index) {
            active_length += l;
        }
    }

    uint seed = NUMBER + RANDOM_SEED;
    float rand_val = fract(sin(float(seed)) * 43758.5453);
    
    // Cząsteczka rodzi się w losowym miejscu, ale TYLKO na żywym odcinku drogi
    CUSTOM.z = start_dist + (active_length * rand_val);
    
    CUSTOM.x = rand_val * 6.28318; // Faza wiru
    CUSTOM.y = 0.0; // Wiek cząsteczki w sekundach
    
    TRANSFORM = mat4(1.0);
}

void process() {
    CUSTOM.y += DELTA; // Czas leci liniowo
    
    // Aktualna pozycja cząsteczki w pikselach od punktu zero
    float current_dist = CUSTOM.z + CUSTOM.y * constant_speed;
    
    // Szukamy segmentu, na którym ta odległość się znajduje
    float accum_dist = 0.0;
    vec2 base_pos = points[0];
    int segment = 0;
    float segment_t = 0.0;
    bool found = false;
    
    for (int i = 0; i < 50; i++) {
        if (i >= point_count - 1) break;
        float seg_len = length(points[i+1] - points[i]);
        
        if (!found && current_dist <= accum_dist + seg_len) {
            segment = i;
            segment_t = (current_dist - accum_dist) / max(0.001, seg_len);
            base_pos = mix(points[i], points[i+1], segment_t);
            found = true;
        }
        accum_dist += seg_len;
    }
    
    // Jeśli wyleciała poza trasę
    if (!found) {
        base_pos = points[point_count - 1];
    }
    
    // --- ROZPROSZENIE (SCATTER) ---
    float rand_x = fract(sin(float(NUMBER) * 12.9898) * 43758.5453) * 2.0 - 1.0;
    float rand_y = fract(sin(float(NUMBER) * 78.2330) * 43758.5453) * 2.0 - 1.0;
    vec2 random_offset = vec2(rand_x, rand_y) * scatter_radius;
    
    // --- WIR (SWIRL) ---
    vec2 p1 = points[segment];
    vec2 p2 = points[min(segment + 1, point_count - 1)];
    vec2 dir = normalize(p2 - p1);
    if (length(dir) < 0.001) { dir = vec2(1.0, 0.0); }
    vec2 normal = vec2(-dir.y, dir.x); 
    
    float phase = CUSTOM.x + CUSTOM.y * swirl_speed;
    vec2 swirl = normal * sin(phase) * swirl_radius;
    swirl += dir * cos(phase) * (swirl_radius * 0.5); 
    
    TRANSFORM[3].xy = base_pos + swirl + random_offset;
    
    // --- SKALOWANIE I WYGASANIE ---
    float rand_scale_val = fract(sin(float(NUMBER) * 33.3333) * 43758.5453);
    float random_scale_factor = mix(min_scale, max_scale, rand_scale_val);
    
    float scale = 1.0;
    if (!found) {
        scale = 0.0; // Ukrywamy cząsteczkę natychmiast, gdy minie ostatnią znajdźkę
    } else {
        // Łagodne wygasanie przed samym końcem całej fali
        float progress = current_dist / max(0.001, accum_dist);
        scale = (1.0 - smoothstep(0.90, 1.0, progress));
    }
    
    scale *= random_scale_factor;
    
    TRANSFORM[0][0] = scale;
    TRANSFORM[1][1] = scale;
}