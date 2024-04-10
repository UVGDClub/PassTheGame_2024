extends Sprite2D

var inactive = preload("res://assets/art/map/exit_inactive.png")
var activated = preload("res://assets/art/map/exit_active.png")

var win_scene = "res://src/ui/win.tscn"
func _process(delta):
	if (DeckManager.cards_collected >= 20):
		texture = activated
	else:
		texture = inactive




func _on_area_2d_body_entered(body):
	if (body.is_in_group("Player")):
		if (DeckManager.cards_collected >= 20):
			get_tree().change_scene_to_file(win_scene)
