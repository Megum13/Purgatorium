extends Node2D

######################## TEXT
var textSpeed = 0.4;
var firstTextIndex = 0;
var firstStart = false;
var firstTextArray = [
	"Итак, [color=ff0000]продажа души[/color] и дальнейшая смерть привели тебя сюда. В мир, где страдания помогают очиститься.",
	"Но [color=ff0000]чистилище[/color] - не наказание, а милость. Я дам тебе шанс [color=ff0000]исправить ошибки[/color] и отыграть проданную душу.",
	"Исходя из твоего прошлого, самое подходящее пари - [color=ff0000]русская рулетка[/color]. Сыграем по правилам людского мира...",
	"В свой ход наводишь ствол [color=ff0000]на себя или на оппонента[/color] и нажимаешь спусковой механизм. Припоминаешь?",
	"В начале раунда всегда показывается количество патронов, [color=ff0000]красным[/color] - количество боевых.",
	"У каждого по [color=ff0000]6[/color] жизней, достигнув 0, игрок погибает, [color=ff0000]навсегда[/color].",
	"[color=ff0000]Патроны перемешаны[/color], поэтому я, как и ты, не знаю какие заряжаю, в остальном разберешься по ходу игры. Начнем."
];
####################### /TEXT
var isGameStarted = false;
####################### MAIN GAME
var turn = 1; # 0 - Demon, 1 - Player
var demon = {
	hp = 6,
	items = [0,0,0,0],
	mindBulletsCount = 8,
	mindKillBullets = 0,
	mindKillBulletsOut = 0,
	skiped = false,
	implantChoise = -1, # 0 - himself, 1 - player 
	readyToShot = true,
};
# items id:  1 - money, 2 - Implantat, 3 - Heal, 4 - Patron
var player = {
	hp = 6,
	items = [0,0,0,0],
	skiped = false,
};
var gun = {
	bullets = [0,0], # 0 - clear, 1 - kill bullet, 2 - light bullet
	oldBullets = [0,0],
};
var game = {
	round = 0,
	bullets = [0,0,0,0,0,0,0,0],  # 1 - kill bullet, 2 - lught bullet
};
var isAnimationPlaying = false;
var firstLoad = true;

var buckshotAnim = preload("res://node_2d.tscn");
var oshmetok = preload("res://Oshmetki.tscn");

#$Room23/Demon.eyeSwitch(1);
#$Room23/Demon.isEyeShaking = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	start();
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ($"Dialog Layer/RichTextLabel".visible_ratio != 1):
		$"Dialog Layer/RichTextLabel".visible_ratio += delta * textSpeed ;
		pass;
	#$Room23/Round.text = game.round % "";
	if(turn == 0): 
		setGunChoisen(false);
		$Room23/TurnLeftLabel.visible = false;
		$Room23/TurnRightLabel.visible = true;
	else: if(turn == 1): 
		$Room23/TurnLeftLabel.visible = true;
		$Room23/TurnRightLabel.visible = false;
		
	if (gun.bullets[0] == 0):
		$Room23/ReloadLabel.visible = true;
	else: 
		$Room23/ReloadLabel.visible = false;
		
	if (player.skiped or demon.skiped):
		$Room23/Moneta.visible = true;
	else: $Room23/Moneta.visible = false;
	if(isGameStarted):
		
		pass;
	pass;


func start():
	$AnimationPlayer.play("RESET");
	visible = false
	await get_tree().create_timer(1.5).timeout;
	visible = true
	$AnimationPlayer.play("FirstLights");
	await $AnimationPlayer.animation_finished
	$Room23/Demon.setEyesCoord(Vector2(0,0));
	setTextToDialogLayer(firstTextArray[0]);
	firstStart = true;
	pass;

###########################
func generateRound():
	# get items
	$PlayerItems.visible = false;
	$Box/AnimationPlayer.play("Start");
	$Box/ShowItem.play("RESET");
	get_tree().paused = true;
	bulletGenerate(); # █
	var result = ""
	var killbullets = 0;
	for i in len(game.bullets):
		if(game.bullets[i] == 1): killbullets+=1;
		pass;
	for i in len(game.bullets):
		if(killbullets != 0):
			result += "[color=ff0000]█ [/color]";
			killbullets-= 1;
		else:
			result += "[color=00ff00]█ [/color]";
		pass;
	$Room23/BuckshotsStart.text = result;
	$Room23/TVAnimation.play("RoundStart");
	pass;


func addItemPlayer(itemId: int): 
	if (checkItemsCount(player) == 4): return;
	var index = addItemToArray(player, itemId);
	print(player.items);
	spawnItemPlayer(itemId, index);
	pass;

func addItemDemon(itemId: int): 
	if (checkItemsCount(demon) == 4): return;
	var index = addItemToArray(demon, itemId);
	print(demon.items);
	spawnItemDemon(itemId, index);
	pass;

func checkItemsCount(obj):
	var count = 0;
	for i in range(4):
		if(obj.items[i] != 0): count += 1;
		pass;
	return count;
	pass;

# Вернет индекс где находится предмет
func addItemToArray(obj, itemId):
	itemId += 1; # айди айтемов начинаются не с 0, а с 1
	for i in range(4):
		if (obj.items[i] == 0): 
			obj.items[i] = itemId;
			return i;
			break;
	pass;

func spawnItemDemon(itemId: int, index: int):
	var item = $Items.get_children()[itemId].duplicate();
	$Room23/TableVer2/DemonItems.get_children()[index].add_child(item);
	item.position = Vector2(0,0);
	item.scale = Vector2(0.6,0.6);
	pass; 
	
func spawnItemPlayer(itemId: int,index: int):
	var item = $Items.get_children()[itemId].duplicate();
	$Room23/TableVer2/PlayerItems.get_children()[index].add_child(item);
	item.position = Vector2(0,0);
	
	if (itemId == 2):
		item = $Items.get_children()[itemId].duplicate();
		$PlayerItems.get_children()[index].add_child(item);
		item.position = Vector2(50,50 + 32);
		item.scale = Vector2(0.6,0.6);
	else:
		item = $Items.get_children()[itemId].duplicate();
		$PlayerItems.get_children()[index].add_child(item);
		item.position = Vector2(50,50);
		item.scale = Vector2(0.6,0.6);
	pass; 

func bulletGenerate():
	game.bullets = [0,0,0,0,0,0,0,0];
	for i in len(game.bullets):
		game.bullets[i] = randi_range(1,2); 
		if (game.bullets[i] == 1): demon.mindKillBullets+= 1;
		pass;
	print(game.bullets);
	
	
	pass;

func setTextToDialogLayer(_text):
	$"Dialog Layer".visible = true;
	$"Dialog Layer/RichTextLabel".text = _text;
	$"Dialog Layer/RichTextLabel".visible_ratio = 0;
	pass;

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			if(get_tree().paused == false):
				get_tree().paused = true;
				$PauseMenu/CanvasLayer.visible = true;
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if(firstStart and !isGameStarted and len(firstTextArray) != firstTextIndex+1):
				if($"Dialog Layer/RichTextLabel".visible_ratio == 1):
					firstTextIndex += 1;
					setTextToDialogLayer(firstTextArray[firstTextIndex]);
					if (firstTextIndex == 2): $Room23/Demon.setEyesCoord(Vector2(0,600));
					if (firstTextIndex == 3): $Room23/Demon.setEyesCoord(Vector2(0,0));
				else:
					$"Dialog Layer/RichTextLabel".visible_ratio = 1;
				pass;
			else: if (len(firstTextArray) == firstTextIndex+1 and $"Dialog Layer/RichTextLabel".visible_ratio == 1 and !isGameStarted):
				isGameStarted = true;
				$Room23/Demon.randomEyeMoving = true;
				$"Dialog Layer".visible = false;
				generateRound();
				loadGun();
				pass;
		else: if (isGameStarted): ################## MAIN GAME
			$Room23/Demon.d = 24;
			$Room23/Demon.eyeMode = 1;
			
			
			pass;
			
			pass;
		if event.button_index == MOUSE_BUTTON_MIDDLE and event.pressed:

			pass;
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			
			pass;
	pass;
	
func grabItemAnimation(StringItemName):
	$Room23/Player/AnimationPlayer.play("RESET");
	await $Room23/Player/AnimationPlayer.animation_finished
	$Room23/Player/AnimationPlayer.play("Hvat");
	await $Room23/Player/AnimationPlayer.animation_finished;
	$Room23/Player/AnimationPlayer.play(StringItemName);
	
	pass

func DemonGrabItemAnimation(StringItemName):
	$AnimationPlayer.play("RESET");
	await $AnimationPlayer.animation_finished
	#$AnimationPlayer.play("GrabItem");  Grab DEMON
	#await $AnimationPlayer.animation_finished;
	$AnimationPlayer.play(StringItemName);
	pass

signal gunGrabed;
func grabGun():
	$Room23/Player/AnimationPlayer.play("RESET");
	await $Room23/Player/AnimationPlayer.animation_finished
	$Room23/Player/AnimationPlayer.play("Hvat");
	await get_tree().create_timer(0.3072).timeout
	$Room23/TableVer2/Gun.visible = false;
	gunGrabed.emit();
	await $Room23/Player/AnimationPlayer.animation_finished;
	$Room23/Player/AnimationPlayer.play("ToPlayer");
	pass

func setGunChoisen(boolean: bool):
	$Room23/TableVer2/Gun.redLine = boolean;

func _on_gun_take_gun():
	if (turn == 1 and isGameStarted):
		await grabGun();
		pass;
	pass # Replace with function body.

# СДЕЛАН ВЫБОР, ОТКРЫТЬ ОГООООНЬ
func _on_demon_choise_signal(choise):
	if(gun.bullets[0] != 0 and gun.bullets[1] != 0):
		gun.oldBullets[0] = gun.bullets[0];
		gun.oldBullets[1] = gun.bullets[1];
		gun.bullets[0] = 0;
		gun.bullets[1] = 0;
		if (choise == 1): # Стрельба в демона
			startTvAnimation(gun.oldBullets);
			if (gun.oldBullets[0] == 1 and gun.oldBullets[1] == 1 ):
				$Room23/TableVer2/Gun/Shoot.play();
				PlayerKillDemon(2);
				demonDiedAnimation();
				demon.mindKillBulletsOut+=2;
				pass;
			else: if (gun.oldBullets[0] == 1 or gun.oldBullets[1] == 1 ):
				$Room23/TableVer2/Gun/Shoot.play();
				PlayerKillDemon(1);
				demonDiedAnimation();
				demon.mindKillBulletsOut+=1;
				pass;
			
			else: 
				$Room23/TableVer2/Gun/Click.play();
				turn = 0;
				dropGun();
			pass;
		else:
			if (gun.oldBullets[0] == 1 and gun.oldBullets[1] == 1 ):
				$Room23/TableVer2/Gun/ShootDie.play();
				PlayerKillHimself(2);
				demon.mindKillBulletsOut+=2;
				if (turn == 1): turn = 0;
				pass;
			else: if (gun.oldBullets[0] == 1 or gun.oldBullets[1] == 1 ):
				$Room23/TableVer2/Gun/ShootDie.play();
				PlayerKillHimself(1);
				demon.mindKillBulletsOut+=1;
				if (turn == 1): turn = 0;
				pass;
			
			else: 
				$Room23/TableVer2/Gun/Click.play();
				startTvAnimation(gun.oldBullets);
				dropGun();
			pass;

		demon.mindBulletsCount-=2;
		
		pass;
	pass # Replace with function body.

func startTvAnimation(array):
	var result = "[center]";
	if (array[0] == 1):
		result+= "[color=ff0000]█[/color] ";
	else:
		result+= "[color=00ff00]█[/color] ";
		
	if (array[1] == 1):
		result+= "[color=ff0000]█[/color]";
	else:
		result+= "[color=00ff00]█[/color]";
		
	$Room23/ShotBuckShots.text = result;
	$Room23/TVAnimation.play("LastBuckshots");
	pass;

func PlayerKillDemon(hp):
	$Room23/Demon/Ebaka10.material.set_shader_parameter("on",false);
	spawnOshmetki();
	demon.hp-=hp;
	if (demon.hp <= 0): get_tree().change_scene_to_file("res://happyEnd.tscn");
	if (demon.hp <= 5 and $Room23/Demon/Ebaka10.frame == 0): $Room23/Demon/Ebaka10.frame = 1;
	if (demon.hp <= 4 and $Room23/Demon/Ebaka10.frame == 1): $Room23/Demon/Ebaka10.frame = 2;
	if (demon.hp <= 1 and $Room23/Demon/Ebaka10.frame == 2): $Room23/Demon/Ebaka10.frame = 3;
	var str = "";
	for i in demon.hp:str+="*";
	$Room23/DemonLabel.text = str;
	await get_tree().create_timer(2).timeout;
	dropGun();
	pass;
	
func PlayerKillHimself(hp):
	player.hp-=hp;
	if (player.hp <= 0): get_tree().change_scene_to_file("res://badEnd.tscn");
	var str = "";
	for i in player.hp:str+="*";
	$Room23/PlayerHealtLabel.text = str;
	setGunChoisen(false);
	$Room23/Demon/Ebaka10.material.set_shader_parameter("on",false);
	$Room23/Player/AnimationPlayer.play("RESET");
	await $Room23/Player/AnimationPlayer.animation_finished;
	$Room23/Player/AnimationPlayer.play("DieAnimation");
	$Room23/TableVer2/Gun.visible = true;
	await get_tree().create_timer(3).timeout;
	startTvAnimation(gun.oldBullets);
	await get_tree().create_timer(2).timeout;
	loadGun();
	pass;
	
func DemonKillPlayer(hp):
	player.hp-=hp;
	if (player.hp <= 0): get_tree().change_scene_to_file("res://badEnd.tscn");
	var str = "";
	for i in player.hp:str+="*";
	$Room23/PlayerHealtLabel.text = str;
	setGunChoisen(false);
	$Room23/Demon/Ebaka10.material.set_shader_parameter("on",false);
	$Room23/Player/AnimationPlayer.play("RESET");
	await $Room23/Player/AnimationPlayer.animation_finished;
	$Room23/Player/AnimationPlayer.play("DieAnimation");
	$Room23/TableVer2/Gun.visible = true;
	await get_tree().create_timer(0.2).timeout;
	$Room23/Demon/AnimationPlayer.play("RESET");
	await get_tree().create_timer(2.8).timeout;
	startTvAnimation(gun.oldBullets);
	await get_tree().create_timer(2).timeout;
	loadGun();
	pass;

func DemonKillHimself(hp):
	demon.hp-=hp;
	if (demon.hp <= 0): get_tree().change_scene_to_file("res://happyEnd.tscn");
	if (demon.hp <= 5 and $Room23/Demon/Ebaka10.frame == 0): $Room23/Demon/Ebaka10.frame = 1;
	if (demon.hp <= 4 and $Room23/Demon/Ebaka10.frame == 1): $Room23/Demon/Ebaka10.frame = 2;
	if (demon.hp <= 1 and $Room23/Demon/Ebaka10.frame == 2): $Room23/Demon/Ebaka10.frame = 3;
	var str = "";
	for i in demon.hp:str+="*";
	$Room23/DemonLabel.text = str;
	spawnOshmetki();
	$Room23/Demon/AnimationPlayer.play("RESET");
	await $Room23/Demon/AnimationPlayer.animation_finished;
	$Room23/Demon/AnimationPlayer.play("DropGun");
	await $Room23/Demon/AnimationPlayer.animation_finished;
	$Room23/TableVer2/Gun.visible = true;
	await get_tree().create_timer(2).timeout;
	loadGun();
	pass;

func spawnBuckshots():
	if (firstLoad): return;
	for i in range(2):
		var buckshot = buckshotAnim.instantiate();
		buckshot.position = Vector2(58,42);
		$Room23/buchotsSpawn.add_child(buckshot);
		
	pass;

func loadGun():
	loadBullet();
	if (firstLoad or (gun.oldBullets[0] == 2 and gun.oldBullets[1] == 2)):
		$Room23/TableVer2/Gun/AnimationPlayer.play("ReloadNotBuckshot");
		await $Room23/TableVer2/Gun/AnimationPlayer.animation_finished
		firstLoad = false;
		pass;
	else:
		$Room23/TableVer2/Gun/AnimationPlayer.play("ReloadWithBuckshot");
		await $Room23/TableVer2/Gun/AnimationPlayer.animation_finished
		pass;
		
	if (demon.skiped):
		demon.skiped = false;
		turn = 1;
		$MarioMoney.play();
	else: if (player.skiped):
		player.skiped = false;
		turn = 0;
		$MarioMoney.play();
		
	await get_tree().create_timer(1).timeout;
	
	if(turn == 0): DemonMind();
	if(turn == 1): 
		setGunChoisen(true);
	
	pass;



func DemonMind():
	await get_tree().create_timer(1.2).timeout;
	await demon.readyToShot;
	demon.readyToShot = false;
	
	var itemRandomindex = randi_range(0,3);
	if (demon.items[itemRandomindex] != 0):
		demonUseItem(itemRandomindex);
		return;
		
	var qoofBullets = randi_range(0,1);
	$Room23/TableVer2/Gun.visible = false;
	$Room23/Demon.eyeMode = 2;


	if(demon.implantChoise == 1):
		demon.implantChoise = -1;
		$Room23/Demon/AnimationPlayer.play("ToPlayer");
		await $Room23/Demon/AnimationPlayer.animation_finished;
		await get_tree().create_timer(1.5).timeout;
		demon.readyToShot = true;
		demonFire(1);
	else: if(demon.implantChoise == 0):
		demon.implantChoise = -1;
		$Room23/Demon/AnimationPlayer.play("ToDemon");
		await $Room23/Demon/AnimationPlayer.animation_finished;
		await get_tree().create_timer(1.5).timeout;
		demon.readyToShot = true;
		demonFire(0);
		
	else: if(qoofBullets == 0):
		$Room23/Demon/AnimationPlayer.play("ToPlayer");
		await $Room23/Demon/AnimationPlayer.animation_finished;
		await get_tree().create_timer(1.5).timeout;
		demon.readyToShot = true;
		demonFire(1);
		pass;

	else: if (qoofBullets == 1):
		$Room23/Demon/AnimationPlayer.play("ToDemon");
		await $Room23/Demon/AnimationPlayer.animation_finished;
		await get_tree().create_timer(1.5).timeout;
		demon.readyToShot = true;
		demonFire(0);
		pass;
		
	
	
	pass;

# 0 - toDemon, 1 - toPlayer
func demonFire(choise):
	if(gun.bullets[0] != 0 and gun.bullets[1] != 0):
		gun.oldBullets[0] = gun.bullets[0];
		gun.oldBullets[1] = gun.bullets[1];
		gun.bullets[0] = 0;
		gun.bullets[1] = 0;
		if (choise == 1):
			if (gun.oldBullets[0] == 1 and gun.oldBullets[1] == 1 ):
				$Room23/TableVer2/Gun/ShootDie.play();
				DemonKillPlayer(2);
				demon.mindKillBulletsOut+=2;
				pass;
			else: if (gun.oldBullets[0] == 1 or gun.oldBullets[1] == 1 ):
				$Room23/TableVer2/Gun/ShootDie.play();
				DemonKillPlayer(1);
				demon.mindKillBulletsOut+=1;
				pass;
			
			else: 
				startTvAnimation(gun.oldBullets);
				if (turn == 0): turn = 1;
				$Room23/TableVer2/Gun/Click.play();
				await get_tree().create_timer(2).timeout;
				$Room23/Demon/AnimationPlayer.play("RESET");
				await $Room23/Demon/AnimationPlayer.animation_finished;
				$Room23/Demon/AnimationPlayer.play("DropGun");
				await $Room23/Demon/AnimationPlayer.animation_finished;
				await get_tree().create_timer(2).timeout;
				loadGun();
			pass;
		else:
			startTvAnimation(gun.oldBullets);
			if (gun.oldBullets[0] == 1 and gun.oldBullets[1] == 1 ):
				$Room23/TableVer2/Gun/Shoot.play();
				DemonKillHimself(2);
				demonDiedAnimation();
				demon.mindKillBulletsOut+=2;
				if (turn == 0): turn = 1;
				pass;
			else: if (gun.oldBullets[0] == 1 or gun.oldBullets[1] == 1 ):
				$Room23/TableVer2/Gun/Shoot.play();
				DemonKillHimself(1);
				demonDiedAnimation();
				demon.mindKillBulletsOut+=1;
				if (turn == 0): turn = 1;
				pass;
			else: 
				$Room23/TableVer2/Gun/Click.play();
				$Room23/Demon/AnimationPlayer.play("DropGun");
				await $Room23/Demon/AnimationPlayer.animation_finished;
				loadGun();
			pass;

		demon.mindBulletsCount-=2;
		
		pass;
	pass # Replace with function body.
	pass;

func demonDiedAnimation():
	$Room23/Demon/DemonDieAnimation.play("Die");
	pass;

func spawnOshmetki():
	$Room23/Player/BloodAnimation.play("Blood");
	for i in range(18):
		var oshm = oshmetok.instantiate();
		$Room23/buchotsSpawn.add_child(oshm);
		pass;
	pass;

func loadBullet():
	if(len(game.bullets) != 0 and gun.bullets[0] == 0 and gun.bullets[1] == 0):
		gun.bullets[0] = game.bullets[0];
		gun.bullets[1] = game.bullets[1];
		game.bullets.remove_at(0);
		game.bullets.remove_at(0);
		print(gun)
		print(game)
	else: # New Round
		game.round += 1;
		$Room23/Round.text = str(game.round);
		generateRound();
		gun.bullets[0] = game.bullets[0];
		gun.bullets[1] = game.bullets[1];
		game.bullets.remove_at(0);
		game.bullets.remove_at(0);
		print(gun)
		print(game)
		pass;
	pass;

func dropGun():
	$Room23/Demon/Ebaka10.material.set_shader_parameter("on",false);
	setGunChoisen(false);
	await get_tree().create_timer(2).timeout;
	$Room23/Player/AnimationPlayer.play("RESET");
	await $Room23/Player/AnimationPlayer.animation_finished
	$Room23/Player/AnimationPlayer.play("DropGun");
	await $Room23/Player/AnimationPlayer.animation_finished
	$Room23/TableVer2/Gun.visible = true;
	await get_tree().create_timer(2).timeout;
	loadGun();
	pass;

# items GUI
func _on_panel_container_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			useItem(0);
			pass;

	#$PlayerItems/PanelContainer.scale += 0.1;
	pass # Replace with function body.


func _on_panel_container_2_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			useItem(1);
	pass # Replace with function body.


func _on_panel_container_3_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			useItem(2);
	pass # Replace with function body.


func _on_panel_container_4_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			useItem(3);
			
	pass # Replace with function body.

func useItem(index):
	
	if (player.items[index] == 0 or turn == 0 or !$Room23/TableVer2/Gun.redLine or !$Room23/Player/AnimationPlayer.animation_finished): return;
	var itemId = player.items[index];
	print(itemId)
	player.items[index] = 0;
	await get_tree().create_timer(0.3).timeout;
	$PlayerItems.get_children()[index].get_child(0).queue_free();
	$Room23/TableVer2/PlayerItems.get_children()[index].get_child(0).queue_free();
	
	if itemId == 1:
		useMoney();
	else: if itemId == 2:
		useImplant();
	else: if itemId == 3:
		useHeal();
	else: if itemId == 4:
		useLightBuckShot();
	pass;
	
func demonUseItem(index):
	var itemId = demon.items[index];
	print(itemId)
	demon.items[index] = 0;
	$Room23/TableVer2/DemonItems.get_children()[index].get_child(0).queue_free();

	if itemId == 1:
		await demonUseMoney();
		demon.readyToShot = true;
	else: if itemId == 2:
		await demonUseImplant();
		demon.readyToShot = true;
	else: if itemId == 3:
		await demonUseHeal();
		demon.readyToShot = true;
	else: if itemId == 4:
		await demonUseLightBuckShot();
		demon.readyToShot = true;
	pass;
# items id:  1 - money, 2 - Implantat, 3 - Heal, 4 - Patron

func useMoney():
	$Room23/Player/AnimationPlayer.play("RESET");
	await $Room23/Player/AnimationPlayer.animation_finished;
	$Room23/Player/AnimationPlayer.play("Hvat");
	await $Room23/Player/AnimationPlayer.animation_finished;
	var mon = randi_range(0,1);
	if (mon == 0): # skip demon
		$Room23/Player/AnimationPlayer.play("Money2");
		await $Room23/Player/AnimationPlayer.animation_finished;
		demon.skiped = true;
		pass;
	else:  # lost hod
		$Room23/Player/AnimationPlayer.play("Money1");
		await $Room23/Player/AnimationPlayer.animation_finished;
		turn = 0;
		$Room23/beep1.play();
		setGunChoisen(false);
		await get_tree().create_timer(1.5).timeout;
		DemonMind();
		pass;
		
	pass;

func useImplant():
	$Room23/Player/AnimationPlayer.play("RESET");
	await $Room23/Player/AnimationPlayer.animation_finished;
	$Room23/Player/AnimationPlayer.play("Hvat");
	await $Room23/Player/AnimationPlayer.animation_finished;
	$Room23/Player/AnimationPlayer.play("RentgenStart");
	await $Room23/Player/AnimationPlayer.animation_finished;

	if (gun.bullets[0] == 1 and gun.bullets[1] == 1 ):
		$Room23/Player/AnimationPlayer.play("RentgenWith2Buckshots");
		await $Room23/Player/AnimationPlayer.animation_finished;
	else: if (gun.bullets[0] == 1 or gun.bullets[1] == 1 ):
		$Room23/Player/AnimationPlayer.play("RentgenWith1Buckshots");
		await $Room23/Player/AnimationPlayer.animation_finished;
	else:
		$Room23/Player/AnimationPlayer.play("RentgenWith0Buckshots");
		await $Room23/Player/AnimationPlayer.animation_finished;

func useHeal():
	$Room23/Player/AnimationPlayer.play("RESET");
	await $Room23/Player/AnimationPlayer.animation_finished;
	$Room23/Player/AnimationPlayer.play("Hvat");
	await $Room23/Player/AnimationPlayer.animation_finished;
	$Room23/Player/AnimationPlayer.play("Heal");
	await get_tree().create_timer(0.3).timeout;
	await $Room23/Player/AnimationPlayer.animation_finished;
	player.hp += 1;
	if (player.hp >= 6): player.hp = 6;
	$Room23/beep1.play();
	var str = "";
	for i in player.hp:str+="*";
	$Room23/PlayerHealtLabel.text = str;
	pass;

func useLightBuckShot():
	$Room23/Player/AnimationPlayer.play("RESET");
	await $Room23/Player/AnimationPlayer.animation_finished;
	$Room23/Player/AnimationPlayer.play("Hvat");
	await $Room23/Player/AnimationPlayer.animation_finished;
	await get_tree().create_timer(1).timeout;
	$Room23/Player/AnimationPlayer.play("Hvat");
	await get_tree().create_timer(0.5).timeout;
	$Room23/TableVer2/Gun.visible = false
	await $Room23/Player/AnimationPlayer.animation_finished;
	$Room23/TableVer2/Gun/Reload2.play();
	await get_tree().create_timer(0.5).timeout;
	$Room23/Player/AnimationPlayer.play("Hvat");
	await get_tree().create_timer(0.2).timeout;
	$Room23/TableVer2/Gun.visible = true
	await $Room23/Player/AnimationPlayer.animation_finished;
	gun.bullets[0] = 1;
	gun.bullets[1] = 1;
	pass;
####################################
func demonUseMoney():
	$Room23/Demon/AnimationPlayer.play("RESET");
	await $Room23/Demon/AnimationPlayer.animation_finished;
	
	var mon = randi_range(0,1);
	if (mon == 0): # skip player
		$Room23/Demon/AnimationPlayer.play("Money");
		await $Room23/Demon/AnimationPlayer.animation_finished;
		player.skiped = true;
		DemonMind()
		pass;
	else:  # lost hod
		$Room23/Demon/AnimationPlayer.play("Money");
		await $Room23/Demon/AnimationPlayer.animation_finished;
		turn = 1;
		$Room23/beep1.play();
		setGunChoisen(true);
		pass;

func demonUseImplant():
	$Room23/Demon/AnimationPlayer.play("RESET");
	await $Room23/Demon/AnimationPlayer.animation_finished;
	
	$Room23/Demon/AnimationPlayer.play("ImplantPart1");
	await $Room23/Demon/AnimationPlayer.animation_finished;
	$Room23/Demon/AnimationPlayer.play("ImplantPart2");
	await $Room23/Demon/AnimationPlayer.animation_finished;
	
	# 0 - himself, 1 - player
	if (gun.bullets[0] == 1 or gun.bullets[1] == 1 ):
		demon.implantChoise = 1;
		DemonMind();
	else: 
		demon.implantChoise = 0;
		DemonMind();
	
func demonUseHeal():
	$Room23/Demon/AnimationPlayer.play("RESET");
	await $Room23/Demon/AnimationPlayer.animation_finished;
	
	$Room23/Demon/AnimationPlayer.play("Heal");
	await $Room23/Demon/AnimationPlayer.animation_finished;
	demon.hp += 1;
	if (demon.hp >= 6): demon.hp = 6;
	$Room23/beep1.play();
	var str = "";
	for i in demon.hp:str+="*";
	$Room23/DemonLabel.text = str;
	DemonMind();
	
func demonUseLightBuckShot():
	$Room23/Demon/AnimationPlayer.play("RESET");
	await $Room23/Demon/AnimationPlayer.animation_finished;
	gun.bullets[0] = 1;
	gun.bullets[1] = 1;
	$Room23/TableVer2/Gun/Reload2.play();
	await get_tree().create_timer(1.5).timeout;
	demon.implantChoise = 1;
	DemonMind();
