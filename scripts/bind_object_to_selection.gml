///bind_object_to_selection(object, game_controller)

var object = argument0;
var game_controller = argument1;

var selection_object = game_controller.selection_object;
selection_object.extra_sprite = object_get_sprite(object);
selection_object.bound_object = object;
