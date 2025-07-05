extends CanvasLayer

signal restart


func _on_restart_button_pressed() -> void:
	restart.emit()

func _on_keydown_r( event )-> void:
	if event is InputEventKey:
		if event.press and event.keycode == KEY_R:
			restart.emit()
