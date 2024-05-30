extends Control

signal textbox_closed

@export var Enemy: Resource = null

var current_player_health = 0
var current_enemy_health = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_health($EnemyContainer/ProgressBar, Enemy.health, Enemy.health)
	_set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health)
	$EnemyContainer/Enemy.texture = Enemy.texture
	
	current_player_health = State.current_health
	current_enemy_health = Enemy.health
	
	$TextBox.hide()
	$ActionsPanel.hide()

	await _display_text("An %s appears" % Enemy.name.to_upper())
	$ActionsPanel.show()
	
func _set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "%d/%d" % [health, max_health]
	
func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $TextBox.visible:
		$TextBox.hide()
		emit_signal("textbox_closed")
		
func _display_text(text: String) -> void:
	$TextBox.show()
	$TextBox/Label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_run_pressed():
	await _display_text("Got away.")
	await (get_tree().create_timer(0.25))
	get_tree().quit


func _on_attack_pressed():
	await _display_text("You attack.")
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	_set_health($EnemyContainer/ProgressBar, current_enemy_health, Enemy.health)
	
	$AnimationPlayer.play("Enemy_damaged")
