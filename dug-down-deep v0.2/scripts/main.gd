extends Node2D

@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel
@onready var fade: ColorRect = $HUD/Fade
@onready var death_count_label: Label = $"HUD/Death Counter/DeathCountLabel"
@onready var timer_label: Label = $HUD/Timer/TimerLabel
@onready var control_node: CanvasLayer = $"Control/Touch Controls"

var level: int = 1
var score: int = 0
var current_level: Node = null
var death_count: int = 0
var runtime: float
var gold_collected_in_level: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var is_mobile: bool = DisplayServer.is_touchscreen_available()
	if is_mobile:
		control_node.show()
		print("YOU ARE IN MOBILE")
	else: 
		control_node.hide()
		print("YOU ARE NOT IN MOBILE")
	
	fade.modulate.a =1.0
	current_level = get_node("Level")
	await _load_level(level, true, false)
	
	
	
	


func _load_level(level_number: int, first_load: bool, reset_score: bool) -> void:
	if not first_load:
		await _fade(1.0)
	if reset_score:
		score = 0
		score_label.text = "SCORE: 0"
	
	if current_level:
		current_level.queue_free()
		
	var level_path = "res://Scenes/level%s.tscn" %level_number
	current_level = load(level_path).instantiate()
	add_child(current_level)
	current_level.name = "LevelRoot"
	_setup_level(current_level)
	
	await _fade(0.0)


func _setup_level(level_root: Node) -> void:
	var exit =level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)
	
	var golds = level_root.get_node_or_null("Golds")
	if golds:
		for gold in golds.get_children():
			gold.collected.connect(increase_score)
	
	var enemies = level_root.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_died.connect(_on_player_died)


func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("level",level) 
		level += 1
		gold_collected_in_level = 0
		
		body.can_move = false
		await _load_level(level, false, false)


func _on_player_died(body):
	body.die()
	print("Player died")
	death_count += 1
	score -= gold_collected_in_level
	score_label.text = "Gold: %s" % score
	gold_collected_in_level = 0
	death_count_label.text = "Death-Counter: %s" % death_count
	level = level
	runtime = runtime
	await _load_level(level, false, false)
	

func increase_score() -> void:
	score += 1
	gold_collected_in_level += 1
	print(score)
	score_label.text = "Gold: %s" % score


func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade,"modulate:a", to_alpha, 1.5)
	await tween.finished


func _on_timer_timeout() -> void:
	
	runtime += 0.1
	timer_label.text = "RunTime: 
%s Seconds" %snapped(runtime,0.1)

func _mobile_controls()-> void:
	var mobilecontrol = get_node("Control")
	mobilecontrol.mobilecontrols.connect(increase_score)
