extends CanvasLayer


signal start_game
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_message(text):
	get_node("Message").text = text
	get_node("Message").show()
	get_node("MessageTimer").start()
	

func show_game_over():
	show_message("Game over!")
	
	#wait until the MessageTimer has counted down
	await get_node("MessageTimer").timeout
	
	$Message.text = ""
	get_node("Message").show()
	
	#Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	get_node("StartButton").show()
	
func update_score(score):
	get_node("ScoreLabel").text = str(score)
	


func _on_message_timer_timeout():
	get_node("Message").hide()


func _on_start_button_pressed():
	get_node("StartButton").hide()
	start_game.emit()


