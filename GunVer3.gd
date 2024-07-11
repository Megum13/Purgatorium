extends Sprite2D


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#if (get_rect().has_point((event.position))):
			print(get_rect().has_point(to_local(event.position)))
			print(event.position)
