extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.gui.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed(): #quit
	get_tree().quit()


func _on_PlayButton_pressed(): #play
	get_tree().change_scene("")
