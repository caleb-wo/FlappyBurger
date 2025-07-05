extends Node2D

signal hit
signal score



func _on_area_2d_body_entered(body: Node2D) -> void:
	hit.emit()



func _on_score_area_body_entered(body: Node2D) -> void:
	score.emit()
