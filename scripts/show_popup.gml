///show_popup(text, life_seconds)

var text = argument0;
var life_seconds = argument1;

var popup = instance_create(window_get_width()/2, 64, obj_popup);
popup.text = text;
popup.life = life_seconds * room_speed;
