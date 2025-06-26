extends Panel


func _on_music_scroll_bar_value_changed(value: float) -> void:
	var db := 0.0
	if value <= 50:
		db = lerp(-50.0, 0.0, value / 50.0)
	else:
		db = lerp(0.0, 20.0, (value - 50.0) / 50.0)
	Global.ChangeMusicVolume.emit(db)


func _on_sound_effect_scroll_bar_value_changed(value: float) -> void:
	var db := 0.0
	if value <= 50:
		db = lerp(-50.0, 0.0, value / 50.0)
	else:
		db = lerp(0.0, 20.0, (value - 50.0) / 50.0)
	Global.ChangeSoundEffectVolume.emit(db)
	


func _on_on_confrim_button_pressed() -> void:
	visible = false
	get_tree().paused = false
