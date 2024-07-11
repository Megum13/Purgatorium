extends Node2D

# Options
var text = "Специально для ВШЭ\n\nГеймдизайнер, художник - Лиза Маслова\nПрограммист - 'MeGum'\n\n ВНИМАНИЕ\nЭто демонстрация одного из возможных вариантов\nиспользования идей, концепта и готовых ресурсов автора.\nНе является конечным продуктом.";
var intervalSymMills = 0.04 # задержка между символами
var intervalStart = 0.8 # Через сколько секунд позволить нажать на кнопку

# Other
var i = -1.5
var j = 0
var isStart = false
var isReady= false

func _ready():
	pass 


func _process(delta):
	i += delta
	if i > intervalSymMills and j < text.length():
		i = 0
		$Label.text += text[j]
		j += 1
	if i > intervalStart and !isReady:
		isReady = true
		$Label2.visible = true
	if isStart:
		$Label.modulate.a -= delta * 0.7
		$Label2.modulate.a = $Label.modulate.a 
		if $Label.modulate.a <= 0:
			get_tree().change_scene_to_file("Logo.tscn")
	pass
	
func _input(event):
	if isReady and !isStart and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			isStart = true
			$AudioStreamPlayer2D.play()
	pass
	
