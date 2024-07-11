extends Node2D
# items id:  1 - money, 2 - Implantat, 3 - Heal, 4 - Patron
var textArray = [
	"[center]Монета[/center]\n\nЕсли повезет, соперник [color=ff0000]пропустит следующий ход[/color], не повезет, [color=ff0000]потеряешь свой ход[/color].",
	"[center]Имплант[/center]\n\nПозволяет подсмотреть, какие патроны [color=ff0000]сейчас заряжены[/color].",
	"[center]Личинка[/center]\n\nЛюбимый предмет для составления контрактов с дьяволом, [color=ff0000]лечит[/color] все болезни.\nИспользовать с особой осторожностью.",
	"[center]Боевые патроны[/center]\n\nГарантированный выстрел! Просто заряди и стреляй.",
];

var ckickIndex = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if (ckickIndex < 2):
				spawnItemPlayer();
				addItemForDemon();
				$BoxBlob.play();
				ckickIndex += 1;
			else:
				$AnimationPlayer.play("End");
				await $AnimationPlayer.animation_finished;
				ckickIndex = 0;
				get_tree().paused = false;
				get_tree().get_root().get_node("Node2D/PlayerItems").visible = true;
				pass;
			pass;
	pass

func spawnItemPlayer():
	$ShowItem.play("RESET");
	await $ShowItem.animation_finished;
	var itemId = randi_range(0,3);
	$CanvasLayer/RichTextLabel.text = textArray[itemId];
	var item = get_parent().get_node("Items").get_children()[itemId].duplicate();
	item.position = Vector2(0,0);
	#get_parent().player.items суем предмет в массив плеера
	if (len($CanvasLayer/Korobka/ItemForAimation.get_children()) >= 1): $CanvasLayer/Korobka/ItemForAimation.get_child(0).queue_free();
	$CanvasLayer/Korobka/ItemForAimation.add_child(item);
	addItemForPlayer(itemId);
	$ShowItem.play("show");
	
	pass;

func addItemForPlayer(itemId):
	get_parent().addItemPlayer(itemId);
	pass;

func addItemForDemon():
	var itemId = randi_range(0,3);
	get_parent().addItemDemon(itemId);
	pass;
