extends Node2D

var isEnter = false;
signal takeGun;
var redLine = false;

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if (isEnter):
				takeGun.emit();
				pass;


func _on_area_2d_mouse_entered():
	if(redLine):
		$GunVer3.material.set_shader_parameter("on",true);
		$GunVer3.material.set_shader_parameter("line_thickness",2.5);
		isEnter = true;
	pass # Replace with function body.


func _on_area_2d_mouse_exited():
	if(redLine):
		$GunVer3.material.set_shader_parameter("on",false)
		isEnter = false;
	pass # Replace with function body.


func _on_area_2d_input_event(viewport, event, shape_idx):
	if(redLine):
		$GunVer3.material.set_shader_parameter("on",true);
		$GunVer3.material.set_shader_parameter("line_thickness",2.5);
		isEnter = true;
	pass # Replace with function body.
