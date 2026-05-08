extends CanvasLayer

signal start_game

const LIFE_ICON_SPACING := 45.0
const LIFE_ICON_NAME_PREFIX := "LifeIcon_"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the Creeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)
	
func set_lifes(countLifes: int):
	for child in get_children():
		if child.name.begins_with(LIFE_ICON_NAME_PREFIX):
			remove_child(child)
			child.queue_free()

	$Lifes.hide()
	var base_position = $Lifes.position

	for i in range(max(countLifes, 0)):
		var life_icon = $Lifes.duplicate()
		life_icon.name = "%s%d" % [LIFE_ICON_NAME_PREFIX, i]
		add_child(life_icon)
		life_icon.position = base_position + Vector2(LIFE_ICON_SPACING * i, 0)
		life_icon.show()


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()
